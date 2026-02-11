---
description: 'Follow our setup guide to connect Hubspot to QUANTI:'
---

# Hubspot

<a href="https://dbdiagram.io/e/67aa29e6263d6cf9a0a7bd09/67aa2dd5263d6cf9a0a82d44" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

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
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
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

## Pre-built Tables

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

<a href="https://dbdiagram.io/e/67aa29e6263d6cf9a0a7bd09/67aa2dd5263d6cf9a0a82d44" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

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
