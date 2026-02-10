---
description: 'Follow our setup guide to connect Google Merchant Center to QUANTI:'
---

# Google Merchant Center

<a href="https://dbdiagram.io/e/698b4b39bd82f5fce2470793/698b4dddbd82f5fce2476a9a" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Google Merchant Center to QUANTI, ensure you have:

* **Google Merchant Center Account**: An active Google Merchant Center account with product feeds configured
* **Google Account Access**: Owner or Admin access to the Merchant Center account
* **Product Feed**: At least one product feed with approved products
* **API Access**: Ensure API access is enabled for your Merchant Center account

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize Google Connection

* Click on **Connect to Google**
* You will be redirected to Google's authorization page
* Log in with your Google account credentials
* Review and accept the requested permissions:
  * View and manage your Google Merchant Center accounts
  * Access product and performance data
* Click **Allow** to grant access
{% endstep %}

{% step %}
#### Select Merchant Center Account(s)

* After authorization, you'll see a list of your Merchant Center accounts
* Select the account(s) you want to connect to QUANTI
* You can select multiple accounts to track products from different sources
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete product tracking and performance analysis
* Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and a lookback window - Click **Save**
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

### Dimension Tables

* **product**: Complete product catalog with attribute change tracking. Contains product details including ID, title, brand, availability, condition, channel, language, and aggregated status. This table includes historization to track product attribute changes over time.
* **item\_issue**: Product issues child table linked to the product table. Captures all issues affecting products including issue code, affected attribute, description, resolution type, severity level, and documentation links. Each product can have multiple issues.

### Metric Tables

* **product\_performance**: Daily product performance metrics including clicks, impressions, click-through rate, conversions, conversion rate, and conversion value. Data is segmented by marketing method (Shopping Ads, Free Listings, etc.) and customer country. Includes hierarchical categorization with Google categories (5 levels), product types (5 levels), and custom labels (5 labels).

{% hint style="info" %}
### **The Parent-Child Relationship between `product` & `item_issue`**

`item_issues` is a nested object within the `product` table, representing a one-to-many relationship between products and their issues. Each product can have multiple issues associated with it. To link issues to their respective products, use the `_quanti_id` field present in both tables - this field enables the join between the two tables and ensures each issue is correctly associated with its parent product record.
{% endhint %}

***

<a href="https://dbdiagram.io/e/698b4b39bd82f5fce2470793/698b4dddbd82f5fce2476a9a" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Historical Limitations**: Google's API allows historical data retrieval up to 18 months for performance metrics.
