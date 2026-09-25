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

You can connect multiple ad accounts from a single connector: the full audience is pushed to each of them, as a separate audience per account. Select them all before the first sync — an account added later only receives users added from then on.
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

* Custom Audiences created by QUANTI: are visible in **Meta Ads Manager → Audiences**, named exactly after the push's **Destination name** (set in the **Mapping** tab) — one audience per selected ad account. Choose a name not already used in the ad account: an existing audience with that exact name is adopted and written into
* Once created, an audience is followed by its ID: you can rename it in Meta Ads Manager without breaking the sync
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

### destination_name — Naming the Custom Audience

The exact name of the Custom Audience QUANTI: creates in Meta on the first sync. With several ad accounts, one audience is created in each account, all under this name. Names longer than 60 characters are truncated (Meta limit).

**Where to find it**

You choose it. Type it before the first sync: that is when the audience is created under this name. Once created, QUANTI: follows the audience by its ID, so rename it directly in Meta Ads Manager → Audiences if needed — the sync keeps working. Changing the name here afterwards only renames the push in QUANTI:, not the audience in Meta.

**Why it matters**

Reusing the name of an audience that already exists in the ad account — one you created by hand, or the one of another push. QUANTI: then adopts that audience and writes into it: two audiences end up mixed, and with the mirror sync mode each push removes the other's members. Pick a name that is not used anywhere in the ad account.

### ad_accounts — Which ad accounts to select

The Meta ad accounts that receive the audience. Meta does not share Custom Audiences between ad accounts, so QUANTI: pushes the full audience to each selected account, as a separate audience in each.

**Where to find it**

Meta Business Manager → Business settings → Ad accounts, or the act= parameter in the Ads Manager URL. The format is act_XXXXXXXXXX.

**Why it matters**

Adding an ad account to a push that has already synced. Each run only sends the users added or removed since the previous one, so the new account never receives the existing audience: its audience gets only the users added from then on, and on runs with no new user its sync reports an error. Select every ad account before the first sync, or create a new push for the additional account.

### email — Email

The main identifier Meta uses to match a user. QUANTI: normalizes it (lowercase, spaces removed) then hashes it with SHA-256 before upload. Unlike Google, Meta expects Gmail addresses as they are: dots and +suffix are kept.

**Where to find it**

Your CRM or customer table, in its raw, readable form.

**Why it matters**

Mapping a column that is already SHA-256 hashed while leaving Auto-hash on: QUANTI: hashes the hash, Meta recognizes nobody, and the audience stays empty without any error. Map raw emails — or turn Auto-hash off for this field if your source only has hashes.

### phone — Phone

A second identifier that raises the match rate. QUANTI: normalizes it to international E.164 format (+33612345678) then hashes it with SHA-256. A number without a country code is read as a French number.

**Where to find it**

Your CRM or customer table. Prefer the international format (+CC…) whenever your base has non-French numbers.

**Why it matters**

Mapping a phone column with values that cannot be read as a valid number — foreign numbers without their +country code, placeholders like "0000000000", free text. The WHOLE row is then dropped, email included, not just the phone. The run reports these rows as transform failures. Clean the column, or leave the field unmapped if your email coverage is good.
