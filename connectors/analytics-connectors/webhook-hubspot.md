---
description: Receive your HubSpot CRM events in your data warehouse in real time, one table per object.
---

# HubSpot webhooks

**HubSpot webhooks** send your CRM events (records created, updated, deleted, merged, associated) to your data warehouse as they happen, one table per kind of object.

{% hint style="warning" %}
A webhook only carries what happens **after** it is created, and nothing once the provider stops retrying an event. For history and reconciliation, use the [HubSpot](../sales-analytics-connectors/hubspot.md) connector alongside it.
{% endhint %}

***

## How it works

* HubSpot sends webhooks from an **app**: you create a private app in your HubSpot account, and give it **one** target URL for all its events.
* QUANTI: writes each event to the table of its object (contacts, deals…), from its `subscriptionType`. HubSpot sends events in batches of up to 100: each event is one row.
* HubSpot signs every request with the app's **client secret**. With it, QUANTI: checks that each request comes from your app.
* An event is a notification, not the record: a property change carries the property name and its new value, not the whole record.

***

## Setup

{% stepper %}
{% step %}
### Create the webhook in QUANTI:

In **Connect › Real time**, choose **HubSpot webhooks**. Give it a name and a dataset, then pick the objects you want. Copy the URL shown on the cards: it is the same for every object.
{% endstep %}

{% step %}
### Set the target URL in HubSpot

In HubSpot, webhooks are created in **Automation › Workflows**:

* **Target URL**: the URL copied from QUANTI:;
* **Subscriptions**: the events of the objects turned on in QUANTI: (for example `contact.creation`, `contact.propertyChange` with the properties to follow, `deal.creation`).
{% endstep %}

{% step %}
### Paste the client secret

In the **Auth** tab of the private app, copy the **client secret** and paste it in the **Security** tab of the QUANTI: webhook.
{% endstep %}
{% endstepper %}

{% hint style="warning" %}
Webhooks in HubSpot workflows are only available with some HubSpot plans (**Data Hub Professional or Enterprise**). If **Automation › Workflows** shows an upgrade page, your plan does not include them.
{% endhint %}

{% hint style="info" %}
QUANTI: checks every event in **observe** mode: an event with a missing or wrong signature is still written, and flagged on our side. A mistyped key never makes you lose events, and the provider never disables your webhook because of it.
{% endhint %}

{% hint style="warning" %}
Private apps built with HubSpot **projects** use generic subscriptions (`object.creation` with an object type id). They are not supported yet: use subscriptions by object (`contact.creation`, `deal.propertyChange`…).
{% endhint %}

***

## Tables

| Table | Object | Events |
|---|---|---|
| `contact_events` | Contacts | `contact.*` |
| `company_events` | Companies | `company.*` |
| `deal_events` | Deals | `deal.*` |
| `ticket_events` | Tickets | `ticket.*` |
| `product_events` | Products | `product.*` |
| `line_item_events` | Line items | `line_item.*` |
| `conversation_events` | Conversations | `conversation.*` |

### Columns of every table

All the tables above share these columns.

| Column | Type | Description |
|---|---|---|
| `subscription_type` | STRING | HubSpot event: <object>.creation, .propertyChange, .deletion, .merge, .associationChange, .restore, .privacyDeletion. |
| `object_id` | INTEGER | Id of the HubSpot record the event is about. |
| `property_name` | STRING | Property that changed (propertyChange events). |
| `property_value` | STRING | New value of the property, as text (propertyChange events). |
| `change_source` | STRING | What made the change: CRM_UI, API, WORKFLOWS, IMPORT… |
| `change_flag` | STRING |  |
| `occurred_at` | TIMESTAMP | When the event happened, in UTC. |
| `event_id` | INTEGER | Event id. Not guaranteed unique by HubSpot: deduplicate on event_id + occurred_at. |
| `subscription_id` | INTEGER |  |
| `portal_id` | INTEGER | HubSpot account id. |
| `app_id` | INTEGER |  |
| `attempt_number` | INTEGER | Delivery attempt, from 0. Above 0, the same event may already be in the table. |
| `primary_object_id` | INTEGER | Merge events: the record kept. |
| `new_object_id` | INTEGER | Merge events: the record resulting from the merge. |
| `number_of_properties_moved` | INTEGER |  |
| `association_type` | STRING |  |
| `from_object_id` | INTEGER |  |
| `to_object_id` | INTEGER |  |
| `association_removed` | BOOLEAN |  |
| `is_primary_association` | BOOLEAN |  |
| `message_id` | STRING | Conversations: id of the new message. |
| `message_type` | STRING |  |
| `source_id` | STRING |  |
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

HubSpot retries an event until it gets a response (up to 10 times over 24 hours), and its `eventId` is not guaranteed unique. Deduplicate on `event_id` and `occurred_at`:

```sql
SELECT * FROM `your_dataset.contact_events`
WHERE _quanti_date >= '2026-01-01'
QUALIFY ROW_NUMBER() OVER (PARTITION BY event_id, occurred_at ORDER BY _quanti_loaded_at) = 1
```
