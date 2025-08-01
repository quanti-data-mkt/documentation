---
description: >-
  Presentation of the aggregation table of conversions from advertising
  platforms.
---

# ads\_import\_conv

***

## Introduction

**ads\_import\_conv** is a pre-built table that allows for the consolidation of conversion and conversion\_value from all platforms into a single table.&#x20;

#### Without ads\_import\_conv :&#x20;

<figure><img src="../../.gitbook/assets/Capture d’écran 2024-06-13 à 15.22.56.png" alt=""><figcaption><p>Example without ads_import_conv</p></figcaption></figure>

#### With ads\_import\_conv :

<figure><img src="../../.gitbook/assets/Capture d’écran 2024-06-13 à 15.24.14.png" alt=""><figcaption><p>Example with ads_import_conv</p></figcaption></figure>

***

## Schema

```sql
`your-project`.quanti.aggregation.ads_import_conv
```

| field name                  | type    |
| --------------------------- | ------- |
| **date**                    | DATE    |
| **quanti\_id**              | STRING  |
| platform\_conversion        | INT64   |
| platform\_conversion\_value | FLOAT64 |

***

## Dimension and Unique keys

The primary keys of the table are:

* `date` : aggregates the data daily.
* `quanti_id` :  aggregates data at a "**ad**" level. The `quanti_id`  allows, via 'tracking templates,' to insert this information into campaign parameters (traditionally called UTM parameters) in order to link <mark style="background-color:purple;">ad-centric</mark> information with <mark style="background-color:yellow;">site-centric</mark> information.

{% hint style="info" %}
Get more information about how is built **quanti\_id** directly in [quanti\_ids.md](quanti_ids.md "mention")
{% endhint %}

***

## Metrics

The metrics of the table are:&#x20;

* platform\_conversion : which accounts conversions
* platform\_conversion\_value : which accounts values of the conversions.

{% hint style="info" %}
- Conversions and their values come from advertising platforms. So, we can say that they have an ad-centric origin. Be careful not to confuse them with the conversions reported by your analysis tool (site-centric).
- Some platforms can track all kinds of events, not just conversions. It is then necessary to define what event is a conversion to be able to aggregate it in the table. Example: Meta Ads, Google Ads.
- If you want to aggregate multiple events from the same platform in the table, you will not have the distinction between them.
{% endhint %}

***

## ads\_import\_conv with all conversions

It is possible to have the pre-built table `ads_import_conv` with performance distinctions by events/conversions. Instead of having generic columns `platform_conversion` and `platform_conversion_value`, the idea is to have one column counting conversions and another column counting conversion values for each conversion.

Metrics are all prefixed by `platform_conversion` followed by the ID assigned by the advertising platform. The conversion values are all suffixed by `_value.`

#### Example

On Google Ads, if you track a conversion `purchase` with the conversion ID 12345678 (automatically assigned by Google), you will find its conversion values in the metrics:

* `platform_conversion_12345678` that counts the number of this conversion.
* `platform_conversion_12345678_value` that counts value associated with this conversion.

{% hint style="info" %}
The technique that allows, from raw data, to have an `ads_import_conv` table integrating a multitude of distinct conversions, incorporates in its SQL transformation process, the concept of `PIVOT` which allows transforming rows into columns.
{% endhint %}
