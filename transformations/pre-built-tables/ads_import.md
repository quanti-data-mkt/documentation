---
description: Introduction to the data aggregation table for advertising platforms.
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

# ads\_import

***

## Introduction

**ads\_import** is a pre-built table that allows for the consolidation of impression, click, and spend data from all platforms into a single table.&#x20;

#### Without ads\_import :&#x20;

<figure><img src="../../.gitbook/assets/Capture d’écran 2024-05-22 à 16.47.31.png" alt=""><figcaption><p>Example without ads_import</p></figcaption></figure>

#### With ads\_import

<figure><img src="../../.gitbook/assets/Capture d’écran 2024-05-22 à 16.50.35.png" alt=""><figcaption><p>Example with ads_import</p></figcaption></figure>

***

## Schema

```sql
`your-project`.quanti.aggregation.ads_import
```

| field name            | type    |
| --------------------- | ------- |
| **date**              | DATE    |
| **quanti\_id**        | STRING  |
| platform\_spend       | FLOAT64 |
| platform\_clicks      | FLOAT64 |
| platform\_impressions | INT64   |

***

## Dimension and Unique keys

The primary keys of the table are:

* `date` : aggregates the data daily.
* `quanti_id` :  aggregates data at a "**ad**" level. The `quanti_id`  allows, via 'tracking templates,' to insert this information into campaign parameters (traditionally called UTM parameters) in order to link <mark style="background-color:purple;">ad-centric</mark> information with <mark style="background-color:yellow;">site-centric</mark> information.

{% hint style="info" %}
Get more information about how is built **quanti\_id** directly in [quanti\_ids.md](quanti\_ids.md "mention")
{% endhint %}

***

## Metrics

The metrics of the table are:&#x20;

* platform\_spend : which accounts for advertising spends.
* platform\_clicks :  which accounts for clicks on advertisements made by users.
* platform\_impressions : which accounts for impressions of advertisements on the platforms' distribution networks.
