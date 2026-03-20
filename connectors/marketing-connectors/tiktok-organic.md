---
description: 'Follow our setup guide to connect TikTok Organic to QUANTI:'
---

# TikTok Organic

***

## Prerequisites

Before connecting TikTok Organic to QUANTI, ensure you have:

* **TikTok Business Account or Creator Account**: Your TikTok profile must be converted to a Business or Creator account to access the Content API
* **Public Profile**: Your TikTok account must be set to public to retrieve content and insights
* **Active TikTok Profile**: Your profile must have published content to retrieve insights

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize TikTok Connection

* Click on **Connect to TikTok Organic**
* You will be redirected to TikTok's authorization page
* Log in with your TikTok account credentials
* Review and accept the requested permissions for TikTok data access
* Click **Confirm** to grant access
{% endstep %}

{% step %}
#### Connector Information

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created
  * The dataset will be created automatically if it doesn't exist
* Click **Next**
{% endstep %}

{% step %}
#### Select TikTok Account(s)

* After authorization, you'll see a list of your TikTok accounts
* Select the account(s) you want to connect to QUANTI
* You can select multiple accounts to track organic content from different TikTok profiles
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete TikTok performance tracking
* Click **Next**
{% endstep %}

{% step %}
#### Finish setup

* Define a sync period and a lookback window - Click save
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

* **Account\_info**: Basic information about TikTok accounts including username, display name, profile description, avatar URL, follower count, following count, total likes received, and total video count.
* **Videos**: All videos published on the TikTok account with title, creation timestamp, video duration, cover image URL, embed link, and share URL.
* **Daily\_account\_insights**: Daily aggregated account-level metrics including profile views, video views, follower count, net follower change, and reach.
* **Lifetime\_video\_insights**: Lifetime engagement metrics for individual videos including total views, likes, comments, shares, reach, impressions, average watch time, and total watch time (cumulative data, not daily).

***

## Notes

* **Data Refresh**: TikTok Organic data is typically updated once per day
* **Historical Limitations**: TikTok's API has limitations on historical data retrieval. Account insights are limited to the last 60 days, while video insights are available for the lifetime of the post
* **Account Type Requirement**: Only Business and Creator accounts have access to the TikTok Content API. Personal accounts cannot be connected
* **Public Profile Requirement**: Your TikTok profile must be set to public. Private accounts cannot be connected and will not return insights data
* **Lifetime Metrics**: Video insights are lifetime/cumulative metrics and not broken down by day
* **API Rate Limits**: TikTok enforces rate limits on API requests. QUANTI automatically manages these limits to ensure reliable data extraction

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your TikTok account is converted to a Business or Creator account
* Ensure your TikTok profile is set to public
* Check that API permissions haven't been revoked in TikTok settings (Settings > Privacy > Apps and Websites)
* Try disconnecting and reconnecting the authorization from the QUANTI connector dashboard

</details>

<details>

<summary>Missing Data</summary>

* Account insights are only available for the last 60 days
* Videos must be public to retrieve insights
* Some metrics may not be available for all content types
* Archived or deleted videos will not be included
* Very recent videos (less than a few hours old) may not yet have insights available

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
