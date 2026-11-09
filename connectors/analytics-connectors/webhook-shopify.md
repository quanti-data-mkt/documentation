---
description: Receive your Shopify store's events in your data warehouse in real time, one table per event.
---

# Shopify webhooks

**Shopify webhooks** send your store's events (orders, refunds, customers, checkouts, products, inventory) to your data warehouse as they happen. Each event you turn on gets its own URL and its own typed table.

{% hint style="warning" %}
A webhook only carries what happens **after** it is created, and nothing once the provider stops retrying an event. For history and reconciliation, use the [Shopify](../sales-analytics-connectors/shopify.md) connector alongside it.
{% endhint %}

***

## How it works

* One QUANTI: webhook covers your whole store. You turn on the events you want in the **Reports** tab: each one is a table.
* Each event has **its own URL** (`https://webhook.quanti.io/wb/<id>/<event>`). In Shopify, you create one webhook per event, with the URL shown on its card.
* Shopify signs every event. With your store's signing key, QUANTI: checks that each event comes from your store.
* Events are created with API version **2026-10**, in **JSON** format.

***

## Setup

{% stepper %}
{% step %}
### Create the webhook in QUANTI:

In **Connect › Real time**, choose **Shopify webhooks**. Give it a name and a dataset, then pick the events you want to receive. You can change them later in the **Reports** tab.
{% endstep %}

{% step %}
### Create one webhook per event in Shopify

In your Shopify admin, open **Settings › Notifications › Webhooks** and click **Create webhook**. For each event turned on in QUANTI:, create a webhook with:

* **Event**: the event of the card (for example *Order creation*);
* **Format**: JSON;
* **URL**: the URL shown on the card, copied with its button;
* **Webhook API version**: 2026-10.

{% hint style="warning" %}
Each URL only accepts **its** event. A URL pasted on another event (for example the *Order creation* URL on *Fulfillment order routing complete*) is refused with a `400`: Shopify shows the failure and retries, and nothing lands in the wrong table. Check the event of each webhook against the card it comes from.
{% endhint %}
{% endstep %}

{% step %}
### Paste the signing key

Once a first webhook exists, Shopify shows at the bottom of the webhook list: *Your webhooks will be signed with …*. Copy this key and paste it in the **Security** tab of the QUANTI: webhook. The key is the same for every webhook of the store.

{% hint style="info" %}
Shopify only shows the key once a webhook exists. Creating the QUANTI: webhook without it is expected: add it right after creating the first Shopify webhook.
{% endhint %}
{% endstep %}

{% step %}
### Test

Use **Send test notification** on a Shopify webhook, or place a test order. The table is created with the first event, within a minute.
{% endstep %}
{% endstepper %}

{% hint style="info" %}
QUANTI: checks every event in **observe** mode: an event with a missing or wrong signature is still written, and flagged on our side. A mistyped key never makes you lose events, and the provider never disables your webhook because of it.
{% endhint %}

***

## Events and tables

### Orders

| Event in Shopify | Topic | Table |
|---|---|---|
| Order creation | `orders/create` | `orders_create` |
| Order update | `orders/updated` | `orders_updated` |
| Order payment | `orders/paid` | `orders_paid` |
| Order cancellation | `orders/cancelled` | `orders_cancelled` |
| Order fulfillment | `orders/fulfilled` | `orders_fulfilled` |
| Order partial fulfillment | `orders/partially_fulfilled` | `orders_partially_fulfilled` |
| Order edit | `orders/edited` | `orders_edited` |
| Order deletion | `orders/delete` | `orders_delete` |
| Order transaction creation | `order_transactions/create` | `order_transactions_create` |
| Refund creation | `refunds/create` | `refunds_create` |
| Fulfillment creation | `fulfillments/create` | `fulfillments_create` |
| Fulfillment update | `fulfillments/update` | `fulfillments_update` |
| Tender transaction creation | `tender_transactions/create` | `tender_transactions_create` |
| Dispute creation | `disputes/create` | `disputes_create` |
| Dispute update | `disputes/update` | `disputes_update` |
| Draft order creation | `draft_orders/create` | `draft_orders_create` |
| Draft order update | `draft_orders/update` | `draft_orders_update` |
| Draft order deletion | `draft_orders/delete` | `draft_orders_delete` |

### Customers

| Event in Shopify | Topic | Table |
|---|---|---|
| Customer creation | `customers/create` | `customers_create` |
| Customer update | `customers/update` | `customers_update` |
| Customer enable | `customers/enable` | `customers_enable` |
| Customer disable | `customers/disable` | `customers_disable` |
| Customer deletion | `customers/delete` | `customers_delete` |
| Customer email marketing consent update | `customers_email_marketing_consent/update` | `customers_email_marketing_consent_update` |

### Checkouts and carts

| Event in Shopify | Topic | Table |
|---|---|---|
| Checkout creation | `checkouts/create` | `checkouts_create` |
| Checkout update | `checkouts/update` | `checkouts_update` |
| Checkout deletion | `checkouts/delete` | `checkouts_delete` |
| Cart creation | `carts/create` | `carts_create` |
| Cart update | `carts/update` | `carts_update` |

### Products

| Event in Shopify | Topic | Table |
|---|---|---|
| Product creation | `products/create` | `products_create` |
| Product update | `products/update` | `products_update` |
| Product deletion | `products/delete` | `products_delete` |
| Variant in stock | `variants/in_stock` | `variants_in_stock` |
| Variant out of stock | `variants/out_of_stock` | `variants_out_of_stock` |
| Collection creation | `collections/create` | `collections_create` |
| Collection update | `collections/update` | `collections_update` |
| Collection deletion | `collections/delete` | `collections_delete` |

### Inventory

| Event in Shopify | Topic | Table |
|---|---|---|
| Inventory level update | `inventory_levels/update` | `inventory_levels_update` |
| Inventory level connect | `inventory_levels/connect` | `inventory_levels_connect` |
| Inventory level disconnect | `inventory_levels/disconnect` | `inventory_levels_disconnect` |
| Inventory item creation | `inventory_items/create` | `inventory_items_create` |
| Inventory item update | `inventory_items/update` | `inventory_items_update` |
| Inventory item deletion | `inventory_items/delete` | `inventory_items_delete` |

***

## Columns

Amounts are exact decimals (NUMERIC). Ids are kept exactly as sent, including those beyond 2^53. Dates are timestamps in UTC.

### Columns of the order tables

Tables: `orders_create`, `orders_updated`, `orders_paid`, `orders_cancelled`, `orders_fulfilled`, `orders_partially_fulfilled`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `admin_graphql_api_id` | STRING |  |
| `name` | STRING |  |
| `order_number` | INTEGER |  |
| `email` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `processed_at` | TIMESTAMP |  |
| `cancelled_at` | TIMESTAMP |  |
| `cancel_reason` | STRING |  |
| `closed_at` | TIMESTAMP |  |
| `currency` | STRING |  |
| `presentment_currency` | STRING |  |
| `financial_status` | STRING |  |
| `fulfillment_status` | STRING |  |
| `total_price` | NUMERIC |  |
| `subtotal_price` | NUMERIC |  |
| `total_tax` | NUMERIC |  |
| `total_discounts` | NUMERIC |  |
| `total_line_items_price` | NUMERIC |  |
| `total_shipping_price` | NUMERIC |  |
| `current_total_price` | NUMERIC |  |
| `total_weight` | INTEGER |  |
| `taxes_included` | BOOLEAN |  |
| `test` | BOOLEAN |  |
| `confirmed` | BOOLEAN |  |
| `source_name` | STRING |  |
| `landing_site` | STRING |  |
| `referring_site` | STRING |  |
| `tags` | STRING |  |
| `note` | STRING |  |
| `buyer_accepts_marketing` | BOOLEAN |  |
| `customer_locale` | STRING |  |
| `checkout_token` | STRING |  |
| `cart_token` | STRING |  |
| `location_id` | INTEGER |  |
| `user_id` | INTEGER |  |
| `app_id` | INTEGER |  |
| `customer_id` | INTEGER |  |
| `shipping_country_code` | STRING |  |
| `shipping_city` | STRING |  |
| `shipping_zip` | STRING |  |
| `billing_country_code` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `orders_edited`

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `order_id` | INTEGER |  |
| `app_id` | INTEGER |  |
| `user_id` | INTEGER |  |
| `created_at` | TIMESTAMP |  |
| `notify_customer` | BOOLEAN |  |
| `staff_note` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the deletion tables

Tables: `orders_delete`, `draft_orders_delete`, `customers_delete`, `checkouts_delete`, `products_delete`, `collections_delete`, `inventory_items_delete`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `order_transactions_create`

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `order_id` | INTEGER |  |
| `parent_id` | INTEGER |  |
| `kind` | STRING |  |
| `gateway` | STRING |  |
| `status` | STRING |  |
| `amount` | NUMERIC |  |
| `currency` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `processed_at` | TIMESTAMP |  |
| `test` | BOOLEAN |  |
| `error_code` | STRING |  |
| `source_name` | STRING |  |
| `payment_id` | STRING |  |
| `user_id` | INTEGER |  |
| `location_id` | INTEGER |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `refunds_create`

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `order_id` | INTEGER |  |
| `created_at` | TIMESTAMP |  |
| `processed_at` | TIMESTAMP |  |
| `note` | STRING |  |
| `restock` | BOOLEAN |  |
| `user_id` | INTEGER |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the fulfillment tables

Tables: `fulfillments_create`, `fulfillments_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `order_id` | INTEGER |  |
| `name` | STRING |  |
| `status` | STRING |  |
| `shipment_status` | STRING |  |
| `service` | STRING |  |
| `location_id` | INTEGER |  |
| `tracking_company` | STRING |  |
| `tracking_number` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `tender_transactions_create`

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `order_id` | INTEGER |  |
| `amount` | NUMERIC |  |
| `currency` | STRING |  |
| `payment_method` | STRING |  |
| `remote_reference` | STRING |  |
| `user_id` | INTEGER |  |
| `test` | BOOLEAN |  |
| `processed_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the dispute tables

Tables: `disputes_create`, `disputes_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `order_id` | INTEGER |  |
| `type` | STRING |  |
| `status` | STRING |  |
| `reason` | STRING |  |
| `network_reason_code` | STRING |  |
| `amount` | NUMERIC |  |
| `currency` | STRING |  |
| `initiated_at` | TIMESTAMP |  |
| `evidence_due_by` | TIMESTAMP |  |
| `evidence_sent_on` | TIMESTAMP |  |
| `finalized_on` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the draft order tables

Tables: `draft_orders_create`, `draft_orders_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `name` | STRING |  |
| `status` | STRING |  |
| `email` | STRING |  |
| `currency` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `completed_at` | TIMESTAMP |  |
| `invoice_sent_at` | TIMESTAMP |  |
| `total_price` | NUMERIC |  |
| `subtotal_price` | NUMERIC |  |
| `total_tax` | NUMERIC |  |
| `taxes_included` | BOOLEAN |  |
| `order_id` | INTEGER |  |
| `customer_id` | INTEGER |  |
| `tags` | STRING |  |
| `note` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the customer tables

Tables: `customers_create`, `customers_update`, `customers_enable`, `customers_disable`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `email` | STRING |  |
| `first_name` | STRING |  |
| `last_name` | STRING |  |
| `phone` | STRING |  |
| `state` | STRING |  |
| `verified_email` | BOOLEAN |  |
| `tax_exempt` | BOOLEAN |  |
| `currency` | STRING |  |
| `tags` | STRING |  |
| `note` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `email_marketing_state` | STRING |  |
| `email_marketing_opt_in_level` | STRING |  |
| `email_marketing_updated_at` | TIMESTAMP |  |
| `sms_marketing_state` | STRING |  |
| `country_code` | STRING |  |
| `city` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `customers_email_marketing_consent_update`

| Column | Type | Description |
|---|---|---|
| `customer_id` | INTEGER |  |
| `email_address` | STRING |  |
| `state` | STRING |  |
| `opt_in_level` | STRING |  |
| `consent_updated_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the checkout tables

Tables: `checkouts_create`, `checkouts_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `token` | STRING |  |
| `cart_token` | STRING |  |
| `email` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `completed_at` | TIMESTAMP |  |
| `currency` | STRING |  |
| `presentment_currency` | STRING |  |
| `total_price` | NUMERIC |  |
| `subtotal_price` | NUMERIC |  |
| `total_tax` | NUMERIC |  |
| `total_discounts` | NUMERIC |  |
| `source_name` | STRING |  |
| `landing_site` | STRING |  |
| `referring_site` | STRING |  |
| `abandoned_checkout_url` | STRING |  |
| `buyer_accepts_marketing` | BOOLEAN |  |
| `customer_id` | INTEGER |  |
| `shipping_country_code` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the cart tables

Tables: `carts_create`, `carts_update`.

| Column | Type | Description |
|---|---|---|
| `id` | STRING |  |
| `token` | STRING |  |
| `note` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the product tables

Tables: `products_create`, `products_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `admin_graphql_api_id` | STRING |  |
| `title` | STRING |  |
| `handle` | STRING |  |
| `product_type` | STRING |  |
| `vendor` | STRING |  |
| `status` | STRING |  |
| `tags` | STRING |  |
| `published_scope` | STRING |  |
| `template_suffix` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `published_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the variant tables

Tables: `variants_in_stock`, `variants_out_of_stock`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `product_id` | INTEGER |  |
| `title` | STRING |  |
| `sku` | STRING |  |
| `barcode` | STRING |  |
| `price` | NUMERIC |  |
| `compare_at_price` | NUMERIC |  |
| `inventory_item_id` | INTEGER |  |
| `inventory_quantity` | INTEGER |  |
| `inventory_policy` | STRING |  |
| `position` | INTEGER |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the collection tables

Tables: `collections_create`, `collections_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `handle` | STRING |  |
| `title` | STRING |  |
| `sort_order` | STRING |  |
| `published_scope` | STRING |  |
| `updated_at` | TIMESTAMP |  |
| `published_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the inventory level tables

Tables: `inventory_levels_update`, `inventory_levels_connect`, `inventory_levels_disconnect`.

| Column | Type | Description |
|---|---|---|
| `inventory_item_id` | INTEGER |  |
| `location_id` | INTEGER |  |
| `available` | INTEGER |  |
| `updated_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the inventory item tables

Tables: `inventory_items_create`, `inventory_items_update`.

| Column | Type | Description |
|---|---|---|
| `id` | INTEGER |  |
| `sku` | STRING |  |
| `cost` | NUMERIC |  |
| `tracked` | BOOLEAN |  |
| `requires_shipping` | BOOLEAN |  |
| `country_code_of_origin` | STRING |  |
| `created_at` | TIMESTAMP |  |
| `updated_at` | TIMESTAMP |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Reading `_raw`

Every table has a `_raw` column with the event exactly as the provider sent it. It holds what the typed columns leave out: lists, nested objects, and the fields a provider adds in a new version. Read it with the JSON functions of your warehouse:

```sql
-- BigQuery
SELECT JSON_VALUE(_raw, '$.some.field') AS some_field
FROM `your_dataset.your_table`
WHERE _quanti_date >= '2026-01-01'

-- Snowflake
SELECT PARSE_JSON(_raw):some.field::STRING AS some_field
FROM your_schema.your_table
```

***

## Duplicates

Shopify resends an event until it gets a response, and sends `orders/updated` at every change of an order. Tables accumulate rows: to read the latest state of an order, keep the most recent row per `id`:

```sql
SELECT * FROM `your_dataset.orders_updated`
WHERE _quanti_date >= '2026-01-01'
QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY updated_at DESC, _quanti_loaded_at DESC) = 1
```
