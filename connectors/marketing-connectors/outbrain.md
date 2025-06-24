---
description: 'Follow our setup guide to connect Microsoft Advertising to QUANTI:'
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

# Outbrain

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Microsoft Advertising to Quanti:, you need to access a [Outbrain](https://my.outbrain.com/login) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

* Use your Username & password to permit Quanti: to access to your data.
* Connector information
  1. Connector Name : Name your connector. It must be unique.
  2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
* Select accounts to sync.
* Select queries: You can select pre-built queries that you want to sync.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* **`campaign_conversion_report`**: Contains daily conversion performance data for marketing campaigns, aggregating direct and view-based metrics.
* **`campaign_report`**: Provides daily overall performance of advertising campaigns, including engagement and cost-related indicators.
* **`promoted_link_report`**: Provides daily performance data at the promoted link level, including user engagement and spending metrics.
* **`publisher_report`**: Provides details daily advertising performance segmented by publisher within campaigns.
* **`campaign_history`**: Stores the historical configuration and metadata of advertising campaigns, including targeting settings and status changes.
* **`marketer_history`**: Maintains historical information about marketers, including status and metadata changes over time.
* **`publisher_history`**: Lists metadata and URLs of publishers associated with advertising content.
* **`promoted_link_history`**: Contains the configuration and metadata history of promoted links, including status, URLs, and associated campaigns.

***

[Pre-built tables and definition ](https://dbdiagram.io/e/685aa0a9f413ba35089e41de/685aa60ff413ba35089f894a):link:[ ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8)

<figure><img src="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/Capture d’écran 2025-02-07 à 11.45.23.png" alt="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8"><figcaption><p>Source : <a href="https://dbdiagram.io/e/685aa0a9f413ba35089e41de/685aa60ff413ba35089f894a">https://dbdiagram.io/e/685aa0a9f413ba35089e41de/685aa60ff413ba35089f894a</a></p></figcaption></figure>
