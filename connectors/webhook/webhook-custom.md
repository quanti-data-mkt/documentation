# Custom Webhook

The **Custom Webhook** connector lets you ingest events from any third-party system via a dedicated HTTPS endpoint. QUANTI: automatically generates the receiving URL, infers the schema from your first test payload, and routes the data directly into your data warehouse.

Typical use cases: CRM events, application alerts, web forms, e-commerce notifications, exports from third-party platforms that don't have a native QUANTI: connector.

{% hint style="info" %}
To ingest data from the QUANTI: web tracking tag, use the dedicated **Real-Time Analytics** connector — it natively handles sessions, attribution, and consent.
{% endhint %}

***

## How it works

1. QUANTI: generates a **unique HTTPS endpoint** for your tenant
2. You point your source's webhook to that endpoint
3. On receipt of the first payload, QUANTI: **automatically infers the schema** (field names and types)
4. You validate the schema and the connector starts ingesting

Each received payload is inserted as-is into your data warehouse, without transformation. Fields are mapped directly from the JSON structure of the payload.

***

## Setup

{% stepper %}
{% step %}
### Name your tenant

Give your webhook connector a name (e.g. `crm-events`, `shop-notifications`). This name will determine the table name in your warehouse.
{% endstep %}

{% step %}
### Retrieve the endpoint URL

Once the connector is created, QUANTI: provides the HTTPS URL to configure in your third-party source. It is unique per tenant.
{% endstep %}

{% step %}
### Send a test payload

Trigger an event from your source or manually send a representative JSON payload via cURL or Postman:

```bash
curl -X POST https://webhook.quanti.io/<your-endpoint> \
  -H "Content-Type: application/json" \
  -d '{"event": "order.created", "order_id": "12345", "amount": 99.90}'
```
{% endstep %}

{% step %}
### Validate the inferred schema

QUANTI: displays the schema detected from your payload. Check that the types are correct (STRING, NUMERIC, TIMESTAMP…) and confirm to activate ingestion.
{% endstep %}
{% endstepper %}

***

## Payload format

* Payload must be in **JSON** format
* HTTP method: **POST**
* Content-Type: `application/json`
* Maximum payload size: **1 MB**
* Nested arrays and objects are accepted — QUANTI: flattens them or stores them as JSON depending on the schema configuration

***

## Data in the warehouse

Each received event generates one row in your BigQuery table. QUANTI: automatically adds the following system columns:

| Column | Type | Description |
|---|---|---|
| `_quanti_received_at` | TIMESTAMP | Timestamp of receipt by QUANTI: |
| `_quanti_id` | STRING | Unique event identifier |

All other columns correspond to the fields in your JSON payload.

***

## Notes

* The endpoint is **public** — there is no authentication on the URL by default. If your source supports it, add a shared secret in a custom header and validate it on the QUANTI: side via payload filters
* The schema is inferred from the **first payload** — if your payload evolves (new fields), additional columns will be added automatically on subsequent payloads
* There is no lookback or history: only events received after the connector is created are stored
* The connector does not handle deduplication — if your source can send the same event multiple times, manage idempotency in your downstream pipeline
