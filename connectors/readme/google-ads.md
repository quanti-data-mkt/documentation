---
description: 'Follow our setup guide to connect Google Ads to QUANTI:'
---

# Google Ads

<a href="https://dbdiagram.io/e/67a6375d263d6cf9a069bf46/67a63980263d6cf9a069f135" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Google Ads to Quanti:, you need to access a [Google Ads](https://ads.google.com/) account.

#### Find customer ID <a href="#findcustomerid" id="findcustomerid"></a>

1. Log in to your [Google Ads account](https://ads.google.com/nav/login).
2.  Locate your Google Ads customer ID and make a note of it. You will need it to fill in your Google Ads setup form.

    ![Customer ID](https://fivetran.com/static-assets-docs/_next/static/media/customer-id.9cc9a54c.png)

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Google account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
   3. Enter the Google Ads customer ID you found.
3. Select accounts : Choose accounts to sync.
4. Select queries : Choose the pre-built queries you’d like to synchronize—or skip this step if none apply.
5. Create queries: create your own custom queries queries you’d like to synchronize—or skip this step if none apply.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* Ad Stats : Advertising performance at ad level (**Impressions, Clicks, Spend**)
* Ad Conversions : Conversion performance at ad level (**All conversion Types and values**)
* Campaign Stats : Advertising performance at campaign level (**Impressions, Clicks, Spend**)
* Campaign Conversions : Conversion performance at campaign level (**All conversion Types and values**)

***

<a href="https://dbdiagram.io/e/67a6375d263d6cf9a069bf46/67a63980263d6cf9a069f135" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Custom query</mark>

If you want to sync a Custom report:

1. Click **Add custom query**
2. Enter a **table name** for the custom report being added.&#x20;
3. Select the **Report Name** of the report you'd like to sync.
4. Select the **Fields** you'd like to sync for the report. See [Google's Ads API Report Types documentation](https://developers.google.com/google-ads/api/fields/v10/overview).
5. Click **Save**.
