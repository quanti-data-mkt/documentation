---
description: 'Follow our setup guide to connect Meta to QUANTI:'
---

# Meta Ads

<mark style="background-color:blue;">Prerequisites</mark>

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

* Ad Stats : Advertising performance at ad level (**Impressions, Clicks, Spend**)
* Ad Conversions : Conversion performance at ad level (**All conversion Types and values**)
* Ad set Stats : Advertising performance at adset level (**Impressions, Clicks, Spend**)
* Campaign Stats : Advertising performance at campaign level  (**Impressions, Clicks, Spend**)

***

[Pre-built tables and definition ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8):link:[ ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8)

***

## <mark style="background-color:blue;">Custom query</mark>

To help you create your own custom queries and understand the compatibility of fields, you can build the custom reports you need using the [Facebook Graph API Explorer](https://developers.facebook.com/docs/graph-api/guides/explorer/) and then replicate them in Quanti:. The Explorer indicates field compatibility, highlights potential errors, and shows whether the data you need is available.&#x20;

The Meta connector relies entirely on Meta's "[API insights](https://developers.facebook.com/docs/marketing-api/insights)" documentation.
