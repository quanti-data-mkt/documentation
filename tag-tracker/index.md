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

# Tag setup

***

## <mark style="background-color:purple;">Prerequisites</mark>

To connect QUANTI: Tag, it's recommended to have a Tag Manager.

***

## <mark style="background-color:purple;">Setup instructions</mark>

1. **Data Warehouse** : Choose a Data Warehouse where QUANTI: Tag will load datas.
2. **Tag name** : Give a distinctive name allowing its scope to be easily understood.\
   Example pattern: \{{site\}} - \{{country\}}
3. **Allowed domains :** Fully matched regex of included domains names.\
   Regex's example : `(payment|www)\.quanti\.io` include hits from `www.quanti.io` domain and from sub-domain `payment.quanti.io`
4. **Excluded referrers** : Fully matched regex of the domains whose traffic you don’t want to identify as referrals. A blacklisted referrer lead to recalculate s\_source and s\_medium values on your raw\_sessions and raw\_conversions tables.&#x20;

```bash
s_referrer = {{blacklisted domain}}
→ s_source = (direct)
→ s_medium = (none)
```

{% hint style="info" %}
In this field, you can add your different domains (including payment platforms) to exclude internal trafic.
{% endhint %}

5. **Dataset name** : Name of the dataset where load datas.

### After saving

* A account ID is created.
* Datasets and tables are automatically created.
* Javascript code is now available.

## <mark style="background-color:purple;">Client-side Tag install</mark>

Quanti: Tag is an Event-based Tag.\
It can be integrated on a [client-side](index.md#client-side-installation) server or a [server-side](index.md#server-side-installation) server.

### JS Library

The JS library has to triggered first before events.

```javascript
<script type="text/javascript">
  window._quantiDataLayer = window._quantiDataLayer || [];
  function _quantiTag() {
    _quantiDataLayer.push(arguments);
  }
  _quantiTag('trackerUrl', "https://api.tag.apiquanti.net/v1/ap/");
  _quantiTag('domain', ".domain.com");
  _quantiTag('accountId', {{Quanti Account ID}});
</script>
<script async src="https://cdn.jsdelivr.net/gh/whatsonio/quantijs@v1.7.3/dist/src.min.js"></script>
```

`Domain` and `accountId` has to personalize. Refer to your "Generated JS Code" on your "Tag Details" screen.

### page\_view

```javascript
_quantiTag('hit', 'page_view', {
    {{custom_object}}
});
```

### event

```javascript
_quantiTag('hit', 'event', {
    {{custom_object}}
});
```

#### \{{Custom\_object\}} fields reference

Example of `{{custom_object}}` for a page\_view hit (Also valid for event hit).

```javascript
_quantiTag('hit', 'page_view', {
    user_id : "",
    conversion_id : "",
    conversion_value : "",
    conversion_type : "",
    consent : "",
    event_category : "",
    event_action : "",
    event_label : "",
    event_value : "",
    product_ids : ""
});
```

## <mark style="background-color:purple;">Server-side Tag install</mark>

`Coming soon...`

## Fields configuration

<table><thead><tr><th width="187">Name</th><th width="109">Type</th><th width="119">Required</th><th width="208">Exemple Value</th><th>Description</th></tr></thead><tbody><tr><td>user_id</td><td>STRING</td><td>No</td><td>example@yopmail.com</td><td>The IDD used to recognize a logged-in user</td></tr><tr><td>conversion_id</td><td>STRING</td><td>No</td><td>ABCD1234</td><td>The unique ID of a transaction</td></tr><tr><td>conversion_value</td><td>STRING</td><td>No</td><td>123.45</td><td>The monetary value of the transaction</td></tr><tr><td>conversion_type</td><td>STRING</td><td>No</td><td>purchase</td><td>The conversion type</td></tr><tr><td>consent</td><td>STRING</td><td>No</td><td>analytics:yes;marketing:yes;retargeting:no</td><td>User consent collected</td></tr><tr><td>event_category</td><td>STRING</td><td>No</td><td></td><td></td></tr><tr><td>event_action</td><td>STRING</td><td>No</td><td></td><td></td></tr><tr><td>event_label</td><td>STRING</td><td>No</td><td></td><td></td></tr><tr><td>event_value</td><td>STRING</td><td>No</td><td></td><td></td></tr><tr><td>product_ids</td><td>STRING</td><td>No</td><td></td><td></td></tr><tr><td>datetime</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr><tr><td>visitor_id</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr><tr><td>session_id</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr><tr><td>device_type</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr><tr><td>url</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr><tr><td>referrer</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr><tr><td>user_agent</td><td>STRING</td><td>Overridable</td><td></td><td></td></tr></tbody></table>

