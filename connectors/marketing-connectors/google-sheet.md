---
description: 'Follow our setup guide to connect Google Sheet to QUANTI:'
layout:
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: false
---

# Google Sheet

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect a Google Sheet to Quanti:, you need to access a [Google Drive](https://drive.google.com/drive/u/0/home) account and have edit access to the Google Sheet you want to use.

#### Named Range

Open your Google Sheet and select the range that you want added to your destination. You can change your selected range later if needed.

To select a range, you can do either of the following:

* manually select the range as shown below, or
* select just the columns (for example, `Sheet1!A:D`). If you select just the columns, Fivetran only creates rows for up to the final row that has values in your sheet (for example, `Sheet1!A1:D6`).

![Select a range](https://fivetran.com/static-assets-docs/_next/static/media/select-a-range.e983f919.png)

You can have as many named ranges as you would like in a single Google Sheet workbook. The first row of the named range will become the column headers in the destination table in your destination.

#### Create named range <a href="#createnamedrange" id="createnamedrange"></a>

1.  In your Google Sheet, go to **Data** > **Named ranges**.

    ![Go to Data > Named ranges...](https://fivetran.com/static-assets-docs/_next/static/media/go-to-data-named-ranges.5fe334ad.png)
2.  In the **Named ranges** menu, enter a name for your new range and click **Done**.

    ![Name the range](https://fivetran.com/static-assets-docs/_next/static/media/name-the-range.0cf5b7ba.png)

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Google account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Settings :&#x20;
   1. Copy and paste the sharing URL of the Google Sheet and click Test URL.
   2. Select the named range you want to sync.

***

## <mark style="background-color:blue;">Sync method</mark>

The insertion method used is INSERT mode, meaning the entire content of the table is overwritten and replaced, whether or not the data has changed.

***

## <mark style="background-color:blue;">Schema mapping</mark>

The schema is directly mapped from the named range in your Google Sheet. It is derived from the first row of the named range.

During each synchronization with Google Sheets, this first row is used as the reference. If new columns—previously absent from the schema—appear in the first row, the connector will update the destination table’s schema to include them.

Conversely, if columns that were part of the original schema are no longer present in the named range, they will remain in the destination table but be left empty.

We also apply light standardization to column names:

Spaces are replaced with underscores

Uppercase letters are converted to lowercase

In short, we convert all fields to camelCase to ensure consistent and compatible naming.

***

## <mark style="background-color:blue;">Field Typing</mark>

Field types are automatically inferred based on the values present in each column of the Google Sheet.

The supported types are:

* Date: if the column contains only dates in the YYYY/MM/DD format
* Float: if the column contains only numeric values (integers or decimals)
* String: for all other types of values

For compatibility purposes, all numeric fields are automatically converted to `FLOAT`.
