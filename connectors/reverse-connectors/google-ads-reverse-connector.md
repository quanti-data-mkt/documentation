---
description: 'Follow our setup guide to push offline conversions and audiences to Google Ads with QUANTI:'
---

# Google Ads (Reverse)

{% hint style="info" %}
This connector uses **two Google APIs**: the **Data Manager API** (OCI, Enhanced Conversions for Leads, Customer Match) and the **Google Ads API v24** (Conversion Adjustments and account setup). Both are covered by a single OAuth authorization.
{% endhint %}

***

## Overview

The Google Ads Reverse connector pushes data **from your data warehouse into Google Ads**. It supports four push types:

* **OCI — Standard (revenue)** — upload offline click conversions with gross revenue to feed tROAS Smart Bidding
* **OCI — Margin-based Smart Bidding** — same as above but with margin instead of revenue, to optimize on profitability
* **Enhanced Conversions for Leads (ECL)** — close the B2B / lead-gen attribution loop by sending lead conversions enriched with hashed PII
* **Conversion Adjustments** — retroactively modify a conversion already uploaded (value restatement, full retraction, or PII enhancement)
* **Customer Match** — sync a user audience (CRM list) to Google Ads for targeting, exclusion, or as a seed for Performance Max

Multiple push types can be activated on a single connector. Each is configured independently in the **Mapping** tab after creation.

***

## Prerequisites

* A **Google account** with admin access to the target Google Ads account(s)
* A **Google Ads MCC** (Manager Account) — required for API access, even for a single account. The MCC must have API access enabled.
* For OCI and ECL: a **conversion action** configured in Google Ads with the correct type (`import from clicks` for OCI, `enhanced conversions for leads` for ECL)
* For ECL specifically: the **Enhanced Conversions for Leads** terms must be accepted in the Google Ads UI (Admin → Conversions → Settings)
* For Conversion Adjustments: the target account must be allowlisted for the Conversion Upload Service (grandfathered accounts only — new accounts use Data Manager)

***

## Setup Instructions

{% stepper %}
{% step %}
**Authorize your Google account**

Click **Continue with Google** and sign in with the Google account that has access to your MCC and customer accounts.

QUANTI: requests the following scopes: `adwords` (Google Ads API access) and `datamanager` (Data Manager API access for OCI, ECL, and Customer Match). Both scopes are required — if you previously connected your Google account without the `datamanager` scope, you must re-authorize.
{% endstep %}

{% step %}
**Select your MCC (login account)**

Select the **MCC (Manager Account)** to use for API calls. This is the account QUANTI: will authenticate as when calling the Google Ads API. It must have manager access to the customer accounts selected in the next step.

The MCC Customer ID is a 10-digit number visible in the Google Ads interface (top-right corner). Do not include hyphens.
{% endstep %}

{% step %}
**Select your customer accounts**

Select one or more **Google Ads customer accounts** (the leaf accounts where conversions and audiences will land). These are the accounts containing your conversion actions and user lists.

If you manage multiple brands or clients, you can target multiple accounts in a single connector — the `conversion_action` field in your source table determines which account each row goes to.
{% endstep %}

{% step %}
**Choose your push types**

Select the push templates to activate. Each template corresponds to a distinct push type:

* **OCI — Standard (revenue)** — offline click conversions with revenue value
* **OCI — Margin-based Smart Bidding** — offline click conversions with margin value
* **Enhanced Conversions for Leads** — lead conversions with hashed PII
* **Conversion Adjustments** — corrections to previously uploaded conversions
* **Customer Match** — audience synchronization from your CRM

You can activate multiple templates. Source table and field mapping for each are configured in the **Mapping** tab after creation.
{% endstep %}

{% step %}
**Name your connector**

Give the connector a unique name within your QUANTI: project, then click **Create**. Source queries and field mappings are configured in the **Mapping** tab.
{% endstep %}
{% endstepper %}

***

## Push Types

### OCI — Standard (revenue)

Uploads offline click conversions attributed to a Google Ads click. Use this template when your Smart Bidding strategy optimizes on **gross revenue** (tROAS on revenue).

The conversion must have been preceded by a Google Ads click — the GCLID is the join key between the click and the offline event.

**Fields:**

| Field | Type | Required | Description |
|---|---|---|---|
| `gclid` | STRING | ✅ | Google Click Identifier captured at the time of the click (typically stored in your CRM or landing page). Must be the GCLID from the original click that led to the conversion — not a later click. |
| `conversion_action` | STRING | ✅ | Full resource name of the Google Ads conversion action: `customers/{customer_id}/conversionActions/{conversion_action_id}`. Find it in Google Ads → Goals → Conversions → click the action → the ID is in the URL, or use the Google Ads API to list conversion actions. |
| `conversion_time` | TIMESTAMP | ✅ | UTC timestamp of the offline conversion event (order confirmed, payment received…). Format: RFC3339 (`2024-11-15T14:32:00Z`). Must be within the conversion action's attribution window (up to 90 days). |
| `conversion_value` | FLOAT | ✅ | Gross revenue of the conversion in the currency specified. Used directly by Smart Bidding to optimize tROAS. |
| `currency` | STRING | ✅ | ISO 4217 currency code (`EUR`, `USD`, `GBP`…). Must match the currency accepted by the conversion action. |
| `order_id` | STRING | ✅ | Unique order or transaction identifier. Used as the idempotence key — if the same `order_id` is uploaded twice, Google deduplicates. Also used to reference the conversion in Conversion Adjustments. |
| `consent_ad_user_data` | STRING | — | DMA consent signal for sending this user's data to Google. Map the consent column from your tag or CMP. Accepted values: `granted`, `denied` (also `true`/`false`, `1`/`0`). If left unmapped, no consent signal is sent — EEA conversions may be rejected or unutilized. |
| `consent_ad_personalization` | STRING | — | DMA consent signal for using this user's data for ad personalization. Same accepted values as `consent_ad_user_data`. Required for remarketing and Customer Match in the EEA. |

***

### OCI — Margin-based Smart Bidding

Identical to OCI Standard in structure, but the `conversion_value` field carries the **margin** rather than the gross revenue. Use this template to teach Smart Bidding to optimize on profitability rather than turnover.

**Fields:** identical to OCI Standard. The only semantic difference is in `conversion_value`:

| Field | Type | Required | Description |
|---|---|---|---|
| `gclid` | STRING | ✅ | Google Click Identifier captured at click time. |
| `conversion_action` | STRING | ✅ | Resource name of the conversion action (`customers/{customer_id}/conversionActions/{id}`). Should be a dedicated margin conversion action — do not mix with the revenue action. |
| `conversion_time` | TIMESTAMP | ✅ | UTC timestamp of the conversion event (RFC3339). |
| `conversion_value` | FLOAT | ✅ | **Margin** of the order (revenue minus cost of goods). This is the value Smart Bidding will optimize on — ensure it reflects the actual margin, not revenue. |
| `currency` | STRING | ✅ | ISO 4217 currency code. |
| `order_id` | STRING | ✅ | Unique order identifier. Used as idempotence key and reference for future Adjustments. |
| `consent_ad_user_data` | STRING | — | DMA consent — same values as OCI Standard. |
| `consent_ad_personalization` | STRING | — | DMA consent — same values as OCI Standard. |

{% hint style="info" %}
Google recommends using a **dedicated conversion action** for margin-based bidding, separate from your revenue action. This avoids polluting your revenue reporting with margin figures.
{% endhint %}

***

### Enhanced Conversions for Leads (ECL)

Sends lead conversion events enriched with **hashed PII** (email, phone, name, address) to Google Ads. ECL closes the B2B attribution loop: when a lead clicks a Google Ad, submits a form, and later converts in your CRM, ECL matches the CRM event back to the original click using the lead's identity — even without a GCLID.

QUANTI: automatically normalizes and hashes all PII fields with SHA-256 before sending:
- **Email**: lowercased, all whitespace removed, and for `gmail.com`/`googlemail.com` addresses the dots in the local part and any `+suffix` are stripped (Google normalization spec)
- **Phone**: normalized to E.164 format, then hashed
- **First/last name**: lowercased and trimmed — **accents are preserved** (Google's spec does not require removing them and removing them would reduce match rate on French or accented names)
- **Country code and postal code**: sent as-is, not hashed

**Fields:**

| Field | Type | Required | Description |
|---|---|---|---|
| `order_id` | STRING | ✅ | Internal lead identifier (form submission ID, CRM lead ID…). Used as idempotence key and reference for future Conversion Adjustments. |
| `conversion_action` | STRING | ✅ | Resource name of the **Enhanced Conversions for Leads** conversion action (`customers/{customer_id}/conversionActions/{id}`). The action must be of type ECL — a standard import action will not accept PII. |
| `conversion_time` | TIMESTAMP | ✅ | UTC timestamp of the lead event (form submission, MQL qualification, opportunity won…). RFC3339 format. |
| `gclid` | STRING | — | Google Click Identifier captured at form submission. Optional — Google can match the event using PII alone, but providing the GCLID significantly improves match rate when available. |
| `conversion_value` | FLOAT | — | Lead value — typically a predicted LTV, deal size, or stage-weighted opportunity value. |
| `currency` | STRING | — | ISO 4217 currency code. Required if `conversion_value` is provided. |
| `email` | STRING | — | Lead email address in its raw form — QUANTI: handles normalization and SHA-256 hashing before upload. Provide at least one of email or phone for matching. |
| `phone_number` | STRING | — | Lead phone number (any format accepted — QUANTI: normalizes to E.164 using France as default region). Hashed before upload. |
| `first_name` | STRING | — | Lead first name (raw — QUANTI: lowercases and hashes). |
| `last_name` | STRING | — | Lead last name (raw — QUANTI: lowercases and hashes). |
| `country_code` | STRING | — | ISO 3166-1 alpha-2 country code (`FR`, `US`…). Sent in clear — used for address-based matching. |
| `postal_code` | STRING | — | Postal code. Sent in clear — used for address-based matching. |
| `consent_ad_user_data` | STRING | — | DMA consent signal. Accepted values: `granted`, `denied` (also `true`/`false`, `1`/`0`). Required for EEA leads. |
| `consent_ad_personalization` | STRING | — | DMA consent signal for personalization. Same values. |

{% hint style="warning" %}
Before activating ECL, you must accept the **Enhanced Conversions for Leads** terms in the Google Ads UI: **Goals → Conversions → Settings → Enhanced conversions for leads → Turn on**. Without this, uploads will fail with `DESTINATION_ACCOUNT_ENHANCED_CONVERSIONS_TERMS_NOT_SIGNED`.
{% endhint %}

***

### Conversion Adjustments

Retroactively corrects a conversion already uploaded via OCI or ECL. Lookback window: **90 days**.

Three adjustment types are supported:

| Type | When to use |
|---|---|
| `RESTATEMENT` | Update the conversion value (margin revised, partial refund, order updated). Requires `adjusted_value`. |
| `RETRACTION` | Remove the conversion entirely (full refund, order cancelled). No value needed. |
| `ENHANCEMENT` | Add PII to a previously uploaded click conversion (ECL flow — not applicable to most use cases). |

{% hint style="info" %}
The legacy value `RESTATE_VALUE` is accepted as an alias for `RESTATEMENT` to avoid breaking existing source tables.
{% endhint %}

**Fields:**

| Field | Type | Required | Description |
|---|---|---|---|
| `order_id` | STRING | ✅ | Order identifier — must match exactly the `order_id` sent in the original OCI upload. Used by Google to look up the conversion to adjust. |
| `conversion_action` | STRING | ✅ | Resource name of the conversion action (`customers/{customer_id}/conversionActions/{id}`). Must match the one used in the original upload. |
| `adjustment_type` | STRING | ✅ | `RESTATEMENT`, `RETRACTION`, or `ENHANCEMENT`. `RESTATE_VALUE` is accepted as an alias for `RESTATEMENT`. |
| `adjustment_date_time` | TIMESTAMP | ✅ | UTC timestamp of the adjustment event (refund date, cancellation date…). Must be **after** the original conversion time and within 90 days. Format: RFC3339 (`2024-11-20T10:00:00Z`). |
| `adjusted_value` | FLOAT | — | New conversion value after adjustment. **Required for `RESTATEMENT`** — the row is rejected without it. Not used for `RETRACTION`. |
| `currency` | STRING | — | ISO 4217 currency code. Required for `RESTATEMENT` if the original conversion had a currency. |

{% hint style="warning" %}
Conversion Adjustments use the **Google Ads API** (not the Data Manager API). They are only available to accounts that were allowlisted for `ConversionUploadService` before June 15, 2026. New accounts cannot use Adjustments — contact QUANTI: support if you need this for a new account.
{% endhint %}

***

### Customer Match

Syncs a user audience from your data warehouse to a Google Ads **user list**. Use it for:
- Retargeting or exclusion lists (CRM customers, churned users, existing buyers)
- Lookalike / Performance Max seeds
- Observation audiences for Smart Bidding insights

QUANTI: automatically creates the user list in Google Ads (named `Quanti Reverse — {prebuild_id}`) and keeps it in sync. PII is hashed with SHA-256 before upload — provide at least one identifier (email or phone) per row for a usable match rate.

**Sync modes:**

| Mode | Behavior |
|---|---|
| `mirror` (default) | Full sync — members added in the source are added to the list; members removed from the source are removed from the list |
| `add_only` | Additive — new members are added, existing members are never removed |
| `remove_only` | Removal only — members present in the source are removed from the list |

**Fields:**

| Field | Type | Required | Description |
|---|---|---|---|
| `user_id` | STRING | ✅ | Internal user identifier — used as deduplication key when syncing the audience. Does not need to match any Google identifier. |
| `email` | STRING | — | Email address in raw form — QUANTI: normalizes (lowercase, whitespace removal, Gmail dot/plus stripping) then hashes with SHA-256. Provide at least email or phone for a useful match rate. |
| `phone_number` | STRING | — | Phone number (any format) — QUANTI: normalizes to E.164 (default region: FR) then hashes with SHA-256. |
| `first_name` | STRING | — | First name — QUANTI: lowercases, trims, keeps accents, then hashes with SHA-256. |
| `last_name` | STRING | — | Last name — QUANTI: lowercases, trims, keeps accents, then hashes with SHA-256. |
| `country_code` | STRING | — | ISO 3166-1 alpha-2 country code (`FR`, `US`…). Sent in clear — used for address-based matching alongside postal code. |
| `postal_code` | STRING | — | Postal code. Sent in clear — used for address-based matching. |
| `consent_ad_user_data` | STRING | — | DMA consent signal. Accepted values: `granted`, `denied` (also `true`/`false`, `1`/`0`). Required for EEA audiences — members without consent granted may be excluded by Google. |
| `consent_ad_personalization` | STRING | — | DMA consent signal for personalization. Same values. Required for remarketing in the EEA. |

{% hint style="info" %}
To maximize match rate, provide at least **email** combined with **first name**, **last name**, and **country code**. Match rate is typically 40–70% on B2C CRM lists and lower on B2B lists.

The minimum audience size to run a campaign is **1,000 matched members**.
{% endhint %}

***

## Consent & DMA (European users)

For users in the European Economic Area (EEA), Google requires a **consent signal** alongside each conversion event or audience member. QUANTI: carries this signal **per row** via two optional fields available on all push types (except Conversion Adjustments):

| Field | Accepted values | Meaning |
|---|---|---|
| `consent_ad_user_data` | `granted`, `true`, `1`, `yes` / `denied`, `false`, `0`, `no` | Consent to send this user's data to Google |
| `consent_ad_personalization` | same | Consent to use this data for personalized ads |

If a value is absent or unrecognized, the field is **omitted** from the payload — QUANTI: never infers consent.

The natural source for these columns is your **QUANTI: Tag Analytics** connector (`ad_user_data` / `ad_personalization` columns from Consent Mode v2), or your CMP export if you collect consent server-side.

***

## Scheduling

| Setting | Options |
|---|---|
| **Frequency** | Daily (default, at 3 AM) |
| **Lookback window** | 7 days (default) — rows from the past N days are re-processed on each run |

{% hint style="info" %}
The lookback window applies to **OCI, ECL, and Customer Match**. For **Conversion Adjustments**, the lookback covers adjustments whose `adjustment_date_time` falls within the window. Google's own lookback limit for adjustments is **90 days** from the original conversion.
{% endhint %}

***

## Troubleshooting

<details>

<summary>Authentication fails with "insufficient authentication scopes"</summary>

The Google account was previously connected without the `datamanager` scope (required for OCI, ECL, and Customer Match). You must re-authorize the connector: go to the connector **Settings** tab, disconnect, then reconnect with the same Google account — the new authorization dialog will include both scopes.

</details>

<details>

<summary>OCI / ECL rows are rejected with "CUSTOMER_NOT_ALLOWLISTED_FOR_THIS_FEATURE"</summary>

This error appears when the account was created after June 15, 2026 and is not yet provisioned on the Data Manager API. Contact QUANTI: support — the Data Manager API project must be activated for your OAuth client.

</details>

<details>

<summary>ECL fails with "DESTINATION_ACCOUNT_ENHANCED_CONVERSIONS_TERMS_NOT_SIGNED"</summary>

The Google Ads account has not accepted the Enhanced Conversions for Leads terms. In the Google Ads UI: **Goals → Conversions → Settings → Enhanced conversions for leads → Turn on**. This is a one-time per-account step that cannot be done via API.

</details>

<details>

<summary>Conversion value appears in Google Ads but Smart Bidding is not reacting</summary>

Verify that: (1) the conversion action is set to **Include in conversions** in Google Ads, (2) the action type matches your bidding strategy (revenue vs. margin), (3) there is enough volume — Smart Bidding needs at least 30–50 conversions per month to learn. Offline conversions may take 24–48 hours to appear in reporting.

</details>

<details>

<summary>Customer Match list is created but match rate is 0% or very low</summary>

Common causes: (1) the audience has fewer than 1,000 rows — Google requires a minimum for privacy reasons; (2) only one PII field is mapped — combine email with name and country for better results; (3) gmail.com emails are not being matched because the normalization rule (dot removal) was not applied — QUANTI: handles this automatically, but verify the source data is not pre-hashed.

</details>

<details>

<summary>Conversion Adjustment rejected with "CONVERSION_NOT_FOUND"</summary>

The `order_id` in the adjustment row does not match any previously uploaded conversion. Verify that: (1) the `order_id` is identical to the one sent in the original OCI upload (exact string match, case-sensitive); (2) the original conversion was uploaded successfully (check the connector run logs); (3) the `conversion_action` resource name matches the original.

</details>

<details>

<summary>Need help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>

### destination_name — Naming the destination

For a Customer Match push, this is the exact name of the Google Ads user list QUANTI: creates on the first sync — one list per push. For conversion pushes (OCI, Enhanced Conversions for Leads, Adjustments), it is only a label inside QUANTI:.

**Where to find it**

You choose it. Type it before the first sync: that is when the list is created under this name. Once created, QUANTI: follows the list by its ID, so rename it directly in Google Ads (Tools → Audience manager) if needed — the sync keeps working. Changing the name here afterwards only renames the push in QUANTI:, not the list in Google Ads.

**Why it matters**

Reusing the name of a list that already exists in the Google Ads account — one you created by hand, or the one of another push. QUANTI: then adopts that list and writes into it: two audiences end up mixed in a single list, and with the mirror sync mode each push removes the other's members. Pick a name that is not used anywhere in the account.

### ad_accounts — Which customer account to select

The Google Ads customer account (not the manager account) where conversions are recorded and Customer Match lists are created.

**Where to find it**

The list shows the customer accounts managed by the MCC chosen in the previous step. The 10-digit ID is displayed at the top right of Google Ads when you are inside the account.

**Why it matters**

Selecting several accounts in one connector. Only the first selected account receives data: every conversion and every audience goes there, and a conversion action belonging to another account is rejected by Google. Create one connector per customer account.

### conversion_action — Conversion action

Tells Google Ads which conversion action each row is recorded against. It is read per row, so a single push can feed several conversion actions of the same account.

**Where to find it**

In Google Ads: Goals → Conversions → Summary → click the action; its numeric ID is in the page URL (ctId=…). Put either that ID or the full resource name customers/{customer_id}/conversionActions/{id} in your source column.

**Why it matters**

Putting the action's display name (e.g. "Offline purchase") instead of its ID: every row is rejected. Second trap: the customer ID written in the resource name is ignored — rows always go to the connector's customer account, so a conversion action belonging to another account is rejected too.

### consent_ad_user_data — Consent — Ad User Data

The EEA (DMA) consent signal allowing Google to receive this user's data, sent row by row with each conversion or audience member.

**Where to find it**

The ad_user_data column of the QUANTI: Tag Analytics connector (Consent Mode v2), or the matching column of your CMP export if you collect consent server-side.

**Why it matters**

Mapping a column whose values are not recognized. Only granted / true / 1 / yes and denied / false / 0 / no are understood; anything else ("accepted", "oui", "opt-in"…) is silently dropped and the row leaves with no consent signal, exactly as if the field were unmapped — EEA data may then be unusable by Google. Check your values before mapping.

### consent_ad_personalization — Consent — Ad Personalization

The EEA (DMA) consent signal allowing Google to use this user's data for personalized ads — required for Customer Match and remarketing in the EEA.

**Where to find it**

The ad_personalization column of the QUANTI: Tag Analytics connector (Consent Mode v2), or your CMP export. If your CMP collects a single consent covering both purposes, the same column can feed both consent fields.

**Why it matters**

Leaving it unmapped on an EEA Customer Match audience because Ad User Data is already mapped. The two signals are independent: without this one, no personalization consent is sent — QUANTI: never infers it — and Google may not use those members for targeting. Same value rules as Ad User Data: only granted / true / 1 / yes and denied / false / 0 / no are understood, anything else is silently dropped.

### email — Email

The main identifier Google uses to match a user (Customer Match) or a lead (Enhanced Conversions for Leads). QUANTI: normalizes it — lowercase, spaces removed, and for gmail.com / googlemail.com the dots and +suffix of the local part stripped — then hashes it with SHA-256 before upload.

**Where to find it**

Your CRM or customer table, in its raw, readable form.

**Why it matters**

Mapping a column that is already SHA-256 hashed while leaving Auto-hash on: QUANTI: hashes the hash, Google recognizes nobody, and the match rate falls to zero without any error. Map raw emails — or turn Auto-hash off for this field if your source only has hashes, knowing the Gmail normalization will then not be applied.

### adjustment_type — Adjustment type

What to do with a conversion already uploaded: RESTATEMENT changes its value, RETRACTION removes it, ENHANCEMENT adds user data to it.

**Where to find it**

A column of your source computed from the business event: partial refund or revised margin → RESTATEMENT, full refund or cancellation → RETRACTION. The legacy value RESTATE_VALUE is accepted as an alias of RESTATEMENT.

**Why it matters**

Sending RESTATEMENT without mapping Adjusted value: the row is rejected, since a restatement without a new value would do nothing. A full refund is a RETRACTION, not a RESTATEMENT to 0.

### scopes — Permissions requested from Google

QUANTI: asks for two scopes: adwords (Google Ads API — account setup, Customer Match lists, Conversion Adjustments) and datamanager (Data Manager API — offline conversions, Enhanced Conversions for Leads, Customer Match members). Both are required.

**Where to find it**

Sign in with a Google account that has access to the manager account (MCC) and to the customer accounts you will push to.

**Why it matters**

Reusing a Google authorization granted before the datamanager scope existed: pushes fail with "insufficient authentication scopes". Disconnect and reconnect the same Google account so the consent screen includes both scopes.
