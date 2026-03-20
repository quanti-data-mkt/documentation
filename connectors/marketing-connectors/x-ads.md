---
description: 'Follow our setup guide to connect X Ads to QUANTI:'
---

# X Ads

<a href="https://dbdiagram.io/e/x-ads-placeholder" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect X Ads to QUANTI:, you need:

* An active **X Ads account** (formerly Twitter Ads) with access to [ads.x.com](https://ads.x.com)
* **Admin or Campaign Manager** permissions on the ad accounts you want to sync
* An `Ads Read` permission to retrieve campaign performance data
* At least one active or historical ad account with campaigns

***

## <mark style="background-color:blue;">Setup instructions</mark>

{% stepper %}
{% step %}
#### Authorize X Ads Connection

* Click on **Connect to X Ads**
* You will be redirected to X's OAuth authorization page
* Log in with your X account credentials (the one with Ads Manager access)
* Review the requested permissions and click **Authorize app**
{% endstep %}

{% step %}
#### Configure Connector

* **Connector Name**: Enter a unique name for this connector (e.g., "X Ads - Brand Campaigns")
* **Dataset ID**: Define the BigQuery dataset ID where data will be stored (will be created automatically if it doesn't exist)
{% endstep %}

{% step %}
#### Select Accounts

* Review the list of X Ads accounts accessible with your credentials
* Select the account(s) you want to synchronize
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default — deselect any you don't need
* Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and lookback window
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete, then navigate to your data warehouse to verify that tables are populated
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
### Token Expiration

X Ads API tokens may expire or be revoked if your X account password is changed or if the app authorization is manually revoked from X's connected apps settings. If synchronization fails with an authentication error, reconnect the connector from the dashboard.
{% endhint %}

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

### Dimension Tables

* **Account**: Account-level metadata including account ID, name, timezone, currency, and creation date. Essential for multi-account reporting and understanding the account configuration.
* **Campaign History**: Campaign configuration including name, status, objective (website clicks, video views, app installs, reach, engagement), daily budget, total budget, start and end dates, and last modification timestamp.
* **Ad Group History**: Ad group (line item) details including campaign reference, name, bid type, bid amount, placement (timeline, search, profile, network), start and end dates, and targeting summary.
* **Ad History**: Individual promoted tweet or ad details including ad group reference, creative reference, status, and serving information.
* **Media Creative History**: Creative asset metadata including media keys, title, call-to-action type, URL, and approval status.

### Metric Tables

* **Campaign Daily Stats**: Daily performance metrics at campaign level including impressions, clicks, engagements, retweets, likes, follows, replies, video views, spend (in micro-currency), and derived metrics such as CTR, CPE, and CPM.
* **Ad Group Daily Stats**: Daily performance metrics at ad group level, same metrics as campaign level but broken down by line item for granular budget management.
* **Ad Daily Stats**: Daily performance metrics at individual ad level including impressions, clicks, engagements, video completions (25%, 50%, 75%, 100%), spend, and conversion events.
* **Conversion Events**: Conversion tracking data including conversion type, conversion value, post-engagement conversions, post-view conversions, and associated campaign/ad references.

### Breakdown Tables

* **Stats by Device**: Campaign performance segmented by device type (mobile, desktop, tablet) enabling cross-device analysis and budget allocation optimization.
* **Stats by Region**: Campaign performance broken down by geographic region, useful for geo-targeted campaigns and market-level analysis.
* **Stats by Gender**: Performance segmentation by inferred gender, enabling audience insight and creative optimization.

***

<a href="https://dbdiagram.io/e/x-ads-placeholder" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Troubleshooting</mark>

<details>

<summary>Connection Issues</summary>

* Verify that your X account has Ads Manager access on the intended ad accounts
* Ensure the X app authorization has not been revoked (check X Settings → Security → Connected Apps)
* Try disconnecting and reconnecting the authorization from the QUANTI connector dashboard
* Make sure you are using the X account that owns or has been granted access to the ad account

</details>

<details>

<summary>Missing Data</summary>

* Performance data is only available for campaigns that have been active and served impressions
* Conversion data requires proper X Pixel or App SDK implementation on your website or app
* Historical data availability depends on X's API retention policy (typically up to 2 years)
* Breakdown tables (device, region, gender) may return limited data for small-volume campaigns due to privacy thresholds

</details>

<details>

<summary>Metric Discrepancies</summary>

* Minor differences between X Ads Manager and QUANTI can occur due to:
  * Time zone differences (X Ads uses UTC by default)
  * Spend is stored in micro-currency (divide by 1,000,000 to get the actual value)
  * Data freshness: X Ads data can be delayed by up to 24 hours

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
