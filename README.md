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

# BigQuery

***

## Prerequisites

To connect QUANTI: to BigQuery, you need an [Google Cloud Platform](https://cloud.google.com/gcp) account.

***

## Setup instructions

### Quanti: configuration

1. In the connector setup form, enter a distinctive name of your choice.
2. Select your sector category and company size.
3.  Enter your BigQuery projet ID. You can find it by clicking in the selection field on the header of your BigQuery interface.\
    \


    <figure><img src="content/en/docs/prologue/bigquery/bigquery1.png" alt="Project ID from BigQuery Interface" width="563"><figcaption><p>Project ID from BigQuery Interface</p></figcaption></figure>


4. Select your Data Location. The physical place where QUANTI: will use to deposit your datas.
5. Click Next.

### Service Account configuration

In this step, copy the service account email adresse provided by QUANTI: and follow the steps bellow:

1.  Go on IAM & Admin product on BigQuery interface. Click on icon Menu < IAM & Admin < IAM\
    \


    <figure><img src="content/en/docs/prologue/bigquery/bigquery2.png" alt="Access to the BigQuery IAM interface" width="375"><figcaption><p>Access to the BigQuery IAM interface</p></figcaption></figure>


2.  Click GRANT ACCESS button.\
    \


    <figure><img src="content/en/docs/prologue/bigquery/bigquery3.png" alt="&#x22;Grant Access&#x22; button from BigQuery interface"><figcaption><p>"Grant Access" button from BigQuery interface</p></figcaption></figure>


3. Copy/ paste the service account email adresse, assign roles bellow and click Save :

* Browser
* Bigquery Admin
*   Storage Admin\
    \


    <figure><img src="content/en/docs/prologue/bigquery/bigquery4.png" alt="BigQuery needed roles for the system user" width="375"><figcaption><p>BigQuery needed roles for the system user</p></figcaption></figure>

4. In QUANTI: interface, click Next Button to launch the connections tests.
