---
description: 'Follow our setup guide to connect Amazon DSP to QUANTI:'
---

# Amazon DSP

{% hint style="warning" %}
This connector is currently in **beta**.
{% endhint %}

<a href="https://dbdiagram.io/e/69cd3ad0fb2db18e3b5a76bf/69cd3b0578c6c4bc7abfda08" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Prerequisites

To connect Amazon DSP to QUANTI, you need access to an [Amazon Advertising](https://advertising.amazon.com) account with at least one active DSP profile.

***

## Setup instructions

{% stepper %}
{% step %}
#### Authorize your Amazon account

* Click **Continue with Amazon**
* You will be redirected to Amazon's authorization page
* Log in with your Amazon Advertising credentials
* Review and accept the requested permissions
* Click **Allow** to grant access
{% endstep %}

{% step %}
#### Select DSP Profiles

Choose the Amazon DSP profiles you want to sync.
{% endstep %}

{% step %}
#### Select pre-built reports

Review the available pre-built tables and select the ones you want to activate.
{% endstep %}

{% step %}
#### Connector information

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}
{% endstepper %}

***

## Pre-built reports

**Dimension tables** — entity snapshots, updated at each sync:

* **advertiser\_history**: Advertiser entity data including name, currency, country, and timezone.
* **campaign\_history**: Campaign entities with budget settings, optimization goals, flight dates, delivery status, and targeting configuration.
* **ad\_group\_history**: Ad group entities with bid settings, budget caps, targeting parameters, scheduling, and delivery status.
* **creative\_history**: Creative assets with type, dimensions, click-through URLs, moderation status, and tracking tags.

**Fact table** — daily performance data:

* **campaign\_stats**: Campaign performance broken down by date, advertiser, order, and creative. Includes impressions, clicks, cost, purchases, sales, ROAS, video completion metrics, reach, and viewability.

***

<a href="https://dbdiagram.io/e/69cd3ad0fb2db18e3b5a76bf/69cd3b0578c6c4bc7abfda08" class="button primary" data-icon="table-tree">Prebuilt reports and definition</a>

***

## Notes

* **Historical data limit**: The Amazon DSP API provides a maximum of **90 days** of history.
* **Lookback window**: Default lookback is **5 days** to account for Amazon's attribution processing delays.
* **Beta status**: This connector is in beta — some features or report fields may evolve.
