---
title: Big Query Data Warehouse setup
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
description: 'Follow our setup guide to connect QUANTI: to BigQuery'
---

# Big Query Data Warehouse setup

_Last update : 2024-02-16_

Follow our setup guide to connect QUANTI: to BigQuery

***

### Prerequisites

To connect QUANTI: to BigQuery, you need an [Google Cloud Platform](https://cloud.google.com/gcp) account.

***

### Setup instructions

#### Quanti: configuration

1. In the connector setup form, enter a distinctive name of your choice.
2. Select your sector category and company size.
3. Enter your BigQuery projet ID. You can find it by clicking in the selection field on the header of your BigQuery UI.\
   ![](../content/en/docs/prologue/bigquery/bigquery1.png)
4. Select your Data Location. The physical place where QUANTI: will use to deposit your datas.
5. Click Next.

#### Service Account configuration

In this step, copy the service account email adresse provided by QUANTI: and follow the steps bellow:

1. Go on IAM & Admin product on BigQuery UI. Click on icon Menu < IAM & Admin < IAM\
   ![](../content/en/docs/prologue/bigquery/bigquery2.png)
2. Click GRANT ACCESS button.\
   ![](../content/en/docs/prologue/bigquery/bigquery3.png)
3. Copy/ paste the service account email adresse, assign roles bellow and click Save :

* Browser
* Bigquery Admin
* Storage Admin\
  ![](../content/en/docs/prologue/bigquery/bigquery4.png)

4. In QUANTI: UI, click Next Button to launch the connections tests.
