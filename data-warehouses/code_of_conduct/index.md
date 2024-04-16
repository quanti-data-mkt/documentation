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

# Big Query Data Warehouse setup

***

## Prerequisites

To connect QUANTI: to BigQuery, you need an [Google Cloud Platform](https://cloud.google.com/gcp) account.

***

## Setup instructions

### Quanti: configuration

1. In the connector setup form, enter a distinctive name of your choice.
2. Select your sector category and company size.
3.  Enter your BigQuery projet ID. You can find it by clicking in the selection field on the header of your BigQuery UI.\
    \


    <figure><img src="../../content/en/docs/prologue/bigquery/bigquery1.png" alt="" width="563"><figcaption><p>Screenshot of BigQuery UI</p></figcaption></figure>


4. Select your Data Location. The physical place where QUANTI: will use to deposit your datas.
5. Click Next.

### Service Account configuration

In this step, copy the service account email adresse provided by QUANTI: and follow the steps bellow:

1.  Go on IAM & Admin product on BigQuery UI. Click on icon Menu < IAM & Admin < IAM\
    \


    <figure><img src="../../content/en/docs/prologue/bigquery/bigquery2.png" alt="" width="375"><figcaption><p>Screenshot of access to the BigQuery IAM UI</p></figcaption></figure>


2.  Click GRANT ACCESS button.\
    \


    <figure><img src="../../content/en/docs/prologue/bigquery/bigquery3.png" alt=""><figcaption><p>Screenshot of the "Grant Acess" button</p></figcaption></figure>


3. Copy/ paste the service account email adresse, assign roles bellow and click Save :

* Browser
* Bigquery Admin
*   Storage Admin\
    \


    <figure><img src="../../content/en/docs/prologue/bigquery/bigquery4.png" alt="" width="375"><figcaption><p>Screenshot of the needed roles for BigQuery</p></figcaption></figure>

4. In QUANTI: UI, click Next Button to launch the connections tests.
