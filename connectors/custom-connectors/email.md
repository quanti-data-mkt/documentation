---
description: 'Follow this setup guide to connect your email attachments to QUANTI:'
---

# Email

## Prerequisites

Before setting up the Email connector, ensure you have:

* **CSV**: Supported file formats for data ingestion
* **Header row**: Your file must include column names in the first row
* **Clean data structure**: Consistent data types across rows for each column

## Setup Instructions

{% stepper %}
{% step %}
#### Connector Information

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created
  * The dataset will be created automatically if it doesn't exist

Click **Next**
{% endstep %}

{% step %}
#### Sync Behavior

Choose the data insertion method that fits your use case:

1. **Table Type**: Select your table type:
   * **Fact table**: A table containing metrics and date-based data (e.g., sales, events, transactions)
   * **Dimension table**: A table composed exclusively of descriptive attributes (e.g., products, customers, categories)
2. **Sync Method**: Choose your insertion method: [Learn more](../../data-management/data-insertion-strategies/).
   * [**INSERT**](../../data-management/data-insertion-strategies/insert-mode.md): Add new rows without checking for duplicates (recommended for time-series data)
   * [**REPLACE**](../../data-management/data-insertion-strategies/replace-mode-delete-and-insert.md): Delete rows within the table scope and reload new rows
   * [**UPSERT**](../../data-management/data-insertion-strategies/upsert-mode-update-and-insert.md): Update existing rows or insert new ones based on primary key (requires unique identifier) - No rows deleted

{% hint style="info" %}
If you have difficulties determining the most accurate configuration for your case, [discover our guide](../../data-management/data-insertion-strategies/insertion-method-selection-guide.md).
{% endhint %}

Click **Next**
{% endstep %}

{% step %}
#### Mapping Configuration

**Upload Sample File**

* **Select a sample CSV** that matches the structure of your incoming files
* **Delimiter flexibility**: The connector automatically detects delimiters (comma, semicolon, tab, pipe, etc.)
* **Important**: The uploaded file is used **only for mapping configuration** - no data is inserted at this stage

**Table Configuration**

* **Destination table name**: Define your BigQuery table name (lowercase, underscores only)
* **Date column** (required): Select the date field for table partitioning
  * This field is **mandatory** for all methods.
  * Used for optimizing query performance and data organization
  * Must be a valid date/timestamp field in your data

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

**Historize Changes**

* **Required** if UPSERT was selected in Step 2 (Sync Behavior)
* **Optional** for INSERT and REPLACE methods
* **Selected fields**: Values are historized (previous versions are kept)
* **Deselected fields**: Values are updated without keeping history

Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

**Retrieve your dedicated email address:**

* Navigate to the **Overview** tab in the connector details page
* Copy the unique email address provided by QUANTI
* Send your CSV files as attachments to this address
{% endstep %}
{% endstepper %}

### Notes

* **File format**: Supports CSV only
* **Delimiter detection**: Automatic detection of comma, semicolon, tab, pipe, and other common delimiters, but it is recommended to verify
* **Processing time**: Files are processed within minutes of receipt
* **Email address**: Found in the **Overview** tab of your connector details page
* **Multiple files**: You can send multiple files in the same email - each will be processed independently

## Troubleshooting

<details>

<summary>Email not processing</summary>

* Verify you're sending to the correct email address (check **Overview** tab)
* Ensure file is attached (not embedded in email body)
* Check file format is CSV
* Check the delimiter is correct
* Check that a header row is present in the CSV file

</details>
