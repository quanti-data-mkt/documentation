---
description: 'Follow our setup guide to connect Meta Ads Library to QUANTI:'
---

# Meta Ads Library

{% hint style="info" %}
The Meta Ad Library is a **public transparency database** — it does not require authentication and gives access to all ads running on Facebook, Instagram, Messenger, Threads, and Audience Network. It is designed for competitive intelligence: you can track your own or any competitor's creatives and delivery windows without needing access to their ad account.

**Spend and impressions data** are only populated for political/issue ads or for commercial ads that reached EU countries (DSA obligation). For most commercial advertisers, these columns will be null.
{% endhint %}

***

## Prerequisites

* The **Facebook Page ID** of the page(s) you want to monitor — yours or a competitor's. The Page ID is visible in the URL of any Facebook Page or in the "About" section: `facebook.com/<page-name>` → click **About** → scroll to the bottom to find the Page ID.
* No Meta account or API token is required.

***

## Setup Instructions

{% stepper %}
{% step %}
**Enter Facebook Page ID(s)**

Enter the numeric Page ID of each Page you want to monitor. You can add multiple pages in a single connector. The format is a numeric string (e.g. `109061981944231`).
{% endstep %}

{% step %}
**Select reports**

Select the **Ads Archive** report. This is the only available report and it retrieves all archived ads (active and past) for the selected Pages.
{% endstep %}

{% step %}
**Name your connector and create**

Give the connector a name and click **Create**.
{% endstep %}
{% endstepper %}

***

## Report Configuration

When activating the Ads Archive report, you can configure the following filters:

| Parameter | Default | Description |
|---|---|---|
| `ad_type` | `ALL` | Filter by category: `ALL`, `POLITICAL_AND_ISSUE_ADS`, `HOUSING_ADS`, `EMPLOYMENT_ADS`, `FINANCIAL_PRODUCTS_AND_SERVICES_ADS` |
| `ad_active_status` | `ALL` | Filter by delivery status: `ALL`, `ACTIVE`, `INACTIVE` |
| `ad_reached_countries` | EU + GB | ISO country codes the ad must have reached. Defaults to all 27 EU countries + the UK — required to surface commercial ad data (see note below) |
| `publisher_platforms` | *(all)* | Restrict to specific platforms: `FACEBOOK`, `INSTAGRAM`, `AUDIENCE_NETWORK`, `MESSENGER`, `THREADS` |

{% hint style="warning" %}
**Country filter and data availability**

The `ad_reached_countries` filter should use specific country codes (e.g. `FR`, `DE`, `GB`) rather than a wildcard. Setting it to `ALL` behaves as if the ad must have reached literally every country, which returns no results in practice. The default (EU + UK) is the recommended value to surface commercial ads.

Commercial ads that never reached the EU or UK are not available in the Ad Library archive at all.
{% endhint %}

***

## Available Reports

### Ads Archive

Archived ads (active and past) delivered by the selected Pages, with creative metadata and — where available under EU DSA or political/issue ad rules — estimated spend and impressions ranges.

**Dimensions**

| Column | Type | Description |
|---|---|---|
| `id` | STRING | Ad Library ID — unique identifier for the archived ad |
| `page_id` | STRING | Facebook Page ID that ran the ad |
| `page_name` | STRING | Name of the Facebook Page |
| `ad_creation_time` | DATETIME | UTC timestamp when the ad was created |
| `ad_delivery_start_time` | DATETIME | Scheduled delivery start date/time (UTC) |
| `ad_delivery_stop_time` | DATETIME | Scheduled delivery end date/time (UTC). Null while the ad is still active |
| `ad_creative_bodies` | STRING | Text displayed in each ad card variation (JSON array) |
| `ad_creative_link_titles` | STRING | Link titles in the call-to-action section (JSON array) |
| `ad_creative_link_descriptions` | STRING | Link descriptions in the call-to-action section (JSON array) |
| `ad_creative_link_captions` | STRING | Call-to-action captions for each ad card (JSON array) |
| `ad_snapshot_url` | STRING | URL to the ad's full rendered snapshot, including media |
| `publisher_platforms` | STRING | Meta platforms where the ad appeared: FACEBOOK, INSTAGRAM, AUDIENCE_NETWORK, MESSENGER, THREADS (JSON array) |
| `languages` | STRING | Ad languages as ISO 639-1 codes (JSON array) |
| `bylines` | STRING | Funding source disclosed for political/issue ads |

**Metrics — EU DSA & political ads only**

{% hint style="warning" %}
The columns below are only populated when the ad is either (a) a political/issue ad (`POLITICAL_AND_ISSUE_ADS`), or (b) a commercial ad that reached at least one EU country. For all other commercial ads, these columns are `null`.
{% endhint %}

| Column | Type | Description |
|---|---|---|
| `currency` | STRING | ISO currency code for spend estimates |
| `spend_lower_bound` | FLOAT | Lower bound of estimated spend range |
| `spend_upper_bound` | FLOAT | Upper bound of estimated spend range |
| `impressions_lower_bound` | INTEGER | Lower bound of estimated impressions range |
| `impressions_upper_bound` | INTEGER | Upper bound of estimated impressions range |
| `estimated_audience_size_lower_bound` | INTEGER | Lower bound of accounts meeting the ad's targeting criteria |
| `estimated_audience_size_upper_bound` | INTEGER | Upper bound of accounts meeting the ad's targeting criteria |
| `eu_total_reach` | INTEGER | Combined estimated reach across EU locations |
| `br_total_reach` | INTEGER | Estimated reach for Brazil political ads |

***

## Scheduling

| Setting | Default | Options |
|---|---|---|
| **Frequency** | Daily | Daily, Weekly |
| **Sync time** | 6:00 AM | — |
| **Lookback window** | 3 days | 3, 7, 14, 30 days |
| **Historical load** | Up to 5 years | 3, 6, 12, 24 months or custom dates |

***

## Notes

* **Creative arrays**: `ad_creative_bodies`, `ad_creative_link_titles`, `ad_creative_link_descriptions`, `ad_creative_link_captions`, and `publisher_platforms` are JSON arrays serialized as strings. Use `JSON_EXTRACT_ARRAY` or equivalent in your query layer to unnest them.
* **Snapshot URL**: The `ad_snapshot_url` links to the full rendered ad in the Meta Ad Library, including images and videos. Access may require a Facebook login for some ad types.
* **Competitive intelligence**: This connector retrieves data for any public Facebook Page — it is not limited to pages you own or manage.
* **Data freshness**: Meta's Ad Library is typically updated within 24 hours of an ad going live or stopping delivery.
