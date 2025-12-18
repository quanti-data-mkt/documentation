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

## DBML Schema Code

For dbdiagram.io configuration, use the following DBML code:

```dbml
// Facebook Organic Connector Schema
// Use this code at https://dbdiagram.io/

Table lifetime_page_info {
  page_id STRING [pk, note: 'Unique identifier for the Facebook Page']
  page_name STRING [note: 'Display name of the Facebook Page']
  category STRING [note: 'Business category of the Page']
  fan_count INTEGER [note: 'Total number of Page likes']
  followers_count INTEGER [note: 'Total number of Page followers']
}

Table page_posts {
  post_id STRING [pk, note: 'Unique identifier for the post']
  message STRING [note: 'Text content of the post']
  created_time TIMESTAMP [note: 'Date and time when the post was published']
  permalink_url STRING [note: 'Permanent URL to access the post']
}

Table daily_page_insights {
  date DATE [pk, note: 'Date of the metrics']
  page_impressions INTEGER [note: 'Total impressions on Page posts']
  page_impressions_unique INTEGER [note: 'Unique people who saw Page content']
  page_post_engagements INTEGER [note: 'Total engagement actions on Page posts']
  page_follows INTEGER [note: 'New Page follows on this date']
}

Table daily_post_insights {
  post_id STRING [pk, note: 'Unique identifier for the post']
  post_reach INTEGER [note: 'Unique people who saw the post']
  post_clicks INTEGER [note: 'Total clicks on the post']
  post_reactions STRING [note: 'JSON object with reaction counts by type']
  post_activity_by_action STRING [note: 'JSON object with activity breakdown']
  reactions_like INTEGER [note: 'Like reactions']
  reactions_love INTEGER [note: 'Love reactions']
  reactions_wow INTEGER [note: 'Wow reactions']
  reactions_haha INTEGER [note: 'Haha reactions']
  reactions_sorry INTEGER [note: 'Sorry reactions']
  reactions_anger INTEGER [note: 'Angry reactions']
  activity_like INTEGER [note: 'Like actions']
  activity_share INTEGER [note: 'Share actions']
  activity_comment INTEGER [note: 'Comment actions']
}

Table daily_page_views {
  date DATE [pk, note: 'Date of the metrics']
  page_views_total INTEGER [note: 'Total Page views on this date']
}

Table lifetime_video_insights {
  video_id STRING [pk, note: 'Unique identifier for the video']
  total_plays INTEGER [note: 'Total video plays']
  impressions_unique INTEGER [note: 'Unique people who saw the video']
  avg_time_watched_ms INTEGER [note: 'Average viewing duration (milliseconds)']
  total_view_time_ms INTEGER [note: 'Total viewing time (milliseconds)']
  replay_count INTEGER [note: 'Number of video replays']
  likes_by_reaction_type STRING [note: 'JSON object with likes by reaction type']
  social_actions STRING [note: 'JSON object with social actions']
  video_reactions_like INTEGER [note: 'Like reactions on video']
  video_reactions_love INTEGER [note: 'Love reactions on video']
  video_reactions_wow INTEGER [note: 'Wow reactions on video']
  video_reactions_haha INTEGER [note: 'Haha reactions on video']
  video_reactions_sorry INTEGER [note: 'Sorry reactions on video']
  video_reactions_anger INTEGER [note: 'Angry reactions on video']
  video_actions_like INTEGER [note: 'Like actions on video']
  video_actions_share INTEGER [note: 'Share actions on video']
  video_actions_comment INTEGER [note: 'Comment actions on video']
}

// Relationships
Ref: page_posts.post_id - daily_post_insights.post_id
Ref: page_posts.post_id - lifetime_video_insights.video_id
```

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
