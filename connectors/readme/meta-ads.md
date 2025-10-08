---
description: 'Follow our setup guide to connect Meta to QUANTI:'
---

# Meta Ads

<a href="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Facebook Ads to QUANTI:, you need:

An active **Meta Ads Manager** account with the following permissions for the accounts you'd like to sync:

* An `ads_read` permission to sync Ads report information for any Ad accounts that you own or have been granted access to through this permission.
* An `ads_management` permission to sync Ads accounts' metadata. This permission also requests the `id` and `account_timezone` fields of Ad accounts. The `account_timezone` field is required to save the correct report date in the destination.
* A `business_management` permission is mandatory to ensure a successful setup. Without this permission, setup tests will fail

The [breakdowns](https://developers.facebook.com/docs/marketing-api/insights/breakdowns) and [fields](https://developers.facebook.com/docs/marketing-api/insights) you'd like to sync.

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Facebook account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select accounts to sync.
4. Create queries: You can either select pre-built queries or create your own custom queries.

***

## <mark style="background-color:blue;">Pre-built Queries</mark>

* **ad\_stats:** Advertising performance at ad level.
* **ad\_conv:** Conversion performance at ad level.
* **adset\_stats:** Advertising performance at ad set level.
* **campaign\_stats:** Advertising performance at campaign level.
* **account\_history:** Account-level metadata history.
* **creative\_history**: Creative-level metadata history.
* **campaign\_history:** Campaign-level metadata history.
* **ad\_set\_history:** Ad set-level metadata history.
* **ad\_history:** Ad-level metadata history.
* **ad\_stats\_age\_gender:** Ad performance broken down by age and gender.
* **ad\_conv\_age\_gender:** Conversion data broken down by age and gender.
* **ad\_stats\_country\_region:** Ad performance broken down by country and region.

{% hint style="warning" %}
When performing a historical data load, the account\_history and campaign\_history tables ignore the selected start date — they retrieve all available data since the ad account was created.

In contrast, the creative\_history, ad\_history, and adset\_history tables only load items that have been modified after the specified start date.

This behavior is designed to optimize performance and reduce load times.

As a result, any item that hasn’t changed during the selected period will not appear in these \_history tables.

We recommend running two separate historical loads:

* One for campaign performance statistics
* Another for dimension tables (the \_history tables)

Be sure to choose a start date far enough in the past to ensure that all relevant items are properly captured.
{% endhint %}

***

<a href="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Custom query</mark>

To help you create your own custom queries and understand the compatibility of fields, you can build the custom reports you need using the [Facebook Graph API Explorer](https://developers.facebook.com/docs/graph-api/guides/explorer/) and then replicate them in Quanti:. The Explorer indicates field compatibility, highlights potential errors, and shows whether the data you need is available.&#x20;

The Meta connector relies entirely on Meta's "[API insights](https://developers.facebook.com/docs/marketing-api/insights)" documentation.
