# Insertion method selection guide

## Introduction

Choosing the appropriate insertion method is crucial for data quality and costs. This guide helps you select the right method through a series of simple questions.

While **Quanti automatically selects the optimal method for standard connectors**, this guide is essential when configuring **custom connectors** or understanding Quanti's choices.

***

## Decision Guide: 4 Questions

{% stepper %}
{% step %}
#### What type of data are you synchronizing?

A) Events or transactions that never change once created

* Examples: clicks, impressions, page views, purchases, API calls
* → Go to [INSERT Mode](insert-mode.md)

B) Metrics or measurements tied to a date

* Examples: daily impressions, daily spend, daily conversions
* → Go to Question 2

C) Attributes or properties of entities

* Examples: campaign names, product prices, customer information, account settings
* → Go to Question 3
{% endstep %}

{% step %}
#### Metrics - Does the source recalculate these metrics?

Context: Many advertising platforms (Google Ads, Meta, etc.) recalculate metrics retroactively due to attribution windows, processing delays, or corrections.

A) YES - Metrics may be updated for past dates

* Examples: Google Ads conversions (7-day attribution), GA4 metrics (processing delays)
* → Go to [REPLACE Mode](insertion-method-selection-guide.md#answer-replace-mode-for-facts)

B) NO - Metrics are final once created

* Examples: Real-time sensor data, minute-level logs
* → Go to [INSERT Mode](insert-mode.md)

C) Unsure

* → Default to [REPLACE Mode](replace-mode-delete-and-insert.md) (safer for most advertising/analytics platforms)
{% endstep %}

{% step %}
#### Attributes - Do you need to track how these attributes change over time?

Context: Do you need to know the historical values? For example: "What was the campaign status on January 15th?"

A) YES - I need complete history of changes

* → Go to [UPSERT Mode WITH historization](upsert-mode-update-and-insert.md)

B) NO - I only need the current state

* → Go to Question 4
{% endstep %}

{% step %}
#### Current state only - Do entities deleted from source need to be removed from your warehouse?

Context: UPSERT Mode keeps all records (even if deleted from source), while REPLACE Mode removes them.

A) YES - Deleted entities must be removed immediately

* Example: Product catalog must exactly match current source state
* → Go to [REPLACE Mode for dimensions](replace-mode-delete-and-insert.md)

B) NO - I want to keep deleted entities for historical reference

* Example: Keep deleted campaigns to preserve historical performance data
* → Go to [UPSERT Mode WITHOUT historization](upsert-mode-update-and-insert.md) ⭐ **Recommended default**
{% endstep %}
{% endstepper %}

***

## Methods Comparison

| Aspect                       | INSERT Mode                    | REPLACE Mode                                                 | UPSERT Mode (no hist)          | UPSERT Mode (with hist)         |
| ---------------------------- | ------------------------------ | ------------------------------------------------------------ | ------------------------------ | ------------------------------- |
| **How it works**             | Append new rows                | Delete scope + Insert                                        | Update or Insert (based on PK) | Insert new version              |
| **Deletion scope**           | None                           | <p>• Facts: reference date<br>• Dimensions: entire table</p> | None                           | None                            |
| **Duplicate risk**           | ⚠️ High                        | ✅ None                                                       | ✅ None (hash optimization)     | ✅ None                          |
| **Storage cost**             | ❌ High (grows continuously)    | ✅ Stable                                                     | ✅ Stable                       | ❌ High (versions accumulate)    |
| **Query cost**               | ⚠️ High (deduplication needed) | ✅ Low (direct queries)                                       | ✅ Low (direct queries)         | ❌ Very High (scan all versions) |
| **Processing cost**          | ✅ Lowest (no WHERE clause)     | ⚠️ Medium (DELETE ops)                                       | ⚠️ Medium (MERGE + hash check) | ⚠️ Medium (MERGE + hash check)  |
| **Historical tracking**      | ⚠️ Manual (via timestamps)     | ❌ Lost                                                       | ❌ No                           | ✅ Complete                      |
| **Referential integrity**    | ⚠️ At risk (duplicates)        | ⚠️ At risk (deletions)                                       | ✅ Preserved                    | ✅ Preserved                     |
| **Hash optimization**        | ❌ N/A                          | ❌ N/A                                                        | ✅ Skips unchanged rows         | ✅ Skips unchanged rows          |
| **Query complexity**         | ❌ High (must deduplicate)      | ✅ Simple                                                     | ✅ Simple                       | ❌ High (must filter latest)     |
| **Handles source updates**   | ❌ Creates duplicates           | ✅ Replaces cleanly                                           | ✅ Updates cleanly              | ✅ Creates new version           |
| **Handles deleted entities** | N/A                            | ✅ Removes them                                               | ⚠️ Keeps them                  | ⚠️ Keeps them                   |

***

## When to use each method

Use cases and recommendations:

* Use INSERT Mode when:
  * Events are truly immutable (never updated by source)
  * Raw landing zone before transformation
  * High-granularity timestamped data
  * Example: click events, API logs, sensor readings
* Use REPLACE Mode when:
  * Facts: Source recalculates metrics (with lookback window)
  * Dimensions: Deleted entities must be removed immediately
  * Clean slate needed for each sync
  * Example: Google Ads metrics, product catalogs (exact match)
* Use UPSERT Mode (no historization) when:
  * Default choice for dimension tables ⭐
  * Need to reflect updates while preserving data
  * Want to keep deleted entities for historical reference
  * Table size or query volume makes historization too expensive
  * Example: campaigns, customers, products (90% of dimensions)
* Use UPSERT Mode (with historization) when:
  * Table is small (< 10,000 rows)
  * Query volume is low
  * Strong compliance/audit requirement
  * Understand and accept the query cost implications
  * Example: small account hierarchies, limited configuration tables

***
