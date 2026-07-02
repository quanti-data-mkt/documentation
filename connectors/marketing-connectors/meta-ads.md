---
description: 'Follow our setup guide to connect Meta to QUANTI:'
---

# Meta Ads

<a href="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" class="button primary" data-icon="table-tree">Prebuilt reports and definition  </a>

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

{% hint style="warning" %}
### Token Expiration

Authentication tokens from third-party platforms may expire for various reasons. According to Meta's documentation, long-lived tokens are valid for 60 days. However, in practice, token behavior can be inconsistent: some tokens renew automatically while others expire as scheduled. Regular API usage generally reduces the chances of expiration, though this is not guaranteed.

If automatic renewal fails, project members will receive an email notification requesting re-authentication through the connector dashboard.
{% endhint %}

***

## Pre-built Queries

#### Stats & Conversions

* **ad\_stats**: Advertising performance at ad level.
* **ad\_conv**: Conversion performance at ad level.
* **adset\_stats**: Advertising performance at ad set level.
* **adset\_conv**: Conversion performance at ad set level.
* **campaign\_stats**: Advertising performance at campaign level.
* **campaign\_conv**: Conversion performance at campaign level.

#### Dimension Tables (History)

* **account\_history**: Account-level metadata history.
* **creative\_history**: Creative-level metadata history.
* **ad\_image\_history**: Ad image metadata history (URLs, dimensions, status).
* **campaign\_history**: Campaign-level metadata history.
* **ad\_set\_history**: Ad set-level metadata history.
* **ad\_history**: Ad-level metadata history.

#### Breakdowns

* **ad\_stats\_age\_gender**: Ad performance broken down by age and gender.
* **ad\_conv\_age\_gender**: Conversion data broken down by age and gender.
* **ad\_stats\_country\_region**: Ad performance broken down by country and region.
* **ad\_conv\_country\_region**: Conversion data broken down by country and region.
* **ad\_stats\_device\_platform\_placement**: Ad performance broken down by device, platform, and placement.
* **ad\_conv\_device\_platform\_placement**: Conversion data broken down by device, platform, and placement.

{% hint style="warning" %}
When performing a historical data load, the account\_history and campaign\_history tables ignore the selected start date — they retrieve all available data since the ad account was created.

In contrast, the creative\_history, ad\_history, and adset\_history tables only load items that have been modified after the specified start date.

This behavior is designed to optimize performance and reduce load times.

As a result, any item that hasn't changed during the selected period will not appear in these \_history tables.

We recommend running two separate historical loads:

* One for campaign performance statistics
* Another for dimension tables (the \_history tables)

Be sure to choose a start date far enough in the past to ensure that all relevant items are properly captured.
{% endhint %}

***

<a href="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" class="button primary" data-icon="table-tree">Prebuilt reports and definition  </a>

***

## <mark style="background-color:blue;">Custom query</mark>

Custom reports let you build your own queries against the [Meta Ads Insights API](https://developers.facebook.com/docs/marketing-api/insights), with full control over the fields, breakdowns, and attribution windows collected. Each custom report produces a dedicated table in your dataset.

To validate field and breakdown combinations before configuring them in QUANTI, use the [Facebook Graph API Explorer](https://developers.facebook.com/docs/graph-api/guides/explorer/): it shows which fields are compatible with which breakdowns and surfaces errors before any data is collected.

### Building a custom report

In the connector setup, click **Add custom report** and configure:

* **Fields**: metrics and dimensions from the Meta Insights API (e.g. `impressions`, `spend`, `clicks`, `actions`, `conversions`, `reach`, `frequency`, `cpm`, `cpc`, `ctr`…). The full list is available in [Meta's documentation](https://developers.facebook.com/docs/marketing-api/insights/parameters/v21.0#fields).
* **Breakdowns**: optional additional dimensions to split results by (e.g. `age`, `gender`, `country`, `region`, `device_platform`, `publisher_platform`, `impression_device`, `placement`…). Breakdowns must be compatible with the fields selected — the Graph API Explorer will flag incompatible combinations.
* **Level**: granularity of the report — `ad`, `adset`, `campaign`, or `account`.
* **Action attribution windows**: defines the conversion window used to attribute actions to ads. See the compatibility table below.

### Action attribution windows

The `action_attribution_windows` parameter controls which click and view windows are used to count conversions. Not all windows are available on all conversion types:

| Window | Web (Pixel) | Android | iOS 14+ |
|---|:---:|:---:|:---:|
| `1d_click` | ✅ | ✅ | ✅ |
| `7d_click` | ✅ | ✅ | ✅ |
| `1d_view` | ✅ | ✅ | ✅ |
| `28d_click` | ✅ | ✅ | ❌ |
| `28d_view` | ✅ | ✅ | ❌ |
| `7d_view` | ✅ | ✅ | ❌ |

{% hint style="warning" %}
**`28d_click`, `28d_view` and `7d_view` are not available for iOS 14+ app campaigns.** Using these windows on app campaigns targeting iOS 14+ devices will result in empty or incomplete data. Use `1d_click` or `7d_click` for these campaigns.
{% endhint %}

### Deprecated parameters

Since **June 10, 2025**, Meta has deprecated the following two parameters. They are silently ignored by the API regardless of the value passed — Meta now applies its own defaults automatically:

* **`action_report_time`**: Meta now automatically uses `mixed` (impression-based for on-Meta actions, conversion-based for off-Meta actions). This parameter no longer has any effect.
* **`use_unified_attribution_setting`**: Meta now automatically aligns with the ad set's attribution settings. This parameter no longer has any effect.

These parameters have been removed from QUANTI's prebuilt reports and custom report configuration. If you have existing custom reports that included them, the reports will continue to function — the parameters are simply ignored by the API.
