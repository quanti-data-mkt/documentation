---
title: Effinity connector
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
description: 'Follow our setup guide to connect Effinity to QUANTI:'
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

# Effinity

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Effinity to QUANTI, you need an [Effinity](https://www.effinity.fr/?utm\_source=quanti.io\&utm\_medium=partnership\&utm\_campaign=effinity\_data\_connector) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

### Find API key

1. Log in to your [Effinity account](https://sso.effinity.fr/auth/sign/affilieur?lg=fr).
2. In the top-right corner, in account parameters, you can find the API Key.
3. You can also request it directly to your account manager.
4. **Important: Keep Your API Key Secure.** You will need it for the configuration in QUANTI.

### Finish Quanti: configuration

1. In the connector setup form, enter the name of your choice.
2. Enter the API key you found in Step 1.
3. Click Save & Test. Quanti: will take it from here and sync your Effinity data.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* account\_detail
* ads\_import

***

## <mark style="background-color:blue;">Tables Diagram (ERD)</mark>

{% embed url="https://docs.google.com/presentation/d/13--xaQBcnDXNwCybc9jMmUud6HXwZmsAGk_Zv5-89vs/edit?usp=sharing" %}
Effinity Connector schema
{% endembed %}

