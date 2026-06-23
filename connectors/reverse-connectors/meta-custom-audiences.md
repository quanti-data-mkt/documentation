# Meta Custom Audiences

The **Meta Custom Audiences** connector is a reverse connector: it pushes audience segments from your data warehouse to Meta (Facebook & Instagram Ads) as Custom Audiences. Use it to activate retargeting, exclusion, or Lookalike Audiences directly from your first-party data.

{% hint style="info" %}
This connector handles **Custom Audiences** (CRM matching) only. To send server-side conversion events (Conversions API / CAPI), use the **Meta Pixel (Reverse)** connector.
{% endhint %}

***

## Prerequisites

* A **Meta Business Manager** account with access to at least one ad account
* The ad account must have the `ads_management` permission
* The data to push must be available in a table in your QUANTI: data warehouse (typically via a **Semantic View** or a source connector)
* PII fields (email, phone, etc.) must be present in the source table — they will be automatically hashed in SHA-256 before being sent

***

## Authentication

The connection is made via **Facebook OAuth2**. During setup, you will be redirected to Meta to authorize QUANTI: to manage your Custom Audiences.

Requested permissions: `ads_management`, `ads_read`, `business_management`, `leads_retrieval`.

***

## Setup

{% stepper %}
{% step %}
### Connect to Meta

Click **Continue with Facebook** and authorize QUANTI: on your Meta Business account.
{% endstep %}

{% step %}
### Select ad account(s)

Enter one or more **Ad Account IDs** in the format `act_XXXXXXXXXX` (visible in Business Manager or in your ad account URL).
{% endstep %}

{% step %}
### Choose push type

Select the **Custom Audience** template and choose the sync mode that fits your use case.
{% endstep %}

{% step %}
### Field mapping

From the **Mapping** tab, map the columns of your source table to the fields expected by Meta. Name your connector and create it.
{% endstep %}
{% endstepper %}

***

## Sync modes

| Mode | Behavior |
|------|----------|
| `mirror` | Full sync — members added in the source are added to the audience; members removed from the source are removed from the audience |
| `add_only` | Additive only — new members are added, no removals are performed |
| `remove_only` | Removal only — members present in the source are removed from the audience |

***

## Available matching fields

Meta accepts the following identifiers for matching. QUANTI: automatically applies **SHA-256** hashing before sending for all PII fields.

| QUANTI: field | Meta type | Expected format |
|---|---|---|
| `email` | `EMAIL` | Lowercase email address |
| `phone` | `PHONE` | E.164 format (e.g. `+33612345678`) |
| `first_name` | `FN` | Lowercase, no accents |
| `last_name` | `LN` | Lowercase, no accents |
| `date_of_birth` | `DOBY` / `DOBM` / `DOBD` | Year, month, day as separate fields |
| `gender` | `GEN` | `m` or `f` |
| `city` | `CT` | Lowercase, no spaces |
| `state` | `ST` | 2-letter state/region code |
| `zip` | `ZIP` | Postal code without spaces |
| `country` | `COUNTRY` | ISO 3166-1 alpha-2 code (e.g. `fr`) |

{% hint style="warning" %}
To maximize match rate, provide at least **email** or **phone**, ideally combined with first and last name.
{% endhint %}

***

## Notes

* Custom Audiences created by QUANTI: are visible in **Meta Ads Manager > Audiences**
* The minimum audience size to run a campaign is **100 matched members**
* Meta enforces its own privacy policies — make sure you have obtained appropriate consent from your users before pushing their data
* Lookalike Audiences can be created manually in Meta Ads Manager from an existing Custom Audience
