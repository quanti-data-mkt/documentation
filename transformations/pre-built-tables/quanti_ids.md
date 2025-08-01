---
description: >-
  Presentation of the aggregation table of dimensions from advertising
  platforms.
---

# quanti\_ids

***

## Introduction

**Quanti\_ids** is the name given to this pre-built dimension table related to statistics found in **ads\_import** and **ads\_import\_conv**.\
The goal is to consolidate the dimensions of advertising platforms into a single table with a unique table schema.

#### Without quanti\_ids :&#x20;

<figure><img src="../../.gitbook/assets/Capture d’écran 2024-06-13 à 16.23.54.png" alt=""><figcaption><p>Example without quanti_ids</p></figcaption></figure>

#### Without quanti\_ids :&#x20;

<figure><img src="../../.gitbook/assets/Capture d’écran 2024-06-13 à 16.23.11.png" alt=""><figcaption><p>Example with quanti_ids</p></figcaption></figure>

***

## Schema

```sql
`your-project`.quanti.aggregation.quanti_ids
```

| field name               | type   |
| ------------------------ | ------ |
| quanti\_id               | STRING |
| plateform\_account\_id   | STRING |
| platform\_account\_name  | STRING |
| platform\_campaign\_id   | STRING |
| platform\_campaign\_name | STRING |
| platform\_adgroup\_id    | STRING |
| platform\_adgroup\_name  | STRING |
| platform\_ad\_id         | STRING |
| platform\_ad\_name       | STRING |

***

## Dimension and Unique keys

The primary keys of the table is:

* `quanti_id` :  aggregates dimensions at a "**ad**" level. The `quanti_id`  allows, via 'tracking templates,' to insert this information into campaign parameters (traditionally called UTM parameters) in order to link <mark style="background-color:purple;">ad-centric</mark> information with <mark style="background-color:yellow;">site-centric</mark> information.
