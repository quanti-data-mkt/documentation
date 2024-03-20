---
title: Adobe Analytics Reverse connector
lead: ''
date: 2020-11-16T12:59:39.000Z
lastmod: 2020-11-16T12:59:39.000Z
draft: false
images: []
menu:
  docs:
    parent: prologue
weight: 110
toc: true
description: Follow our setup guide to interger the reverse-connector Adobe Analytics
---

# Adobe Analytics Reverse connector

_Last update : 2024-02-16_

Please refer to our setup guide to integrate the Adobe Analytic reverse-connector.

***

### Prerequisites

To establish a connection between the QUANTI platform and the Adobe Analytics reverse connector, it is essential to possess an Adobe Experience Cloud account. This account will provide the necessary permissions to access and interact with the Adobe Analytics product.

***

### Setup Instructions

#### Create Your Credentials

1. Access the [Adobe Developer Console](https://developer.adobe.com/console/home) using your Adobe Experience Cloud credentials.
2. Navigate to the Console tab, specifically the APIs and services section, and review the available services.
3. Locate the Adobe Analytics service and proceed to create a new project.\
   ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe1.png>)

* Select OAuth server-to-server.
* Assign a unique name to your project (For example: Quanti Reverse Connector API) and move to the next step.\
  ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe2.png>)
* Select your organization's name and click on "Save configured API".

4. Then on the new project page, you will see your API Key (Client ID). Note the API key. You will need it to configure QUANTI:\
   ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe3.png>)
5. Click on OAuth Server-to-Server < 'Retrieve Client Secret'. Note the Client Secret. You will need it to configure QUANTI:\
   ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe4.png>)

#### Declare your classification

1. Enter Adobe Analytics UI and go to your Adobe Analytics product.
2. Click on the tab Admin > Report Suite > Select your Report Suite > Edit Settings > Conversion > Conversion Classification.
3. Select Classification Type "Campaign" and add your classification field names.\
   ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe6.png>)
4. Note the classification field names. You will need them to configure QUANTI:

#### Declare your custom metrics

1. Click on the tab Admin > Report Suite > Select your Report Suite > Edit Settings > Conversion > Success Events.
2. Select events of your choice and add your custom metrics names.\
   ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe7.png>)
3. Write down events and meanings. You will need them to configure QUANTI:

#### Quanti: Data Warehouse configuration

These steps show how to configure data recovery:

1. In the connector setup form, select your data warehouse.
2. Click Next.

#### 2 connectors types to set

You will have to set 2 connectors type : Data source Adobe Reverse Connector and Classification Adobe Reverse Connector. They don’t use the same API point and don’t import the same data type. Therefore, we formally present you with the subject, separating it into two distinct connectors

* Data source Adobe Reverse Connector is used to import metrics.
* Classification Adobe Reverse Connector is used to import dimensions. In Data Warehousing language, we can talk about "Fact table" for data source importing and "Dimensions table" for classification importing. It is very important to understand this point for the rest because Adobe Analytics will match your two imports using the primary keys concept.\
  ![](<../content/en/docs/prologue/Adobe Analytics Reverse/adobe8.png>)

#### Create your Data Source Query

These steps show how to create a SQL query which permits to import data into Adobe Analytics UI. The selected fields in your query must coincide with custom metrics that you created above. You can import all custom metrics you want, but you have to respect two mandatory fields: Date and tracking\_code.

* Date field: Make a coincidence between a field with a date data type from your query and the date field expected by the connector.
* Tracking\_code field: Make a coincidence between a string data type field from your query and the tracking\_code expected by the connector. Tracking\_code + date are the unique keys of your query which permit afterwards to match your data source with classification dimensions that we will configure together later in this tutorial. Data type expected :
* date (DATE - YYYY-mm-dd)
* tracking\_code (STRING - Matching with your Classification)
* event1 (FLOAT)
* event2 (FLOAT)
* event3 (FLOAT) All custom events must be of FLOAT type.

#### Quanti: Data Source Connnector Configuration

These steps show how to extract data from your table:

1. Build a new SQL request from your table following the last step and give aliases to your queried fields. Your query must only compose of fields expected by Adobe Analytics.
2. In the connector setup form, copy/paste your query.
3. Click Next.
4. Make correspondence between query fields and fields expected by Adobe Analytics.

* Tracking\_code field and date field are expected by Adobe Analytics: You have to indicate which fields are used for them in your query.
* You also have to fill each text input using custom metric names created earlier in your Adobe Analytics UI.

5. Click View details.

#### Create Your Classification Query

These steps show how to create a SQL query which permits to import dimensions in Adobe Analytics UI. The selected fields in your query must coincide with classification names that you created above. You have to respect one mandatory field: tracking\_code. Make a coincidence between a string data type field from your query and the tracking\_code expected by the connector. Tracking\_code must be the unique key of your query and permit afterwards to match your classification dimensions with your data source.

#### Quanti: Classification Connnector Configuration

These steps show how to extract a classification table from your Data Warehouse:

1. Build a new SQL request from your table following the last step and give aliases to your queried fields. Your query must only compose of fields expected by Adobe Analytics.
2. In the connector setup form, copy/paste your query.
3. Click Next.
4. Make correspondence between query fields and fields expected by Adobe Analytics.

* Tracking\_code field is expected by Adobe Analytics: You have to indicate which field is used for it in your query.
* You also have to fill each text input using classification names created earlier in Adobe Analytics UI in step 2 above.

5. Click View details.
