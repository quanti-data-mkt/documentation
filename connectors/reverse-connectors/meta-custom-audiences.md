---
description: 'Follow our setup guide to push Custom Audiences from QUANTI: to Meta (Facebook & Instagram Ads)'
---

# Meta Custom Audiences

{% hint style="info" %}
**Reverse connector** — this connector pushes data **from** your data warehouse **to** Meta. It creates or updates Custom Audiences in your Meta Ads account for retargeting, exclusion, or as seeds for Lookalike Audiences.

To send server-side conversion events (Conversions API / CAPI), use the **Meta Pixel (Reverse)** connector instead.
{% endhint %}

***

## Prerequisites

* A **Meta Business Manager** account with access to at least one ad account
* The ad account must have the `ads_management` permission
* The audience data must be available in a table or view in your QUANTI: data warehouse — typically via a **Semantic View** or a source connector
* At least one of `email` or `phone` must be present in the source table for Meta to match users

***

## Authentication

Authentication uses **Facebook OAuth2**. During setup you will be redirected to Meta to authorize QUANTI:.

Requested permissions: `ads_management`, `ads_read`, `business_management`, `leads_retrieval`.

***

## Setup Instructions

{% stepper %}
{% step %}
**Authorize your Meta account**

Click **Continue with Facebook** and grant QUANTI: access to your Meta Business account.
{% endstep %}

{% step %}
**Select Ad Account(s)**

Enter one or more **Ad Account IDs** where Custom Audiences will be created. The expected format is `act_XXXXXXXXXX` — visible in Meta Business Manager or in your ad account URL.

You can connect multiple ad accounts from a single connector.
{% endstep %}

{% step %}
**Select push type**

Select the **Custom Audience** template. This determines the sync mode and the fields that will be pushed to Meta.
{% endstep %}

{% step %}
**Name your connector**

Give the connector a unique name, then click **Create**. The source table and field mapping are configured in the **Mapping** tab after creation.
{% endstep %}
{% endstepper %}

***

## Sync Modes

Three sync modes are available, selected per push template:

| Mode | Behavior |
|---|---|
| `mirror` | Full sync — users added in the source are added to the audience; users removed from the source are removed from the audience *(default)* |
| `add_only` | Additive only — new users are added, no removals performed |
| `remove_only` | Removal only — users present in the source are removed from the audience |

***

## Field Mapping

After connector creation, configure the field mapping in the **Mapping** tab by linking your source table columns to the following destination fields.

| Field | Required | Description |
|---|---|---|
| `user_id` | **Yes** | Internal user identifier — used as the deduplication key to detect additions and removals across syncs. Not sent to Meta. |
| `email` | No | User email address. QUANTI: normalizes it (lowercase, whitespace removed) then hashes it with **SHA-256** before upload. |
| `phone` | No | User phone number. QUANTI: normalizes it to **E.164** format (e.g. `+33612345678`, defaulting to the FR region), then hashes it with **SHA-256** before upload. |

{% hint style="warning" %}
**At least one of `email` or `phone` must be mapped** for Meta to match users. Providing both maximizes the match rate.

`user_id` is mandatory in all cases as the internal deduplication key — it is never sent to Meta.
{% endhint %}

{% hint style="info" %}
**Hashing is automatic.** QUANTI: applies SHA-256 normalization and hashing before any data leaves your warehouse. You do not need to pre-hash your data.
{% endhint %}

***

## Scheduling

| Setting | Default |
|---|---|
| **Frequency** | Daily |
| **Sync time** | 3:00 AM |
| **Lookback window** | 7 days |

***

## Notes

* Custom Audiences created by QUANTI: are visible in **Meta Ads Manager → Audiences**
* The minimum audience size to activate a campaign is **100 matched members** (Meta requirement)
* **Lookalike Audiences** can be created manually in Meta Ads Manager from any existing Custom Audience
* Meta enforces its own privacy and data policies — ensure you have obtained appropriate consent from your users before pushing their data
* `mirror` mode computes the diff between two syncs using `user_id` — make sure this field is stable and unique in your source table

***

## Troubleshooting

<details>

<summary>The audience size in Meta Ads Manager is lower than expected</summary>

Meta only counts users it was able to match against its own graph. The match rate depends on the quality and coverage of the PII provided. To improve it: provide both email and phone when available, and make sure phone numbers are in a clean format (QUANTI: will normalize them to E.164).

</details>

<details>

<summary>Users are not being removed in `mirror` mode</summary>

`mirror` mode detects removals by comparing the current sync against the previous one using `user_id`. If `user_id` values change between runs (e.g. because the source query is not deterministic), removals may not be detected correctly. Ensure `user_id` is a stable, unique identifier across runs.

</details>

<details>

<summary>Need help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>
