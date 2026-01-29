# Lookback window

The **lookback window** defines the **time period** that a connector will retrieve data for during each synchronization, relative to the reference date.

{% hint style="info" %}
Why use a lookback window?

Data on source platforms (Google Ads, Meta, etc.) is not always immediately finalized. Several factors can cause retroactive changes:

* **Data processing delays**: metrics may be updated hours or days after the actual event
* **Attribution adjustments**: conversions can be attributed retroactively to earlier clicks
* **Platform corrections**: source platforms may correct or recalculate historical data
* **Time zone differences**: events near midnight may be reassigned to the correct date
{% endhint %}

{% stepper %}
{% step %}
### How it works

Instead of only synchronizing data for the reference date, the connector retrieves data for a **period including past days** (the lookback window) to capture retroactive updates.
{% endstep %}

{% step %}
### Example with a 7-day lookback window

Today's date: 2025-01-22\
Reference date: 2025-01-15\
Lookback window: 7 days

Data retrieved for dates:

* 2025-01-15 (reference date)
* 2025-01-14
* 2025-01-13
* 2025-01-12
* 2025-01-11
* 2025-01-10
* 2025-01-09 (reference date - 6 days)

All data for these 7 days is retrieved and synchronized, ensuring any retroactive updates are captured.
{% endstep %}

{% step %}
### Practical example

Initial sync on 01/16:

```
| date       | campaign_id | clicks |
| 2025-01-15 | camp_123    | 100    |
```

Sync on 01/20 with 7-day lookback:

```
| date       | campaign_id | clicks |
| 2025-01-15 | camp_123    | 105    | ← updated (5 additional clicks attributed retroactively)
```
{% endstep %}

{% step %}
### Impact by insertion method

The lookback window interacts differently with each insertion method:

* **REPLACE Mode**: Previous data within the lookback window is deleted and replaced with fresh data from the source.
* **UPSERT Mode**: Rows are updated with new values, preserving history if configured.
* **INSERT Mode**: May create duplicates if the same data is retrieved multiple times (not recommended with lookback).
{% endstep %}

{% step %}
### Typical lookback window values

| Platform Type                            | Common Lookback | Reason                                 |
| ---------------------------------------- | --------------- | -------------------------------------- |
| Advertising platforms (Google Ads, Meta) | 3-7 days        | Attribution windows, conversion delays |
| Analytics platforms (GA4)                | 1-3 days        | Processing delays, session completion  |
| CRM/Sales (Salesforce, HubSpot)          | 1-2 days        | Data entry delays, batch updates       |
| E-commerce (Shopify, WooCommerce)        | 1-2 days        | Order updates, refunds                 |
{% endstep %}

{% step %}
### Trade-offs

<table><thead><tr><th width="160.20703125">Critère</th><th>Longer Lookback Window</th><th>Shorter Lookback Window</th></tr></thead><tbody><tr><td><strong>Data completeness</strong></td><td>✅ More complete and accurate data</td><td>⚠️ Risk of missing retroactive updates</td></tr><tr><td><strong>Retroactive changes</strong></td><td>✅ Captures all platform corrections</td><td>❌ May miss late attribution or corrections</td></tr><tr><td><strong>API costs</strong></td><td>❌ Higher (more data retrieved per sync)</td><td>✅ Lower (less data per sync)</td></tr><tr><td><strong>Synchronization time</strong></td><td>❌ Longer processing time</td><td>✅ Faster synchronizations</td></tr><tr><td><strong>Data warehouse costs</strong></td><td>❌ Higher (more partitions scanned/written)</td><td>✅ Lower (fewer partitions affected)</td></tr><tr><td><strong>Data consistency</strong></td><td>✅ More reliable for reporting</td><td>⚠️ Potential inconsistencies over time</td></tr><tr><td><strong>Use case</strong></td><td>Critical metrics, attribution analysis</td><td>High-volume data, stable metrics</td></tr></tbody></table>
{% endstep %}

{% step %}
### Best practices

* Configure the lookback window based on the **platform's attribution window**.
* Monitor data stability: if values change significantly after several days, increase the lookback.
* For critical metrics, prefer a longer lookback window to ensure data accuracy.
* For high-volume tables with stable data, a shorter lookback may be sufficient.
{% endstep %}

{% step %}
### Configuration in Quanti

The lookback window is configured at the connector level and can be adjusted based on your data quality requirements and platform-specific behavior.
{% endstep %}
{% endstepper %}
