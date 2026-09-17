---
description: 'Follow our setup guide to connect Hubspot to QUANTI:'
---

# Hubspot

<a href="https://dbdiagram.io/e/67aa29e6263d6cf9a0a7bd09/67aa2dd5263d6cf9a0a82d44" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

Before connecting HubSpot to QUANTI, ensure you have:

* **HubSpot Account Access**: You need access to a [HubSpot](https://app.hubspot.com/login) account with appropriate permissions
* **Super Admin or Marketing/Sales Hub Access**: Sufficient permissions to authorize third-party applications and access CRM data
* **Active CRM Data**: At least some contacts, deals, or other CRM objects in your HubSpot account
* **Marketing Hub** (Optional): Required for accessing forms and form submission data

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize HubSpot Connection

* Click on **Connect to HubSpot**
* You will be redirected to HubSpot's authorization page
* Log in with your HubSpot account credentials
* Review and accept the requested permissions to allow QUANTI to access your HubSpot data
* Select the HubSpot account you want to connect (if you have multiple accounts)
* Click **Grant access** to authorize
{% endstep %}

{% step %}
#### Configure Connector

* **Connector Name**: Enter a unique name for this connector (e.g., "HubSpot CRM - Production")
* **Dataset ID**: Define the BigQuery dataset ID where data will be stored (will be created automatically if it doesn't exist)
{% endstep %}

{% step %}
#### Select Prebuilt reports

* Review the available Prebuilt reports (see section below for details)
* Select the tables you want to synchronize:
  * **Core CRM**: Deals, Contacts, Leads (essential)
  * **Associations**: Deal-Contact, Lead-Contact relationships (recommended for relationship analysis)
  * **Pipeline**: Deal Pipeline stages (recommended for sales funnel analysis)
  * **Marketing**: Forms and Form Submissions (if using HubSpot Marketing Hub)
* Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and lookback window
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete, then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

{% hint style="warning" %}
**Dynamic Schema Notice**: Some tables (Deals, Contacts, Leads) have dynamic schemas that depend on the native and custom properties configured in your HubSpot account. The actual fields in these tables will vary based on your HubSpot configuration. All standard HubSpot properties are included, plus any custom properties you've created.
{% endhint %}

### CRM Objects (Core Entities)

These tables contain your primary CRM data and have dynamic schemas that adapt to your HubSpot property configuration.

* **Deals**: Complete deal records from your HubSpot CRM including all deal properties (both standard and custom). Standard properties include deal name, amount, close date, deal stage, pipeline, deal owner, create date, last modified date, and deal source. Custom properties you've created (e.g., custom fields for your business process, integration data, calculated fields) are automatically included. Essential for sales pipeline analysis, revenue forecasting, and win/loss analysis. The schema adapts to your HubSpot configuration, so new properties are automatically synced.
* **Contacts**: Complete contact records with all contact properties including standard fields (email, first name, last name, company, phone, lifecycle stage, lead status, original source, create date, last activity date) and any custom properties you've defined (custom demographics, qualification scores, engagement metrics, integration data). Critical for marketing analysis, lead scoring, segmentation, and customer journey tracking. Enables analysis of contact behavior, conversion paths, and engagement patterns.
* **Leads**: Lead records from your HubSpot account with all lead properties. In HubSpot, leads can represent different stages or types of prospects depending on your sales process configuration. Includes standard lead properties and custom fields specific to lead qualification and routing. Used for lead generation analysis, qualification funnel tracking, and lead source attribution.
* **Forms**: Marketing and non-marketing forms configuration and metadata. Contains form details including form GUID (unique identifier), form name, form type (embedded, standalone, popup), created date, last updated date, redirect URL, submission notification settings, field configurations, styling settings, thank you message, and form performance metrics. Essential for understanding form structure, tracking form changes over time, and analyzing which forms drive conversions. Links to Form Submissions table for complete submission analysis.

### Association Tables (Relationships)

These tables map relationships between different CRM objects, enabling multi-object analysis and relationship tracking.

* **Deal Contact Associations**: Links deals to associated contacts, establishing the many-to-many relationship between these entities. Contains deal ID and contact ID pairs with association timestamps. Essential for understanding who is involved in each deal, analyzing contact influence on deal outcomes, and building relationship networks. Enables analysis like "which contacts are associated with closed-won deals" or "average number of contacts per deal by deal size."
* **Lead Contact Associations**: Maps the relationship between leads and contacts in your HubSpot CRM. Contains lead ID and contact ID pairs. Useful for tracking lead-to-contact conversion paths, understanding relationship hierarchies, and analyzing how leads are qualified and converted into active contacts. Supports lead nurturing analysis and conversion funnel optimization.

### Pipeline & Stages

These tables provide sales pipeline structure and stage tracking for deal progression analysis.

* **Deal Pipeline**: Sales pipeline configuration and current stage information for deals. Contains deal ID, pipeline ID, stage ID, stage label, stage display order, probability (win likelihood percentage for the stage), closed-won flag, and stage timestamps. Essential for sales funnel analysis, conversion rate calculation by stage, deal velocity tracking, and pipeline health monitoring. Enables analysis of stage progression patterns, bottleneck identification, and forecast accuracy by pipeline stage.

### Transaction Tables (Events & Activities)

These tables capture time-stamped events and user activities within HubSpot.

* **Form Submissions**: Form submission events with captured field values and page context. Contains form GUID (links to Forms table), conversion ID (unique submission identifier), submission timestamp, page URL where form was submitted, page title, submitted field values (as JSON), contact ID (if known), and source information. Critical for form performance analysis, conversion path tracking, lead source attribution, and understanding what content drives form fills. Enables calculation of form conversion rates, submission trends over time, and analysis of which pages generate the most form submissions.

***

<a href="https://dbdiagram.io/e/67aa29e6263d6cf9a0a7bd09/67aa2dd5263d6cf9a0a82d44" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your HubSpot account has proper permissions (Super Admin recommended)
* Check that the account is active and not suspended
* Ensure you're authorizing with the correct HubSpot account if you have multiple
* Try disconnecting and reconnecting the HubSpot authorization
* Verify that API access is enabled in your HubSpot account settings

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>

### hubId — Which HubSpot portal this connector reads

Identifies the HubSpot portal (Hub ID) whose CRM data this connector synchronizes; the same value is written to the adAccount column of every synced row.

**Where to find it**

In HubSpot, the top-right account menu shows the Hub ID under your account name, and it appears in every app URL (app.hubspot.com/contacts/<hubId>). QUANTI: reads it automatically from the token returned at authorization — you never type it.

**Why it matters**

Authorizing while your browser is logged into another portal — a sandbox, a partner or agency portal, or a second brand. The consent screen binds the connector to that portal silently: the sync succeeds, the tables fill, and the mismatch only surfaces later as unknown record IDs and a foreign Hub ID in the adAccount column. Log into the intended portal in HubSpot before clicking Continue with HubSpot; switching portal afterwards means creating a new connector, not editing this one.

### scopes — Permissions requested at authorization

The set of HubSpot scopes QUANTI: requests — read access to contacts, deals, leads, companies and their schemas, plus forms and business-intelligence.

**Where to find it**

Listed on the HubSpot consent screen when you click Continue with HubSpot, and afterwards in HubSpot under Settings → Integrations → Connected Apps → QUANTI:.

**Why it matters**

Letting a user without Marketing Hub access grant the consent: the forms scope is not granted, and the Forms and Form Submissions reports fail with a 403 at every run while the CRM tables keep filling normally. The connector looks healthy and those two tables stay empty. Grant access with a Super Admin whose account covers every hub you intend to read.

### formSubmissions — Form Submissions depends on Forms

Syncs form submission events — conversion ID, submission timestamp, page URL and submitted field values — for each form in your portal.

**Where to find it**

Selected in the report list at the Prebuilt reports step; in HubSpot, the same data sits under Marketing → Forms, in the submissions tab of each form.

**Why it matters**

Enabling Form Submissions without enabling Forms. Submissions are fetched form by form, from the form GUIDs the Forms report collects during the same run: with Forms disabled there is no GUID list, the run still ends in success, and the form_submissions table stays empty. Keep both enabled — disabling Forms later has the same effect.

### lookback — What the lookback window actually filters

Sets how many days back each scheduled sync re-reads, so records updated after they were first synced are picked up again.

**Where to find it**

Last setup step, next to the sync frequency; editable afterwards in the connector's scheduling settings.

**Why it matters**

Reading it as a window on the close date or the create date. The filter is on hs_lastmodifieddate: a deal created last year and edited yesterday comes back in today's sync, while a deal closed yesterday and untouched since does not. Related limit: HubSpot's search API returns at most 10,000 records per window — the connector bisects the window down to one minute, so a bulk workflow or CSV import that touches more than 10,000 records within the same minute leaves the excess unretrieved.
