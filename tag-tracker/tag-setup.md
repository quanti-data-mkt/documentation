---
description: 'Follow our setup guide to interger the QUANTI: tag'
---

# Tag setup

***

## <mark style="background-color:purple;">Prerequisites</mark>

To connect QUANTI: Tag, it's recommended to have a Tag Manager.

***

## <mark style="background-color:purple;">Setup instructions</mark>

<mark style="background-color:purple;">Event tracker information</mark>

1. **Event tracker name** : Give a distinctive name allowing its scope to be easily understood.\
   Example pattern: \{{site\}} - \{{country\}}
2. **Dataset ID** : Name of the dataset where load datas.

<mark style="background-color:purple;">Tag information</mark>

1. **Allowed domains :** Fully matched regex of included domains names.\
   Regex's example : `(payment|www)\.quanti\.io` include hits from `www.quanti.io` domain and from sub-domain `payment.quanti.io`
2. **Excluded referrers** : Fully matched regex of the domains whose traffic you don’t want to identify as referrals. A blacklisted referrer lead to recalculate s\_source and s\_medium values on your raw\_sessions and raw\_conversions tables.&#x20;

```bash
s_referrer = {{blacklisted domain}}
→ s_source = (direct)
→ s_medium = (none)
```

{% hint style="info" %}
In this field, you can add your different domains (including payment platforms) to exclude internal trafic.
{% endhint %}

3. **Session timeout** : A session is initiated when an app is opened in the foreground or when a webpage is loaded. It ends after a period of user inactivity. The default timeout is 30 minutes but can be adjusted here. The timeout duration can be expressed in seconds (s), minutes (m), or hours (h).
4. **Session restart on new UTM** : If true, each time a new utm\_source is detected in the URL during a session, a new session is automatically created — meaning a new session\_id value is generated. The new UTM values are then used to characterize the source of this new session.

### After saving

* A account ID is created.
* Datasets and tables are automatically created.
* Javascript code and Server side template is now available.

***

## <mark style="background-color:purple;">Client-side Tag install</mark>

Quanti: Tag is an Event-based Tag.\
It can be integrated on a [client-side](tag-setup.md#client-side-installation) server or a [server-side](tag-setup.md#server-side-installation) server.

### JS Library

The JS library has to triggered first before events.

{% code overflow="wrap" %}
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
{% endcode %}

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

{% hint style="info" %}
`{custom_object}` is optional.
{% endhint %}

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

***

## <mark style="background-color:purple;">Server-side Tag install</mark>

To install the server-side tag, simply use the GTM template available for download here :&#x20;

{% file src="../.gitbook/assets/2025-02-04 QUANTI - Server-side Tag Template (1).tpl" %}

***

## <mark style="background-color:purple;">Fields configuration</mark>

<table data-full-width="true"><thead><tr><th width="175">Name</th><th width="109">Type</th><th width="119">Overridable</th><th width="170">Exemple Value</th><th>Description</th></tr></thead><tbody><tr><td>user_id</td><td>STRING</td><td>Yes</td><td>example@yopmail.com</td><td>The ID used to recognize a logged-in user</td></tr><tr><td>conversion_id</td><td>STRING</td><td>Yes</td><td>ABCD1234</td><td>The unique ID of a conversion</td></tr><tr><td>conversion_value</td><td>STRING</td><td>Yes</td><td>123.45</td><td>The monetary value of the conversion</td></tr><tr><td>conversion_type</td><td>STRING</td><td>Yes</td><td>purchase</td><td>The conversion type</td></tr><tr><td>consent</td><td>STRING</td><td>Yes</td><td>analytics:yes;marketing:yes;retargeting:no</td><td>User consent collected</td></tr><tr><td>event_category</td><td>STRING</td><td>Yes</td><td>video</td><td>Typically the object that was interacted with</td></tr><tr><td>event_action</td><td>STRING</td><td>Yes</td><td>play</td><td>The type of interaction</td></tr><tr><td>event_label</td><td>STRING</td><td>Yes</td><td>spring campaign</td><td>Usefull to categorize events </td></tr><tr><td>event_value</td><td>STRING</td><td>Yes</td><td>42.23</td><td>Numeric value associated with the event</td></tr><tr><td>product_ids</td><td>STRING</td><td>Yes</td><td>[ { "product_id":"ID123", "price":"123.34", "quantity":"2", "amount":"246.68" } ]</td><td>products table with custom fields</td></tr><tr><td>datetime</td><td>STRING</td><td>Yes</td><td>2023-11-06T05:53:11</td><td>Datetime of the hit automatically set the tag but overridable if needed*</td></tr><tr><td>visitor_id</td><td>STRING</td><td>Yes</td><td>1hehirh3h0.d003ebc3</td><td>Visitor ID automatically set by the tag but overridable if needed*</td></tr><tr><td>session_id</td><td>STRING</td><td>Yes</td><td>45d01d5a-4df9-457d-9c6c-af7d707756f2</td><td>Visit ID automatically set by the tag but overridable if needed*</td></tr><tr><td>device_type</td><td>STRING</td><td>Yes</td><td>mobile</td><td>hit device type automatically set by the tag but overridable if needed*</td></tr><tr><td>url</td><td>STRING</td><td>Yes</td><td>https://www.shoes.com</td><td>The page that loaded the hit automatically set by the tag but overridable if needed*</td></tr><tr><td>referrer</td><td>STRING</td><td>Yes</td><td>https://www.google.com</td><td>The page from which the visitor comes automatically set by the tag but overridable if needed*</td></tr><tr><td>user_agent</td><td>STRING</td><td>Yes</td><td>Mozilla/5.0 (iPad; CPU OS 17_0_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) </td><td>Informations of your browser automatically set by the tag but overridable if needed*</td></tr><tr><td>ad_user_data</td><td>STRING</td><td>Yes</td><td>granted or denied</td><td>Controls the sending of user-identifiable data for advertising purposes.</td></tr><tr><td>ad_personalization</td><td>STRING</td><td>Yes</td><td>granted or denied</td><td>Controls the use of data for personalized advertising (e.g., remarketing, audience targeting).</td></tr><tr><td>ad_storage</td><td>STRING</td><td>Yes</td><td>granted or denied</td><td>Controls the use of local storage for advertising purposes (e.g., marketing cookies).</td></tr><tr><td>analytics_storage</td><td>STRING</td><td>Yes</td><td>granted or denied</td><td>Controls the use of storage for analytics data.</td></tr></tbody></table>



{% hint style="info" %}
\*Informations automatically available through the browser and retrievable in JavaScript in a client-side configuration must be manually retrieved in a server-side configuration.
{% endhint %}
