---
description: Follow our setup guide to connect AppsFlyer to QUANTI.
---

# AppsFlyer

AppsFlyer is a mobile attribution and analytics platform. This connector collects your app performance data via the AppsFlyer Pull API: aggregate LTV reports by media source, campaign and geography, as well as raw event-level data for installs, in-app events, uninstalls and reinstalls.

***

## Prerequisites

* An active AppsFlyer account with at least one app configured
* **Account Admin** role (required to retrieve the API Token V2)
* For raw data reports (`installs`, `in_app_events`, `uninstalls`, `reinstalls`): a plan that includes **raw data access**

***

## Setup instructions

{% stepper %}
{% step %}
#### Enter your API Token V2

In AppsFlyer, go to **Security center** > **Manage API tokens** and copy your API Token V2 (a JWT string of 700+ characters). Only account admins can access this page.

Paste the token in QUANTI and click **Continue**.
{% endstep %}

{% step %}
#### Select your apps

QUANTI lists all apps accessible from your AppsFlyer account. Select the apps you want to sync. Each app is identified by its App ID (e.g. `com.example.android` for Android, `id123456789` for iOS).

Apps without real traffic (e.g. internal test apps) can be included — their tables will simply be empty.
{% endstep %}

{% step %}
#### Select prebuilt reports

Choose which tables to activate. Reports are organized into two groups:

* **Aggregate reports** (`daily`, `geo_daily`, `partners_daily`, `partners`, `geo`): summary LTV metrics, no raw data plan required.
* **Raw data reports** (`installs`, `in_app_events`, `uninstalls`, `reinstalls`): user-level data, requires raw data access on your AppsFlyer plan.
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Give your connector a unique name
* **Sync frequency**: Daily (default) or weekly
* **Lookback window**: 7 days by default (up to 30)
* **Historical data**: Up to 24 months of history
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

### Aggregate reports

These tables are sourced from the AppsFlyer Aggregate Pull API. Each row represents LTV metrics — the cumulative lifetime value of users installed on a given date, aggregated by media source, campaign and optional dimensions. The reference date is always the **install date**, not the activity date.

* **daily**: Daily LTV performance by media source and campaign — impressions, clicks, CTR, installs, conversions, conversion rate, sessions, loyal users, total cost, eCPI, total revenue, ROI, ARPU LTV. One row per `date × app_id × view_type × agency × media_source × campaign × conversion_type`. Refreshed with `delete_insert`.

* **partners\_daily**: Same grain and metrics as `daily`, sourced from a separate endpoint (`partners_by_date_report`). The documented difference is that `daily` excludes in-app events from its revenue columns. For non-e-commerce apps the two tables are equivalent. Refreshed with `delete_insert`.

* **geo\_daily**: Same as `partners_daily` with an additional `country_code` dimension — the most granular aggregate table available. One row per `date × app_id × view_type × agency × country_code × media_source × campaign × conversion_type`. Refreshed with `delete_insert`.

* **partners**: Cumulative lifetime metrics by media source and campaign (no date dimension). Represents the all-time totals since the app's first install. A new full snapshot is appended at every run — always filter on `MAX(_quanti_loaded_at)` to get the latest state. Refreshed with `append`.

* **geo**: Same as `partners` with an additional `country_code` dimension. Refreshed with `append`.

### Raw data reports

These tables provide user-level event data. They require raw data access on your AppsFlyer plan. Each row represents a single event attributed to a non-organic user.

* **installs**: One row per install, with full attribution fields (media source, campaign, adset, ad, channel, keywords), device information (platform, device type, OS version, app version, SDK version), geographic data (country, city), user identifiers (AppsFlyer ID, customer user ID), LAT flag, and multi-touch attribution contributors. Refreshed with `delete_insert`.

* **in\_app\_events**: One row per in-app event performed by an attributed user (e.g. `af_purchase`, `af_login`, `ftd`). Includes `event_name`, `event_value` (a JSON-encoded string containing event-specific parameters), `event_revenue`, `event_revenue_currency`, `event_revenue_usd`, attribution dimensions inherited from the original install. Refreshed with `delete_insert`.

* **uninstalls**: One row per detected uninstall for attributed users. Detection is based on silent push notifications — `event_time` reflects the detection date, not the actual deletion date. Attribution fields are inherited from the original install. Refreshed with `delete_insert`.

* **reinstalls**: One row per reinstall of a user who had previously uninstalled the app and was re-attributed to a UA campaign. Includes both `install_time` (reinstall date) and `original_install_time` (first ever install date). Users present in `reinstalls` also appear in `installs` — avoid cross-table deduplication on `appsflyer_id`. Refreshed with `delete_insert`.

{% hint style="warning" %}
**`reinstalls` requires a specific AppsFlyer plan.** If your subscription does not include raw data reports, AppsFlyer returns an HTTP 400 error and the table remains empty. This is expected behavior — no action is needed on your end.
{% endhint %}

***

## Notes

**`total_cost`, `roi`, `total_revenue` — Cost API required**

These columns are `NULL` for all accounts that have not activated the Cost API or ROI360 in AppsFlyer. This is expected for non-e-commerce apps (utilities, GPS, etc.) that do not track in-app revenue or sync ad spend.

**`view_type` — user\_acquisition vs retargeting**

The `view_type` field distinguishes two attribution perimeters:

* `user_acquisition`: classic acquisition traffic (new users, `reattr=false`).
* `retargeting`: re-engagement and re-attribution traffic (`reattr=true`).

The **Unified** view in the AppsFlyer dashboard corresponds to `user_acquisition` + `retargeting` combined. Rows with `view_type = retargeting` often have `NULL` metrics if no retargeting campaign is active.

**Impression and click gap vs AppsFlyer dashboard**

A structural gap of 3%–6% on impressions and clicks is expected on iOS campaigns (primarily Facebook Ads). This is due to the absence of SKAN/SSOT deduplication in the Pull API Aggregate standard used by this connector. The AppsFlyer Unified dashboard applies this deduplication internally. Install counts are unaffected and match exactly. This gap cannot be resolved without activating the SSOT Data Locker with AppsFlyer.

**`partners` and `geo` — snapshot tables**

These two tables accumulate one full snapshot per run. To avoid double-counting, always filter on the most recent snapshot before querying:

```sql
SELECT * FROM `your_dataset.partners`
WHERE _quanti_loaded_at = (SELECT MAX(_quanti_loaded_at) FROM `your_dataset.partners`)
```

**`event_value` in `in_app_events`**

The `event_value` column is a JSON-encoded string. Extract specific fields using `JSON_VALUE`:

```sql
SELECT
  event_name,
  CAST(JSON_VALUE(event_value, '$.af_revenue') AS FLOAT64) AS revenue,
  JSON_VALUE(event_value, '$.af_currency') AS currency
FROM `your_dataset.in_app_events`
WHERE event_name = 'af_purchase'
```
