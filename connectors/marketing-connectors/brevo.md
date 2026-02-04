---
description: 'Follow our setup guide to connect Brevo to QUANTI:'
---

# Brevo

<a href="https://dbdiagram.io/e/694c1666b8f7d8688612560d/694c1685b8f7d86886125905" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Brevo to QUANTI, ensure you have:

* **Brevo Account**: An active Brevo (formerly Sendinblue) account
* **API Access**: Access to the API Keys section in your Brevo account settings
* **Email Campaigns**: At least some email campaigns created to retrieve insights
* **Proper Permissions**: Email Campaigns and Contacts read permissions

***

## Setup Instructions

{% stepper %}
{% step %}
#### Create API Key

* Log in to your Brevo account at https://app.brevo.com/
* Navigate to **Settings** → **API Keys**
* Click on **Create a new API key**
* Give your key a descriptive name (e.g., "QUANTI Integration")
* Copy the API key immediately (it will only be shown once)
* Store it securely
{% endstep %}

{% step %}
#### Configure Authentication

* Return to QUANTI
* Click on **Connect to Brevo**
* Enter your API key in the authentication field
* Click **Validate** to test the connection
* QUANTI will verify your credentials and permissions
{% endstep %}

{% step %}
#### **Connector Information**

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created
  * The dataset will be created automatically if it doesn't exist
* Click **Next**


{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* Select the tables you want to synchronize:
  * **Campaigns**: Campaign dimensions and configuration
  * **Campaign Stats**: Global campaign metrics
  * **Campaign Lists Stats**: Campaign metrics by contact list
  * **Contact Lists**: Lists metadata
  * **Contacts**: Individual contacts and attributes
* Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and a lookback window
* Click **Save**
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete
* Navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built Tables

* **Campaigns**: Email campaign dimensions including configuration, sender details, A/B testing setup, and UTM parameters
* **Campaign Stats**: Global aggregated performance metrics for campaigns (all lists combined)
* **Campaign Lists Stats**: Campaign performance metrics decomposed by recipient list with detailed list-level analysis
* **Contact Lists**: Metadata about contact lists including names, folder organization, and list type
* **Contacts**: Individual contacts with email addresses, subscription status, list memberships, and custom attributes

***

<a href="https://dbdiagram.io/e/694c1666b8f7d8688612560d/694c1685b8f7d86886125905" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Data Refresh**: Brevo data can be synced multiple times per day. Configure your sync frequency based on your campaign sending schedule
* **Rate Limits**: Brevo enforces a rate limit of 600 requests per 10 minutes. QUANTI automatically manages these limits to ensure reliable data extraction
* **Historical Data**: All historical campaign data is accessible via the API. Use the historical data recovery feature for initial backload
* **Incremental Sync**: The Contacts table supports incremental synchronization using the `modifiedSince` parameter to fetch only updated contacts
* **A/B Testing**: Campaign dimensions include complete A/B testing configuration (subjects, split rule, winner criteria)
* **Custom Attributes**: Contact attributes vary by account configuration and are stored as JSON for flexibility
* **Deferred Emails**: The `deferred` metric is only available in Campaign Lists Stats, not in Campaign Stats
* **List Relationships**: Contact list memberships are stored within the Contacts table as JSON arrays, making separate junction tables unnecessary
* **Deprecated Fields**: Some API fields (totalBlacklisted, totalSubscribers, uniqueSubscribers) are deprecated by Brevo and not collected

***

## Troubleshooting

<details>

<summary>Authentication Issues</summary>

* Verify that your API key is correct and hasn't been revoked
* Ensure your API key has the required permissions (Email Campaigns and Contacts read access)
* Check that your Brevo account is active and not suspended
* Generate a new API key if the current one doesn't work

</details>

<details>

<summary>Missing Campaign Data</summary>

* Only sent campaigns appear in the statistics tables
* Draft, archived, or deleted campaigns may not have complete metrics
* Ensure campaigns were sent after your configured lookback window
* Check campaign status in the Campaigns dimension table

</details>

<details>

<summary>Rate Limit Errors</summary>

* QUANTI automatically handles rate limiting with exponential backoff
* If you encounter persistent rate limit issues, consider:
  * Reducing the number of pre-built tables selected
  * Increasing the sync interval
  * Contacting Brevo support to verify your account's rate limits

</details>

<details>

<summary>Missing Contacts</summary>

* Verify that contacts exist in your Brevo account
* Check if contacts are in lists that were included in your sync configuration
* For incremental syncs, only modified contacts are retrieved
* Blacklisted contacts are included but marked with appropriate flags

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
