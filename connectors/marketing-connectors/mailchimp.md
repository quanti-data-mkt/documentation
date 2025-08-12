---
description: 'Follow our setup guide to connect Mailchimp to QUANTI:'
---

# Mailchimp

<a href="https://dbdiagram.io/e/684ae5df1dff20a534caede9/684ae84a1dff20a534cb4a46" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Mailchimp to Quanti:, you need to access a [Mailchimp](https://login.mailchimp.com/?locale=en) account.

***

## <mark style="background-color:blue;">Setup instructions</mark>

* Authorize your account : Connect your Mailchimp account to permit Quanti: to access to your data
* Connector information
  1. Connector Name : Name your connector. It must be unique.
  2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
* Select queries: You can select pre-built queries that you want to sync.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* **campaigns\_history**: Stores the setup and metadata of email campaigns, including delivery configuration, design options, and scheduling.
* **campaign\_recipient\_history**: Maps each campaign to its recipients, recording which members received which campaigns and their delivery status.
* **campaign\_recipient\_activity**: Captures recipient interactions such as opens, clicks, and bounces for detailed engagement tracking.
* **lists\_history**: Represents the structure and metadata of mailing lists, including list settings, creation details, and subscription management.
* **members\_history**: Maintains detailed records about individual subscribers, including identifiers, preferences, subscription sources, and status history.

***

<a href="https://dbdiagram.io/e/682704361227bdcb4e9c9d5b/6827045e1227bdcb4e9ca579" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>
