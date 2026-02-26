# Klaviyo

<a href="https://dbdiagram.io/e/69a05c95a3f0aa31e132e756/69a05df0a3f0aa31e13313b7" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Klaviyo to QUANTI, ensure you have:

* **Klaviyo Account**: An active Klaviyo account with at least one campaign sent
* **API Key**: A Private API Key with read access — generate it from **Klaviyo > Account > Settings > API Keys**
* **Permissions**: The key must have read permissions on Campaigns, Lists, Segments, Profiles, and Metrics

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize Klaviyo Connection

* Click on **Connect to Klaviyo**
* Enter your Klaviyo Private API Key
* Click **Connect** to validate the connection
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default — you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete email marketing analytics
* Click **Next**
{% endstep %}

{% step %}
#### **Finish setup**

* Define a sync period and a lookback window — Click save
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

### Dimensions

* **Campaign** : Email campaigns with status (Draft, Scheduled, Sending, Sent, Paused, Canceled), channel, send timestamps, targeted audiences, and send/tracking options as JSON.
* **List** : Contact lists used for campaign targeting, with opt-in process type (single or double opt-in).
* **Segment** : Dynamic segments with their segmentation rule definition (JSON), active status, and processing state.
* **Profile** : Contact profiles with email, phone, external ID, demographics, location details, custom properties, and subscription status per channel — all stored as JSON objects.

### Facts

* **Campaign\_performance\_stats** : Aggregated performance metrics per campaign: recipients, deliveries, opens, clicks, unsubscribes, spam complaints, and derived rates (open rate, click rate, bounce rate, unsubscribe rate).

***

<a href="https://dbdiagram.io/e/69a05c95a3f0aa31e132e756/69a05df0a3f0aa31e13313b7" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>
