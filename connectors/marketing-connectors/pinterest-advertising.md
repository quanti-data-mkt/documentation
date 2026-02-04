---
description: 'Follow our setup guide to connect Pinterest to QUANTI:'
---

# Pinterest

<a href="https://dbdiagram.io/e/68e7ba6bd2b621e42211ab2b/68e7be77d2b621e422129949" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

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

* Review the available pre-built tables
* All tables are selected by default - you can deselect tables you don't need
* Click **Next**
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

## Pre-built Tables

* **Advertiser History**: Advertiser account attributes including name, country, currency, permissions, and timestamps
* **Campaign History**: Campaign configuration and attributes at campaign level including status, budget caps, objectives, and scheduling
* **Ad Group History**: Ad group configuration including name, status, budget settings, targeting parameters, and optimization goals
* **Ad History**: Individual ad attributes and configuration including creative references, status, and tracking settings
* **Pin Promotion History**: Promoted Pin details including creative specifications, destination URLs, and promotion settings
* **Campaign Report**: Daily performance metrics aggregated at campaign level including impressions, clicks, spend, and conversions
* **Ad Group Report**: Daily performance metrics aggregated at ad group level with detailed engagement and conversion tracking
* **Pin Promotion Report**: Daily performance metrics at Pin promotion level including video metrics, web sessions, and ROAS calculations

***

<a href="https://dbdiagram.io/e/68e7ba6bd2b621e42211ab2b/68e7be77d2b621e422129949" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***
