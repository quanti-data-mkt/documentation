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

* The header row with a **unique, non-empty** name for each column
* All data rows you want to sync

{% hint style="warning" %}
**Empty headers are not supported.** If several columns have an empty header, they are read as the same column and only one of them is kept. Give every column a name, or exclude unused columns from the named range.
{% endhint %}
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
  * Each **Destination field name** must be **unique**. Two fields mapped to the same name will make the sync fail.
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

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| Columns missing or values in the wrong column | Several columns have an empty header | Name every column in the header row, or shrink the named range to exclude empty columns |
| Setup or sync fails at the mapping step | The same destination field name is used twice | Rename the fields so every destination name is unique |

### mapping_source — Source columns come from your header row

Each Source entry is a column header read from the first row of the named range you selected; its values are imported under that column.

**Where to find it**

In your Google Sheet, the first row of the named range (Data > Named ranges shows which cells it covers). To change a Source name, edit the header cell in the sheet, then detect the columns again.

**Why it matters**

Leaving several columns with an empty header. They are all read as the same column, so only one of them is kept and the others are silently lost. Give every column a unique, non-empty header, or shrink the named range so it excludes unused columns.
