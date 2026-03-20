---
description: 'Follow our setup guide to connect TikTok Organic to QUANTI:'
---

# TikTok Organic

<a href="https://dbdiagram.io/e/69bd5d7d78c6c4bc7a302be3/69bd5ddefb2db18e3bcabd49" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

Before connecting TikTok Organic to QUANTI, ensure you have:

* **TikTok Business account**: Your TikTok profile must be a Business account. Personal and Creator accounts are not supported.
  * To convert: open the TikTok app → Settings → Manage account → Switch to Professional account → Business
* **Single account per connector**: TikTok's API only allows one Business account per connector. To sync multiple accounts, create one connector per account.

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize your TikTok Business account

* Click **Continue with TikTok Business**
* You will be redirected to TikTok's authorization page
* Log in with your TikTok Business account credentials
* Review and approve the requested permissions
* You will be redirected back to QUANTI automatically

{% hint style="warning" %}
Make sure you log in with a **TikTok Business** account. If your account is not a Business account, you will see an error. You can convert your account in the TikTok app under Settings → Manage account → Switch to Professional account → Business.
{% endhint %}
{% endstep %}

{% step %}
#### Confirm your account

* QUANTI displays the details of the authenticated account: display name, username, avatar, and account type
* Verify this is the correct account and click **Continue**

{% hint style="info" %}
Only one TikTok Business account can be connected per connector. To sync a different account, create a new connector.
{% endhint %}
{% endstep %}

{% step %}
#### Select pre-built reports

* Review the available pre-built reports (see section below for details)
* All reports are selected by default — deselect any you don't need
* At least one report must be selected to continue
* Click **Continue**
{% endstep %}

{% step %}
#### Connector Information

* **Connector Name**: A unique name for this connector (default: `TikTok Organic - {display_name}`)
* **Dataset ID**: The BigQuery dataset ID where tables will be created (default: `tiktokorganic_{username}`)
  * Must be lowercase, start with a letter, and use only letters, numbers, and underscores
  * The dataset will be created automatically if it doesn't exist
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

## Pre-built reports

* **profile**: Account profile attributes — username, display name, bio description, profile image URL, deep link, verification status, and business account flag. One row per account, updated at each sync (upsert).

* **profile\_snapshot\_metric**: Cumulative account metrics captured at each sync — total followers, following count, total likes received, video count, and audience demographics broken down by country, city, age range, and gender (stored as JSON arrays).

* **profile\_daily\_metric**: Daily engagement metrics at account level — video views, unique video views, profile views, likes, comments, shares, new followers gained, followers lost, total net followers, engaged audience, and bio link clicks. Also includes business-only metrics (phone number clicks, lead submissions, app download clicks, email clicks, address clicks) and hourly audience activity as a JSON array. Partitioned by date.

* **video**: Video-level analytics captured at each sync — video ID, publication date, caption, thumbnail URL, embed URL, share URL, and lifetime cumulative metrics: likes, comments, shares, total video views, unique reach, video duration, total watch time, average watch time per view, completion rate, impression sources by channel, and audience countries (stored as JSON arrays).

<a href="https://dbdiagram.io/e/69bd5d7d78c6c4bc7a302be3/69bd5ddefb2db18e3bcabd49" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Notes

* **Data refresh**: Syncs run daily (default at 3:00 AM) or weekly. The default lookback window is 5 days to capture retroactive metric adjustments.
* **Historical data**: Historical recovery is limited to a maximum of **60 days**.
* **Metric delay**: Some metrics may have a delay of 24 to 48 hours before being available via TikTok's API.
* **Token management**: TikTok Business API issues long-lived tokens that do not expire automatically. Tokens can be revoked manually by the user in TikTok → Settings → Security → Third-party apps. If a token is revoked, you will need to reconnect the connector.
* **Business-only metrics**: Fields such as `phone_number_clicks`, `lead_submissions`, `app_download_clicks`, `email_clicks`, and `address_clicks` in `profile_daily_metric` are only populated for accounts registered as a TikTok Business account with a configured business profile.
* **Custom reports**: This connector does not support custom queries. Only the pre-built reports above are available.

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your TikTok account is a Business account (not a Creator or Personal account)
* To convert: TikTok app → Settings → Manage account → Switch to Professional account → Business
* If you see an "Unverified app" warning during authorization, this is expected — click **Continue** to proceed
* If the connection fails, check that you have not revoked the app's permissions in TikTok Settings → Security → Third-party apps

</details>

<details>

<summary>Missing Data</summary>

* Historical data is limited to the last 60 days — data older than that cannot be recovered
* Some metrics may not be available immediately after publication (24–48 hour delay)
* Business-only metrics (phone clicks, leads, etc.) will be empty if your account does not have a configured business profile
* The `video` table only contains videos that were public at the time of the sync

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
