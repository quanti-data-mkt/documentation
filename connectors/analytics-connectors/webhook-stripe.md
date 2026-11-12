---
description: Receive your Stripe events in your data warehouse in real time, one table per kind of object.
---

# Stripe webhooks

**Stripe webhooks** send your Stripe events (payments, refunds, disputes, payouts, invoices, subscriptions, checkout sessions) to your data warehouse as they happen, one table per kind of object.

{% hint style="warning" %}
A webhook only carries what happens **after** it is created, and nothing once the provider stops retrying an event. For history and reconciliation, use the [Stripe](../sales-analytics-connectors/stripe.md) connector alongside it.
{% endhint %}

***

## How it works

* Stripe sends every event to **one** endpoint URL. QUANTI: writes each event to the table of its object, from its `type`.
* The most specific table wins: a `charge.dispute.created` event goes to `dispute_events`, not `charge_events`. **`other_events`** receives every event no other active table takes.
* Stripe signs every event with the endpoint's **signing secret** (`whsec_…`) and a timestamp. QUANTI: checks both: an event signed more than 5 minutes earlier is treated as a replay.

***

## Setup

{% stepper %}
{% step %}
### Create the webhook in QUANTI:

In **Connect › Real time**, choose **Stripe webhooks**. Give it a name and a dataset, then pick the tables you want. Copy the URL shown on the cards: it is the same for every table.
{% endstep %}

{% step %}
### Add the endpoint in Stripe

In your Stripe Dashboard, open **Developers › Webhooks** and add an endpoint (event destination):

* **Payload style**: **Snapshot**, never **Thin**;
* **Events**: the events of the tables turned on in QUANTI: (see the list below);
* **Endpoint URL**: the URL copied from QUANTI:.

{% hint style="danger" %}
**A Thin destination writes nothing, and Stripe still shows every delivery as successful.** A thin event only carries the id of the object, not the object itself, and its type is prefixed (`v1.product.created` instead of `product.created`): no table takes it. To fix it: create a new Snapshot destination, paste its signing secret in QUANTI:, then delete the Thin one.
{% endhint %}
{% endstep %}

{% step %}
### Paste the signing secret

On the endpoint page, reveal the **signing secret** (`whsec_…`) and paste it in the **Security** tab of the QUANTI: webhook. Each destination has its own secret: a new destination means a new secret to paste. Live and test mode endpoints have different secrets: one QUANTI: webhook per mode.
{% endstep %}

{% step %}
### Test

Trigger a real event of a table you turned on, in the same mode (live or test) as the destination: create a product for `product_events`, run a test payment for `payment_intent_events`. The table is created with the first event, within a minute.

The ping Stripe sends when you create the destination (`v2.core.event_destination.ping`) only lands in `other_events`, if that table is on. It proves nothing about the others.
{% endstep %}
{% endstepper %}

{% hint style="info" %}
QUANTI: checks every event in **observe** mode: an event with a missing or wrong signature is still written, and flagged on our side. A mistyped key never makes you lose events, and the provider never disables your webhook because of it.
{% endhint %}

***

## Stripe shows "200", but the table stays empty

QUANTI: answers **200** to every event it receives, even one that no table takes: an error would make Stripe retry, then disable the whole destination. A successful delivery in Stripe therefore only proves the event reached QUANTI:. Check, in this order:

1. **Payload style.** Open a delivery in Stripe: if the request body has `"object": "v2.core.event"` and a type starting with `v1.`, the destination is **Thin**. Replace it with a Snapshot destination (see [Setup](#setup)).
2. **Events.** Only the event types ticked on the destination are sent. A `payment_intent.succeeded` never reaches `product_events`; turn on `other_events` to catch everything else.
3. **Mode.** Events triggered in test mode, or in a sandbox, never reach a live destination, and the other way round.
4. **Delay.** Events are written in batches: allow about a minute before querying the table.

***

## Tables

| Table | Stripe events |
|---|---|
| `payment_intent_events` | `payment_intent.*` |
| `charge_events` | `charge.*` |
| `refund_events` | `refund.*`, `charge.refund.*` |
| `dispute_events` | `charge.dispute.*` |
| `payout_events` | `payout.*` |
| `invoice_events` | `invoice.*` |
| `subscription_events` | `customer.subscription.*` |
| `customer_events` | `customer.created`, `customer.updated`, `customer.deleted` |
| `checkout_session_events` | `checkout.session.*` |
| `product_events` | `product.*` |
| `price_events` | `price.*` |
| `other_events` | `*` |

Amounts are integers in the currency's smallest unit (cents for EUR). Dates are timestamps in UTC. The shape of `data.object` depends on the **API version of the endpoint** (`api_version` column): a field Stripe moved in a newer version stays readable in `_raw`.

### Columns of `payment_intent_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `amount` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_received` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `currency` | STRING |  |
| `status` | STRING |  |
| `customer` | STRING |  |
| `payment_method` | STRING |  |
| `latest_charge` | STRING |  |
| `description` | STRING |  |
| `cancellation_reason` | STRING |  |
| `last_payment_error_code` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `charge_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `amount` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_captured` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_refunded` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `currency` | STRING |  |
| `status` | STRING |  |
| `paid` | BOOLEAN |  |
| `captured` | BOOLEAN |  |
| `refunded` | BOOLEAN |  |
| `customer` | STRING |  |
| `payment_intent` | STRING |  |
| `failure_code` | STRING |  |
| `failure_message` | STRING |  |
| `billing_email` | STRING |  |
| `billing_country` | STRING |  |
| `payment_method_type` | STRING |  |
| `card_brand` | STRING |  |
| `outcome_type` | STRING |  |
| `risk_level` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `refund_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `amount` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `currency` | STRING |  |
| `status` | STRING |  |
| `reason` | STRING |  |
| `charge` | STRING |  |
| `payment_intent` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `dispute_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `amount` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `currency` | STRING |  |
| `status` | STRING |  |
| `reason` | STRING |  |
| `charge` | STRING |  |
| `payment_intent` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `payout_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `amount` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `currency` | STRING |  |
| `status` | STRING |  |
| `method` | STRING |  |
| `payout_type` | STRING |  |
| `arrival_date` | TIMESTAMP |  |
| `failure_code` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `invoice_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `number` | STRING |  |
| `customer` | STRING |  |
| `customer_email` | STRING |  |
| `status` | STRING |  |
| `billing_reason` | STRING |  |
| `currency` | STRING |  |
| `total` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `subtotal` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_due` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_paid` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_remaining` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `attempt_count` | INTEGER |  |
| `period_start` | TIMESTAMP |  |
| `period_end` | TIMESTAMP |  |
| `hosted_invoice_url` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `subscription_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `customer` | STRING |  |
| `status` | STRING |  |
| `currency` | STRING |  |
| `collection_method` | STRING |  |
| `cancel_at_period_end` | BOOLEAN |  |
| `cancellation_reason` | STRING |  |
| `start_date` | TIMESTAMP |  |
| `canceled_at` | TIMESTAMP |  |
| `ended_at` | TIMESTAMP |  |
| `trial_end` | TIMESTAMP |  |
| `first_price_id` | STRING | Price of the first item. Every item is in _raw. |
| `first_quantity` | INTEGER |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `customer_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `email` | STRING |  |
| `name` | STRING |  |
| `phone` | STRING |  |
| `currency` | STRING |  |
| `country` | STRING |  |
| `delinquent` | BOOLEAN |  |
| `balance` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `checkout_session_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `mode` | STRING |  |
| `status` | STRING |  |
| `payment_status` | STRING |  |
| `amount_total` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `amount_subtotal` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `currency` | STRING |  |
| `customer` | STRING |  |
| `customer_email` | STRING |  |
| `payment_intent` | STRING |  |
| `subscription` | STRING |  |
| `client_reference_id` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `product_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `name` | STRING |  |
| `active` | BOOLEAN |  |
| `description` | STRING |  |
| `default_price` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `price_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
| `product` | STRING |  |
| `active` | BOOLEAN |  |
| `currency` | STRING |  |
| `unit_amount` | INTEGER | Amount in the currency's smallest unit (cents for EUR). |
| `price_type` | STRING |  |
| `recurring_interval` | STRING |  |
| `nickname` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `other_events`

| Column | Type | Description |
|---|---|---|
| `event_id` | STRING | Stripe event id (evt_…). Stripe may send an event more than once: deduplicate on event_id. |
| `type` | STRING | Stripe event type, e.g. payment_intent.succeeded. |
| `created_at` | TIMESTAMP | When Stripe created the event, in UTC. |
| `object_id` | STRING | Id of the Stripe object the event is about. |
| `livemode` | BOOLEAN | false for test mode events. |
| `api_version` | STRING | API version of the webhook endpoint: the shape of data.object depends on it. |
| `request_id` | STRING | API request that caused the event, empty for automatic events. |
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

Stripe may send the same event more than once. Deduplicate on `event_id`:

```sql
SELECT * FROM `your_dataset.payment_intent_events`
WHERE _quanti_date >= '2026-01-01'
QUALIFY ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY _quanti_loaded_at) = 1
```
