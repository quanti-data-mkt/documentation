---
description: 'Follow our setup guide to push server-side events from QUANTI: to Google Analytics 4'
---

# Google Analytics 4 (Reverse)

{% hint style="info" %}
**Reverse connector** — this connector pushes events **from** your data warehouse **to** a Google Analytics 4 property, through the Google **Data Manager API**. Use it to bring events the Google tag cannot see (orders confirmed in your back-office, in-store sales, refunds, qualified leads) into your GA4 reports and audiences.

To send offline conversions for Google Ads bidding, use the **Google Ads (Reverse)** connector. Both connectors can run side by side on the same source tables.
{% endhint %}

***

## Prerequisites

* A **Google account** with **Editor** access to the target GA4 property.
* A GA4 property with **one web data stream** (or a single app data stream). QUANTI: detects the stream automatically — see [Notes](#notes).
* A **GA4 Client ID** (or App Instance ID) for every event, in your data warehouse. In practice it comes from the native GA4 BigQuery export, where `user_pseudo_id` **is** the Client ID, or from a column captured on your site. The QUANTI: tag does not collect it.
* A source table or view in your data warehouse with **one row per event**.

***

## Authentication

The connector uses **Google OAuth 2.0**. You authorize QUANTI: once from the setup screen; no API key to copy.

Requested scopes: `datamanager` (send events), `analytics.readonly` (list your accounts, properties and data streams) and `userinfo.email`.

***

## Setup Instructions

{% stepper %}
{% step %}
**Authorize your Google account**

Click **Continue with Google** and sign in with the Google account that has **Editor** access to the GA4 property you want to send events to.
{% endstep %}

{% step %}
**Select your GA4 account**

Select the Google Analytics account that owns the property.
{% endstep %}

{% step %}
**Select your property**

Pick the GA4 property that will receive the events. Its web data stream is detected automatically.
{% endstep %}

{% step %}
**Choose your event types**

Pick the events you want to push: **Purchase**, **Refund**, or **Custom event** to push an event of your own. Each template comes with the parameters that matter for it.
{% endstep %}

{% step %}
**Name your connector**

Give the connector a name, then click **Create**. The source table and field mapping of each activated event template are configured in the **Mapping** tab after creation.
{% endstep %}
{% endstepper %}

***

## Data Model

Each event template reads its own source table (or view). QUANTI: turns every row into one GA4 event and sends it to the selected property.

```mermaid
flowchart LR
    subgraph DW["Your data warehouse"]
        P["ga4_purchase source<br/>PK transaction_id"]
        R["ga4_refund source<br/>PK transaction_id"]
        C["ga4_custom source<br/>PK event_id"]
    end
    Q["QUANTI:<br/>hash PII · check 72 h window<br/>check Client ID"]
    G["GA4 property<br/>web data stream"]
    P -- "purchase" --> Q
    R -- "refund" --> Q
    C -- "event name set in Mapping tab" --> Q
    Q -- "Data Manager API<br/>events:ingest" --> G
```

***

## Event Types

### Purchase

Sends server-side `purchase` events. Use it to bring offline or back-office revenue (orders confirmed after payment, in-store sales) into your GA4 reports and audiences, alongside what the Google tag collects on the site.

One row per purchase — or one row per purchased item, see [Basket items](#basket-items).

| Field | Type | Required | Description |
|---|---|---|---|
| `transaction_id` | STRING | ✅ | Order identifier (primary key). Required by GA4 for purchase events, and used as the deduplication key against the client-side event. |
| `event_timestamp` | TIMESTAMP | ✅ | UTC timestamp of the event (RFC3339). GA4 rejects anything older than **72 hours**: rows outside that window are skipped and reported as `EVENT_TIMESTAMP_TOO_OLD`. |
| `value` | FLOAT | ✅ | Total revenue of the purchase in the specified currency. |
| `currency` | STRING | ✅ | ISO 4217 currency code (`EUR`, `USD`, `GBP`…). |
| `client_id` | STRING | — | GA4 Client ID of the web visitor — the value GA4 exports as `user_pseudo_id`. Each row needs `client_id` or `app_instance_id`, see [User identifier](#user-identifier). |
| `session_id` | STRING | — | GA4 session of the visit the event belongs to — `ga_session_id` in the native GA4 BigQuery export. Sent with the Client ID as the `session_id` event parameter, so GA4 can count the event in that session. |
| `app_instance_id` | STRING | — | Firebase app instance identifier — the app equivalent of the Client ID. Only for app data streams. |
| `user_id` | STRING | — | Your own user identifier, for User-ID measurement. Use it when the event comes from a logged-in context. |
| `gclid` | STRING | — | Google click identifier captured at conversion time. Improves attribution. |
| `item_id` | STRING | — | Identifier of the purchased product (SKU). One item per row. |
| `item_name` | STRING | — | Human-readable product name. |
| `quantity` | INTEGER | — | Number of units for this item. |
| `unit_price` | FLOAT | — | Price of a single unit, in the event currency. |
| `email` | STRING | — | User email. QUANTI: normalizes it (lowercase, whitespace removed, Gmail dot/alias rules) then hashes it with SHA-256. |
| `phone_number` | STRING | — | User phone. QUANTI: normalizes it to E.164 (default region FR) then hashes it with SHA-256. |
| `first_name` | STRING | — | User first name. Hashed with SHA-256. |
| `last_name` | STRING | — | User last name. Hashed with SHA-256. |
| `country_code` | STRING | — | ISO 3166-1 alpha-2 country code (`FR`, `US`…). Sent unhashed, as Google expects. |
| `postal_code` | STRING | — | Postal code. Sent unhashed, as Google expects. |
| `consent_ad_user_data` | STRING | — | DMA consent to send this user's data to Google, see [Consent](#consent-and-dma-european-users). |
| `consent_ad_personalization` | STRING | — | DMA consent to use this user's data for ad personalization. |

### Refund

Sends `refund` events so reported revenue reflects what was actually kept. Map the **same Transaction ID as the original purchase**: GA4 uses it to tie the refund back to the order.

| Field | Type | Required | Description |
|---|---|---|---|
| `transaction_id` | STRING | ✅ | Identifier of the order being refunded (primary key). Must match the Transaction ID sent with the original purchase event. |
| `event_timestamp` | TIMESTAMP | ✅ | UTC timestamp of the event (RFC3339). Must be less than **72 hours** old. |
| `value` | FLOAT | — | Amount refunded in the specified currency. Leave unmapped for a full refund of the original order. |
| `currency` | STRING | — | ISO 4217 currency code. Required whenever a value is sent. |
| `client_id` | STRING | — | GA4 Client ID (`user_pseudo_id`). Each row needs `client_id` or `app_instance_id`. |
| `session_id` | STRING | — | GA4 session of the visit (`ga_session_id` in the GA4 BigQuery export), sent as the `session_id` event parameter. |
| `app_instance_id` | STRING | — | Firebase app instance identifier. Only for app data streams. |
| `user_id` | STRING | — | Your own user identifier, for User-ID measurement. |
| `gclid` | STRING | — | Google click identifier captured at conversion time. |
| `item_id` | STRING | — | Identifier of the refunded product (SKU). One item per row. |
| `item_name` | STRING | — | Human-readable product name. |
| `quantity` | INTEGER | — | Number of units for this item. |
| `unit_price` | FLOAT | — | Price of a single unit, in the event currency. |
| `email` | STRING | — | User email — normalized then hashed with SHA-256. |
| `phone_number` | STRING | — | User phone — normalized to E.164 then hashed with SHA-256. |
| `first_name` | STRING | — | User first name — hashed with SHA-256. |
| `last_name` | STRING | — | User last name — hashed with SHA-256. |
| `country_code` | STRING | — | ISO 3166-1 alpha-2 country code. Sent unhashed. |
| `postal_code` | STRING | — | Postal code. Sent unhashed. |
| `consent_ad_user_data` | STRING | — | DMA consent — Ad User Data. |
| `consent_ad_personalization` | STRING | — | DMA consent — Ad Personalization. |

### Custom event

Sends any event of your own. Unlike Purchase and Refund, you choose the **event name** yourself in the **Mapping** tab — either a GA4 recommended event (`sign_up`, `login`, `add_to_cart`, `begin_checkout`, `search`…) or a name of your own. GA4 reserved event names are rejected (`INVALID_EVENT_NAME`).

| Field | Type | Required | Description |
|---|---|---|---|
| `event_id` | STRING | ✅ | Unique identifier of the event (primary key). QUANTI: sends each Event ID **once**, see [Each custom event is sent once](#each-custom-event-is-sent-once). Also sent to GA4 as an event parameter, which helps when debugging in DebugView. |
| `event_timestamp` | TIMESTAMP | ✅ | UTC timestamp of the event (RFC3339). Must be less than **72 hours** old. |
| `client_id` | STRING | — | GA4 Client ID (`user_pseudo_id`). Each row needs `client_id` or `app_instance_id`. |
| `session_id` | STRING | — | GA4 session of the visit (`ga_session_id` in the GA4 BigQuery export), sent as the `session_id` event parameter. |
| `app_instance_id` | STRING | — | Firebase app instance identifier. Only for app data streams. |
| `user_id` | STRING | — | Your own user identifier, for User-ID measurement. |
| `gclid` | STRING | — | Google click identifier captured at conversion time. |
| `transaction_id` | STRING | — | Transaction identifier, when the event relates to an order. |
| `value` | FLOAT | — | Monetary value of the event, when it has one. |
| `currency` | STRING | — | ISO 4217 currency code. Required whenever a value is sent. |
| `email` | STRING | — | User email — normalized then hashed with SHA-256. |
| `phone_number` | STRING | — | User phone — normalized to E.164 then hashed with SHA-256. |
| `first_name` | STRING | — | User first name — hashed with SHA-256. |
| `last_name` | STRING | — | User last name — hashed with SHA-256. |
| `country_code` | STRING | — | ISO 3166-1 alpha-2 country code. Sent unhashed. |
| `postal_code` | STRING | — | Postal code. Sent unhashed. |
| `consent_ad_user_data` | STRING | — | DMA consent — Ad User Data. |
| `consent_ad_personalization` | STRING | — | DMA consent — Ad Personalization. |

### Custom parameters

On top of the template fields, you can add **parameters of your own** to any event type (margin, channel, customer type…): click **Add custom parameter** in the Mapping tab, name it, then pick its source column. Each one is sent to GA4 as a **text** event parameter, under the name you gave it.

* The name follows GA4 rules: it starts with a letter, holds only letters, digits and underscores, 40 characters at most. Names starting with `google_`, `ga_` or `firebase_` are reserved by GA4.
* A name already sent elsewhere by the template (`client_id`, `email`, `value`, `currency`…) is refused: use the template field instead.
* **No personal data.** A custom parameter is sent unhashed, and GA4 forbids personal data in event parameters. Names that point to one (`email`, `phone`, `first_name`, `address`…) are refused; emails, phones and names go through the template's hashed fields.
* Up to **15** custom parameters per push: GA4 keeps at most 25 parameters per event.

To see a custom parameter in your GA4 reports, register it as a **custom dimension** (or metric) in GA4 Admin.

{% hint style="info" %}
**Hashing is automatic.** QUANTI: normalizes and hashes `email`, `phone_number`, `first_name` and `last_name` with SHA-256 before any data leaves your warehouse. Map raw, readable values — do not pre-hash them.
{% endhint %}

***

## Each custom event is sent once

GA4 counts **every** event it receives: it does not recognise an event it already got, even with the same `event_id`. The **Custom event** push therefore runs in **Add only** mode: QUANTI: keeps a record of the Event IDs already sent, and each sync only sends the ones it has never sent.

* The [lookback window](#scheduling) still re-reads the last days, to catch events that reached your warehouse late, without sending anything twice. Running **Sync now** on the same days does not resend them either.
* A row that **changed** after being sent is not sent again: GA4 cannot update an event it already received. Exception: a row skipped earlier (no Client ID, for example) and fixed since is sent at the next sync.
* Give **each event its own Event ID**. Two different events sharing one Event ID: only the first reaches GA4.
* **Full resync** is not available on GA4 pushes: it would send every event of the window again, and GA4 would count them twice.

**Purchase** and **Refund** keep the **Insert** mode: one order can span several rows (one per item, or several partial refunds), and they all share its Transaction ID.

{% hint style="warning" %}
Schedule the push **after** the connectors that feed its source table. A sync that finds the source still empty leaves an empty record, and the next sync sends the whole window again.
{% endhint %}

***

## User identifier

GA4 attaches a server-side event to a device. Each row therefore needs a **`client_id`** (web) or an **`app_instance_id`** (app).

`user_id`, `gclid` and hashed user data **enrich** the event but do not replace the Client ID. A row with neither `client_id` nor `app_instance_id` is skipped and reported as `MISSING_USER_IDENTIFIER`.

***

## Basket items

`item_id`, `item_name`, `quantity` and `unit_price` describe **one item per row**. For a multi-item basket, either send one row per item, or leave these columns unmapped to send the transaction total only.

***

## Consent and DMA (European users)

Two optional fields carry the consent signal **per row**, on every event type:

| Field | Accepted values | Meaning |
|---|---|---|
| `consent_ad_user_data` | `granted` / `denied` (also `true` / `false`, `1` / `0`) | Consent to send this user's data to Google |
| `consent_ad_personalization` | same | Consent to use this data for ad personalization |

Map the consent column captured by your tag or CMP. Left unmapped, no consent signal is sent and EEA data may be unusable.

***

## Scheduling

| Setting | Default | Options |
|---|---|---|
| **Frequency** | Daily | — |
| **Sync time** | 3:00 AM | — |
| **Lookback window** | 2 days | 1, 2 days |

{% hint style="warning" %}
**No backfill.** GA4 refuses any event older than **72 hours**, which is why the lookback window stops at 2 days. Events that could not be sent within that window — for example after several failed runs in a row — cannot be sent later.
{% endhint %}

***

## Notes

* The connector sends events to the property's data stream, detected automatically at the start of each run. Web streams take precedence over app streams; a single app stream is also usable. A property exposing **several web data streams** is refused, rather than sending events to the wrong stream.
* The Data Manager API accepts or rejects a batch of events **as a whole**. This is why QUANTI: skips invalid rows (too old, no Client ID) before sending, instead of letting one row reject the others.
* Any field that is not a structured GA4 field is sent as an **event parameter**, as are [custom parameters](#custom-parameters).
* Server-side events show up in **GA4 → Reports → Realtime** within minutes, and in **DebugView**.

***

## Troubleshooting

<details>

<summary>Rows are skipped with EVENT_TIMESTAMP_TOO_OLD</summary>

The `event_timestamp` is more than 72 hours old at the time of the run. GA4 does not accept these events. Make sure the source table is refreshed before the connector runs, and that `event_timestamp` holds the actual event time in UTC.

</details>

<details>

<summary>Rows are skipped with MISSING_USER_IDENTIFIER</summary>

The row has neither `client_id` nor `app_instance_id`. A `user_id` or a `gclid` alone is not enough. Map the GA4 Client ID — `user_pseudo_id` in the native GA4 BigQuery export.

</details>

<details>

<summary>The run fails with PERMISSION_DENIED</summary>

The Google account used to authorize QUANTI: does not have **Editor** access to the GA4 property. Grant it Editor access on the property, then run the connector again. If the error persists, contact QUANTI: support.

</details>

<details>

<summary>A custom event is rejected with INVALID_EVENT_NAME</summary>

The event name entered in the Mapping tab is reserved by GA4. Pick another name.

</details>

<details>

<summary>An event appears several times in GA4</summary>

GA4 counts every event it receives. On a **Custom event** push, each Event ID is sent once: check that your source gives each event its own `event_id`, and that it is stable from one day to the next (an ID rebuilt at every refresh looks like a new event). On **Purchase**, GA4 relies on the `transaction_id` to recognise an order: map it.

</details>

<details>

<summary>Need help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>

### event_id — Event ID

Identifies each custom event: QUANTI: sends a given Event ID to GA4 only once, since GA4 counts every event it receives, even one it already got.

**Where to find it**

A column of your source that is unique per event and stable from one refresh to the next: an order ID, a lead ID, or a key built from them (order ID + event type). Avoid row numbers or IDs generated at each refresh of the view.

**Why it matters**

Expecting GA4 to drop events it already received: it does not, and before this push sent each Event ID once, the same events were counted two or three times in the reports. Today the risk is the other way round: an Event ID shared by two different events sends only the first, and an ID rebuilt at every refresh looks new each day and is sent again.
