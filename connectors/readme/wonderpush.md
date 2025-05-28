---
title: Wonderpush connector
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
description: 'Follow our setup guide to connect Wonderpush to QUANTI:'
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

# Wonderpush

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Wonderpush to QUANTI, you need a [Wonderpush](https://www.wonderpush.com/fr/?utm_source=quanti.io\&utm_medium=partnership) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

### Find API key

1. Log in to your [Wonderpush account](https://partner.wonderpush.net/login).
2. In the top-right corner, click on your profile. Next, click on Settings < API credentials.
3. Make a note of the Access token. You will need it to configure QUANTI:.

### Finish Quanti: configuration

1. Enter your Access token you found in Step 1.
2. Enter the name of your choice.
3. Select the queries you want to sync.
4. Click Save. Quanti: will take it from here and sync your Wonderpush data.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* Campaign list : Stores unique campaign identifiers and their names.
* Notifications : Aggregates daily event counts by campaign, type, and subtype.
* Subscriptions : Aggregates daily event counts by campaign, type, and subtype.

***

[Pre-built tables and definition ](https://dbdiagram.io/e/65577c543be149578735ccf9/65cf2b18ac844320ae4a3ed6):link:[ ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8)

<figure><img src="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/Capture d’écran 2025-02-07 à 11.45.23.png" alt="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8"><figcaption><p>Source : <a href="https://dbdiagram.io/e/65c356a8ac844320aea34431/65ce2477ac844320ae3a1b28">https://dbdiagram.io/e/65c356a8ac844320aea34431/65ce2477ac844320ae3a1b28</a></p></figcaption></figure>

