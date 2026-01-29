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

* If **different** → data has changed → UPDATE (or INSERT if historization enabled)
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

**SQL implementation (BigQuery example):**

```sql
MERGE INTO campaigns AS target
USING new_data AS source
ON target._quanti_id = source._quanti_id  -- Primary Key match

WHEN MATCHED AND target._quanti_hash != source._quanti_hash THEN  -- Only if changed
  UPDATE SET
    name = source.name,
    status = source.status,
    budget = source.budget,
    _quanti_hash = source._quanti_hash,
    _quanti_loaded_at = CURRENT_TIMESTAMP()

WHEN NOT MATCHED THEN
  INSERT (campaign_id, name, status, budget, _quanti_id, _quanti_hash, _quanti_loaded_at)
  VALUES (source.campaign_id, source.name, source.status, source.budget, 
          source._quanti_id, source._quanti_hash, CURRENT_TIMESTAMP())
```

***

## UPSERT with historization

UPSERT Mode can be configured to **preserve historical values** rather than updating rows in place. This creates a new row for each change while keeping the old values.

**Example with historization enabled:**

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

## When to enable historization

**✅ Enable historization when:**

* Compliance or audit requirements mandate complete history
* Business analysis requires tracking attribute changes over time
* Dimension table is small (< 10,000 rows) and changes infrequently
* Query volume on this table is low
* You can implement partitioning strategies (advanced)

**❌ Avoid historization when:**

* Dimension table is large (> 100,000 rows) or changes frequently
* High query volume on this table
* Only current state matters for business needs
* Storage and query costs are a concern
* No specific requirement for historical tracking

## Alternative strategies

{% stepper %}
{% step %}
### Periodic snapshots instead of full historization

```sql
-- Weekly snapshot table instead of row-level historization
CREATE TABLE campaigns_snapshot_20250120 AS
SELECT * FROM campaigns_current
```
{% endstep %}

{% step %}
### Separate historical archive table

```sql
-- Current state (fast queries)
campaigns_current: latest version only, no historization

-- Historical archive (slow queries, rarely used)
campaigns_history: full historization for compliance
```
{% endstep %}

{% step %}
### Use REPLACE mode + external archival

* Main table uses REPLACE mode (current snapshot only)
* Periodic exports to archive storage (e.g., Cloud Storage)
* Cheaper storage, acceptable for infrequent historical analysis
{% endstep %}
{% endstepper %}

***

## Critical characteristic: No deletion

**⚠️ UPSERT Mode NEVER deletes rows from your table.**

This is a fundamental difference from REPLACE Mode.

What happens when entities are deleted from source: the corresponding rows remain in your table (they are not removed by UPSERT). This preserves referential integrity and audit trails but can create orphaned or stale records over time.

**Best practices to handle this:**

1. Add a status or deleted flag if available from source

```sql
-- Many platforms provide a status field
SELECT * FROM campaigns
WHERE status NOT IN ('DELETED', 'REMOVED', 'ARCHIVED')
```

2. Use \_quanti\_loaded\_at to identify stale records

```sql
-- Entities not updated recently may be deleted from source
SELECT * FROM campaigns
WHERE _quanti_loaded_at >= CURRENT_DATE() - 30
```

3. Implement periodic cleanup jobs

```sql
-- Manual cleanup of old, inactive entities
DELETE FROM campaigns
WHERE _quanti_loaded_at < CURRENT_DATE() - 365
  AND status IN ('DELETED', 'ARCHIVED', 'REMOVED')
```

4. Document this behavior clearly

* Inform data consumers that deleted entities persist
* Provide guidance on filtering for active entities only
* Create views that exclude likely deleted entities

***

## Advantages

* ✅ No data loss — Existing rows that don't appear in new data are preserved
* ✅ Handles updates gracefully — Changes to existing entities are reflected immediately, no duplicates
* ✅ Supports historization — Can track attribute changes over time (with performance considerations)
* ✅ Flexible and robust — Works for both fact and dimension tables; resilient to partial source data
* ✅ Optimized with hash comparison — Skips unchanged rows entirely (\_quanti\_hash comparison)

***

## Disadvantages

* ❌ Moderate processing costs — `MERGE` operations require PK matching and scanning
* ❌ Table growth with historization — Storage costs increase with each change
* ❌ Complex queries with historization — Need to filter latest version using `_quanti_loaded_at`
* ❌ Primary Key dependency — Requires accurate PK definition (`_quanti_id`)
* ❌ Cannot remove deleted entities — Orphaned records remain unless manually cleaned

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

{% stepper %}
{% step %}
### Best practices — define Primary Key accurately

* Ensure PK truly identifies unique entities (feeds `_quanti_id`)
* Test PK definition with sample data
* Document PK fields clearly for maintenance
{% endstep %}

{% step %}
### Best practices — evaluate historization needs

* Default to NO historization for dimension tables unless needed
* Enable historization only if table is small, changes infrequently, low query volume, or compliance requires it
* Consider snapshots or archive tables as alternatives
{% endstep %}

{% step %}
### Best practices — leverage \_quanti\_loaded\_at

* Use it to identify most recent version and when changes occurred
* Use it to identify stale/deleted entities
* Include it in queries on historized tables
{% endstep %}

{% step %}
### Best practices — monitor table growth & cleanup

* Set up alerts for unexpected growth
* Implement archival strategies (e.g., keep last 2 years)
* Consider partitioning by `_quanti_loaded_at` for cleanup (advanced)
{% endstep %}

{% step %}
### Best practices — create views for current state

* For historized tables, create a "current" view to simplify queries
* Centralizes deduplication logic
{% endstep %}

{% step %}
### Best practices — handle orphaned records

* Decide how to handle entities deleted from source
* Use status fields and `_quanti_loaded_at` to identify stale records
* Implement cleanup jobs if needed
{% endstep %}

{% step %}
### Best practices — optimize merge performance

* Ensure Primary Key fields are indexed
* Partition large tables appropriately
* Monitor merge operation duration
{% endstep %}

{% step %}
### Best practices — monitor \_quanti\_hash effectiveness

* Track how many rows are skipped vs updated
* High skip rate = hash optimization working well
* Adjust sync frequency if most rows unchanged
{% endstep %}
{% endstepper %}

***

## Example: Creating a current state view

For historized dimension tables, create a view to simplify access to current state:

```sql
CREATE VIEW campaigns_current AS
SELECT 
  campaign_id,
  name,
  status,
  budget,
  _quanti_loaded_at
FROM campaigns
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY campaign_id
  ORDER BY _quanti_loaded_at DESC
) = 1
```

Users can then query `campaigns_current` instead of dealing with deduplication logic:

```sql
-- Simple query for current state
SELECT * FROM campaigns_current
WHERE status = 'ACTIVE'
```

***

## Historization vs. No Historization

<table><thead><tr><th width="169.67578125">Aspect</th><th align="right">With Historization</th><th align="right">Without Historization</th></tr></thead><tbody><tr><td>Update behavior</td><td align="right">New row inserted</td><td align="right">Existing row updated in place</td></tr><tr><td>Historical tracking</td><td align="right">✅ Full history preserved</td><td align="right">❌ Only current state</td></tr><tr><td>Table growth</td><td align="right">📈 Grows with each change</td><td align="right">📊 Stable (one row per entity)</td></tr><tr><td>Query complexity</td><td align="right">⚠️ Need to filter latest version</td><td align="right">✅ Direct access to current state</td></tr><tr><td>Storage cost</td><td align="right">❌ Higher (multiple versions)</td><td align="right">✅ Lower (single version)</td></tr><tr><td>Query cost (dimension tables)</td><td align="right">❌❌ VERY HIGH (full table scans)</td><td align="right">✅ Low</td></tr><tr><td>Audit capability</td><td align="right">✅ Complete audit trail</td><td align="right">❌ No audit trail</td></tr><tr><td>Temporal analysis</td><td align="right">✅ "State at time X" queries</td><td align="right">❌ Not possible</td></tr><tr><td>Performance impact</td><td align="right">❌❌ Severe on dimensions</td><td align="right">✅ Minimal</td></tr><tr><td>Use case</td><td align="right">Small tables, compliance, rare queries</td><td align="right">Most dimension tables</td></tr></tbody></table>

***

## Cost optimization summary

**UPSERT Mode = Balanced processing and storage costs**

| Aspect                                     | Impact                | Explanation                                        |
| ------------------------------------------ | --------------------- | -------------------------------------------------- |
| Insertion                                  | ⚠️ Moderate cost      | MERGE requires PK matching (WHERE clause)          |
| Hash optimization                          | ✅ Significant savings | Skips unchanged rows (no operation)                |
| Storage (no historization)                 | ✅ Stable              | One row per entity                                 |
| Storage (with historization)               | ❌ Growing             | Multiple versions per entity                       |
| Queries (no historization)                 | ✅ Simple              | Direct access to current values                    |
| Queries (with historization on dimensions) | ❌❌ VERY EXPENSIVE     | Full table scans, no partition pruning             |
| Overall                                    | ✅ Best balance        | Optimal for most scenarios (without historization) |

Recommendation: Use UPSERT as default, **avoid historization on dimension tables** unless there's a strong business case and table size is manageable.
