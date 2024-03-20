---
title: Big Query dataware House | Quanti Setup Guide
lead: >-
  Doks is a Hugo theme for building secure, fast, and SEO-ready documentation
  websites, which you can easily update and customize.
date: 2020-10-06T08:48:57.000Z
lastmod: 2020-10-06T08:48:57.000Z
draft: false
images: []
menu:
  docs:
    parent: prologue
weight: 100
toc: true
description: 'Follow our setup guide to connect your BigQuery data warehouse to QUANTI:'
---

# Big Query dataware House | Quanti Setup Guide

Follow our setup guide to connect your BigQuery data warehouse to Quanti:.

> NOTE: This is a BigQuery setup guide. For instructions on Quanti:-managed BigQuery, see our [Managed BigQuery documentation](../content/en/docs/prologue/https:/Quanti:.com/docs/destinations/bigquery/managed-bigquery/).

***

### Prerequisites[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#prerequisites\_1)

To connect BigQuery to Quanti:, you need the following:

* A BigQuery account or a Google Apps account
* Quanti: role with the [Create Destinations or Manage Destinations](../content/en/docs/prologue/https:/Quanti:.com/docs/using-Quanti:/Quanti:-dashboard/account-management/role-based-access-control/#destinationpermissions) permissions

> NOTE: Quanti: doesn't support BigQuery sandbox accounts.

***

### Setup instructions[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#setupinstructions\_1)

#### Find Project ID[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#findprojectid\_1)

You need to grant Quanti: access to your BigQuery cluster so we can create and manage tables for your data, and periodically load data into those tables.

1. Go to your Google Cloud Console's [projects list](https://console.cloud.google.com/cloud-resource-manager?pli=1).
2. Find your project on the list and make a note of the project ID in the ID column. You will need it to configure Quanti:.

#### Find Quanti: service account[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#findQuanti:serviceaccount\_1)

1. Log in to your Quanti: account.
2. Go to the [Destinations page](../content/en/docs/prologue/https:/Quanti:.com/dashboard/destinations/), and then click Add destination.
3. In the pop-up window, enter a Destination name of your choice.
4. Click Add.
5. Select BigQuery as the destination type.
6. Enter the Project ID you found in [Step 1](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#findprojectid).
7. Make a note of the Quanti: service account. You will need to grant it permissions in BigQuery.

#### (Optional) Create service account[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#optionalcreateserviceaccount\_1)

If you want to use your service account to control access to BigQuery, instead of the Quanti:-managed service account, you must create a service account. For more information, see [Google's Creating a service account documentation](https://cloud.google.com/iam/docs/creating-managing-service-accounts#creating).

[Follow Google's service key instructions](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating) to create a private key in JSON format for your service account. Make a note of the private key. You will need it to configure Quanti:. The private key should have the following format:

```
{
  "type": "service_account",
  "project_id": "random-project-12345",
  "private_key_id": "abcdefg",
  "private_key": "*****",
  "client_email": "name@project.iam.gserviceaccount.com",
  "client_id": "12345678",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/name%40project.iam.gserviceaccount.com"
}

```

#### Configure service account[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#configureserviceaccount\_1)

1. Go back to the IAM & admin tab, and go to the [project principals list](https://console.cloud.google.com/iam-admin/iam/project).
2. Select + GRANT ACCESS.
3. In the New Principals field, enter the Quanti: service account you found in [Step 2](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#findQuanti:serviceaccount) or the service account you created in [Step 3](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#optionalcreateserviceaccount). The service account is the entire email address.
4.  Click Select a role > BigQuery > BigQuery User.

    > NOTE: For more information about roles, see [our documentation](../content/en/docs/prologue/https:/Quanti:.com/docs/destinations/bigquery/#rolesandpermissions).

#### (Optional) VPC service perimeter configuration[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#optionalvpcserviceperimeterconfiguration\_1)

If you use a service perimeter to control access to BigQuery, you must set up a GCP bucket to ingest data from Quanti:.

> NOTE: The bucket must be present in the same location as the dataset location.

**Assign permissions to service account**[**link**](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#assignpermissionstoserviceaccount\_1)

You must give the service account (in the setup form) Storage Object Admin permission for the bucket, so that it can read and write the data from the bucket.

1. In your Google Cloud Console, go [Storage > Browser](https://console.cloud.google.com/storage/browser?\_ga=2.91914202.-115928388.1548358412) to see the list of buckets in your current project.
2. Select the bucket you want to use.
3. Go to Permissions and then click Add Principals.
4. In the Add principals window, enter the Quanti: service account you found in [Step 2](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#findQuanti:serviceaccount) or the service account you created in [Step 3](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#optionalcreateserviceaccount).
5. From the Select a role drop-down, select Storage Object Admin.

**Set the life cycle of objects in the bucket**[**link**](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#setthelifecycleofobjectsinthebucket\_1)

You must set a lifecycle rule so that data older than one day is deleted from your bucket.

1. In your Google Cloud Console, go [Storage > Browser](https://console.cloud.google.com/storage/browser?\_ga=2.91914202.-115928388.1548358412) to see the list of buckets in your current project.
2. In the list, find the bucket you are using for Quanti:, and in the Lifecycle rules column, select its rules.
3. Click Add rule. A detail view will open.
4. In Select object conditions, select Age and enter 1.
5. Click Continue.
6. In Select action, select Delete.
7. Click Continue and then click Save.

#### Complete Quanti: configuration[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#completeQuanti:configuration\_1)

1. Log in to your Quanti: account.
2. Go to the [Destinations page](../content/en/docs/prologue/https:/Quanti:.com/dashboard/destinations/), then click + Add Destination.
3. On the Add destination to your account page, enter a Destination name of your choice.
4. Click Add.
5. Select BigQuery as the destination type.
6. In the destination setup form, enter the Project ID you found in [Step 1](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#findprojectid).
7. (Optional) If you want to use your service account, set the Use own Service Account toggle to ON, and then paste the whole contents of the private key JSON file that you created in [Step 3](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#optionalcreateserviceaccount) into the Service Account Private Key field.
8. Enter the Data Location.
9.  (Optional) If you want to use your GCS bucket to process the data instead of a Quanti:-managed bucket, set the Use GCP Service Parameter toggle to ON, and then enter the Customer Bucket name you configured in [Step 5](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#optionalvpcserviceperimeterconfiguration).

    > NOTE: Make sure that the bucket is present in the same location as the datasets and the service account has Storage Object Admin permission for the bucket.
10. Choose the Data processing location. Depending on the plan you are on and your selected cloud service provider, you may also need to choose a Cloud service provider and cloud region as described in our [Destinations documentation](../content/en/docs/prologue/https:/Quanti:.com/docs/destinations/#instructions\_1).

    > NOTE: To use a [Private Google Access](../content/en/docs/prologue/https:/Quanti:.com/docs/destinations/bigquery/#privateconnectivitytobigquery) connection, choose GCP as the Cloud service provider.
11. Choose your Time zone.
12. (Optional for Business Critical accounts) To enable [regional failover](../content/en/docs/prologue/https:/Quanti:.com/docs/using-Quanti:/features/regional-failover/), set the Use Failover toggle to ON, and then select your Failover Location and Failover Region. Make note of the IP addresses of the secondary region and safelist these addresses in your firewall.
13. Click Save & Test.

Quanti: [tests and validates](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#setuptests) the BigQuery connection. On successful completion of the setup tests, you can sync your data using Quanti: connectors to the BigQuery destination.

#### Setup tests[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#setuptests\_1)

Quanti: performs the following BigQuery connection tests:

* The Connection test checks if we can connect to your BigQuery data warehouse and retrieve a list of the datasets.
* The Check Permissions test validates if we have the required permissions on your data warehouse. The test also checks if billing has been enabled on your account and is not a sandbox account. As part of the test we:
  * create a dataset to check if we have `bigquery.datasets.create` permissions on your data warehouse.
  * create a table in the dataset (`bigquery.tables.create` permissions) and insert a row in the table (`bigquery.tables.updateData` permissions) to check if billing has been enabled.
  * create a job to check if we have `bigquery.jobs.create` permissions.
*   The Bucket Configuration Test verifies if we have the Storage Object Admin permission on your data bucket if you are using your own data bucket to process the data. The test also checks if the bucket is located in the same dataset. We skip this test if you are using a Quanti:-managed bucket.

    > NOTE: The tests may take a couple of minutes to finish running.

***

### Related articles[link](../content/en/docs/prologue/https:/Quanti:.com/integrations/big\_query#relatedarticles\_1)

[description Destination Overview](../content/en/docs/prologue/https:/Quanti:.com/docs/destinations/bigquery/)

[assignment Release Notes](../content/en/docs/prologue/https:/Quanti:.com/docs/destinations/bigquery/changelog/)

[settings API Destination Configuration](../content/en/docs/prologue/https:/Quanti:.com/docs/rest-api/destinations/config/#bigquery)

[home Documentation Home](../content/en/docs/prologue/https:/Quanti:.com/docs/getting-started/)
