---
description: 'Follow our setup guide to connect Google Search Console to QUANTI:'
---

# Google Search Console

<a href="https://dbdiagram.io/e/68555a41f039ec6d36273bf9/685562ddf039ec6d36286cbf" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

To connect Google Search Console to QUANTI, you need access to a [Google Search Console](https://search.google.com/search-console?hl=fr) account with at least one verified property.

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize Google Connection

* Click on **Connect to Google**
* You will be redirected to Google's authorization page
* Log in with your Google account credentials
* Review and accept the requested permissions
* Click **Continue** to grant access
{% endstep %}

{% step %}
#### Configure Connector

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}

{% step %}
#### Select Account(s)

* Choose the Google Search Console property (or properties) you want to sync
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default — you can deselect tables you don't need
* Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and a lookback window — Click **Save**
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete. Then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built Tables

* **keyword\_page\_report** : Keyword-level performance per page. The most granular table — each row represents a unique combination of date, search type, site, country, device, page URL, and search query. Ideal for detailed SEO analysis at the keyword × page level.
* **keyword\_site\_report\_by\_page** : Keywords aggregated across the site using a `byPage` aggregation method. Each row represents a unique combination of date, search type, site, country, device, and query — without the page dimension. Useful for site-wide keyword performance analysis.
* **keyword\_site\_report\_by\_site** : Keywords aggregated at the site level using a `byProperty` aggregation method. Same structure as `keyword_site_report_by_page` but metrics are computed differently by Google. The two tables may show slightly different totals for the same query.
* **page\_report** : Performance data per page. Each row represents a unique combination of date, search type, site, country, device, and page URL. Useful for analyzing which pages generate the most clicks and impressions.
* **site\_report\_by\_page** : Site-level aggregated data using a `byPage` aggregation. Each row represents a unique combination of date, search type, site, country, and device — without a page or query dimension.
* **site\_report\_by\_site** : Overall site performance using a `byProperty` aggregation. Same structure as `site_report_by_page` but aggregated differently by Google. Use this table for the most accurate site-level totals.
* **sitemap** : Dimension table containing sitemap file metadata. Each row represents a sitemap submitted in Google Search Console, with its path, type, submission and download dates, and the number of submitted vs. indexed URLs.

***

<a href="https://dbdiagram.io/e/68555a41f039ec6d36273bf9/685562ddf039ec6d36286cbf" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Data Availability Delay**: Google Search Console data is typically available with a **2 to 3 day delay**. The most recent days will not be populated immediately after a sync — this is a Google API limitation. It is recommended to configure a **lookback window of at least 3 days** to ensure complete and finalized data is retrieved.
* **No Real-Time or Fresh Data via API**: The Search Analytics API only returns **finalized data**. The "fresh data" available in the Google Search Console web interface (including the 24-hour view) is not exposed through the API and therefore not available in QUANTI.
* **Data May Retroactively Change**: Data for the last few days before finalization can change slightly as Google continues processing. This is expected behavior — the lookback window ensures these days are re-synced and updated automatically.
* **`byPage` vs `byProperty` Aggregation**: Google computes metrics differently depending on the aggregation type. `byPage` and `byProperty` tables for the same date and dimensions may show slightly different numbers for clicks, impressions, and position. Refer to [Google's documentation](https://support.google.com/webmasters/answer/6155685) for details on how each method calculates data.
* **Historical Data Limit**: The Search Analytics API provides data for up to **16 months** of history.
* **API Rate Limits**: Google enforces quotas on API requests. QUANTI automatically manages these limits to ensure reliable data extraction.
