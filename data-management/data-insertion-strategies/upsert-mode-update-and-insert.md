# Upsert mode : Update and insert

## How it works

**UPSERT Mode** combines UPDATE and INSERT operations: **existing rows (identified by their Primary Key) are updated, and new rows are inserted. No data is deleted.**

This is Quanti's **preferred insertion method** as it provides the best balance between data preservation and accuracy.

{% stepper %}
{% step %}
### Technical implementation

UPSERT Mode uses a `MERGE` statement (or equivalent) that:

* Matches rows based on Primary Key fields (via `_quanti_id`)
* Checks if data has actually changed (via `_quanti_hash` comparison)
* Updates or inserts matched rows only if data changed
* Inserts unmatched rows as new records
{% endstep %}

{% step %}
### Change detection optimization

Quanti uses two technical fields to optimize operations:

* **`_quanti_id`**: Composite identifier created by concatenating all Primary Key fields (fields with `quantiId: true`)
* **`_quanti_hash`**: Hash of all table fields, used as a data fingerprint

When a row with matching `_quanti_id` is found, Quanti compares the `_quanti_hash`:

* If **different** → data has changed → UPDATE.
* If **identical** → data unchanged → **SKIP** (no operation performed)

This prevents unnecessary insertions when source data hasn't changed, significantly reducing storage costs and processing time.
{% endstep %}
{% endstepper %}

**Visual representation:**

```
Existing data based on PK:
  Row A (PK=1): [old values] hash: abc123
  Row B (PK=2): [old values] hash: def456

New data:
  Row A (PK=1): [new values] hash: xyz789  ← PK matches, hash different → UPDATE
  Row B (PK=2): [old values] hash: def456  ← PK matches, hash identical → SKIP
  Row C (PK=3): [new values] hash: ghi012  ← PK new → INSERT

Result:
  Row A (PK=1): [new values] hash: xyz789  ← updated
  Row B (PK=2): [old values] hash: def456  ← unchanged (no operation)
  Row C (PK=3): [new values] hash: ghi012  ← inserted
```

**Concrete example with a dimension table:**

```
Existing data (campaigns table):
| campaign_id | name            | status | budget | _quanti_hash | _quanti_loaded_at   |
|-------------|-----------------|--------|--------|--------------|---------------------|
| camp_123    | Summer Campaign | ACTIVE | 5000   | abc123       | 2025-01-15 10:00:00 |
| camp_456    | Winter Campaign | PAUSED | 3000   | def456       | 2025-01-15 10:00:00 |

Primary Key: (campaign_id)

New data from synchronization:
| campaign_id | name            | status | budget |
|-------------|-----------------|--------|--------|
| camp_123    | Summer Campaign | PAUSED | 5500   | → hash: xyz789 (different)
| camp_456    | Winter Campaign | PAUSED | 3000   | → hash: def456 (identical)
| camp_789    | Fall Campaign   | ACTIVE | 6000   | → hash: ghi012 (new)

Result:
| campaign_id | name            | status | budget | _quanti_hash | _quanti_loaded_at   |
|-------------|-----------------|--------|--------|--------------|---------------------|
| camp_123    | Summer Campaign | PAUSED | 5500   | xyz789       | 2025-01-20 14:00:00 | ← updated
| camp_456    | Winter Campaign | PAUSED | 3000   | def456       | 2025-01-15 10:00:00 | ← skipped (unchanged)
| camp_789    | Fall Campaign   | ACTIVE | 6000   | ghi012       | 2025-01-20 14:00:00 | ← inserted
```

**Impact example:**\
If you sync 10,000 campaigns daily and only 500 change each day, Quanti will only perform operations on those 500 rows, skipping the 9,500 unchanged rows entirely.

{% hint style="danger" %}
#### ⚠️ Critical consideration: Performance impact on dimension tables

Dimension tables are typically NOT partitioned (unlike fact tables). This means historized dimension tables require scanning the ENTIRE table to find the latest version of each entity, causing large increases in query cost, storage, and degraded performance.

Example consequences:

* Table size growth: 10,000 rows → 500,000 rows (50 changes/campaign/year)
* Query scans: 10,000 rows → 500,000 rows (50x more expensive)
* Monthly cost example: \~$5 → \~$250 (50x increase)

Why this doesn't affect fact tables:

* Fact tables are partitioned by date (`_quanti_date`) and queries typically include date filters so partition pruning reduces scanned data.
{% endhint %}

***

## Critical characteristic: No deletion

**⚠️ UPSERT Mode NEVER deletes rows from your table.**

This is a fundamental difference from REPLACE Mode.

What happens when entities are deleted from source: the corresponding rows remain in your table (they are not removed by UPSERT). This preserves referential integrity and audit trails but can create orphaned or stale records over time.

***

## UPSERT mode for historization

UPSERT Mode can be configured to **preserve historical values** rather than updating rows in place. This creates a new row for each change while keeping the old values.

**Example of historization :**

```
Existing data (campaigns table):
| campaign_id | name            | status | budget | _quanti_loaded_at   |
|-------------|-----------------|--------|--------|---------------------|
| camp_123    | Summer Campaign | ACTIVE | 5000   | 2025-01-15 10:00:00 |
| camp_456    | Winter Campaign | PAUSED | 3000   | 2025-01-15 10:00:00 |

New data from synchronization:
| campaign_id | name            | status | budget |
|-------------|-----------------|--------|--------|
| camp_123    | Summer Campaign | PAUSED | 5500   | ← status changed

Result WITH historization:
| campaign_id | name            | status | budget | _quanti_loaded_at   |
|-------------|-----------------|--------|--------|---------------------|
| camp_123    | Summer Campaign | ACTIVE | 5000   | 2025-01-15 10:00:00 | ← old version kept
| camp_456    | Winter Campaign | PAUSED | 3000   | 2025-01-15 10:00:00 |
| camp_123    | Summer Campaign | PAUSED | 5500   | 2025-01-20 14:00:00 | ← new version inserted
```

With historization, the `_quanti_loaded_at` field becomes crucial for identifying the most recent version of each entity.

**Querying with historization:**

```sql
-- Get current state (most recent version of each campaign)
SELECT *
FROM campaigns
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY campaign_id
  ORDER BY _quanti_loaded_at DESC
) = 1
```

***

## When to historize

**✅ Historize when:**

* Compliance or audit requirements mandate complete history
* Business analysis requires tracking attribute changes over time
* Dimension table is small (< 10,000 rows) and changes infrequently
* Query volume on this table is low

**❌ Avoid historization when:**

* Dimension table is large (> 100,000 rows) or changes frequently
* High query volume on this table
* Only current state matters for business needs
* Storage and query costs are a concern
* No specific requirement for historical tracking

***

## How to Configure Historization

Historization in UPSERT Mode is controlled through **Primary Key configuration** during the connector setup (Mapping step). By selecting which fields form your table's unique identifier, you control which changes create new historical rows versus updating existing ones.

#### The Primary Key Principle

When configuring your table mapping, you select which fields are part of the **Primary Key** by checking their boxes in the Mapping step. This choice directly determines historization behavior.

**Key concept:**

* Fields **checked as Primary Key** → Changes to these fields create **new rows** (historization)
* Fields **not checked** → Changes to these fields **update existing rows** (no historization)

**What is a Primary Key?** The Primary Key is the combination of fields that uniquely identifies each row in your table. For example, for a campaigns table, `campaign_id` uniquely identifies each campaign. If you want to track how that campaign changes over time, you can add more fields to the Primary Key (like `date` or `status`), which will create a new row for each distinct combination.

#### Example 1: Standard setup (no historization)

**Scenario:** Keep only the current state of each campaign

**Mapping configuration:**

```
Table: campaigns

Field Name      | Type    | Primary Key
----------------|---------|-------------
campaign_id     | STRING  | ☑ (checked)
name            | STRING  | ☐
status          | STRING  | ☐
budget          | NUMERIC | ☐
```

**Primary Key selected:** `campaign_id` only

**Behavior:**

```
Initial data:
| campaign_id | name            | status | budget |
|-------------|-----------------|--------|--------|
| camp_123    | Summer Campaign | ACTIVE | 5000   |

Sync with status change:
| campaign_id | name            | status | budget |
|-------------|-----------------|--------|--------|
| camp_123    | Summer Campaign | PAUSED | 5000   |

Result (Primary Key matches → row is UPDATED):
| campaign_id | name            | status | budget |
|-------------|-----------------|--------|--------|
| camp_123    | Summer Campaign | PAUSED | 5000   | ← updated in place
```

**Result:** Only current state is kept. No history of the status change.

***

#### Example 2: Track changes over time with date

**Scenario:** Create a daily snapshot to track how campaign attributes evolve

**Mapping configuration:**

```
Table: campaigns

Field Name      | Type    | Primary Key
----------------|---------|-------------
campaign_id     | STRING  | ☑ (checked)
date            | DATE    | ☑ (checked)  ← Added to Primary Key
name            | STRING  | ☐
status          | STRING  | ☐
budget          | NUMERIC | ☐
```

**Primary Key selected:** `campaign_id` + `date`

**Behavior:**

```
Initial data (2025-01-15):
| campaign_id | date       | name            | status | budget |
|-------------|------------|-----------------|--------|--------|
| camp_123    | 2025-01-15 | Summer Campaign | ACTIVE | 5000   |

Sync with status change (2025-01-20):
| campaign_id | date       | name            | status | budget |
|-------------|------------|-----------------|--------|--------|
| camp_123    | 2025-01-20 | Summer Campaign | PAUSED | 5000   |

Result (Primary Key different → new row INSERTED):
| campaign_id | date       | name            | status | budget |
|-------------|------------|-----------------|--------|--------|
| camp_123    | 2025-01-15 | Summer Campaign | ACTIVE | 5000   | ← kept
| camp_123    | 2025-01-20 | Summer Campaign | PAUSED | 5000   | ← new row
```

**Result:** Full history preserved. You can see the campaign's status on any date.

***

#### Example 3: Track only status changes

**Scenario:** Create a new row only when the status changes, but update other fields in place

**Mapping configuration:**

```
Table: campaigns

Field Name      | Type    | Primary Key
----------------|---------|-------------
campaign_id     | STRING  | ☑ (checked)
status          | STRING  | ☑ (checked)  ← Include field to track changes
name            | STRING  | ☐
budget          | NUMERIC | ☐
```

**Primary Key selected:** `campaign_id` + `status`

**Behavior:**

```
Initial data:
| campaign_id | status | name            | budget |
|-------------|--------|-----------------|--------|
| camp_123    | ACTIVE | Summer Campaign | 5000   |

Sync 1 - Budget change only:
| campaign_id | status | name            | budget |
|-------------|--------|-----------------|--------|
| camp_123    | ACTIVE | Summer Campaign | 5500   |

Result (Primary Key matches → row UPDATED):
| campaign_id | status | name            | budget |
|-------------|--------|-----------------|--------|
| camp_123    | ACTIVE | Summer Campaign | 5500   | ← updated

Sync 2 - Status change:
| campaign_id | status | name            | budget |
|-------------|--------|-----------------|--------|
| camp_123    | PAUSED | Summer Campaign | 5500   |

Result (Primary Key different → new row INSERTED):
| campaign_id | status | name            | budget |
|-------------|--------|-----------------|--------|
| camp_123    | ACTIVE | Summer Campaign | 5500   | ← kept
| camp_123    | PAUSED | Summer Campaign | 5500   | ← new row
```

**Result:**

* Status changes → new rows (tracked over time)
* Name/budget changes → update existing row (not tracked)

{% hint style="danger" %}
#### ⚠️ Critical consideration: Performance impact on dimension tables

Dimension tables are typically NOT partitioned (unlike fact tables). This means historized dimension tables require scanning the ENTIRE table to find the latest version of each entity, causing large increases in query cost, storage, and degraded performance.

Example consequences:

* Table size growth: 10,000 rows → 500,000 rows (50 changes/campaign/year)
* Query scans: 10,000 rows → 500,000 rows (50x more expensive)
* Monthly cost example: \~$5 → \~$250 (50x increase)

Why this doesn't affect fact tables:

* Fact tables are partitioned by date (`_quanti_date`) and queries typically include date filters so partition pruning reduces scanned data.
{% endhint %}

***

{% hint style="success" %}
## Advantages

* ✅ No data loss — Existing rows that don't appear in new data are preserved
* ✅ Handles updates gracefully — Changes to existing entities are reflected immediately, no duplicates
* ✅ Supports historization — Can track attribute changes over time (with performance considerations)
* ✅ Flexible and robust — Works for both fact and dimension tables; resilient to partial source data
* ✅ Optimized with hash comparison — Skips unchanged rows entirely (\_quanti\_hash comparison)
{% endhint %}

***

{% hint style="warning" %}
## Disadvantages

* ❌ Moderate processing costs — `MERGE` operations require PK matching and scanning
* ❌ Table growth with historization — Storage costs increase with each change
* ❌ Complex queries with historization — Need to filter latest version using `_quanti_loaded_at`
* ❌ Primary Key dependency — Requires accurate PK definition (`_quanti_id`)
* ❌ Cannot remove deleted entities — Orphaned records remain unless manually cleaned
{% endhint %}

***

## Use cases

Ideal for:

* Dimension tables (campaigns, ad groups, products, customers) — reflect updates while preserving referential integrity (avoid historization on large, frequently-changing dimension tables)
* Master data and reference tables (account hierarchies, org structures)
* Fact tables where updates are expected (order status, conversion tracking) — partitioning mitigates historization impact
* Tables requiring compliance/audit trails (user permissions, config changes)
* Mixed scenarios (new + updates + unchanged), e.g., product catalogs

Not suitable for:

* Pure event streams or logs (events should be INSERT-only)
* Tables requiring explicit deletion of entities (use REPLACE mode)
* Large dimension tables with high change frequency + historization (consider REPLACE or snapshots)

***

***

## Historization vs. No Historization

<table><thead><tr><th width="169.67578125">Aspect</th><th align="right">With Historization</th><th align="right">Without Historization</th></tr></thead><tbody><tr><td>Update behavior</td><td align="right">New row inserted</td><td align="right">Existing row updated in place</td></tr><tr><td>Historical tracking</td><td align="right">✅ Full history preserved</td><td align="right">❌ Only current state</td></tr><tr><td>Table growth</td><td align="right">📈 Grows with each change</td><td align="right">📊 Stable (one row per entity)</td></tr><tr><td>Query complexity</td><td align="right">⚠️ Need to filter latest version</td><td align="right">✅ Direct access to current state</td></tr><tr><td>Storage cost</td><td align="right">❌ Higher (multiple versions)</td><td align="right">✅ Lower (single version)</td></tr><tr><td>Query cost (dimension tables)</td><td align="right">❌❌ VERY HIGH (full table scans)</td><td align="right">✅ Low</td></tr><tr><td>Audit capability</td><td align="right">✅ Complete audit trail</td><td align="right">❌ No audit trail</td></tr><tr><td>Temporal analysis</td><td align="right">✅ "State at time X" queries</td><td align="right">❌ Not possible</td></tr><tr><td>Performance impact</td><td align="right">❌❌ Severe on dimensions</td><td align="right">✅ Minimal</td></tr><tr><td>Use case</td><td align="right">Small tables, compliance, rare queries</td><td align="right">Most dimension tables</td></tr></tbody></table>

***
