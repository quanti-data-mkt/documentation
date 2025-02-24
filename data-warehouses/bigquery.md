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
description: >-
  How to give rights to a Service Account in GCP. Follow our setup guide to
  connect QUANTI: to Google Cloud Platform.
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

# Manage rights on GCP

***

As part of creating a project unmanaged by Quanti (i.e., a project for which you already have a data warehouse), it is necessary to authorize a service account that will deposit the data into your data warehouse.

{% hint style="warning" %}
Quanti: only needs access to your GCP to deposit the data you requested. The service account we will use will be granted only the necessary level of permissions to use the BigQuery service.
{% endhint %}

## Prerequisites

To connect QUANTI: to Google Cloud Plaform (GCP), you need an [GCP](https://cloud.google.com/gcp) account.

***

## Setup instructions

### 1. Project creation

When creating a new unmanaged project, you are asked to specify the Google Cloud Platform project ID. You can find it by clicking in the selection field on the header of your Google Cloud Platform interface. Enter your projet ID in the designated field on Quanti: UI.

<figure><img src="../content/en/docs/prologue/bigquery/bigquery1.png" alt="Project ID from BigQuery Interface" width="563"><figcaption><p>Project ID from BigQuery Interface</p></figcaption></figure>

### 2. Service Account configuration

When the creation is done, you will redirect on the dashboard projet. In your arrival, a pop-in will opens and give instructions to continue : "Add the Service Account to your IAM Project".

1.  Go on IAM & Admin product on GCP interface. Click on icon Menu < IAM & Admin < IAM\
    \


    <figure><img src="../content/en/docs/prologue/bigquery/bigquery2.png" alt="Access to the BigQuery IAM interface" width="375"><figcaption><p>Access to the BigQuery IAM interface</p></figcaption></figure>


2.  Click GRANT ACCESS button.\
    \


    <figure><img src="../content/en/docs/prologue/bigquery/bigquery3.png" alt="&#x22;Grant Access&#x22; button from BigQuery interface"><figcaption><p>"Grant Access" button from BigQuery interface</p></figcaption></figure>


3. Copy/ paste the service account email adresse, assign roles requested and click Save :
4. In QUANTI: interface, click on Check button to launch the connections tests.
