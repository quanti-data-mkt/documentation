---
title: Affilae connector
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
description: Follow our setup guide to connect your Affilae connector
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

# Affilae

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Affilae to QUANTI:, you need an [Affilae](https://affilae.com/fr/logiciel-affiliation/?utm\_source=quanti.io\&utm\_medium=partnership) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

### Find API key

1. Log in to your [Affilae account](https://app.affilae.com/fr/login).
2.  In the bottom-left corner, click on "**My account**", then select "**API keys**".\
    \


    <figure><img src="../../content/en/docs/prologue/affilae/affilae1.png" alt="Access path to API key on Affilae interface" width="325"><figcaption><p>Access path to API key on Affilae interface</p></figcaption></figure>


3. You'll find in this section your API key. If the permission level is not appropriated, please make a request to your account manager.
4. keep your API key to finish your configuration in QUANTI:.

### Connector configuration

1. In the connector setup form, enter the **name** of your choice.
2. Enter the **API key** found in Step 1.
3. Click on "**Save & Test**"

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* affilae\_data\_import
* affilae\_partnership\_import

***

## <mark style="background-color:blue;">Tables Diagram (ERD)</mark>

{% embed url="https://docs.google.com/presentation/d/1QtqL2SrIhkf9uObcG3SdIef76dAFWSxXiX-pm82lsgY/edit?usp=sharing" fullWidth="false" %}
Affilae Tables ERD
{% endembed %}
