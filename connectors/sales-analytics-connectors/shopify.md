---
description: Follow our setup guide to connect Shopify to QUANTI.
---

# Shopify

## Prerequisites

To connect Shopify to QUANTI, you need:

* Access to a [Shopify](https://accounts.shopify.com/lookup) account with admin permissions
* Permission to create custom apps in your Shopify store

## Setup instructions

{% stepper %}
{% step %}
### Enable custom app development

* Log in to your Shopify admin
* Go to **Settings** > **Apps and sales channels**
* Click **Develop apps**
* Click **Allow custom app development** (if not already enabled)
* Confirm by clicking **Allow custom app development**

<figure><img src="../../.gitbook/assets/QUANTI _ Setup Guide.png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
### Create a custom app

* Click **Create an app**
* Enter an app name (e.g., "QUANTI Connector")
* Select an app developer from the dropdown (connect@quanti.io)
* Click **Create app**
{% endstep %}

{% step %}
### Configure Admin API scopes

* Click **Configure Admin API scopes**
* Select the following read access scopes:

| Scope                            | Description                  |
| -------------------------------- | ---------------------------- |
| `read_all_orders`                | Access to all orders history |
| `read_products`                  | Products catalog             |
| `read_customers`                 | Customer data                |
| `read_inventory`                 | Inventory levels             |
| `read_locations`                 | Store locations              |
| `read_fulfillments`              | Fulfillment data             |
| `read_draft_orders`              | Draft orders                 |
| `read_price_rules`               | Price rules and discounts    |
| `read_discounts`                 | Discount codes               |
| `read_shipping`                  | Shipping settings            |
| `read_returns`                   | Returns data                 |
| `read_shopify_payments_payouts`  | Payout data                  |
| `read_shopify_payments_disputes` | Payment disputes             |

* Click **Save**

{% hint style="info" %}
Shopify Plus only: The `read_gift_cards` and `read_users` scopes are available only for Shopify Plus accounts.
{% endhint %}
{% endstep %}

{% step %}
### Install the app and get your API token

* Click **Install app**
* Confirm by clicking **Install**
* In the **API credentials** tab, click **Reveal token once**
* **Copy and save your Admin API access token** — it will only be shown once

{% hint style="warning" %}
Store this token securely. If lost, you'll need to uninstall and reinstall the app to generate a new one.
{% endhint %}
{% endstep %}

{% step %}
### Find your shop name

Your shop name is the part before `.myshopify.com` in your store URL.

Example: If your URL is `mystore.myshopify.com`, your shop name is `mystore`.
{% endstep %}

{% step %}
### Configure QUANTI connector

In the QUANTI connector setup, provide the following:

| Field                      | Description                                                                                             |
| -------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Connector Name**         | Name your connector. It must be unique.                                                                 |
| **Dataset ID**             | Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there. |
| **Shop Name**              | Your Shopify shop name (without `.myshopify.com`)                                                       |
| **Admin API Access Token** | The token copied in Step 4                                                                              |
| **Select queries**         | Select the pre-built queries you want to sync                                                           |
{% endstep %}
{% endstepper %}

## Pre-built Tables

| Table            | Description                                                        |
| ---------------- | ------------------------------------------------------------------ |
| **Orders**       | Complete orders data including line items, discounts, and shipping |
| **Products**     | Product catalog with variants, images, and inventory               |
| **Customers**    | Customer profiles with addresses and tags                          |
| **Inventory**    | Stock levels by location                                           |
| **Transactions** | Payment transactions and refunds                                   |
| **Fulfillments** | Shipping and delivery information                                  |

> Tables schema depend on your Shopify configuration and custom metafields.

## Sync behavior

* **Incremental sync**: Orders, customers, and products are synced incrementally based on update timestamps
* **Full sync**: Some tables (locations, shop settings) are synced daily
* **Historical data**: You can configure how far back to sync historical data during setup

***

