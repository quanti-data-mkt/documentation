---
title: Piano connector
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
description: >-
  Follow our setup guide to connect your Google Analytics 4 connector with
  QUANTI:
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

# Google Analytics 4

***

## <mark style="background-color:yellow;">Prerequisites</mark> <a href="#pre-requisites" id="pre-requisites"></a>

To connect Google Analytics 4 to QUANTI, you need an [Google](https://www.google.com/account/about/) account and access to a [Google Analytics 4 account](https://analytics.google.com/analytics/web/).

***

## <mark style="background-color:yellow;">Setup instructions</mark>

1. Connect your Google account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select accounts & properties to sync.
4. "Create queries: You can either select pre-built queries or create your own custom queries. To help you, refer to the 'Custom Query' chapter below."

***

## <mark style="background-color:yellow;">Pre-built Tables</mark>

* ACCOUNTS
* CUSTOM\_DIMENSIONS
* CONVERSION\_EVENTS
* PROPERTIES
* GOOGLE\_ADS\_LINKS

***

## <mark style="background-color:yellow;">Tables Diagram (ERD)</mark>

{% embed url="https://docs.google.com/presentation/d/1a2dypcQnmRIcx9DcIlaDek_UVriEYjOSDir5EaeXDNY/edit?usp=sharing" %}
Google Analytics 4 pre-built tables
{% endembed %}

***

## <mark style="background-color:yellow;">Custom query</mark>

To create custom Query, you need `dimensions` and `metrics`. To help you in this step, we recommend to use the [GA4 Dimensions & Metrics Explorer tool](https://ga-dev-tools.google/ga4/dimensions-metrics-explorer/).

<figure><img src="../../.gitbook/assets/GA4-Dimensions-Metrics-Explorer.png" alt="google-analytics-4-doc-query-builder" width="563"><figcaption><p>GA4 Dimensions &#x26; Metrics Explorer Tool</p></figcaption></figure>

***

## <mark style="background-color:yellow;">Limits</mark>

The Google Analytics 4 API limits custom queries to 9 dimensions, so choose them carefully.
