---
description: 'Follow our setup guide to connect your Matomo connector with QUANTI:'
---

# Matomo

<a href="https://dbdiagram.io/e/689b41c01d75ee360a3d6e88/689b474e1d75ee360a3e98a0" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

To connect Matomo to QUANTI:, you need a [Matomo](https://fr.matomo.org/login/) account.

***

## Setup instructions

### Find your Auth token

1. Go to Matomo settings Settings Cog Icon > Personal > Security.
2.  At the bottom of the page, click on Create new token.<br>

    <figure><img src="../../.gitbook/assets/image (2) (1) (1).png" alt=""><figcaption></figcaption></figure>
3. Confirm your account password.
4. Enter the purpose for this token.
5. Choose if the token should only be valid for secure requests (Matomo 5 and newer).
6. Click on Create new token.

### Connector configuration

1. Authentication
   1. Enter the Auth token you retrieved in the previous step.
   2. Enter the Matomo URL that allows you to access your reports. This should be in the form: https://data.yourwebsite.com.
2. Connector information
   1. Connector Name: Name your connector. It must be unique.
   2. Dataset ID: Define the ID of the dataset. It must not already exist, as it will be created and data will be sent there.
3. Select your Advertiser Id: Choose your Advertiser ID.
4. Select the pre-built reports you want to synchronize, and/or create your own custom reports. To help you configure custom reports, refer to the **Custom reports** chapter below.

***

## Pre-built reports

* **visitor\_country**: Tracks website visits, user actions, and conversions segmented by the visitor's country.
* **visitor\_language**: Records website engagement metrics based on the visitor's preferred language.
* **visitor\_device\_type**: Measures website activity by the type of device used (e.g., desktop, mobile, tablet).
* **behaviour\_page**: Monitors page-level behavior, including entrances, exits, pageviews, and time spent.
* **acquisition\_campaign**: Captures visitor metrics grouped by marketing campaign name.
* **acquisition\_referrer**: Logs visits and conversions by referring source, type, and URL.
* **acquisition\_channel\_type**: Aggregates website performance by high-level marketing channel type.

***

<a href="https://dbdiagram.io/e/689b41c01d75ee360a3d6e88/689b474e1d75ee360a3e98a0" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Custom reports

Matomo custom reports let you query any endpoint of the [Matomo Reporting API](https://developer.matomo.org/api-reference/reporting-api) and bring the result directly into your data warehouse.

#### Find available methods and fields

Each custom report is built around a **Matomo API method** (e.g. `VisitsSummary.get`, `Events.getCategory`). The method determines which fields are returned.

Two ways to explore what's available:

* **Matomo official reference**: [developer.matomo.org/api-reference/reporting-api](https://developer.matomo.org/api-reference/reporting-api) — full list of methods and their returned fields
* **Your own Matomo instance**: call the following endpoint to get metadata for all reports available on your site:

```
https://<your-matomo-instance>/index.php?module=API&method=API.getReportMetadata&idSite=<id>&period=day&date=today&format=JSON&token_auth=<token>
```

{% hint style="info" %}
**Not sure which fields to pick?** Describe the report you see in the Matomo interface to an AI assistant (Claude, ChatGPT…) — it will identify the corresponding API method and the right `fields` string for you.
{% endhint %}

#### Configure the custom report

In QUANTI, at the **Select pre-built reports** step, click **Add custom report**. Fill in the following JSON:

```json
{
  "report": "",
  "flat": "1",
  "fields": ""
}
```

* **`report`** *(required)*: The Matomo API method name (e.g. `"VisitsSummary.get"`, `"Events.getCategory"`)
* **`flat`**: Set to `"1"` to flatten nested JSON structures — recommended for most reports
* **`fields`** *(optional)*: Comma-separated list of field names to retrieve. If omitted, all fields returned by the method are ingested — useful for a first run to discover what arrives in BigQuery

> ℹ️ Regardless of the method used, the following fields are always added by QUANTI: `date`, `website_id`, `website_name`.

#### Common report examples

| Report | `report` value | Key `fields` |
|---|---|---|
| Visit summary | `VisitsSummary.get` | `nb_visits,nb_uniq_visitors,nb_actions,bounce_rate,avg_time_on_site` |
| Event categories | `Events.getCategory` | `label,nb_events,sum_event_value,avg_event_value` |
| Campaigns | `Referrers.getCampaigns` | `label,nb_visits,nb_actions,bounce_rate,revenue` |
| Channel types | `Referrers.getReferrerType` | `label,nb_visits,nb_actions,avg_time_on_site,bounce_rate` |

#### Map your fields (Schema)

After configuring the query, the **Schema** step lets you define how fields are stored in your data warehouse:

* Set the **field type** (STRING, INTEGER, FLOAT, DATE…) for each field
* Check **Unique identifiers** to mark dimension fields as part of the primary key (e.g. `date`, `label`, `website_id`) — they collectively form the unique identifier of each row

Once all fields are mapped, click **Save** to create the custom report table.
