---
title: Piwikpro connector
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
  Follow our setup guide to connect your Piwik Pro Analytics connector with
  QUANTI:
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
    visible: true
---

# PIWIK connector

***

## <mark style="background-color:yellow;">Prerequisites</mark>

To connect Piwikpro to QUANTI, you need an [Piwikpro](https://piwik.pro/?pk\_campaign=ecommerce-data-connector\&pk\_source=quanti.io\&pk\_medium=partnership) account.

***

## <mark style="background-color:yellow;">Setup instructions</mark>

### Find your domain

The expected information in this field is the domain displayed on your search bar when you are connected to your Piwik Account.

### Find your API credentials

1. Go on your profile parameters : **Menu** > **Profile** > **API Keys**

<div align="center" data-full-width="true">

<figure><img src="../content/en/docs/prologue/piwikpro/piwik1.png" alt="piwik-pro-analytics-credentials" width="241"><figcaption><p>screenshot from our piwik account admin</p></figcaption></figure>

</div>

2. To generate a new API Key, please click on the "Create a Key" button, which is highlighted in blue.
3. Name your instance and carefully record the API credentials. These are essential for the configuration of QUANTI.

<figure><img src="../content/en/docs/prologue/piwikpro/piwik2.png" alt=""><figcaption><p>API credentials from Piwik Pro analytics admin</p></figcaption></figure>

### Find your Website ID

1. To locate your Website ID while using Piwik Pro Analytics, navigate to your Piwikpro account. Your Website ID is displayed in the URL during your session.
2. This is the information contained between term '/analytics/' and '/dashboard/' in the url.&#x20;

Example :  "`5678h0td6-f434-4ggt-932j-b8767cd8d5d2`".

#### Quanti: configuration

1. In the connector setup form, enter the name of your choice.
2. Enter the domain you found in Step 1.
3. Enter the credentials you find in Step 2.
4. Enter you Website ID you find in Step 3. You can add several IDs separating by commas and clicking on "+".

#### Create a Custom request

This connector Piwikpro don't offer standard reports. You have to create your own reports. To help you in this step, we recommand to use "Personalized report" tool on Piwikpro Analytics UI.\
![](../content/en/docs/prologue/piwikpro/piwik3.png)

1. Create a new report.
2. Select your fields (Dimensions and metrics).\
   ![](../content/en/docs/prologue/piwikpro/piwik4.png)
3. Save your report.
4. In the filters bar, click on the button '...' (3 dots) and click on "See API call"\
   ![](../content/en/docs/prologue/piwikpro/piwik5.png)
5. A pop-in opens : make a note of the fields's name. You will need it to configure your custom request on QUANTI:.\
   ![](../content/en/docs/prologue/piwikpro/piwik6.png)
6. On QUANTI: UI, click on the button "Create".
7. Name your custom request : It will be use to name your table on your Warehouse.
8. Copy/ Paste your dimensions and metrics from your Piwikpro personalized report. You can add several fields separating by commas and clicking on "add +".
9. Repeat operation as many time it's necessary.

## <mark style="background-color:yellow;">Quanti: configuration</mark>

Click Save & Test. Quanti: will take it from here and sync your Piwikpro datas.

#### Tables

To zoom, open the ERD in a new window : [ERD](https://dbdiagram.io/e/65c4a93aac844320aeb8b15e/65ce1957ac844320ae390da2)
