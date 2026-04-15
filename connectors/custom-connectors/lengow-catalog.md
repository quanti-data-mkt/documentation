---
description: 'Follow our setup guide to connect Lengow Catalog to QUANTI:'
---

# Lengow Catalog

{% hint style="warning" %}
This connector is currently in **beta**.
{% endhint %}

***

## Overview

The Lengow Catalog connector imports your product catalog feeds directly from public [Lengow](https://www.lengow.com) feed URLs. Each custom request maps to one marketplace feed — the schema is automatically detected from the feed headers.

***

## Prerequisites

To connect a Lengow catalog feed to QUANTI, you need:

* A [Lengow](https://www.lengow.com) account with at least one marketplace catalog configured
* The public feed URL of your catalog (e.g. `https://feeds.lengow.io/3/abc123`)

To retrieve your feed URL, log in to your Lengow account and navigate to **Catalog** > **Export** for the desired marketplace, then copy the generated feed URL.

***

## Setup instructions

{% stepper %}
{% step %}
#### Connector information

* **Connector Name**: Name your connector. It must be unique.
* **Dataset ID**: Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
{% endstep %}

{% step %}
#### Add a custom request per marketplace feed

For each marketplace catalog you want to sync, add a custom request:

* **Feed URL**: Paste the public Lengow feed URL for the marketplace (e.g. `https://feeds.lengow.io/3/abc123`)
* **Separator** *(optional)*: Column separator used in the feed. Leave empty to auto-detect.

{% hint style="info" %}
Supported separators: `,` (comma), `;` (semicolon), `|` (pipe), `\t` (tab). When left empty, the connector will auto-detect the delimiter from the feed headers.
{% endhint %}

Add one custom request per marketplace feed you want to sync.
{% endstep %}
{% endstepper %}

***

## Notes

* **Schema auto-detection**: The table schema is built automatically from the feed column headers on the first sync. No manual field mapping is required.
* **Full replace sync**: Each sync fully replaces the catalog data for the feed — the connector runs in dimension mode (full reload).
* **One feed per request**: Each custom request corresponds to one marketplace feed URL. To sync multiple marketplaces, add one request per feed.
* **Beta status**: This connector is in beta — some features may evolve.
