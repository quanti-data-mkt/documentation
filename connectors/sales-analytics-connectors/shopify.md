---
description: Follow our setup guide to connect Shopify to QUANTI.
---

# Shopify

<a href="https://dbdiagram.io/e/694439cfe4bb1dd3a9971e40/69443a24e4bb1dd3a99726ad" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Shopify to QUANTI, ensure you have:

* **Shopify Store**: An active Shopify store with admin access
* **Admin Permissions**: Store Owner or Staff account with full permissions
* **Custom App Access**: Ability to create and install custom apps in your Shopify store
* **Store Data**: Existing orders, products, or customer data to synchronize

***

## Setup Instructions

{% stepper %}
{% step %}
#### Enable custom app development

* Log in to your Shopify admin
* Go to **Settings** > **Apps and sales channels**
* Click **Develop apps**
* Click **Allow custom app development** (if not already enabled)
* Confirm by clicking **Allow custom app development**

<figure><img src="../../.gitbook/assets/QUANTI _ Setup Guide.png" alt=""><figcaption></figcaption></figure>
{% endstep %}

{% step %}
#### Create a custom app

* Click **Create an app**
* Enter an app name (e.g., "QUANTI Connector")
* Select an app developer from the dropdown ([connect@quanti.io](mailto:connect@quanti.io))
* Click **Create app**
{% endstep %}

{% step %}
#### Configure Admin API scopes

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
#### Install the app and get your API token

* Click **Install app**
* Confirm by clicking **Install**
* In the **API credentials** tab, click **Reveal token once**
* **Copy and save your Admin API access token** — it will only be shown once

{% hint style="warning" %}
Store this token securely. If lost, you'll need to uninstall and reinstall the app to generate a new one.
{% endhint %}
{% endstep %}

{% step %}
#### Find your shop name

Your shop name is the part before `.myshopify.com` in your store URL.

Example: If your URL is `mystore.myshopify.com`, your shop name is `mystore`.
{% endstep %}

{% step %}
#### Connect to QUANTI

* In QUANTI, click on **Connect to Shopify**
* Enter your **Shop Name** (without .myshopify.com)
* Paste your **Admin API access token**
* Click **Validate** to verify the connection
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete e-commerce data tracking
* Click **Next**
{% endstep %}

{% step %}
#### Finish setup

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

* **Orders**: Complete order information including order numbers, dates, customer details, financial status, fulfillment status, totals, taxes, and shipping information.
* **Order\_line\_items**: Individual line items for each order with product details, quantities, prices, discounts, taxes, and fulfillment information.
* **Products**: Product catalog including titles, descriptions, product types, vendors, tags, variants, and inventory tracking settings.
* **Product\_variants**: Product variants with SKUs, prices, inventory quantities, weights, barcodes, and variant-specific attributes.
* **Customers**: Customer information including names, email addresses, phone numbers, addresses, order history, total spent, and customer tags.
* **Customer\_addresses**: Customer shipping and billing addresses with address details and default address flags.
* **Collections**: Product collections (manual and smart) with collection rules, published status, and display settings.
* **Inventory\_items**: Inventory tracking information including SKUs, costs, countries of origin, and inventory management settings.
* **Inventory\_levels**: Current inventory quantities by location with available and incoming quantities.
* **Locations**: Store locations and warehouses with addresses and active status.
* **Fulfillments**: Order fulfillment records with tracking numbers, carriers, shipment status, and fulfillment dates.
* **Refunds**: Order refunds with refund amounts, reasons, refunded line items, and refund dates.
* **Transactions**: Payment transactions including transaction types, amounts, gateways, statuses, and authorization codes.
* **Discounts**: Discount codes and automatic discounts with usage limits, value types, amounts, and validity periods.
* **Gift\_cards**: Gift card information with codes, balances, initial values, and expiration dates (Shopify Plus only).
* **Price\_rules**: Price rule configurations for promotions including discount types, allocation methods, and eligibility criteria.
* **Draft\_orders**: Draft orders created by staff with order details and completion status.
* **Abandoned\_checkouts**: Abandoned cart data with checkout details, cart contents, and recovery information.
* **Payouts**: Shopify Payments payout information with payout dates, amounts, and banking details (Shopify Payments required).
* **Disputes**: Payment disputes and chargebacks with dispute status, amounts, and resolution information (Shopify Payments required).

***

<a href="https://dbdiagram.io/e/694439cfe4bb1dd3a9971e40/69443a24e4bb1dd3a99726ad" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Data Refresh**: Shopify data can be synchronized multiple times per day
* **Historical Data**: Full historical data is available with no API limitations on date ranges
* **Order Data**: Orders include complete financial details including line items, shipping, taxes, and discounts
* **Multi-Currency**: If your store uses Shopify Payments with multi-currency, amounts will be in the presentment currency
* **Metafields**: Custom metafields are not included by default but can be added upon request
* **API Rate Limits**: Shopify enforces rate limits based on your plan tier (Basic: 2 req/s, Shopify: 4 req/s, Advanced/Plus: 10 req/s). QUANTI automatically manages these limits
* **Deleted Records**: Deleted products, orders, or customers can be tracked if enabled in sync settings
* **GraphQL vs REST**: The connector uses Shopify's Admin API (REST) for maximum compatibility
* **Webhooks**: Real-time webhook support can be configured for instant updates on order creation/updates
* **Privacy**: Customer data complies with GDPR and privacy regulations

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that custom app development is enabled in your Shopify admin
* Ensure the Admin API access token is valid and hasn't been regenerated
* Check that all required API scopes are granted to the custom app
* Verify your shop name is correct (without .myshopify.com)
* Ensure the app is installed and active in your Shopify admin

</details>

<details>

<summary>Missing Data</summary>

* Check that the required API scopes are enabled (e.g., `read_all_orders` for orders)
* Verify that data exists in your Shopify store for the selected date range
* Draft or archived orders may require specific scopes to be included
* Shopify Plus features (gift cards, users) require a Plus subscription
* Check date filters in your sync configuration

</details>

<details>

<summary>Rate Limit Issues</summary>

* QUANTI automatically manages rate limits, but high-frequency syncs may be throttled
* Consider adjusting sync frequency for stores with large order volumes
* Shopify Plus accounts have higher rate limits (10 req/s vs 2-4 req/s)
* Historical data recovery for large stores may take several hours

</details>

<details>

<summary>Token Issues</summary>

* If your Admin API access token is lost, you must uninstall and reinstall the custom app to generate a new one
* Access tokens don't expire but can be revoked if the app is uninstalled
* Store tokens securely and never share them publicly
* If token appears invalid, verify it wasn't regenerated in Shopify admin

</details>

<details>

<summary>Data Discrepancies</summary>

* Verify that orders aren't filtered by fulfillment or payment status
* Check timezone settings between Shopify and your analysis tools
* Ensure currency conversions are handled correctly for multi-currency stores
* Compare order totals including taxes and shipping
* Draft orders are separate from completed orders

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
