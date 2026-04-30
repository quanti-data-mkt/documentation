---
description: 'Follow our setup guide to connect Mirakl Seller to QUANTI:'
---

# Mirakl Seller

{% hint style="warning" %}
This connector is currently in **beta**.
{% endhint %}

<a href="https://dbdiagram.io/e/69d8d8550f7c9ef2c0c6d4ad/69d8d890808962968466e347" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

To connect Mirakl to QUANTI, you need:

* Access to a [Mirakl](https://www.mirakl.com)-powered marketplace as a seller
* Your marketplace instance URL (e.g. `https://your-instance.mirakl.net`)
* A seller API key generated from your Mirakl seller dashboard

***

## Setup instructions

{% stepper %}
{% step %}
#### Authorize your account

Enter your credentials:

* **Marketplace URL**: The base URL of your Mirakl marketplace instance
* **API Key**: Your seller API key

To retrieve your API key, log in to your Mirakl seller dashboard and navigate to **My Account > API Key**.
{% endstep %}

{% step %}
#### Select pre-built reports

Review the available pre-built reports and select the ones you want to activate.
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

* **shop\_history**: History of shop settings, status and configuration — name, currency, lead time, channels, billing, VAT and contact details.
* **shop\_stats**: Daily aggregated shop performance metrics by channel — acceptance rate, cancellation rate, incident rate, refund rate, late shipment rate, revenue, average cart, and seller grade.
* **order**: Orders with status, amounts, payment workflow, customer shipping information and fulfillment details.
* **order\_line**: Order line details per product — pricing, commission, shipping carrier, tracking, refunds and cancellations.
* **offer\_history**: History of offer status, price, stock and inactivity reasons per product, including refused, pending and inactive offers.
* **category**: Marketplace catalog category hierarchy with codes, labels and parent relationships.
* **product\_import**: Product import history with integration statistics — lines read, successes, errors, warnings, and rejected or invalid products.
* **catalog\_status**: Publication status of products from Mirakl Catalog Manager (MCM) — LIVE or NOT\_LIVE for each product (identified by its shop SKU), with the list of blocking errors and warnings as JSON arrays. Requires the MCM module to be enabled on the marketplace instance.

```mermaid
erDiagram
    shop_history {
        TIMESTAMP _quanti_loaded_at PK
        INTEGER   shop_id PK
        TIMESTAMP last_updated_date PK
        VARCHAR   shop_name
        TIMESTAMP date_created
        VARCHAR   currency_iso_code
        BOOLEAN   is_professional
        VARCHAR   suspension_reason
        VARCHAR   contact_email
        VARCHAR   contact_country
        VARCHAR   channels
        VARCHAR   vat_number
    }
    shop_stats {
        TIMESTAMP _quanti_loaded_at PK
        DATE      collected_date PK
        INTEGER   shop_id PK
        VARCHAR   channel_code PK
        FLOAT     approval_rate
        FLOAT     cancelation_rate
        FLOAT     incident_rate
        FLOAT     refund_rate
        FLOAT     total_revenue
        FLOAT     grade
        INTEGER   evaluations_count
    }
    order {
        TIMESTAMP _quanti_loaded_at PK
        VARCHAR   order_id PK
        TIMESTAMP last_updated_date PK
        VARCHAR   commercial_id
        TIMESTAMP created_date
        VARCHAR   order_state
        VARCHAR   channel_code
        VARCHAR   currency_iso_code
        FLOAT     total_price
        FLOAT     total_price_incl_tax
    }
    order_line {
        TIMESTAMP _quanti_loaded_at PK
        VARCHAR   order_line_id PK
        VARCHAR   order_id PK
        TIMESTAMP last_updated_date PK
        INTEGER   offer_id
        VARCHAR   offer_sku
        VARCHAR   product_title
        VARCHAR   order_line_state
        INTEGER   quantity
        FLOAT     price
        FLOAT     commission_fee
    }
    category {
        TIMESTAMP _quanti_loaded_at PK
        VARCHAR   code PK
        VARCHAR   label
        INTEGER   level
        VARCHAR   parent_code
    }
    offer_history {
        TIMESTAMP _quanti_loaded_at PK
        INTEGER   offer_id PK
        TIMESTAMP last_updated_date PK
        VARCHAR   category_code
        VARCHAR   shop_sku
        VARCHAR   product_title
        VARCHAR   state_code
        BOOLEAN   active
        FLOAT     price
        INTEGER   quantity
    }
    product_import {
        TIMESTAMP _quanti_loaded_at PK
        INTEGER   import_id PK
        VARCHAR   import_status PK
        INTEGER   shop_id
        TIMESTAMP date_created
        INTEGER   transform_lines_read
        INTEGER   transform_lines_in_success
        INTEGER   transform_lines_in_error
        BOOLEAN   has_error_report
    }
    catalog_status {
        TIMESTAMP _quanti_loaded_at PK
        STRING    provider_unique_identifier PK
        STRING    status
        STRING    errors
        STRING    warnings
    }

    shop_history   ||--o{ shop_stats      : "shop_id"
    shop_history   ||--o{ product_import  : "shop_id"
    order          ||--o{ order_line      : "order_id"
    offer_history  ||--o{ order_line      : "offer_id"
    category       ||--o{ offer_history   : "category_code"
    offer_history  ||--o{ catalog_status  : "shop_sku"
```

***

<a href="https://dbdiagram.io/e/69d8d8550f7c9ef2c0c6d4ad/69d8d890808962968466e347" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Notes

* **Lookback window**: Default lookback is **7 days**. Orders and offers are re-synced over the lookback window to capture status updates (e.g. an order accepted or shipped after the initial sync).
* **Differential sync for offers**: The `offer_history` table uses a differential sync mode — only offers modified since the last sync are fetched.
* **catalog\_status requires MCM**: The `catalog_status` table is only available if the Mirakl Catalog Manager (MCM) module is enabled on your marketplace instance.
* **Beta status**: This connector is in beta — some features or report fields may evolve.
