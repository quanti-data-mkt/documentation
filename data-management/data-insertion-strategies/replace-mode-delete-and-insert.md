# Replace mode : Delete and insert

## How it works

REPLACE Mode follows a two-step process: delete existing data within a defined scope, then insert new data.

This ensures clean data for each synchronization by removing old values before writing new ones.

Technical implementation:

{% stepper %}
{% step %}
### Delete (step 1)

Use a DELETE statement with a WHERE clause to remove data within the sync scope.
{% endstep %}

{% step %}
### Insert (step 2)

Use an INSERT statement to add the new data.
{% endstep %}
{% endstepper %}

The key distinction is the deletion scope, which differs based on table type.

Visual representation:

```
Step 1 - DELETE: Remove data matching the scope
Step 2 - INSERT: Add new data
Result: Only new data remains in the scope
```

***

## Deletion scope by table type

The scope of deletion is critical to understand in REPLACE Mode:

### Fact tables (metrics)

Scope: Only the reference date being synchronized

Example with a daily metrics table:

```
Existing data:
| date       | campaign_id | impressions | clicks |
|------------|-------------|-------------|--------|
| 2025-01-14 | camp_123    | 900         | 45     |
| 2025-01-15 | camp_123    | 1000        | 50     | ← will be deleted
| 2025-01-15 | camp_456    | 800         | 30     | ← will be deleted
| 2025-01-16 | camp_123    | 1100        | 55     |

Synchronization for 2025-01-15 with new data:
DELETE WHERE date = '2025-01-15'  -- Only this date

New data inserted:
| date       | campaign_id | impressions | clicks |
|------------|-------------|-------------|--------|
| 2025-01-15 | camp_123    | 1050        | 52     |
| 2025-01-15 | camp_456    | 820         | 31     |

Final result:
| date       | campaign_id | impressions | clicks |
|------------|-------------|-------------|--------|
| 2025-01-14 | camp_123    | 900         | 45     | ← preserved
| 2025-01-15 | camp_123    | 1050        | 52     | ← replaced
| 2025-01-15 | camp_456    | 820         | 31     | ← replaced
| 2025-01-16 | camp_123    | 1100        | 55     | ← preserved
```

SQL implementation:

{% code title="Fact table SQL" %}
```sql
-- Step 1: Delete the reference date
DELETE FROM campaign_stats 
WHERE _quanti_date = '2025-01-15';

-- Step 2: Insert new data
INSERT INTO campaign_stats (date, campaign_id, impressions, clicks, _quanti_date)
VALUES (...);
```
{% endcode %}

### Dimension tables (attributes)

Scope: The entire table

Example with a campaign attributes table:

```
Existing data:
| campaign_id | name              | status | budget |
|-------------|-------------------|--------|--------|
| camp_123    | Summer Campaign   | ACTIVE | 5000   | ← will be deleted
| camp_456    | Winter Campaign   | PAUSED | 3000   | ← will be deleted
| camp_789    | Spring Campaign   | ACTIVE | 4000   | ← will be deleted

Synchronization with new data:
DELETE FROM campaigns  -- Entire table deleted

New data inserted (current state from source):
| campaign_id | name              | status | budget |
|-------------|-------------------|--------|--------|
| camp_123    | Summer Campaign   | PAUSED | 5500   | ← updated values
| camp_456    | Winter Campaign   | PAUSED | 3000   | ← same values
| camp_890    | Fall Campaign     | ACTIVE | 6000   | ← new campaign

Final result:
| campaign_id | name              | status | budget |
|-------------|-------------------|--------|--------|
| camp_123    | Summer Campaign   | PAUSED | 5500   |
| camp_456    | Winter Campaign   | PAUSED | 3000   |
| camp_890    | Fall Campaign     | ACTIVE | 6000   |

Note: camp_789 is gone (deleted from source platform)
```

SQL implementation:

{% code title="Dimension table SQL" %}
```sql
-- Step 1: Delete entire table
DELETE FROM campaigns;

-- Step 2: Insert current state
INSERT INTO campaigns (campaign_id, name, status, budget)
VALUES (...);
```
{% endcode %}

***

## Advantages

✅ Clean data guaranteed

* No duplicates possible within the sync scope
* Each synchronization provides a clean slate
* Data consistency ensured for each reference date

✅ Handles source corrections

* If source platform recalculates metrics, new values replace old ones
* Perfect for metrics that may be adjusted retroactively
* Ideal when combined with lookback windows

✅ Snapshot accuracy for dimensions

* Dimension tables always reflect the current state from source
* Deleted entities in source are automatically removed
* No stale or obsolete records

✅ Predictable table size

* Fact tables: size is stable per partition (one date = fixed row count)
* Dimension tables: size reflects current source entity count
* No uncontrolled growth

✅ Simple queries

* No need for deduplication logic
* Direct access to the most recent data
* Straightforward aggregations

***

## Disadvantages

❌ Complete loss of historical data on dimensions

* Previous attribute values are permanently deleted
* Cannot track how a campaign status evolved over time
* No audit trail of changes
* Impossible to answer "what was the value on X date?"

❌ Risk during partial failures

* If deletion succeeds but insertion fails, data is lost
* Requires robust error handling and transaction management
* Backup/recovery strategies essential

❌ Higher processing costs

* DELETE operations require scanning data (WHERE clause evaluation)
* More expensive than INSERT mode
* Impact increases with table size

❌ Performance impact on large dimension tables

* Deleting entire table can be slow
* Insertion of large datasets takes time
* Can create locks during synchronization

❌ No historical analysis for dimensions

* Cannot perform time-based analysis on attribute changes
* Cannot reconstruct past states
* Limited analytical capabilities for business intelligence

***

## Use cases

Ideal for:

📊 Fact tables with recalculated metrics

```
Example: Daily advertising metrics (impressions, clicks, conversions)
Reason: Platforms recalculate metrics with attribution windows
Benefit: Lookback window ensures latest values replace old ones
```

📊 Dimension tables requiring current snapshot only

```
Example: Current campaign configurations, active product catalog
Reason: Only current state matters, history not needed
Benefit: Always reflects exact source state, deleted items removed
```

📊 Aggregated data that may be reprocessed

```
Example: Daily summary tables, pre-aggregated reports
Reason: Source may recalculate aggregations
Benefit: Clean replacement ensures accuracy
```

📊 Data quality fixes

```
Example: Correcting malformed data, reprocessing with fixes
Reason: Need to replace incorrect data completely
Benefit: Clean slate for each sync scope
```

Not suitable for:

❌ Dimension tables requiring historical tracking

```
Problem: All previous values are lost permanently
Example: Cannot track campaign status changes over time
Alternative: Use UPSERT mode with historization
```

❌ High-frequency synchronizations on large tables

```
Problem: Delete + insert on large tables is expensive
Example: Hourly syncs on million-row dimension tables
Alternative: Use UPSERT mode or optimize sync frequency
```

❌ Event logs or immutable transactions

```
Problem: Events should never be deleted
Example: Click events, payment transactions
Alternative: Use INSERT mode
```

❌ Compliance or audit requirements

```
Problem: Complete data history may be legally required
Example: Financial transactions, medical records
Alternative: Use UPSERT mode or INSERT mode with archival
```

***

## Best practices

{% stepper %}
{% step %}
### Understand your deletion scope clearly

* Fact tables: only reference date partition affected
* Dimension tables: entire table replaced
* Document this behavior for data consumers
{% endstep %}

{% step %}
### Combine with appropriate lookback windows

* Use lookback to capture source platform corrections
* Balance data accuracy vs. processing costs
* Typical: 3-7 days for advertising platforms
{% endstep %}

{% step %}
### Implement robust error handling

* Use transactions when possible
* Monitor for partial failures
* Have rollback/recovery procedures ready
{% endstep %}

{% step %}
### Consider partitioning strategy

* Ensure fact tables are partitioned by `_quanti_date`
* Verify partition pruning is working correctly
* Monitor partition-level costs
{% endstep %}

{% step %}
### Evaluate historical data needs

* If history is needed for dimensions, use UPSERT instead
* For fact tables, REPLACE is often appropriate
* Document the trade-off decision
{% endstep %}

{% step %}
### Monitor synchronization performance

* Track DELETE + INSERT operation times
* Alert on failures or slowdowns
* Optimize if sync windows become problematic
{% endstep %}

{% step %}
### Backup critical dimension tables

* Before migration to REPLACE mode, backup historical data
* Consider archiving snapshots periodically
* Implement retention policies if needed
{% endstep %}
{% endstepper %}

***

## Example: REPLACE with lookback window

Scenario: Google Ads metrics with 7-day attribution window

```
Day 1 (2025-01-15): Initial sync
| date       | campaign_id | conversions |
|------------|-------------|-------------|
| 2025-01-15 | camp_123    | 10          |

Day 8 (2025-01-22): Sync with 7-day lookback
- Source platform attributes 3 additional conversions to 2025-01-15
- Lookback window retrieves data for 2025-01-15 through 2025-01-22
- REPLACE mode deletes 2025-01-15 data
- New value inserted:

| date       | campaign_id | conversions |
|------------|-------------|-------------|
| 2025-01-15 | camp_123    | 13          | ← updated (10 + 3)
| 2025-01-16 | camp_123    | 15          |
| ...        | ...         | ...         |
| 2025-01-22 | camp_123    | 12          |
```

Without REPLACE mode: You'd have duplicate rows for 2025-01-15 with different conversion values.

With REPLACE mode: Clean data with the most accurate values.

***

## Comparison: Fact tables vs Dimension tables

| Aspect                  | Fact Tables              | Dimension Tables            |
| ----------------------- | ------------------------ | --------------------------- |
| **Deletion scope**      | Reference date only      | Entire table                |
| **Data preserved**      | Other dates untouched    | Nothing preserved           |
| **Historical tracking** | ✅ Yes (by date)          | ❌ No                        |
| **Typical size**        | Very large               | Small to medium             |
| **Sync frequency**      | Daily                    | Daily to weekly             |
| **Performance impact**  | Low (partition-level)    | Medium to High (full table) |
| **Use case**            | Metrics with corrections | Current state snapshots     |
