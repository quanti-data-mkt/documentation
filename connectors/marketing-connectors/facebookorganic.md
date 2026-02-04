---
description: 'Follow our setup guide to connect Facebook Organic to QUANTI:'
---

# Facebook Organic

<a href="https://dbdiagram.io/e/6943dbc1e4bb1dd3a98c5af8/6944301ee4bb1dd3a9961b6b" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## Prerequisites

Before connecting Facebook Organic to QUANTI, ensure you have:

* **Facebook Page Access**: Administrator or Editor access to the Facebook Page(s) you want to connect
* **Facebook Business Account**: A Facebook Business account linked to your Page(s)
* **Active Facebook Page**: Your Page must have published content to retrieve insights

***

## Setup Instructions

{% stepper %}
{% step %}
### Authorize Facebook Connection

* Click on **Connect to Facebook**
* You will be redirected to Facebook's authorization page
* Log in with your Facebook account credentials
* Review and accept the requested permissions:
* Click **Continue** to grant access
{% endstep %}

{% step %}
### **Connector Information**

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created
  * The dataset will be created automatically if it doesn't exist
* Click **Next**
{% endstep %}

{% step %}
### Select Facebook Page(s)

* After authorization, you'll see a list of your Facebook Pages
* Select the Page(s) you want to connect to QUANTI
* You can select multiple Pages to track organic content from different sources
* Click **Next**
{% endstep %}

{% step %}
### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete organic performance tracking
* Click **Next**
{% endstep %}

{% step %}
### **Finish setup**

* Define a sync period and a lookback window - Click save
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the Sync now button
* Wait for the sync to complete. Then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built Tables

* **Lifetime\_page\_info** : Basic information about Facebook Pages including page ID, name, category, and follower metrics.
* **Page\_posts** : Posts published on Facebook Pages with message content, creation time, and permalink.
* **Daily\_page\_insights** : Daily aggregated insights metrics for Facebook Pages including impressions, reach, and engagement.
* **Daily\_post\_insights** : Lifetime engagement metrics for individual posts including reach, clicks, reactions, and activity breakdown.
* **Daily\_page\_views** : Daily page views metrics tracking total visits to the Facebook Page.
* **Lifetime\_video\_insights** : Lifetime performance metrics for video posts including plays, watch time, replays, reactions, and social actions (cumulative data, not daily).

***

<a href="https://dbdiagram.io/e/6943dbc1e4bb1dd3a98c5af8/6944301ee4bb1dd3a9961b6b" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## Notes

* **Data Refresh**: Facebook Organic data is typically updated once per day
* **Historical Limitations**: Facebook's API has limitations on historical data retrieval. Some metrics may only be available for the last 90 days
* **Lifetime vs Daily Metrics**: Note that video insights and post insights are lifetime/cumulative metrics, while page insights are aggregated daily
* **JSON Fields**: Some fields (reactions, activities) are stored as JSON strings for flexible analysis
* **API Rate Limits**: Facebook enforces rate limits on API requests. QUANTI automatically manages these limits to ensure reliable data extraction
* **Video Detection**: Only posts identified as video content will appear in the `lifetime_video_insights` table

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your Facebook Business account has proper permissions
* Ensure your Page is not restricted or deactivated
* Check that API permissions haven't been revoked

</details>

<details>

<summary>Missing Data</summary>

* Some metrics may not be available for all post types
* Historical data older than 90 days may be limited
* Private or unpublished posts won't be included

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at support@quanti.io or consult our comprehensive documentation at https://docs.quanti.io

</details>
