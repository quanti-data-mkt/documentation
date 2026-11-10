---
description: Receive your Brevo email and SMS events in your data warehouse in real time.
---

# Brevo webhooks

**Brevo webhooks** send your email and SMS events (deliveries, opens, clicks, bounces, unsubscribes, contact changes) to your data warehouse as they happen, one table per kind of event.

{% hint style="warning" %}
A webhook only carries what happens **after** it is created, and nothing once the provider stops retrying an event. For history and reconciliation, use the [Brevo](../marketing-connectors/brevo.md) connector alongside it.
{% endhint %}

***

## How it works

* One QUANTI: webhook covers your Brevo account. You turn on the tables you want in the **Reports** tab.
* Brevo has one kind of webhook per channel (transactional or marketing, email or SMS). Each has **its own URL** in QUANTI:, shown on the cards of its tables.
* Email campaign events and contact changes come from the **same** Brevo marketing webhook: they share a URL, and QUANTI: writes each event to its table from its `event` field.
* Brevo does not sign its webhooks. QUANTI: generates an **authentication token** that Brevo sends back with every event.

***

## Setup

{% stepper %}
{% step %}
### Create the webhook in QUANTI:

In **Connect › Real time**, choose **Brevo webhooks**. Give it a name and a dataset, then pick the tables you want. QUANTI: generates the authentication token at creation.
{% endstep %}

{% step %}
### Copy the token

Open the **Security** tab of the QUANTI: webhook and copy the token.
{% endstep %}

{% step %}
### Create one Brevo webhook per URL

Create one Brevo webhook for each URL shown on your active tables. Each Brevo webhook covers one event category:

| Table | Brevo event category | URL suffix |
|---|---|---|
| `transactional_email_events` | Transactional email | `/transactional-email` |
| `campaign_email_events` | Marketing email | `/marketing` |
| `contact_events` | Marketing email (contact events are listed there) | `/marketing` |
| `transactional_sms_events` | Transactional SMS | `/transactional-sms` |
| `campaign_sms_events` | Marketing SMS | `/marketing-sms` |

For each URL:

1. In Brevo, click your **account name** (bottom left), then **Integrations › Webhooks**.
2. Click **Add webhook**, select **Outbound webhook**, then click **Add webhook**.
3. Enter a name (for example `QUANTI: transactional email`) and click **Continue**.
4. Paste the QUANTI: URL of the table.
5. Under **Authentication**, select **Token** and paste the token copied from QUANTI:.
6. Under the sending strategy, select **Send one at a time**, then click **Continue**.
7. Select the **event category** from the table above. All its events are on by default: turn off the ones you don't want.
8. (Optional) Click the **⋯** next to an event and choose **Send test request** to check that it arrives.
9. Click **Activate webhook**.

{% hint style="warning" %}
QUANTI: does not accept batched events. Do not select **Send by batch**: keep **Send one at a time**.
{% endhint %}

{% hint style="info" %}
`campaign_email_events` and `contact_events` share the `/marketing` URL: one Brevo webhook on the **Marketing email** category feeds both. An event whose table is not turned on in QUANTI: (for example a contact change while only `campaign_email_events` is active) is acknowledged and not written. Turn the table on in the Reports tab to start receiving it.
{% endhint %}
{% endstep %}
{% endstepper %}

{% hint style="info" %}
QUANTI: checks the token in **observe** mode: an event without the token, or with a wrong one, is still written and flagged on our side. A webhook created without the token keeps working; you can add it later by editing the webhook in **Integrations › Webhooks**, or through the Brevo API (`auth` of the webhook).
{% endhint %}

***

## Tables

| Table | Events | URL suffix |
|---|---|---|
| `transactional_email_events` | `transactional_email` | `/transactional-email` |
| `campaign_email_events` | `delivered`, `opened`, `click`, `proxy_open`, `unique_opened`, `hard_bounce`, `hardBounce`, `soft_bounce`, `softBounce`, `spam`, `unsubscribe`, `unsubscribed` | `/marketing` |
| `contact_events` | `list_addition`, `listAddition`, `contact_updated`, `contactUpdated`, `contact_deleted`, `contactDeleted` | `/marketing` |
| `transactional_sms_events` | `transactional_sms` | `/transactional-sms` |
| `campaign_sms_events` | `campaign_sms` | `/marketing-sms` |

### Columns of `transactional_email_events`

| Column | Type | Description |
|---|---|---|
| `event` | STRING | Event at Brevo, as sent in the `event` field (delivered, opened, click, hard_bounce…). |
| `email` | STRING | Recipient email address. |
| `id` | INTEGER | Id of the Brevo webhook that sent the event. |
| `message_id` | STRING | Id of the email message, shared by every event of the same email. |
| `subject` | STRING |  |
| `tag` | STRING | First tag of the email. Every tag is in _raw (tags). |
| `template_id` | INTEGER | Id of the Brevo template used, when there is one. |
| `contact_id` | INTEGER | Id of the Brevo contact. |
| `link` | STRING | Link clicked (click events). |
| `reason` | STRING | Bounce, deferral or block reason. |
| `sending_ip` | STRING |  |
| `user_agent` | STRING |  |
| `device_used` | STRING |  |
| `mirror_link` | STRING |  |
| `source` | STRING | Origin of the email: api, automation… |
| `workflow_id` | STRING | Automation workflow, when source is automation. |
| `step_id` | STRING | Automation step, when source is automation. |
| `x_mailin_custom` | STRING | Custom header set when the email was sent. |
| `event_at` | TIMESTAMP | When the event happened, in UTC (from ts_event). |
| `ts_epoch` | INTEGER | Event time in milliseconds, as sent by Brevo. |
| `date` | STRING | Event date as sent by Brevo (text, account time zone). |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `campaign_email_events`

| Column | Type | Description |
|---|---|---|
| `event` | STRING | Event at Brevo, as sent in the `event` field (delivered, opened, click, hard_bounce…). |
| `email` | STRING |  |
| `id` | INTEGER | Id of the Brevo webhook that sent the event. |
| `camp_id` | INTEGER | Id of the email campaign. |
| `campaign_name` | STRING |  |
| `tag` | STRING |  |
| `url` | STRING | Link clicked (click events). |
| `reason` | STRING |  |
| `sending_ip` | STRING |  |
| `sent_at` | TIMESTAMP | When the campaign was sent, in UTC. |
| `event_at` | TIMESTAMP | When the event happened, in UTC (from ts_event). |
| `date_sent` | STRING |  |
| `date_event` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of `contact_events`

Lists added to and attributes updated are in `_raw` (`list_id`, `content`).

| Column | Type | Description |
|---|---|---|
| `event` | STRING | list_addition, contact_updated or contact_deleted. |
| `email` | STRING |  |
| `id` | INTEGER | Id of the Brevo webhook that sent the event. |
| `key` | STRING |  |
| `api_key_name` | STRING | API key that made the change, empty when made in Brevo. |
| `event_at` | TIMESTAMP | When the change happened, in UTC (from ts). Lists and updated attributes are in _raw. |
| `date` | STRING |  |
| `_raw` | STRING | Full JSON body of the event, as received. |
| `_quanti_date` | DATE | Day the event was received (partition). |
| `_quanti_loaded_at` | TIMESTAMP | When the event was written. |

### Columns of the SMS tables

Tables: `transactional_sms_events`, `campaign_sms_events`.

| Column | Type | Description |
|---|---|---|
| `msg_status` | STRING | SMS event: sent, delivered, replied, soft_bounce, hard_bounce, subscribe, unsubscribed, skip… |
| `id` | STRING |  |
| `to` | STRING | Recipient phone number. |
| `message_id` | STRING |  |
| `status` | STRING |  |
| `description` | STRING |  |
| `type` | STRING |  |
| `tag` | STRING |  |
| `campaign_id` | STRING |  |
| `sms_count` | INTEGER |  |
| `credits_used` | NUMERIC |  |
| `remaining_credit` | NUMERIC |  |
| `reply` | STRING | Text of the reply (replied events). |
| `error_code` | STRING |  |
| `bounce_type` | STRING |  |
| `event_at` | TIMESTAMP | When the event happened, in UTC (from ts_event). |
| `date` | STRING |  |
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
