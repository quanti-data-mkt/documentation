---
description: 'Follow our setup guide to connect Instragram Business to QUANTI:'
---

# Instagram Business

<a href="https://dbdiagram.io/e/69443544e4bb1dd3a996a990/69443574e4bb1dd3a996ae40" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Instagram Business to QUANTI, ensure you have:

* **Instagram Business Account**: Your Instagram account must be converted to a Business or Creator account
* **Facebook Page Connection**: Your Instagram Business account must be linked to a Facebook Page
* **Facebook Business Manager**: Access to Facebook Business Manager with appropriate permissions
* **Active Instagram Profile**: Your profile must have published content to retrieve insights

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize Facebook Connection

* Click on **Connect to Instagram Business**
* You will be redirected to Facebook's authorization page (Instagram uses Facebook's authentication)
* Log in with your Facebook account credentials
* Review and accept the requested permissions for Instagram data access
* Click **Continue** to grant access
{% endstep %}

{% step %}
#### Select Instagram Business Account(s)

* After authorization, you'll see a list of your Instagram Business accounts linked to your Facebook Pages
* Select the account(s) you want to connect to QUANTI
* You can select multiple accounts to track organic content from different Instagram profiles
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete Instagram performance tracking
* Click **Next**
{% endstep %}

{% step %}
#### Finish setup

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

* **Account\_info**: Basic information about Instagram Business accounts including username, profile data, followers, and media counts.
* **Media\_posts**: All media posts (photos, videos, carousels, reels) published on Instagram with captions, timestamps, and media details.
* **Daily\_account\_insights**: Daily aggregated account-level metrics including impressions, reach, profile views, and follower growth.
* **Lifetime\_media\_insights**: Lifetime engagement metrics for individual media posts including reach, impressions, engagement actions, and saved count.
* **Daily\_stories**: Instagram Stories published with timestamps and media URLs (24-hour availability).
* **Lifetime\_story\_insights**: Lifetime performance metrics for Stories including impressions, reach, replies, and exit rates.
* **Daily\_reel\_insights**: Daily performance metrics for Instagram Reels including plays, reach, likes, comments, shares, and saves.

***

<a href="https://dbdiagram.io/e/69443544e4bb1dd3a996a990/69443574e4bb1dd3a996ae40" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Data Refresh**: Instagram Business data is typically updated once per day
* **Historical Limitations**: Instagram's API has limitations on historical data retrieval. Account insights are limited to the last 30 days, while media insights are available for the lifetime of the post
* **Stories Limitations**: Stories data is only available for 24 hours after publication. Historical stories data cannot be retrieved after this period
* **Lifetime vs Daily Metrics**: Media and story insights are lifetime/cumulative metrics, while account insights and reel insights are aggregated daily
* **Media Types**: The connector supports all Instagram media types: photos, videos, carousels (albums), reels, and IGTV
* **API Rate Limits**: Instagram enforces strict rate limits on API requests. QUANTI automatically manages these limits to ensure reliable data extraction
* **Engagement Metrics**: Some engagement metrics (like saves) are only available for Business accounts, not Creator accounts
* **Reels Detection**: Only posts identified as Reels content will appear in the `daily_reel_insights` table

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your Instagram account is converted to a Business or Creator account
* Ensure your Instagram account is properly linked to a Facebook Page
* Check that your Facebook Business Manager has the necessary permissions
* Verify that API permissions haven't been revoked in Facebook settings

</details>

<details>

<summary>Missing Data</summary>

* Account insights are only available for the last 30 days
* Stories data is only available for 24 hours after publication
* Some metrics may not be available for all media types (e.g., video-specific metrics for photos)
* Private accounts or unpublished posts won't be included
* Archived posts may have limited metrics available

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
