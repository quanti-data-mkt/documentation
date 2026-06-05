---
description: 'Follow our setup guide to connect Kwanko to QUANTI:'
---

# Kwanko

<a href="https://dbdiagram.io/e/689b4f0c1d75ee360a4021c3/689b50301d75ee360a40615a" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

To connect Kwanko to QUANTI, you need an active [Kwanko](https://advertiser.kwanko.com/#/dashboard) advertiser account.

***

## Setup instructions

{% stepper %}
{% step %}
#### Find your API token

* Log in to your [Kwanko account](https://advertiser.kwanko.com/#/dashboard)
* In the top-right corner, click **Tools** then **API**
* Copy the API token displayed on this screen
{% endstep %}

{% step %}
#### Connect to QUANTI

* In QUANTI, click **Connect to Kwanko**
* Paste your API token in the authentication field
* Click **Validate** to confirm the connection
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}

{% step %}
#### Select prebuilt reports

Review the available prebuilt reports and select the ones you want to activate.
{% endstep %}
{% endstepper %}

***

## Prebuilt reports

* **campaign\_stats**: Overall performance metrics per campaign — impressions, clicks, leads, sales, downloads, bonus activities, and associated spend.
* **transactions**: Individual transaction and conversion records — campaign details, device type, tracking source, website information, achievement status, and spend values.

***

<a href="https://dbdiagram.io/e/689b4f0c1d75ee360a4021c3/689b50301d75ee360a40615a" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>
