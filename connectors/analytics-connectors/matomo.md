---
description: 'Follow our setup guide to connect your Matomo connector with QUANTI:'
---

# Matomo

<a href="https://dbdiagram.io/e/689b41c01d75ee360a3d6e88/689b474e1d75ee360a3e98a0" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:yellow;">Prerequisites</mark> <a href="#pre-requisites" id="pre-requisites"></a>

To connect Matomo to QUANTI:, you need a [Matomo](https://fr.matomo.org/login/) account.

***

## <mark style="background-color:yellow;">Setup instructions</mark>

### Find your Auth token

1. Go to Matomo settings Settings Cog Icon > Personal > Security.
2.  At the bottom of the page, click on Create new token.<br>

    <figure><img src="../../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>
3. Confirm your account password.
4. Enter the purpose for this token.
5. Choose if the token should only be valid for secure requests (Matomo 5 and newer).
6. Click on Create new token.

### Connector configuration

1. Authentication
   1. Enter the Auth token you retrieved in the previous step.
   2. Enter the Matomo URL that allows you to access your reports. This should be in the form: https://data.yourwebsite.com.
2. Connector information
   1. Connector Name: Name your connector. It must be unique.
   2. Dataset ID: Define the ID of the dataset. It must not already exist, as it will be created and data will be sent there.
3. Select your Advertiser Id: Choose your Advertiser ID.
4. Select the pre-built queries you want to synchronize.

***

## <mark style="background-color:yellow;">Pre-built Tables</mark>

* **visitor\_country**: Tracks website visits, user actions, and conversions segmented by the visitor’s country.
* **visitor\_language**: Records website engagement metrics based on the visitor’s preferred language.
* **visitor\_device\_type**: Measures website activity by the type of device used (e.g., desktop, mobile, tablet).
* **behaviour\_page**: Monitors page-level behavior, including entrances, exits, pageviews, and time spent.
* **acquisition\_campaign**: Captures visitor metrics grouped by marketing campaign name.
* **acquisition\_referrer**: Logs visits and conversions by referring source, type, and URL.
* **acquisition\_channel\_type**: Aggregates website performance by high-level marketing channel type.

***

<a href="https://dbdiagram.io/e/689b41c01d75ee360a3d6e88/689b474e1d75ee360a3e98a0&#x27;" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>
