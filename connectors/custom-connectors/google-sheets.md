---
description: 'Follow our setup guide to connect Google Sheet to QUANTI:'
---

# Google Sheets

## Prerequisites

To connect a Google Sheet to QUANTI, you need to:

* Access a [Google Drive](https://drive.google.com/drive/u/0/home) account
* Have edit access to the Google Sheet you want to use
* Create a named range in your Google Sheet (see instructions below)

#### Named Range

Open your Google Sheet, then go to **Data** > **Named ranges** and create a named range.

**Steps to create a named range:**

{% stepper %}
{% step %}
1. Select the range you want to sync, **including the header row**
{% endstep %}

{% step %}
2. Go to **Data** > **Named ranges**
{% endstep %}

{% step %}
3. Give it a name of your choice
{% endstep %}

{% step %}
4. Ensure the selected range includes:

* The header row with a name for each column
* All data rows you want to sync
{% endstep %}

{% step %}
5. Click **Done**
{% endstep %}
{% endstepper %}

***

## Setup Instructions

{% stepper %}
{% step %}
#### **Authorize Google Connection**

* Click on **Connect to Google Sheets**
* You will be redirected to Google's authorization page
* Log in with your Google account credentials
* Review and accept the requested permissions
* Click **Allow** to grant QUANTI access to your Google Sheets

Click **Next**
{% endstep %}

{% step %}
#### **Connector Information**

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.

Click **Next**
{% endstep %}

{% step %}
#### **Select Google Sheet and Range**

* **Browse**: Use the Google Picker to select your Google Sheet from your Google Drive.
* **Named Range**: Select the named range you want to sync
  * The named range must be created beforehand in your Google Sheet
  * The first row of the range will be used as column headers

Click **Next**
{% endstep %}

{% step %}
#### **Sync Behavior**

Choose the data insertion method that fits your use case:

* **Table Type**: Select your table type:
  * **Fact table**: A table containing metrics and date-based data (e.g., sales, events, transactions)
  * **Dimension table**: A table composed exclusively of descriptive attributes (e.g., products, customers, categories)
* **Sync Method**: Choose your insertion method: [Learn more](https://docs.quanti.io/data-management/data-insertion-strategies).
  * [**INSERT**](https://docs.quanti.io/data-management/data-insertion-strategies/insert-mode): Add new rows without checking for duplicates (recommended for time-series data)
  * [**REPLACE**](https://docs.quanti.io/data-management/data-insertion-strategies/replace-mode-delete-and-insert): Delete rows within the table scope and reload new rows
  * [**UPSERT**](https://docs.quanti.io/data-management/data-insertion-strategies/upsert-mode-update-and-insert): Update existing rows or insert new ones based on primary key (requires unique identifier) - No rows deleted

{% hint style="info" %}
If you have difficulties determining the most accurate configuration for your case, [discover our guide](https://docs.quanti.io/data-management/data-insertion-strategies/insertion-method-selection-guide).
{% endhint %}

Click **Next**
{% endstep %}

{% step %}
#### **Mapping Configuration**

**Table Configuration**

* **Destination table name**: Define your BigQuery table name (lowercase, underscores only)

**Field Mapping**

For each column detected in your sample file:

* **Destination field name**: Define the column name in BigQuery (lowercase, underscores recommended)
* **Data type**: Choose the appropriate type:
  * `STRING` - Text values, alphanumeric data
  * `INTEGER` - Whole numbers (e.g., 42, -10, 0)
  * `FLOAT` - Decimal numbers (e.g., 3.14, -0.5)
  * `BOOLEAN` - True/False values
  * `DATE` - Date only (format: YYYY-MM-DD)
  * `TIMESTAMP` - Date and time with timezone
  * `DATETIME` - Date and time without timezone

**Date Column** (mandatory for Fact tables)

* Select the date field for table partitioning
* This field is **mandatory** for all methods when **Fact table** was selected in Step 2
* Used for optimizing query performance and data organization
* Must be a valid date/timestamp field in your data

**Historize Changes**

* **Required** if UPSERT was selected in Step 2 (Sync Behavior)
* **Optional** for INSERT and REPLACE methods
* **Selected fields**: Values are historized (previous versions are kept)
* **Deselected fields**: Values are updated without keeping history

Click **Next**
{% endstep %}

{% step %}
**Finish Setup**

* Save your sync settings
* You can now active the auto-sync or launch a sync now.
{% endstep %}
{% endstepper %}

***

## Notes

* **Named Range**: Must be created in your Google Sheet before setup
* **Permissions**: Ensure your Google account maintains access to the spreadsheet

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify your Google account has access to the spreadsheet
* Check that OAuth permissions haven't been revoked
* Re-authenticate if the connection has expired
* Ensure the spreadsheet hasn't been deleted or moved

</details>

<details>

<summary>Named Range Not Found</summary>

* Verify the named range exists in your Google Sheet
* Ensure the named range includes the header row

</details>

<details>

<summary>Data Type Errors</summary>

* Check date format is YYYY/MM/DD in your Google Sheet
* Verify numeric columns contain only numbers (no text)
* Mixed data types in a column must to be STRING

</details>
