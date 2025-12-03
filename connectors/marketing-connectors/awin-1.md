---
description: 'Follow our setup guide to connect Kwanko to QUANTI:'
---

# Kwanko

<a href="https://dbdiagram.io/e/689b4f0c1d75ee360a4021c3/689b50301d75ee360a40615a" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Kwanko to QUANTI, you need an [Kwanko](https://advertiser.kwanko.com/#/dashboard) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

### Find API token

1. Log in to your [Kwanko account](https://advertiser.kwanko.com/#/dashboard).
2. In the top-right corner, click on Tools < API\
   ![](<../../.gitbook/assets/image (3).png>)<br>
3. Retrieve the API token displayed on this screen.

### Finish Quanti: configuration

1. Authentication
   1. Enter the API token you found in Step 1.
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select queries : Choose the pre-built queries you’d like to synchronize.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* **campaign\_stats**: Contains overall performance metrics for campaigns, including impressions, clicks, leads, sales, downloads, bonus activities, and associated spend.
* **transactions**: Stores detailed records of individual transactions or conversions, including IDs, campaign details, device type, tracking source, website information, achievement status, and spend values.

***

<a href="https://dbdiagram.io/e/689b4f0c1d75ee360a4021c3/689b50301d75ee360a40615a" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>
