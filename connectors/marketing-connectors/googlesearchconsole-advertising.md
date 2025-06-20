---
description: 'Follow our setup guide to connect Google Ads to QUANTI:'
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

# Google Search Console

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Google Search Console to Quanti:, you need to access a [Google Seach console](https://search.google.com/search-console?hl=fr) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Google account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select accounts : Choose accounts to sync.
4. Select queries : Choose the pre-built queries you’d like to synchronize—or skip this step if none apply.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* **keyword\_page\_report** : Keyword-level performance per page.
* **keyword\_site\_report\_by\_page** : Keywords aggregated by page across the site.
* **keyword\_site\_report\_by\_site** : Keywords aggregated at the site level.
* **page\_report** : Performance data per page.
* **site\_report\_by\_page** : Site-level data broken down by page.
* **site\_report\_by\_site** : Overall performance at the site level.
* **sitemap** : Sitemap file metadata and status.

***

[Pre-built tables and definition ](https://dbdiagram.io/e/68555a41f039ec6d36273bf9/685562ddf039ec6d36286cbf):link:[ ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8)

<figure><img src="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/Capture d’écran 2025-02-07 à 11.45.23.png" alt="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8"><figcaption><p>Source : <a href="https://dbdiagram.io/e/68555a41f039ec6d36273bf9/685562ddf039ec6d36286cbf">https://dbdiagram.io/e/68555a41f039ec6d36273bf9/685562ddf039ec6d36286cbf</a></p></figcaption></figure>
