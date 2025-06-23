---
description: 'Follow this setup guide to connect your email attachments to QUANTI:'
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

# Email

***

## <mark style="background-color:blue;">Prerequisites</mark>

1. Use a `.csv` file only.
2. Make sure the delimiter is a semicolon (`;`).
3. Include a header row with column names in the first line of the file.

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
2. Settings :&#x20;
   1. Choose a local .csv file that exactly matches the structure of the incoming files. This file will be used by the connector to automatically generate the right schema and properly ingest the data into your data warehouse.
   2. For each column in the test file, select a data type that specifically matches the data contained in that column.

At the end of the connector setup, you will be provided with an email address to which you can send your emails with attachments.

***

## <mark style="background-color:blue;">Sync method</mark>

The insertion method used is `INSERT` mode, meaning we only insert data from the attached files without modifying any data already present in the table.
