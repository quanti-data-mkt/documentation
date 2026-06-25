---
description: 'Follow our setup guide to connect Brevo to QUANTI:'
---

# Brevo

<a href="https://dbdiagram.io/e/694c1666b8f7d8688612560d/694c1685b8f7d86886125905" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

To connect Brevo to QUANTI, you need:

* An active [Brevo](https://app.brevo.com) account
* At least one email campaign created

***

## Setup instructions

{% stepper %}
{% step %}
#### Generate an API key

* In Brevo, go to **Settings** > **SMTP & API** > **API Keys & MCP**
* Click **Generate API Key**
* Enter a distinctive name (e.g. "QUANTI Integration") and select **No expiration**
* Click **Generate**
* Copy the value shown in the **API key** field — this is the only time it will be displayed

{% hint style="warning" %}
Do not enable the **Create MCP server API key** toggle. QUANTI requires a standard API key, not an MCP key.
{% endhint %}
{% endstep %}

{% step %}
#### Connect to QUANTI

* In QUANTI, click **Connect to Brevo**
* Paste your API key in the authentication field
* Click **Validate** to confirm the connection
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}

{% step %}
#### Select prebuilt reports

Review the available prebuilt reports and select the ones you want to activate.
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

* **campaigns**: Email campaign dimensions — configuration, sender details, A/B testing setup, and UTM parameters.
* **campaign\_stats**: Global aggregated performance metrics per campaign (all lists combined).
* **campaign\_lists\_stats**: Campaign performance broken down by recipient list.
* **contact\_lists**: Metadata about contact lists — names, folder organization, and list type.
* **contacts**: Individual contacts with email addresses, subscription status, list memberships, and custom attributes.

***

<a href="https://dbdiagram.io/e/694c1666b8f7d8688612560d/694c1685b8f7d86886125905" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Notes

* **Rate limits**: Brevo enforces a limit of 600 requests per 10 minutes. QUANTI manages this automatically.
* **Incremental sync**: The `contacts` table uses incremental sync — only contacts modified since the last sync are fetched.
* **A/B testing**: Campaign dimensions include full A/B test configuration (subjects, split rule, winner criteria).
* **Custom attributes**: Contact attributes vary by account and are stored as JSON.
* **`deferred` metric**: Only available in `campaign_lists_stats`, not in `campaign_stats`.
* **Deprecated fields**: `totalBlacklisted`, `totalSubscribers`, and `uniqueSubscribers` are deprecated by Brevo and not collected.
* **Historical data coverage**: `campaign_stats` uses the Brevo list campaigns API, which only returns statistics for events that occurred in the **last 6 months**. Campaigns older than 6 months will have `NULL` or `0` values for all performance metrics (views, clicks, unsubscribes, etc.) in this table. For complete historical coverage, use `campaign_lists_stats`, which fetches stats per campaign individually via a dedicated endpoint and is not subject to this limitation.
* **`clickers` vs `clicks`**: The Brevo API exposes `clickers` (number of unique individuals who clicked at least once) and `unique_clicks` (total unique click count). There is no field named `clicks` in the API response — if you observe a `clicks` column returning `NULL` in your warehouse, it is an unmapped field. Refer to `clickers` or `unique_clicks` depending on the metric you need.
* **Deduplication**: If you use `campaign_stats` or `campaign_lists_stats` in a dashboard or aggregated model, filter on the most recent `_quanti_process_id` to avoid counting duplicate rows from multiple syncs on the same day.
