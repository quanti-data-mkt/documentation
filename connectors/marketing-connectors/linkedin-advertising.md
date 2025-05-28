---
description: 'Follow our setup guide to connect Linkedin Ads to QUANTI:'
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

# Linkedin Ads

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Linkedin Ads to Quanti:, you need to access a [Linkedin Ads](https://www.linkedin.com/campaignmanager/accounts) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Linkedin Ads account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select accounts to sync.
4. Select queries: You can select pre-built queries that you want to sync.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* **account\_history:** Stores account details.
* **campaign\_group\_history:** Stores campaign group info.
* **campaign\_history:** Stores campaign settings.
* **creative\_history:** Stores creative asset details.
* **ad\_analytics\_by\_creative:** Aggregates performance metrics by creative.
* **ad\_analytics\_by\_creative\_with\_conversion\_breakdown:** Aggregates creative metrics with conversion breakdown.

***

[Pre-built tables and definition ](https://dbdiagram.io/e/682b4daf1227bdcb4eff888a/682b4fa51227bdcb4effdd6c):link:[ ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8)

<figure><img src="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/Capture d’écran 2025-02-07 à 11.45.23.png" alt="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8"><figcaption><p>Source : <a href="https://dbdiagram.io/e/682b4daf1227bdcb4eff888a/682b4fa51227bdcb4effdd6c">https://dbdiagram.io/e/682b4daf1227bdcb4eff888a/682b4fa51227bdcb4effdd6c</a></p></figcaption></figure>
