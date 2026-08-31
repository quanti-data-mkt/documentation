---
description: Follow our setup guide to push Classifications and offline data to Adobe Analytics with QUANTI:
---

# Adobe Analytics (Reverse)

{% hint style="info" %}
This connector replaces the two separate connectors that previously handled **Adobe Analytics — Classification** and **Adobe Analytics — Data Source**. Both push types are now available in a single connector.
{% endhint %}

{% hint style="warning" %}
Adobe Analytics takes time to process imports — it does not communicate how long this processing takes. Imported data is **not immediately visible** in the interface.

We recommend syncing this connector **no more than once per day** to give Adobe sufficient processing time.
{% endhint %}

***

## Overview

The Adobe Analytics Reverse connector pushes data **from your data warehouse into Adobe Analytics**. It supports two push types:

* **Classification** — enriches an Adobe Analytics dimension by importing a lookup table (e.g. tracking code → campaign name, channel…)
* **Data Source** — imports offline business data (CRM, call center, in-store transactions) to unify attribution across online and offline channels

In data warehousing terms: Classifications populate **dimension tables** and Data Sources populate **fact tables**. Adobe matches them using a shared primary key (the tracking code).

***

## Prerequisites

* An **Adobe Experience Cloud** account with access to Adobe Analytics
* Access to [Adobe Developer Console](https://developer.adobe.com/console) to create OAuth Server-to-Server credentials

***

## Setup Instructions

{% stepper %}
{% step %}
**Create your API credentials**

In [Adobe Developer Console](https://developer.adobe.com/console/home):

1. Create a new project (or open an existing one)
2. Click **Add API** and select **Adobe Analytics**
3. Choose **OAuth Server-to-Server** as the authentication method
4. Give your project a name (e.g. `Quanti Reverse Connector`)
5. Select your organization and click **Save configured API**

Note your **Client ID** (API Key) and **Client Secret** — you will need both in the next step. Your **Global Company ID** will be detected automatically.
{% endstep %}

{% step %}
**Authorize your Adobe Analytics connection**

In QUANTI:, enter the credentials you retrieved:

* **Client ID** — found on the project overview page in Adobe Developer Console
* **Client Secret** — click *OAuth Server-to-Server → Retrieve Client Secret*

QUANTI: will automatically detect the **Global Company ID** associated with your credentials.
{% endstep %}

{% step %}
**Select your Report Suites**

Choose the Adobe Analytics Report Suites into which classifications and offline data will be pushed.
{% endstep %}

{% step %}
**Choose your push type**

Select the push templates to activate:

* **Classification** — to enrich an Adobe Analytics dimension (lookup table import)
* **Data Source — Offline import** — to import offline events and transactions

You can activate both in a single connector. Field mapping is configured in the **Mapping** tab after the connector is created.
{% endstep %}

{% step %}
**Connector information**

* **Connector name** — must be unique within your QUANTI: project

Source queries and field mappings for each activated push type are configured in the **Mapping** tab after creation.
{% endstep %}
{% endstepper %}

***

## Push Types

### Classification

Imports a lookup table that enriches an Adobe Analytics dimension. Each row maps a **key** (dimension value, e.g. a tracking code) to one or more classification columns (e.g. Channel, Campaign Name).

Adobe matches the imported keys against collected dimension values in your report suite.

**Available fields:**

| Field | Type | Required | Description |
|---|---|---|---|
| `key` | STRING | ✅ | The dimension value to classify (e.g. tracking code, product ID). Primary key used by Adobe to match against collected data. |
| `channel` | STRING | — | Example classification column — rename or replace to match your dimension sub-attributes in Adobe. |
| `campaign_name` | STRING | — | Example classification column — rename or replace to match your dimension sub-attributes in Adobe. |

{% hint style="info" %}
Classification columns are flexible: add or rename them to reflect your exact classification dataset in Adobe Analytics. The only mandatory field is `key`.
{% endhint %}

**Before activating Classification**, you must declare your classification fields in Adobe Analytics:

1. In Adobe Analytics, go to **Admin → Report Suites → \[select your suite\] → Edit Settings → Conversion → Conversion Classifications**
2. Select Classification Type (e.g. **Campaign**) and add your classification field names
3. Note the field names — they must match the column names you configure in QUANTI:

📖 [Adobe Classifications API documentation](https://developer.adobe.com/analytics-apis/docs/2.0/guides/endpoints/classifications/)

***

### Data Source — Offline import

Imports offline events (CRM conversions, call center data, in-store transactions) into Adobe Analytics via the Data Sources 2.0 API. Enables unified attribution between digital campaigns and offline conversions.

**Available fields:**

| Field | Type | Required | Description |
|---|---|---|---|
| `row_id` | STRING | ✅ | Internal row identifier — used as idempotence key for the import batch. |
| `date` | DATE | ✅ | Date of the offline event (transaction date, call date…). Sent to Adobe as MM/DD/YYYY. |
| `visitor_id` | STRING | — | Adobe Analytics visitor ID (MCID / ECID). Used to stitch the offline event to an online session when available. |
| `campaign` | STRING | — | Tracking code (campaign variable) for offline attribution back to digital campaigns. |
| `events` | STRING | — | Comma-separated list of Adobe Analytics events triggered by this row. |
| `revenue` | FLOAT | — | Transaction revenue, margin, or lead value. |
| `currency` | STRING | — | ISO 4217 currency code (e.g. `EUR`, `USD`). |
| `products` | STRING | — | Product string in Adobe Analytics format. |

{% hint style="info" %}
The `campaign` field is the join key between your Data Source rows and your Classification lookup: Adobe uses it to attach classification attributes (channel, campaign name…) to each offline event.
{% endhint %}

**Before activating Data Source**, you must create the data source and declare your custom metrics in Adobe Analytics:

1. Go to **Admin → Data Sources → \[select your suite\] → Create**
2. Select **Ad Campaigns** then **Generic Pay-Per-Click Service**
3. Name your data source and provide a notification email
4. Map your custom metrics and tracking code fields as prompted

Then declare custom metrics at **Admin → Report Suites → Edit Settings → Conversion → Success Events**.

📖 [Adobe Data Sources API documentation](https://developer.adobe.com/analytics-apis/docs/2.0/guides/endpoints/data-sources/)

***

## How Classification and Data Source work together

Adobe Analytics matches your two imports using the **tracking code** as a shared primary key:

* The **Data Source** row carries the `campaign` field (tracking code) + metrics (revenue, events…)
* The **Classification** row carries the same `key` (tracking code) + dimension attributes (channel, campaign name…)

Adobe joins them in the interface, giving you a fully enriched view of your offline conversions — segmented by campaign, channel, and any other classification dimension you configured.

***

## Scheduling

* **Default frequency**: Daily (recommended — at 3 AM)
* **Lookback window**: 2, 7, or 30 days (default: 7 days)
* **Historical load**: 3, 6, or 12 months — or a custom date range (up to 365 days)

***

## Troubleshooting

<details>

<summary>Data imported but not visible in Adobe Analytics yet</summary>

Adobe Analytics processes imports asynchronously and does not expose a processing timeline. Wait at least a few hours after a sync before checking the interface. Avoid triggering multiple syncs in quick succession.

</details>

<details>

<summary>Classification keys are not matching</summary>

Verify that the `key` values in your QUANTI: mapping exactly match the dimension values collected in Adobe Analytics (case-sensitive). A mismatch means Adobe cannot attach classification attributes to those rows.

</details>

<details>

<summary>Authentication error / Invalid credentials</summary>

* Verify that your **Client ID** and **Client Secret** are correct and that the OAuth Server-to-Server credential is active in Adobe Developer Console
* Ensure the Adobe Analytics API has been added to the project and is set to **OAuth Server-to-Server**

</details>

<details>

<summary>Need help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>
