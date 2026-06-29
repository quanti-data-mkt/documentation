---
description: Follow our setup guide to connect Google Ad Manager to QUANTI.
---

# Google Ad Manager

{% hint style="info" %}
This connector is currently in **beta**. The Google Ad Manager REST API is itself in Open Beta — breaking changes may occur. Monitor the [release notes](https://developers.google.com/ad-manager/api/beta/docs/release-notes) before upgrading.
{% endhint %}

***

## Prerequisites

Before connecting Google Ad Manager to QUANTI, ensure you have:

* An active Google Ad Manager account (standard or 360)
* **Administrator** or **Ad Manager** role on the network
* API access enabled in GAM: **Admin** > **Global settings** > **Network settings** > enable **API access**

***

## Setup instructions

{% stepper %}
{% step %}
#### Connect your Google account

Click **Continue with Google** and authorize QUANTI to access your Ad Manager data. QUANTI requests the `admanager` OAuth scope, which covers both read operations and the report generation endpoint.
{% endstep %}

{% step %}
#### Select your network

QUANTI lists all Ad Manager networks accessible from your Google account. Select the network you want to sync. Each network syncs into its own dataset.
{% endstep %}

{% step %}
#### Select prebuilt reports

Choose which tables to activate. All 7 reports are selected by default. You can deselect tables you don't need.
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Give your connector a unique name
* **Dataset ID**: The dataset will be created automatically, named `googleadmanager_{networkCode}`
* **Sync frequency**: Daily (default), weekly, or monthly
* **Lookback window**: 7 days by default (up to 30)
* **Historical data**: Up to 95 days back via the historical sync tab
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

### Dimensions (reference tables)

* **network**: Configuration and settings of the Ad Manager network — network code, display name, property code, timezone, primary and secondary currencies, root ad unit, test network flag.

* **company**: Directory of advertisers and agencies — company ID, name, type (`ADVERTISER`, `AGENCY`, `HOUSE_ADVERTISER`…), external ID, contact details, last update timestamp.

* **ad\_unit**: Inventory hierarchy — ad unit ID, name, serving code, parent ad unit ID (for tree reconstruction), status (`ACTIVE`, `INACTIVE`, `ARCHIVED`), target window, sizes (JSON), last update timestamp. Historized with SCD2 on `update_time`.

* **placement**: Placement groups and their targeted ad units — placement ID, name, serving code, status, list of targeted ad unit resource names (JSON), last update timestamp. Historized with SCD2 on `update_time`.

* **order**: Trafficking orders — order ID, name, status (`DRAFT`, `PENDING_APPROVAL`, `APPROVED`, `PAUSED`, `CANCELED`, `ARCHIVED`), start/end dates, advertiser ID, agency ID, trafficker ID, total budget, purchase order number, creation timestamp. Historized with SCD2 on `update_time`.

* **line\_item**: Line item delivery settings — line item ID, parent order ID, name, type (`SPONSORSHIP`, `STANDARD`, `NETWORK`, `PRICE_PRIORITY`, `HOUSE`…), status, start/end dates, cost type (CPM, CPC, CPD…), cost per unit (JSON, Google Money format), contracted volume, serving priority, creative rotation, pacing strategy, targeting rules (JSON). Historized with SCD2 on `update_time`.

### Metrics

* **delivery\_stats**: Daily ad serving performance by ad unit — impressions, clicks, CTR, revenue, and average eCPM across all traffic sources (Ad Server, AdSense, Ad Exchange). Granularity: one row per `date × ad_unit_id`. Refreshed with `delete_insert` on the synced date range.

***

## Notes

* **Rate limits**: Ad Manager standard networks are limited to 2 requests/second; Ad Manager 360 networks to 8 requests/second. QUANTI manages backoff automatically.
* **Historical data**: Maximum 95 days per historical sync run. For longer histories, run multiple historical syncs with different date ranges.
* **Lookback window**: Default 7 days. Increase to 30 days if your ad server has late-reporting traffic sources (AdSense, Ad Exchange).
* **JSON fields**: The following columns are stored as JSON strings and must be parsed in BigQuery: `ad_unit_sizes`, `targeted_ad_units`, `targeting`, `cost_per_unit`. To extract the cost per unit value: `CAST(JSON_VALUE(cost_per_unit, '$.units') AS FLOAT64) + CAST(JSON_VALUE(cost_per_unit, '$.nanos') AS FLOAT64) / 1e9`.
* **Ad unit hierarchy**: `ad_unit` is a tree structure (2–5 levels). Reconstruct the full path using recursive CTEs on `parent_ad_unit_id`.
* **SCD2 dimensions**: `ad_unit`, `placement`, `order`, and `line_item` are historized — each modification creates a new row. To get the current state, filter on the latest `update_time` per entity ID.
* **Reporting**: `delivery_stats` uses the asynchronous GAM Reporting API. The report is generated server-side and fetched once ready. This may add a few minutes to the sync time for large networks.
