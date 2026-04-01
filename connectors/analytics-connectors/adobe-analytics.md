---
description: 'Follow our setup guide to connect Adobe Analytics to QUANTI:'
---

# Adobe Analytics

<a href="#" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

To connect Adobe Analytics to QUANTI, you need:

* An [Adobe Analytics](https://business.adobe.com/products/analytics/adobe-analytics.html) account
* Access to [Adobe Developer Console](https://developer.adobe.com/console) to create an OAuth Server-to-Server project and retrieve your API credentials

***

## Setup instructions

{% stepper %}
{% step %}
#### Retrieve your API credentials

In [Adobe Developer Console](https://developer.adobe.com/console):

1. Create a new project (or open an existing one)
2. Click **Add API** and select **Adobe Analytics**
3. Choose **OAuth Server-to-Server** as the authentication method
4. Note your **Client ID** and **Client Secret**

Your **Global Company ID** is found in Adobe Analytics under **Admin > Company Settings**.
{% endstep %}

{% step %}
#### Authorize your account

In QUANTI, enter the credentials retrieved in the previous step:

* **Client ID**
* **Client Secret**
* **Global Company ID**
{% endstep %}

{% step %}
#### Select Report Suites

Choose the Adobe Analytics Report Suites you want to sync.
{% endstep %}

{% step %}
#### Select pre-built reports

Select the pre-built reports you want to activate, and/or create your own custom reports. To help you configure custom reports, refer to the **Custom reports** chapter below.
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}
{% endstepper %}

***

## Pre-built reports

* **campaign\_performance**: Visits, visitors, bounces, revenue, orders, and pageviews per tracking code (campaign).
* **pages\_performance**: Pageviews, visitors, visits, exits, and bounces per page.

***

<a href="#" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Custom reports

Adobe Analytics custom reports let you query any combination of dimensions and metrics available in your Report Suite via the [Adobe Analytics Reporting API 2.0](https://developer.adobe.com/analytics-apis/docs/2.0/).

#### Find available dimensions and metrics

The full reference for available dimensions and metrics is the official Adobe Analytics API documentation:
👉 [developer.adobe.com/analytics-apis/docs/2.0/](https://developer.adobe.com/analytics-apis/docs/2.0/)

Dimensions follow the pattern `variables/<name>` (e.g. `variables/campaign`, `variables/page`) and metrics follow `metrics/<name>` (e.g. `metrics/visits`, `metrics/pageviews`).

{% hint style="info" %}
**Use an AI assistant to speed up the configuration.** Describe the report you want to reproduce — as you see it in the Adobe Analytics interface — to an AI assistant (Claude, ChatGPT…). For example:

> *"I want to build a custom Adobe Analytics report showing visits, bounces and revenue by marketing channel. What dimension and metrics should I use in the QUANTI JSON format `{ "dimension": "", "metrics": [] }` ?"*

The AI will identify the correct `dimension` value and the exact `metrics` array for you.
{% endhint %}

#### Configure the custom report

In QUANTI, at the **Select pre-built reports** step, click **Add custom report**. Fill in the following JSON:

```json
{
  "dimension": "",
  "metrics": []
}
```

* **`dimension`** *(required)*: The Adobe Analytics dimension ID (e.g. `"variables/campaign"`, `"variables/page"`, `"variables/browser"`)
* **`metrics`** *(required)*: Array of metric IDs to retrieve (e.g. `["metrics/visits", "metrics/pageviews", "metrics/bounces"]`)

#### Map your fields (Schema)

After configuring the query, the **Schema** step lets you define how fields are stored in your data warehouse:

* Adjust the **Type** (STRING, INTEGER, FLOAT…) for each field
* Check **Unique identifiers** to mark dimension fields as part of the primary key — they collectively form the unique identifier of each row

Once all fields are mapped, click **Save** to create the custom report table.
