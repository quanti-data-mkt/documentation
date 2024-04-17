---
title: 'QUANTI: Tag'
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
description: 'Follow our setup guide to interger the QUANTI: tag'
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

# QUANTI: Tag

***

## <mark style="background-color:purple;">Prerequisites</mark>

To connect QUANTI: Tag, it's recommanded to have a dataLayer (Javascript object which permit using website navigation informations) and a Tag Manager (tool which permit to handle tags integating and triggering).

***

## <mark style="background-color:purple;">Setup instructions</mark>

### Fill the form

1. **Page Choose destination** : You have to choose a destination (Data Warehouse) where QUANTI: Tag will deposit datas.
2. **Tag name** : Give it a distinctive name allowing its scope to be easily understood. Example pattern: \{{site\}} - \{{country\}}
3. **Allowed domains** : This field permit to inform domains name on which QUANTI: Tag will allowed to run. Domains non-informed in this field will be automatically dismiss from the recovering. This text field is waiting a 'Full match" Regexp type. That means an exactly pattern correspondance is waited to be accepted. Regex's example : ._quanti.io._ permit to count enterring hits from Quanti.io domain but also from all of his sub-domains like payment.quanti.io for example.
4. **Excluded referrers** : This field permit to inform domains name that you want exclude from your referrers on your raw\_sessions and raw\_conversions tables. A blacklisted referrer at the beginning of a session start (or a conversion) lead to recalculate s\_source and s\_medium values.

```bash
s_referrer = {{blacklisted domain}}
→ s_source = (direct)
→ s_medium = (none)
```

It is in this field that you can inform your payment platforms, your different domains names (to exclude internal trafic), ...

5. Settings : Enter the dataset name where you want to deposit datas. At the saving, the dataset and tables are automatically created.

### After saving

* A account ID is created.
* Javascript code is available in which you will also find your account ID.

## <mark style="background-color:purple;">Tag install</mark>

Tag can be integrated client-side server and also server-side server.
