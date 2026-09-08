---
description: 'Follow our setup guide to connect Pinterest to QUANTI:'
---

# Pinterest

<a href="https://dbdiagram.io/e/68e7ba6bd2b621e42211ab2b/68e7be77d2b621e422129949" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

Before connecting Pinterest Ads to QUANTI, ensure you have:

* **Pinterest Business Account**: A Pinterest Business account with active advertising campaigns
* **Ad Account Access**: Admin or Analyst access to the Pinterest Ad Account(s) you want to connect
* **Active Campaigns**: At least one active or historical advertising campaign to retrieve performance data
* **API Access**: Your Pinterest account must have API access enabled (automatically granted for Business accounts)

***

## Setup Instructions

{% stepper %}
{% step %}
**Authorize Pinterest Connection**

* Click on **Connect to Pinterest**
* You will be redirected to Pinterest's authorization page
* Log in with your Pinterest Business account credentials
* Review and accept the requested permissions:
  * See all of your advertising data, including ads, ad groups, campaigns etc
  * Afficher vos comptes utilisateurs et vos abonnés
* Click **Allow** to grant access
{% endstep %}

{% step %}
**Connector Information**

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created
  * The dataset will be created automatically if it doesn't exist
* Click **Next**
{% endstep %}

{% step %}
**Select Account(s)**

* Select the account(s) you want to connect to QUANTI
* You can select multiple Ad Accounts to track performance across different accounts
* Click **Next**
{% endstep %}

{% step %}
**Select Queries**

* Review the available Prebuilt reports
* All tables are selected by default - you can deselect tables you don't need
* Click **Next**
{% endstep %}

{% step %}
**Attribution Settings** _(optional)_

Configure how Pinterest attributes conversions in your report tables. These three fields are optional — leaving them blank preserves the current behavior (Pinterest API defaults apply).

| Field | API parameter | Allowed values | Default |
|---|---|---|---|
| **Click Attribution Window** | `click_window_days` | 1 / 7 / 30 / 60 | 30 |
| **View Attribution Window** | `view_window_days` | 1 / 7 / 30 / 60 | 1 |
| **Conversion Report Time** | `conversion_report_time` | `AD_EVENT` / `CONVERSION_EVENT` | `AD_EVENT` |

{% hint style="warning" %}
**View Attribution Window cannot exceed Click Attribution Window.** Valid combinations (click, view) are: (60, 60) (60, 30) (60, 7) (60, 1) (30, 30) (30, 7) (30, 1) (7, 7) (7, 1) (1, 1).
{% endhint %}

{% hint style="info" %}
**Conversion Report Time** controls the date used to report conversions:
* `AD_EVENT` — conversion is attributed to the date the user interacted with the ad (default)
* `CONVERSION_EVENT` — conversion is attributed to the date the conversion actually occurred

These settings only affect **Campaign Report**, **Ad Group Report**, and **Pin Promotion Report**. History/dimension tables are not impacted.
{% endhint %}
{% endstep %}

{% step %}
**Finish Setup**

* Define a sync period and a lookback window
* Click **Save**
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete
* Navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

### Dimension tables (append-only)

* **Advertiser History**: Advertiser account attributes including name, country, currency, permissions, and timestamps
* **Campaign History**: Campaign configuration and attributes at campaign level including status, budget caps, objectives, and scheduling
* **Ad Group History**: Ad group configuration including name, status, budget settings, targeting parameters, and optimization goals
* **Pin Promotion History**: Promoted Pin details including creative specifications, destination URLs, and promotion settings
* **Pin History**: Editorial and creative attributes of the Pin behind a Pinterest ad — title, description, alt text, dominant color, creative type (REGULAR, VIDEO, CAROUSEL, MAX\_VIDEO, SHOPPING, COLLECTION, IDEA), board, and promotion flag. Joins to `pin_promotion_history` via `pin_id`.
* **Pin Media**: Media asset metadata of the Pin — type (image / video / multi\_image), cover image URL, video duration (ms), dimensions, and Idea Pin item attributes. One row per Pin.
* **Pin Media Image**: Available image renditions of the Pin's media, one row per `(pin_id, image_size_label)`. Provides direct image URLs per resolution (150x150, 400x300, 600x, 1200x, originals) for display in dashboards without re-calling the API.

### Metric tables (delete-insert on `_quanti_date`)

Conversion metrics in these tables reflect the attribution window configured at connector level (see Attribution Settings above).

* **Campaign Report**: Daily performance metrics aggregated at campaign level including impressions, clicks, spend, and conversions
* **Ad Group Report**: Daily performance metrics aggregated at ad group level with detailed engagement and conversion tracking
* **Pin Promotion Report**: Daily performance metrics at Pin promotion level including video metrics, web sessions, and ROAS calculations

***

<a href="https://dbdiagram.io/e/68e7ba6bd2b621e42211ab2b/68e7be77d2b621e422129949" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***
