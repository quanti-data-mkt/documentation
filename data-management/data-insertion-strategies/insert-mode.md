# Insert mode : Insert without deleting

## How it works

**INSERT Mode** follows a simple principle: **new data is appended to existing data without any deletion**.

Each synchronization adds rows to the table, regardless of whether similar or identical data already exists.

**Technical implementation:**

INSERT Mode uses straightforward `INSERT` SQL statements **without any `WHERE` clause**. This means:

* No need to scan existing data to check for duplicates
* No complex filtering or comparison operations
* Direct insertion into the table

**Visual representation:**

```
Existing data: [A, B, C]
New data:      [D, E]
Result:        [A, B, C, D, E]
```

**Concrete example with a fact table:**

```
Initial state (campaign_stats table):
| date       | campaign_id | impressions | clicks | _quanti_loaded_at   |
|------------|-------------|-------------|--------|---------------------|
| 2025-01-15 | camp_123    | 1000        | 50     | 2025-01-16 08:00:00 |
| 2025-01-15 | camp_456    | 800         | 30     | 2025-01-16 08:00:00 |

After synchronization (same reference date):
| date       | campaign_id | impressions | clicks | _quanti_loaded_at   |
|------------|-------------|-------------|--------|---------------------|
| 2025-01-15 | camp_123    | 1000        | 50     | 2025-01-16 08:00:00 |
| 2025-01-15 | camp_456    | 800         | 30     | 2025-01-16 08:00:00 |
| 2025-01-15 | camp_123    | 1050        | 52     | 2025-01-17 09:00:00 | ← new row
| 2025-01-15 | camp_456    | 820         | 31     | 2025-01-17 09:00:00 | ← new row
```

**Key characteristics:**

* No deletion operations
* No updates to existing rows
* Each synchronization adds new rows
* Table grows continuously

***

{% hint style="success" %}
#### Advantages

* ✅ Minimal insertion costs
  * **No `WHERE` clause in INSERT queries** = no need to scan existing data
  * Significantly faster insertion compared to UPSERT or REPLACE
  * Lower processing costs during synchronization
  * **Cost transfer: from processing to storage** — it's always cheaper to store data than to process it
* ✅ Maximum data preservation
  * No risk of accidentally losing historical data
  * Every synchronization is safely recorded
  * Ideal for audit trails and compliance requirements
* ✅ Simplicity and performance
  * Fastest insertion method (no DELETE or UPDATE operations)
  * Minimal impact on database resources
  * No locks on existing data
* ✅ Natural append-only pattern
  * Aligns with immutable data principles
  * Perfect for event-driven architectures
  * Easy to implement and understand
* ✅ Reconstruction of uniqueness via \_quanti\_loaded\_at
  * The `_quanti_loaded_at` field records the exact timestamp of row insertion
  * **Enables recreating table uniqueness retrospectively** before transformation steps
  * You can always identify the most recent version of each record
  * Facilitates building deduplicated views or materialized tables downstream
{% endhint %}

{% hint style="warning" %}
#### Disadvantages

* ❌ Significant table growth
  * Storage volume increases with every synchronization
  * Even if source data hasn't changed, new rows are added
  * **Trade-off: lower processing costs → higher storage costs** (but storage remains cheaper)
  * Can lead to very large tables quickly
* ❌ High risk of duplicates
  * If the same data is synchronized twice, it appears twice in the table
  * No built-in deduplication mechanism at insertion time
  * Requires deduplication logic in transformation layer
* ❌ Complex queries required
  * Analytics queries must handle duplicates explicitly
  * Need to determine which row is the "correct" one using `_quanti_loaded_at`
  * Aggregations may produce incorrect results without proper filtering
* ❌ Not suitable for updates
  * Cannot reflect changes to existing records cleanly
  * If a campaign status changes, both old and new values coexist
  * Impossible to get a clean "current state" view without deduplication
{% endhint %}

***

## Use cases

Ideal for:

*   Event logs and activity streams

    ```
    Example: Click events, impression logs, user actions
    Reason: Events are immutable facts that should never be modified
    ```
*   Transaction records

    ```
    Example: Payment transactions, order completions, API calls
    Reason: Each transaction is a unique occurrence in time
    ```
*   Timestamped metrics with high granularity

    ```
    Example: Real-time sensor data, minute-level analytics
    Reason: Each timestamp represents a distinct measurement
    ```
*   Raw data landing zones

    ```
    Example: Initial data ingestion before transformation (bronze layer)
    Reason: Preserve complete historical record of all incoming data
    Cost optimization: Cheaper insertion, deduplication handled in transformation
    ```

Not suitable for:

*   Dimension tables (attributes)

    ```
    Problem: Multiple versions of the same entity without clear "current" state
    Example: A campaign with 10 status changes creates 10 rows
    ```
*   Daily aggregated metrics that may be recalculated

    ```
    Problem: Duplicates make it impossible to know which values are correct
    Example: Same date appears multiple times with different values
    ```
*   Master data or reference tables

    ```
    Problem: No way to update existing records
    Example: Cannot reflect changes to campaign names or budgets
    ```

***

## Best practices

{% stepper %}
{% step %}
### Leverage \_quanti\_loaded\_at for deduplication

* Use `_quanti_loaded_at` systematically in transformation queries to identify the latest version.
* This field is the key to recreating uniqueness.
* Document the deduplication logic for data consumers.
{% endstep %}

{% step %}
### Implement deduplication in transformation layer

* Create deduplicated views or tables downstream.
* Use `ROW_NUMBER()` with `PARTITION BY` on primary key fields.
* Order by `_quanti_loaded_at DESC` to get the most recent version.
{% endstep %}

{% step %}
### Ensure true immutability

* Only use INSERT Mode for data that genuinely never changes once created.
* Verify that your source platform doesn't update historical records.
* If updates occur, INSERT mode will create duplicates without clear resolution.
{% endstep %}

{% step %}
### Monitor table growth

* Set up alerts for unexpected table size increases.
* Implement data retention policies if needed.
* Consider archiving or partitioning old data.
* Balance storage costs against processing cost savings.
{% endstep %}

{% step %}
### Document the choice

* Clearly communicate to data consumers why INSERT Mode is used.
* Provide example queries showing how to handle duplicates.
* Explain the data model and deduplication strategy.
{% endstep %}
{% endstepper %}

***

## Example: Recreating uniqueness with \_quanti\_loaded\_at

The `_quanti_loaded_at` field allows you to reconstruct table uniqueness before transformations.

Get the most recent version of each record:

```sql
SELECT *
FROM campaign_stats
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY date, campaign_id  -- Primary Key fields
  ORDER BY _quanti_loaded_at DESC -- Most recent insertion first
) = 1
```

Create a deduplicated view:

```sql
CREATE VIEW campaign_stats_unique AS
SELECT 
  date,
  campaign_id,
  impressions,
  clicks,
  _quanti_loaded_at
FROM campaign_stats
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY date, campaign_id
  ORDER BY _quanti_loaded_at DESC
) = 1
```

Aggregate unique events only:

```sql
SELECT 
  date,
  campaign_id,
  SUM(impressions) as total_impressions,
  SUM(clicks) as total_clicks
FROM (
  SELECT *
  FROM campaign_stats
  QUALIFY ROW_NUMBER() OVER (
    PARTITION BY date, campaign_id
    ORDER BY _quanti_loaded_at DESC
  ) = 1
)
GROUP BY date, campaign_id
```

***

## Cost optimization summary

**INSERT Mode = Lower processing costs + Higher storage costs**

| Aspect        | Impact            | Explanation                            |
| ------------- | ----------------- | -------------------------------------- |
| **Insertion** | ✅ Cheaper         | No `WHERE` clause = no data scanning   |
| **Storage**   | ❌ More expensive  | Table grows with every sync            |
| **Queries**   | ⚠️ More expensive | Need to scan more rows and deduplicate |
| **Overall**   | ✅ Net positive    | Storage is cheaper than compute        |

Best use case: Raw data ingestion layers where deduplication is handled downstream in transformation pipelines.
