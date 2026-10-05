---
description: 'Follow our setup guide to connect YouTube Analytics to QUANTI:'
---

# YouTube Analytics

The YouTube Analytics connector syncs the organic performance of your YouTube channels and videos: views, watch time, engagement, audience, traffic sources, reach and playlists. It combines the **YouTube Reporting API** (daily bulk reports) with the **YouTube Data API v3** (video, channel and playlist metadata).

***

## Prerequisites

Before connecting YouTube Analytics to QUANTI, ensure you have:

* **A Google account with access to the YouTube channel(s)** you want to sync.
* **(Optional) A Content Owner ID**: only if you manage channels through a YouTube Content Owner (CMS) account and want multi-channel, asset and revenue reports. Leave it empty for a standard channel setup.

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize your Google account

* Click **Continue with Google**
* Log in with the Google account that has access to your YouTube channel(s)
* Review and approve the requested permissions
* You will be redirected back to QUANTI automatically
{% endstep %}

{% step %}
#### Content Owner (optional)

* **Leave the field empty** for a standard setup: the connector syncs channel and playlist reports for the channel(s) you select.
* **Enter your Content Owner ID** to switch to Content Owner mode: the connector syncs Content Owner reports (all channels of the Content Owner), asset, revenue and system-managed financial reports.

{% hint style="info" %}
The two modes are mutually exclusive. In Content Owner mode, channel-level reports are hidden and skipped: a Content Owner report already covers every channel of the Content Owner. You can change this value later in the connector **Settings**.
{% endhint %}
{% endstep %}

{% step %}
#### Select your channel(s)

* QUANTI lists the YouTube channels available to the authorized account
* All channels are selected by default — deselect any you don't need
* Click **Continue**
{% endstep %}

{% step %}
#### Select pre-built reports

* Review the available pre-built reports (see section below for details)
* Select the reports you need
* Click **Continue**
{% endstep %}

{% step %}
#### Connector Information

* **Connector Name**: A unique name for this connector
* **Dataset ID**: The dataset where tables will be created
* Click **Save** to create the connector
{% endstep %}

{% step %}
#### Finish setup

* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs (daily or weekly) by clicking the switch button
  * Launch a historical data recovery — maximum **60 days** of history available
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete. Then navigate to your data warehouse to verify that tables are populated
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

The name of each Reporting API table is the YouTube `reportTypeId` (for example `channel_basic_a3`). The `_aN` suffix is the version of the report on YouTube's side.

### Channel mode — Video

* **channel\_basic\_a3**: Daily user activity per video (views, watch time, engagement), by live/on-demand, subscribed status and country.
* **channel\_province\_a3**: Same as above, by US state. US data only.
* **channel\_playback\_location\_a3**: Activity by playback location (YouTube watch page, embedded player…).
* **channel\_traffic\_source\_a3**: Activity by traffic source (search, suggested videos, external…).
* **channel\_device\_os\_a3**: Activity by device type and operating system.
* **channel\_demographics\_a1**: Share of views by age group and gender.
* **channel\_sharing\_service\_a1**: Shares by sharing service.
* **channel\_annotations\_a1**: Annotation performance. Annotations are deprecated by YouTube: historical data only.
* **channel\_cards\_a1**: Card performance.
* **channel\_end\_screens\_a1**: End screen element performance.
* **channel\_subtitles\_a3**: Activity by subtitle language.
* **channel\_combined\_a3**: Activity by playback location, traffic source, device and operating system combined.

### Channel mode — Reach

* **channel\_reach\_basic\_a1**: Daily thumbnail impressions and click-through rate per video.
* **channel\_reach\_combined\_a1**: Same, by traffic source, device and operating system.

### Channel mode — Playlist

* **playlist\_basic\_a2**, **playlist\_province\_a2**, **playlist\_playback\_location\_a2**, **playlist\_traffic\_source\_a2**, **playlist\_device\_os\_a2**, **playlist\_combined\_a2**: The same breakdowns as the video reports, for videos watched within a playlist.

### Content Owner mode

Available only when a Content Owner ID is set. These reports cover every channel of the Content Owner (`channel_id` is a dimension) and add the `claimed_status` and `uploader_type` dimensions.

* **Video**: `content_owner_*` equivalents of the channel video reports (basic, province, playback location, traffic source, device/OS, demographics, annotations, cards, end screens, sharing service, subtitles, combined).
* **Reach**: `content_owner_reach_basic_a1`, `content_owner_reach_combined_a1`.
* **Playlist**: `content_owner_playlist_*` (basic, province, playback location, traffic source, device/OS, combined).
* **Assets**: `content_owner_asset_*` reports, broken down by `asset_id`.
* **Revenue**: `content_owner_ad_rates_a1`, `content_owner_estimated_revenue_a1`, `content_owner_asset_estimated_revenue_a1`.
* **System-managed**: `content_owner_ad_revenue_raw_a1`, `content_owner_asset_ad_revenue_raw_a1`, `content_owner_non_music_asset_red_revenue_raw_a1`, `content_owner_active_claims_a3`, `content_owner_asset_a3`, `content_owner_video_metadata_a4`.

### Metadata and retention (both modes)

* **video**: Video metadata from the Data API v3 — title, description, publication date, tags, thumbnails, duration, privacy and upload status, and lifetime counters (views, likes, comments).
* **channel**: Channel metadata — title, description, country, custom URL, and lifetime counters (subscribers, views, videos).
* **playlist**: Playlist metadata — title, description, privacy status, item count.
* **audience\_retention**: Audience retention curve per video, by elapsed video time ratio.

{% hint style="info" %}
The `view_count`, `like_count` and `comment_count` columns of the metadata tables are **lifetime cumulative counters** at sync time. They are not daily metrics: use the Reporting API tables for daily figures.
{% endhint %}

***

## Unavailable reports

### Comments and captions

The **comment** and **caption** reports were removed from the connector in September 2026.

Both reports require one YouTube Data API v3 call per video. The Data API has a daily quota of **10,000 units**, shared by all QUANTI customers. On a channel with 2,050 videos, the caption report alone needed **512,000 units** (250 units per video), more than 50 times the daily quota. YouTube rejected the requests within seconds, so the sync could never complete and the tables ended up partially filled without any error.

Removing these reports keeps the quota available for the other reports, so every sync completes. Comment counts remain available: daily per video in the `comments` column of **channel\_basic\_a3**, and as a lifetime total in the `comment_count` column of the **video** table. The comment text itself is no longer synced.

***

## Notes

* **Data refresh**: Syncs run daily (default at 6:00 AM) or weekly. The default lookback window is 7 days.
* **Historical data**: Historical recovery is limited to a maximum of **60 days**.
* **First data availability**: YouTube generates the first reports about **48 hours** after the first sync, and only covers the **30 days** before that sync.
* **Custom reports**: This connector does not support custom queries. Only the pre-built reports above are available.

***

## Troubleshooting

<details>

<summary>No data after the first sync</summary>

* YouTube needs about 48 hours after the first sync to generate the first reports. Wait two days, then launch a new sync.

</details>

<details>

<summary>Content Owner reports are empty</summary>

* Check that the Content Owner ID is set in the connector **Settings**.
* Check that the authorized Google account has access to this Content Owner.

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
