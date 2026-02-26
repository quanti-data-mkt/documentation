# Prestashop par API

<a href="https://dbdiagram.io/e/69a05484a3f0aa31e131c8fc/69a054e9a3f0aa31e131d5fd" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting PrestaShop to QUANTI, ensure you have:

* **PrestaShop Webservice Access**: The Webservice API must be enabled in your PrestaShop back-office (**Advanced Parameters > Webservice**)
* **API Key**: A Webservice API key with read permissions on the required resources
* **PrestaShop Version**: PrestaShop 1.7+ recommended for full compatibility
* **Store URL**: The base URL of your PrestaShop store (e.g. `https://yourstore.com`)

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize PrestaShop Connection

* Click on **Connect to PrestaShop**
* Enter your store URL (e.g. `https://yourstore.com`)
* Enter your Webservice API key
* Click **Connect** to validate the connection
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default — you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete e-commerce analytics
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

* **Carrier** : Shipping providers with delivery methods, rate calculation mode, weight limits, and active/deleted status.
* **Cart\_rule** : Discount rules and coupon codes with percentage/fixed reductions, free shipping flags, validity dates, and usage limits.
* **Category** : Hierarchical product classification tree with parent-child relationships, names, and activity status.
* **Customer** : Customer profiles including demographics, registration date, newsletter subscription, and guest vs. registered account status.
* **Product** : Product catalog with names, references, barcodes (EAN13/UPC), base prices, wholesale prices, weight, category and manufacturer associations.
* **Product\_variant** : Product variant/combination level detail with SKU, barcodes, price and weight impact relative to the parent product.

### Facts

* **Order** : Orders with full financial breakdown: products total, shipping, discounts, and amount actually paid. Linked to customer and carrier.
* **Order\_line** : Individual line items per order with product references, quantities ordered/refunded/returned, and unit/total prices (tax included and excluded).
* **Order\_cart\_rule** : Junction table tracking which discount rules were applied to each order, with the actual discount values.
* **Transaction** : Payment transactions with amounts, payment method, external gateway transaction ID, and currency conversion rate.

***

<a href="https://dbdiagram.io/e/69a05484a3f0aa31e131c8fc/69a054e9a3f0aa31e131d5fd" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>
