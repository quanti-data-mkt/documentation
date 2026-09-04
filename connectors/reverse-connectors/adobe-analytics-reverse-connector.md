---
description: Setup guide for the Adobe Analytics reverse connector (Classification & Data Source) — legacy article
---

# Adobe Analytics (Reverse) — ancien article

{% hint style="warning" %}
Adobe Analytics takes some time to process the data imports we send, but unfortunately, it does not communicate how long this processing takes.
It's important to understand that imported data is not immediately available in the interface.

We recommend syncing your Adobe Analytics connector no more than once per day, to give Adobe sufficient time to process the data properly.
{% endhint %}

***

## Prerequisites

To establish a connection between the QUANTI platform and the Adobe Analytics reverse connector, it is essential to possess an Adobe Experience Cloud account. This account will provide the necessary permissions to access and interact with the Adobe Analytics product.

***

## Setup Instructions

### Create Your Credentials

1. Access the [Adobe Developer Console](https://developer.adobe.com/console/home) using your Adobe Experience Cloud credentials.
2. Navigate to the Console tab, specifically the APIs and services section, and review the available services.
3. Locate the Adobe Analytics service and proceed to create a new project.

* Select OAuth server-to-server.
* Assign a unique name to your project (For example: Quanti Reverse Connector API) and move to the next step.
* Select your organization's name and click on "Save configured API".

4. Then on the new project page, you will see your API Key (Client ID). Note the API key. You will need it to configure QUANTI:
5. Click on OAuth Server-to-Server < 'Retrieve Client Secret'. Note the Client Secret. You will need it to configure QUANTI:

### Declare your classification

1. Enter Adobe Analytics UI and go to your Adobe Analytics product.
2. Click on the tab Admin > Report Suite > Select your Report Suite > Edit Settings > Conversion > Conversion Classification.
3. Select Classification Type "Campaign" and add your classification field names.
4. Note the classification field names. You will need them to configure QUANTI:

### Declare your custom metrics

1. Click on the tab Admin > Report Suite > Select your Report Suite > Edit Settings > Conversion > Success Events.
2. Select events of your choice and add your custom metrics names.
3. Write down events and meanings. You will need them to configure QUANTI:

### Create your data source

1. Click on the tab Admin > Data sources > Select your Report Suite in the top-right corner > Create
2. On the page for creating a new data source, choose: Ad Campaigns, then: Generic Pay-Per-Click Service. Click Next.
3. A pop-up will open and ask you to name your data source and provide an email address where notifications will be sent each time data is uploaded.
4. Check the box to give your consent, then click on "Next".
5. Check the metrics you wish to import and fill in the fields with any additional metrics you wish to import, then click on "Next".
6. In the selection fields, for each metric listed, select the events you created previously in the "Declare your custom metrics" step. Then click "Next".
7. Check the box labeled "Tracking codes" and click on "Next".
8. In the selection field for Tracking codes, select "Tracking Code".
9. Then click "Next", "Save" and "Close".

### 2 connector types to set

You will have to set 2 connector types: Adobe Analytics - Data Sources Connector and Adobe Analytics - Classifications Connector. They don't use the same API point and don't import the same data type.

* **Adobe Analytics - Data Sources Connector** is used to import metrics (Fact table).
* **Adobe Analytics - Classifications Connector** is used to import dimensions (Dimension table).

Adobe Analytics will match your two imports using the primary keys concept.

### Create your Data Source Query

These steps show how to create a SQL query which permits to import data into Adobe Analytics UI. The selected fields in your query must coincide with custom metrics that you created above. You can import all custom metrics you want, but you have to respect two mandatory fields: Date and tracking\_code.

* **Date field**: Make a coincidence between a field with a date data type from your query and the date field expected by the connector.
* **Tracking Code field**: Make a coincidence between a string data type field from your query and the tracking\_code expected by the connector.

Data type expected:

* Date (DATE - YYYY-mm-dd)
* Tracking Code (STRING - Matching with your Classification)
* Event 1 (FLOAT)
* Event 2 (FLOAT)
* Event 3 (FLOAT)

All custom events must be of FLOAT type. Date, Tracking Code & Events are written with space and upper case as in the example above.

### Quanti: Data Source Connector Configuration

1. Build a new SQL request from your table following the last step and give aliases to your queried fields.
2. In the connector setup form, copy/paste your query.
3. Click Next.
4. Make correspondence between query fields and fields expected by Adobe Analytics.
5. Click View details.

### Create Your Classification Query

These steps show how to create a SQL query which permits to import dimensions in Adobe Analytics UI. The selected fields in your query must coincide with classification names that you created above. You have to respect one mandatory field: tracking\_code. Tracking\_code must be the unique key of your query.

### Quanti: Classification Connector Configuration

1. Build a new SQL request from your table following the last step and give aliases to your queried fields.
2. In the connector setup form, copy/paste your query.
3. Click Next.
4. Make correspondence between query fields and fields expected by Adobe Analytics.
5. Click View details.

***

## Use Case

I want to know the expenses made on my advertising platforms for each of my traffic sources to my site. Therefore, I will need to identify the traffic sent to my site and match it with the metrics imported from the data source to have a clear dispatch of my campaign performances between my sources and campaigns.

To align the metrics you import from external sources into Adobe Analytics (such as impressions, clicks, or spend from your advertising platforms) with internal Adobe Analytics metrics (for example: visits, conversions, or revenue), it is crucial to match them.

{% hint style="warning" %}
Adobe Analytics takes some time to process the data imports we send, but unfortunately, it does not communicate how long this processing takes.
It's important to understand that imported data is not immediately available in the interface.

We recommend syncing your Adobe Analytics connector no more than once per day, to give Adobe sufficient time to process the data properly.
{% endhint %}
