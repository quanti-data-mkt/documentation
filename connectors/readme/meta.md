---
description: 'Follow our setup guide to connect Meta to QUANTI:'
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

# Meta

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Meta to QUANTI, you need an [Facebook](https://www.facebook.com/) account and an access to a [business manager](https://business.facebook.com/).

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Facebook account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select accounts to sync.
4. "Create queries: You can either select pre-built queries or create your own custom queries.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* Ad Stats : Advertising performance at ad level
* Ad Conversions : Conversion performance at ad level
* Adset Stats : Advertising performance at adset level
* Campaign Stats : Advertising performance at campaign level

***

## <mark style="background-color:blue;">Tables Diagram (ERD)</mark>

Text

***

## <mark style="background-color:blue;">Custom query</mark>

To help you to create your own custom queries and know the compatibility of fields between them, you can build the custom reports you require using the [Facebook Graph API Explorer](https://developers.facebook.com/docs/graph-api/guides/explorer/) and then replicate it on Quanti:. The explorer indicates fields compatibility, any potential errors, and if the data you require is available.

The Meta connector works entirely on the Meta "[API insights](https://developers.facebook.com/docs/marketing-api/insights)" documentation.

***

## <mark style="background-color:blue;">Limits</mark> if needed

Text (if needed)
