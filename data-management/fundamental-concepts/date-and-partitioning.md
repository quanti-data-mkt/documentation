# Date & Partitioning

The **reference date** (or synchronization date) defines the **temporal scope** of each synchronization.

## How it works

Quanti processes queries and insertions **date by date**. For each synchronization, a reference date is defined (for example `2025-01-15`), and all data for that day is processed together.

## Practical example

If you synchronize advertising metrics for **January 15, 2025**:

* Reference date = `2025-01-15`
* All data for that day is retrieved from the source platform
* This data is then inserted into your data warehouse with this reference date

## Partitioning and optimization

On **fact tables (metrics)**, Quanti uses this reference date to partition tables via the `_quanti_date` field.

How does it work?

```
campaign_stats table partitioned on _quanti_date

Partition 2025-01-13: [data from 01/13]
Partition 2025-01-14: [data from 01/14]
Partition 2025-01-15: [data from 01/15]  ← only this partition is affected
Partition 2025-01-16: [data from 01/16]
```

During a synchronization for `2025-01-15`, only the corresponding partition is targeted:

* SQL queries scan **only the affected partition**
* Insert/delete operations are **isolated** to this partition
* Other partitions are neither read nor modified

{% hint style="success" %}
Partitioning by date via `_quanti_date` allows you to:

* **Optimize performance**: SQL queries scan only strictly necessary data
* **Reduce costs**: less data scanned = reduced billing on your data warehouse
* **Speed up synchronizations**: operations are faster because targeted to a data subset
* **Facilitate maintenance**: ability to reprocess a specific day without impacting other dates
* **Determine the deletion scope** in certain insertion methods (REPLACE Mode): only data for this date is affected
{% endhint %}

{% hint style="info" %}
Partitioning by `_quanti_date` is primarily used on **fact tables** (metrics, events) where the date notion is intrinsic to the data. **Dimension tables** (attributes) are generally not partitioned because they represent a global state rather than a time series.
{% endhint %}
