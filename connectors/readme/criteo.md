---
description: 'Follow our setup guide to connect Criteo to QUANTI:'
---

# Criteo

<a href="https://dbdiagram.io/e/67aa0d57263d6cf9a0a4115e/67aa17c7263d6cf9a0a58734" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Criteo to Quanti:, you need to access a [Criteo](https://marketing.criteo.com/) account.

#### Find Client ID and Client Secret <a href="#findclientidandclientsecret" id="findclientidandclientsecret"></a>

1. Log in to your [Criteo account](https://www.criteo.com/login/).
2. [Create your organization](https://developers.criteo.com/retail-media/docs/create-your-organization).
3. Click **Create a new app** to create an app.
4.  Select an **Authentication Method**.

    > NOTE: This selection can not be changed once submitted.
5.  Choose the **Service**.

    > NOTE: This selection can not be changed once submitted.
6.  In the **Authorization** section, set every domain option to Read access level or above. Click **Save**.

    > NOTE: Each domain requires a minimum of Read access for the connection to succeed. This selection can not be changed once submitted.
7.  Scroll to the middle of the page and click **Create API key**.

    > NOTE: The file with the Client ID and Client Secret will _only be_ loaded _once_. You will need them to configure Fivetran. Download and save the file.
8. Click the Copy button to copy the link. You need to send the link to your account administrator.
9. Call the portfolio endpoint with your credentials to confirm that you can now access the accounts.
10. (Optional) (For advertisers, brands, or publishers) Click the shared link and choose **Portfolio access**.

    > NOTE: For more information, see Criteo's [Onboarding Checklist](https://developers.criteo.com/marketing-solutions/docs/onboarding-checklist) and [Authorization requests](https://developers.criteo.com/retail-media/docs/authorization-requests) documentation.

***

## <mark style="background-color:blue;">Setup instructions</mark>

* Connector information
  1. Name your connector
     1. Connector Name : Name your connector. It must be unique.
     2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
  2. Connector information
     1. Client ID and Client secret retrieved following the steps above.
     2. Select the currency code using the Currency drop-down menu.
     3. Select the Report Timezone.
  3. Advertiser ID(s)
     1. Click on + Add an advertiser and select one or those what you wxant to sync.
* Select queries: You can select pre-built queries that you want to sync.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* AdSet Stats Report : Advertising performance at adset level (**Impressions, Clicks, Spend**)
* AdSet Transactions Report : Conversion performance at adset level (**Transaction ID, amount**)

***

<a href="https://dbdiagram.io/e/682704361227bdcb4e9c9d5b/6827045e1227bdcb4e9ca579" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>
