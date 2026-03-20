---
description: 'Follow our setup guide to connect Google Ads to QUANTI:'
---

# Google Ads

<a href="https://dbdiagram.io/e/67a6375d263d6cf9a069bf46/67a63980263d6cf9a069f135" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Google Ads to QUANTI, ensure you have:

* **Google Ads Account Access**: You need access to a [Google Ads](https://ads.google.com/) account with appropriate permissions
* **Customer ID**: Your Google Ads customer ID (found in the upper right corner of your Google Ads interface)
* **Admin or Standard Access**: Sufficient permissions to authorize third-party applications

### Find Your Customer ID

{% stepper %}
{% step %}
Log in to your [Google Ads account](https://ads.google.com/nav/login)
{% endstep %}

{% step %}
In the top right corner of your account, you'll see a 10-digit number (format: XXX-XXX-XXXX)
{% endstep %}

{% step %}
This is your Google Ads Customer ID - note it down for the setup process
{% endstep %}
{% endstepper %}

<figure><img src="../../.gitbook/assets/image (11).png" alt="Google Ads Customer ID location"><figcaption></figcaption></figure>

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize Google Connection

* Click on **Connect to Google Ads**
* You will be redirected to Google's authorization page
* Log in with your Google account credentials
* Review and accept the requested permissions to allow QUANTI to access your Google Ads data
* Click **Allow** to grant access
{% endstep %}

{% step %}
#### Configure Connector

* **Connector Name**: Enter a unique name for this connector (e.g., "Google Ads - Brand Campaign")
* **Dataset ID**: Define the BigQuery dataset ID where data will be stored (will be created automatically if it doesn't exist)
* **Customer ID**: Enter your Google Ads Customer ID (10-digit number without hyphens)
{% endstep %}

{% step %}
#### Select Accounts

* Review the list of Google Ads accounts accessible with your credentials
* Select the account(s) you want to synchronize
* You can connect multiple accounts by creating separate connectors
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built reports

* Review the available pre-built reports (see section below for details)
* All reports are selected by default - you can deselect any you don't need
* Recommended: Keep all reports enabled for comprehensive campaign analysis
* Click **Next**
{% endstep %}

{% step %}
#### Create reports

Select the pre-built reports you want to activate, and/or create your own custom reports. To help you configure custom reports, refer to the **Custom reports** chapter below.
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and lookback window
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete, then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built reports

#### Dimension Tables

These tables track the historical evolution of your Google Ads account structure and configuration. They enable audit trails and analysis of how settings changes impact performance over time.

* **Account History**: Account-level configuration and settings including currency, time zone, auto-tagging status, optimization score, and manager account relationships. Tracks whether the account is a test account, payment eligibility status, and URL tracking templates. Essential for multi-account management and configuration audit trails.
* **Campaign History**: Campaign configuration history including status (enabled, paused, removed), serving status, campaign dates, advertising channel type (Search, Display, Video, Shopping, etc.), channel subtypes, optimization scores, experiment settings, payment modes, URL tracking templates, frequency caps, and video brand safety settings. Enables analysis of campaign evolution and A/B test tracking.
* **Ad Group History**: Ad group configuration including status, type (search standard, display standard, etc.), ad rotation mode, optimized targeting settings, display custom bid dimensions, targeting restrictions, URL tracking templates, and experiment base ad group relationships. Tracks how ad group settings change over time for optimization analysis.
* **Ad History**: Individual ad creative history including ad type (text ad, responsive search ad, etc.), status, policy approval and review status, action items for compliance, system-managed ad indicators, device preferences, display URLs, final URLs (desktop, mobile, app), URL suffixes, tracking templates, and URL collections. Critical for creative performance analysis and policy compliance monitoring.
* **Criterion**: Targeting criteria at ad group level including keywords, audiences, placements, topics, and other targeting methods. Contains detailed criterion configuration including type, text, match type (for keywords), bid adjustments, status, quality scores, final URLs, tracking templates, and user list information. Essential for understanding what triggers ad delivery and for optimizing targeting strategies.
* **Shopping Product**: Shopping product catalog with eligibility status and issues tracking. Includes item ID, Merchant Center account, channel (online/local), language, status (eligible, not eligible), title, brand, Google taxonomy categories (up to 5 levels), merchant-defined product types, condition, and custom attributes (0–4). Useful for identifying product issues and optimization opportunities. ⚠️ Large dimension table — use date-filtered queries and avoid MERGE on the full table.

#### Metric Tables

These are the essential performance tables providing daily metrics at different aggregation levels. They form the foundation for standard campaign performance analysis.

* **Ad Stats**: Daily ad-level advertising performance metrics including impressions, clicks, cost (in micros), conversions, conversion value, interactions, view-through conversions, and Active View metrics (viewable impressions, measurability, viewability percentages). Segmented by device type (desktop, mobile, tablet) and ad network type (Search, Display, YouTube). Essential for analyzing individual ad creative performance and device/network breakdowns. Includes interaction event types to understand engagement patterns.
* **Ad Conversions**: Daily ad-level conversion data broken down by conversion action type. Contains conversion action resource name, category (purchase, lead, signup, etc.), action name, conversion counts, conversion values, all conversions (including cross-device), and view-through conversions. Uses Google Ads platform attribution (default 30-day post-click). Critical for understanding which ads drive specific conversion types and calculating ROI by conversion action. Enables analysis of both online conversion events from Google Ads tags and offline conversions uploaded via offline events.
* **Campaign Stats**: Daily campaign-level performance metrics aggregated across all ad groups and ads. Includes impressions, clicks, cost, conversions, conversion value, interactions, view-through conversions, and Active View metrics. Segmented by device and ad network type. Provides high-level campaign performance overview for quick analysis of campaign delivery, spend tracking, and year-over-year comparisons. Ideal for executive dashboards and campaign-level budget management.
* **Campaign Conversions**: Daily campaign-level conversion metrics broken down by conversion action. Contains the same conversion action details as ad conversions (action name, category, counts, values) but aggregated at campaign level. Enables quick comparison of which campaigns drive the most valuable conversion actions and ROI analysis by campaign. Useful for budget allocation decisions based on conversion performance rather than just clicks or impressions.
* **Search Term Stats**: Actual user search queries that triggered your ads. Contains the exact search terms (not just matched keywords), match type that was used, search term status (added as keyword, excluded, or none), impressions, clicks, cost, conversions, CTR, average CPC, conversion rates, position metrics (absolute top and top impression percentages), and view-through conversions. Critical for search query mining, negative keyword discovery, and understanding user intent vs keyword targeting.
* **Audience Stats**: Performance metrics segmented by audience targeting. Includes audience resource names, user list details, criterion IDs, combined audience information, custom affinity/intent audiences, demographic segments (age, gender, income, parental status), and standard performance metrics. Enables analysis of which audience segments drive the best results and ROI by demographic or behavior-based targeting.
* **Keyword Stats**: Comprehensive keyword-level performance including the keyword text, match type (broad, phrase, exact), approval status, quality score components (quality score, ad relevance, landing page experience, expected CTR), first page CPC estimates, top of page CPC estimates, historical quality scores, search impression share metrics, budget lost impression shares, rank lost impression shares, absolute top impression percentage, top impression percentage, and all standard performance metrics. Essential for keyword optimization, bid management, and quality score improvement.
* **Age Range Stats**: Daily performance metrics broken down by age range targeting (18–24, 25–34, 35–44, 45–54, 55–64, 65+, undetermined) at ad group level. Includes impressions, clicks, cost (micros), conversions, and conversion value. Useful for optimizing bid adjustments and budget allocation across age demographics.
* **Gender Stats**: Daily performance metrics broken down by gender targeting (male, female, undetermined) at ad group level. Includes impressions, clicks, cost (micros), conversions, and conversion value. Enables analysis of gender-based performance differences to refine targeting strategies.
* **Landing Page View**: Daily landing page performance metrics segmented by URL, device, and ad network type. Includes standard traffic metrics (impressions, clicks, cost, conversions) alongside page quality indicators: mobile speed score (1–100), percentage of clicks on mobile-friendly pages, and percentage of clicks on valid AMP pages. Useful for identifying underperforming landing pages and prioritizing UX improvements.
* **Product Group View**: Daily performance metrics for product listing groups in Shopping campaigns. Segmented by campaign, ad group, criterion, and listing group type (subdivision or unit). Includes impressions, clicks, cost (micros), conversions, conversion value, all conversions, CTR, and average CPC. Useful for optimizing product group bids and Shopping campaign structure.
* **Asset Group Product Group View**: Daily performance metrics for product targeting within Performance Max campaigns, at the asset group and listing group filter level. Includes impressions, clicks, cost (micros), conversions, conversion value, and all conversions. Enables granular analysis of which product groups perform best within PMax asset groups.
* **Shopping Performance View**: Shopping campaign performance metrics aggregated at product level. Includes product attributes (item ID, title, brand, category, custom labels, condition, channel, language, country) alongside standard performance metrics (impressions, clicks, cost, conversions, conversion value, all conversions). Essential for identifying top-performing products and optimizing product feed and bidding strategies.

***

<a href="https://dbdiagram.io/e/67a6375d263d6cf9a069bf46/67a63980263d6cf9a069f135" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Custom reports

{% stepper %}
{% step %}
#### Retrieve your field names from the Google Ads Query Language Explorer

The easiest way to identify the field names and report types expected by the Google Ads API is to use the **[Google Ads Query Builder](https://developers.google.com/google-ads/api/docs/developer-toolkit/gaa-query-builder)**.

This tool is the official Google reference for building API queries. It lets you:

* Browse all available **report types** (called _resources_ in the Google Ads API), such as `campaign`, `ad_group`, `search_term_view`, `keyword_view`, `shopping_performance_view`, etc.
* Explore the **fields**, **metrics**, and **segments** available for each resource, along with their exact API names
* Check **field compatibility** — the explorer highlights which fields can be combined in the same query
* Generate a complete **GAQL query** that you can use as a reference to fill in your QUANTI JSON configuration

**How to use it:**

1. Go to [developers.google.com/google-ads/api/docs/developer-toolkit/gaa-query-builder](https://developers.google.com/google-ads/api/docs/developer-toolkit/gaa-query-builder)
2. Select a **resource** from the left panel (e.g., `campaign` for campaign-level data, `ad_group_ad` for ad-level data)
3. Browse the available fields and tick those you want to retrieve — the explorer will warn you if two fields are incompatible
4. Note down:
   * The **resource name** → this will populate the `report` field in your JSON
   * The **selected field names** (in `resource.field_name` format) → these will populate the `fields` value in your JSON
   * Any **filter or sort** conditions you wish to apply

{% hint style="info" %}
Field names follow the `resource.attribute` format. For example, for the `campaign` resource: `campaign.name`, `campaign.status`, `metrics.impressions`, `metrics.clicks`, `metrics.cost_micros`, `segments.date`.
{% endhint %}
{% endstep %}

{% step %}
#### Configure the custom report query

In QUANTI, at the **Create reports** step, click **Add custom report**. A pop-in opens with two steps: **Query** and **Schema**.

In the **Query** step:

* Give your report a name in the **Query name** field — this name will become the table name in your data warehouse

{% hint style="danger" %}
The name chosen for your custom report is the one that names your table in the data warehouse.
{% endhint %}

* Fill in the **Query configuration (JSON)** with the following structure:

```json
{
  "report": "",
  "fields": "",
  "filters": [],
  "sorts": []
}
```

* **`report`** _(required)_: The Google Ads API resource name as identified in the GAQL explorer (e.g., `"campaign"`, `"ad_group_ad"`, `"search_term_view"`).
* **`fields`** _(required)_: A comma-separated string of field names copied from the GAQL explorer.\
  Example: `"fields": "campaign.id, campaign.name, metrics.impressions, metrics.clicks, metrics.cost_micros, segments.date"`
* **`filters`** _(optional)_: An array of filter conditions to restrict the data returned. Each filter is an object with `field`, `operator`, and `value`.\
  Example: `"filters": [{"field": "campaign.status", "operator": "EQUALS", "value": "ENABLED"}]`\
  Can be left as an empty array `[]` if no filter is needed.
* **`sorts`** _(optional)_: An array of sort conditions. Each sort is an object with `field` and `order` (`ASC` or `DESC`).\
  Example: `"sorts": [{"field": "metrics.impressions", "order": "DESC"}]`\
  Can be left as an empty array `[]`.

Once your JSON is filled in, click **Next**.
{% endstep %}

{% step %}
#### Map your fields (Schema)

The second step of the pop-in is the **Schema** mapping. QUANTI infers the type of each field and displays them in a table.

For each field, you can:

* Adjust the **Type** (STRING, INTEGER, FLOAT, etc.)
* Check **Unique identifiers** to mark the field as part of the primary key — this should include all dimension fields of your report (e.g., `campaign.id`, `ad_group.id`, `segments.date`), as they collectively form the unique identifier of each row
* Check **Metric** to flag a field as a numeric metric

Once all fields are correctly mapped, click **Save** to create the custom report table.
{% endstep %}
{% endstepper %}

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your Google account has proper permissions for the Google Ads account
* Check that the Customer ID is entered correctly (10 digits, no hyphens)
* Ensure your account is not suspended or restricted
* Try disconnecting and reconnecting the Google authorization

</details>

<details>

<summary>Missing Data</summary>

* Some metrics may not be available for all campaign types (e.g., Quality Score only applies to Search campaigns)
* Historical data older than 2 years may not be available
* Removed campaigns, ad groups, or ads may not appear in history tables depending on sync settings
* Draft or experiment data may have limited availability

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
