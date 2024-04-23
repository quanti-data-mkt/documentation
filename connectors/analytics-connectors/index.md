---
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

## <mark style="background-color:yellow;">Pre requisites</mark> <a href="#pre-requisites" id="pre-requisites"></a>

To connect Google Analytics 4 to QUANTI, you need an [Google](https://www.google.com/account/about/) account and access to a [Google Analytics 4 account](https://analytics.google.com/analytics/web/).

***

## <mark style="background-color:yellow;">Setup instructions</mark>

1. Choose the google acccount you want lo log in with
2. Choose the accounts you want to sync
3. build your custom query

## <mark style="background-color:yellow;">Custom query</mark>

To create custom Query, you need `dimensions` and `metrics`. To help you in this step, we recommend to use the [GA4 Dimensions & Metrics Explorer tool](https://ga-dev-tools.google/ga4/dimensions-metrics-explorer/).

<figure><img src="../../.gitbook/assets/GA4-Dimensions-Metrics-Explorer.png" alt=""><figcaption></figcaption></figure>

***

## <mark style="background-color:yellow;">Pre-built Queries</mark>

* ACCOUNTS
* CUSTOM\_DIMENSIONS
* CONVERSION\_EVENTS
* PROPERTIES
* GOOGLE\_ADS\_LINKS

***

## <mark style="background-color:yellow;">Tables Diagram (ERD)</mark>

{% embed url="https://docs.google.com/presentation/d/1a2dypcQnmRIcx9DcIlaDek_UVriEYjOSDir5EaeXDNY/edit?usp=sharing" %}
Google Analytics 4 pre-built queries
{% endembed %}

***

## <mark style="background-color:yellow;">Quota Policy</mark>

{% hint style="info" %}
The Google Analytics 4 API limits custom queries to 9 dimensions, so choose them carefully.
{% endhint %}