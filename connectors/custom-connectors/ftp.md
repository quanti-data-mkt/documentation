# (S)FTP

## Prerequisites

Before setting up the (S)FTP connector, ensure you have:

* **FTP or SFTP server access**: Valid credentials to connect to your server
* **CSV files**: Supported file format for data ingestion
* **Header row**: Your files must include column names in the first row
* **Clean data structure**: Consistent data types across rows for each column

## Setup Instructions

{% stepper %}
{% step %}
**Authorize your (S)FTP Account**

Add your credentials to let QUANTI download your data:

* **Protocol**: Choose between FTP or SFTP
* **File Type**: Select CSV (all files will be processed as the selected file type)
* **Server Host Address**: Your server hostname or IP address (e.g., sftp.yourhostname.com)
* **Server Port**: Server port (default: 21 for FTP, 22 for SFTP)
* **Server Username**: Your FTP/SFTP username
* **Server Password**: Your FTP/SFTP password
* **Folder Path**: Provide the folder path for file retrieval (e.g., quanti/csv). Leave blank to use the root directory.
* **File Pattern** (optional): Regular expression to filter files (e.g., `^*\.csv$`). If left empty, all files in the folder path will be synchronized.

Click **Next**
{% endstep %}

{% step %}
**Connector Information**

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created
  * The dataset will be created automatically if it doesn't exist

Click **Next**
{% endstep %}

{% step %}
**Sync Behavior**

Choose the data insertion method that fits your use case:

{% stepper %}
{% step %}
### Table Type

Select your table type:

* **Fact table**: A table containing metrics and date-based data (e.g., sales, events, transactions)
* **Dimension table**: A table composed exclusively of descriptive attributes (e.g., products, customers, categories)
{% endstep %}

{% step %}
### Sync Method

Choose your insertion method: [Learn more](/broken/pages/98a3c505f3adcd58f037b12ac3c210d6ccf47a22).

* [**INSERT**](/broken/pages/edb1d99b179d83ec12c96c92bbd27ff39d8d4a26): Add new rows without checking for duplicates (recommended for time-series data)
* [**REPLACE**](/broken/pages/acae44baca6b724928963f1a92670818eabc69b4): Delete rows within the table scope and reload new rows
* [**UPSERT**](/broken/pages/73d5a1fe2980d1ec035b1becc9f9675ba6d3268e): Update existing rows or insert new ones based on primary key (requires unique identifier) - No rows deleted
{% endstep %}
{% endstepper %}

{% hint style="info" %}
If you have difficulties determining the most accurate configuration for your case, [discover our guide](/broken/pages/b42505faf73508973903be3bb34709373a294434).
{% endhint %}

Click **Next**
{% endstep %}

{% step %}
**Mapping Configuration**

**Upload Sample File**

* Select a sample CSV file that matches the structure of your incoming files
* **Delimiter detection**: The connector automatically proposes a delimiter based on your file (comma, semicolon, tab, pipe, etc.)
* **Important**: The uploaded file is used **only for mapping configuration** - no data is inserted at this stage

**Table Configuration**

* **Destination table name**: Define your BigQuery table name (lowercase, underscores only)
* **Delimiter**: Automatically proposed based on your uploaded file, but it is recommended to verify the selection

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
{% endstepper %}

## Notes

* **File format**: Supports CSV only
* **Folder Path**: Provide the folder path for file retrieval. Leave blank to use the root directory
* **File Pattern**: Optional regular expression to filter files. If left empty, all files in the folder path will be synchronized
* **Delimiter detection**: Automatic proposal based on your uploaded file, but it is recommended to verify the selection
* **Processing time**: Files are processed according to your sync schedule
* **Multiple files**: All CSV files matching the pattern in the configured path are processed
* **Connection security**: SFTP is recommended for encrypted data transfer

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify your server hostname or IP address is correct
* Check that the port is accessible (not blocked by firewall)
* Ensure your username and password are valid
* Verify the path exists on the server
* For SFTP, check that SSH keys are properly configured (if applicable)

</details>

<details>

<summary>Files not syncing</summary>

* Verify CSV files are present in the configured path
* Check file permissions allow read access
* Ensure files have the correct structure (header row, consistent columns)
* Check the delimiter is correctly detected
* Verify the sync schedule is active

</details>

<details>

<summary>Data type errors</summary>

* Review your mapping configuration - data types must match actual data
* Check for non-numeric values in INTEGER/FLOAT columns
* Verify date formats match your DATE/TIMESTAMP columns
* Look for special characters or encoding issues

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at support@quanti.io or consult our comprehensive documentation at https://docs.quanti.io

</details>
