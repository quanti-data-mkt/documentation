---
title: "Big Query dataware House | Quanti Setup Guide"
description: "Follow our setup guide to connect your BigQuery data warehouse to QUANTI:"
lead: "Doks is a Hugo theme for building secure, fast, and SEO-ready documentation websites, which you can easily update and customize."
date: 2020-10-06T08:48:57+00:00
lastmod: 2020-10-06T08:48:57+00:00
draft: false
images: []
menu:
  docs:
    parent: "prologue"
weight: 100
toc: true
---

Follow our setup guide to connect your BigQuery data warehouse to Fivetran.

> NOTE: This is a BigQuery setup guide. For instructions on Fivetran-managed BigQuery, see our [Managed BigQuery documentation](https://fivetran.com/docs/destinations/bigquery/managed-bigquery).

* * * * *

Prerequisites[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#prerequisites_1)
-----------------------------------------------------------------------------------------------------------------------------------------

To connect BigQuery to Fivetran, you need the following:

-   A BigQuery account or a Google Apps account
-   Fivetran role with the [Create Destinations or Manage Destinations](https://fivetran.com/docs/using-fivetran/fivetran-dashboard/account-management/role-based-access-control#destinationpermissions) permissions

> NOTE: Fivetran doesn't support BigQuery sandbox accounts.

* * * * *

Setup instructions[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#setupinstructions_1)
--------------------------------------------------------------------------------------------------------------------------------------------------

### Find Project ID[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#findprojectid_1)

You need to grant Fivetran access to your BigQuery cluster so we can create and manage tables for your data, and periodically load data into those tables.

1.  Go to your Google Cloud Console's [projects list](https://console.cloud.google.com/cloud-resource-manager?pli=1).

2.  Find your project on the list and make a note of the project ID in the ID column. You will need it to configure Fivetran.

    ![Project ID](https://fivetran.com/static-assets-docs/_next/static/media/project-id.650063a1.png)

### Find Fivetran service account[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#findfivetranserviceaccount_1)

1.  Log in to your Fivetran account.

2.  Go to the [Destinations page](https://fivetran.com/dashboard/destinations), and then click Add destination.

3.  In the pop-up window, enter a Destination name of your choice.

4.  Click Add.

5.  Select BigQuery as the destination type.

6.  Enter the Project ID you found in [Step 1](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#findprojectid).

7.  Make a note of the Fivetran service account. You will need to grant it permissions in BigQuery.

    ![Service Account](https://fivetran.com/static-assets-docs/_next/static/media/service-account.9ef9d4be.png)

### (Optional) Create service account[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#optionalcreateserviceaccount_1)

If you want to use your service account to control access to BigQuery, instead of the Fivetran-managed service account, you must create a service account. For more information, see [Google's Creating a service account documentation](https://cloud.google.com/iam/docs/creating-managing-service-accounts#creating).

[Follow Google's service key instructions](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating) to create a private key in JSON format for your service account. Make a note of the private key. You will need it to configure Fivetran. The private key should have the following format:

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

### Configure service account[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#configureserviceaccount_1)

1.  Go back to the IAM & admin tab, and go to the [project principals list](https://console.cloud.google.com/iam-admin/iam/project).

2.  Select + GRANT ACCESS.

    ![Add IAM User](https://fivetran.com/static-assets-docs/_next/static/media/new-grant-access.3ac27cce.png)

3.  In the New Principals field, enter the Fivetran service account you found in [Step 2](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#findfivetranserviceaccount) or the service account you created in [Step 3](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#optionalcreateserviceaccount). The service account is the entire email address.

    ![Add Fivetran Service Account](https://fivetran.com/static-assets-docs/_next/static/media/AddServiceAccount.01c764f1.png)

4.  Click Select a role > BigQuery > BigQuery User.

    ![Add Fivetran Service Account](https://fivetran.com/static-assets-docs/_next/static/media/SelectRole.a478f322.png)

    > NOTE: For more information about roles, see [our documentation](https://fivetran.com/docs/destinations/bigquery#rolesandpermissions).

### (Optional) VPC service perimeter configuration[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#optionalvpcserviceperimeterconfiguration_1)

If you use a service perimeter to control access to BigQuery, you must set up a GCP bucket to ingest data from Fivetran.

> NOTE: The bucket must be present in the same location as the dataset location.

#### Assign permissions to service account[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#assignpermissionstoserviceaccount_1)

You must give the service account (in the setup form) Storage Object Admin permission for the bucket, so that it can read and write the data from the bucket.

1.  In your Google Cloud Console, go [Storage > Browser](https://console.cloud.google.com/storage/browser?_ga=2.91914202.-115928388.1548358412) to see the list of buckets in your current project.

2.  Select the bucket you want to use.

    ![select_gcs_bucket](https://fivetran.com/static-assets-docs/_next/static/media/select_gcs_bucket.4ad12321.png)

3.  Go to Permissions and then click Add Principals.

    ![select_permission_and_add_members](https://fivetran.com/static-assets-docs/_next/static/media/select_permission.b5973b43.png)

4.  In the Add principals window, enter the Fivetran service account you found in [Step 2](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#findfivetranserviceaccount) or the service account you created in [Step 3](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#optionalcreateserviceaccount).

5.  From the Select a role drop-down, select Storage Object Admin.

    ![add_member_and_give_storage_object_admin_permission](https://fivetran.com/static-assets-docs/_next/static/media/storage_object_admin_permission.2c26e0a3.png)

#### Set the life cycle of objects in the bucket[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#setthelifecycleofobjectsinthebucket_1)

You must set a lifecycle rule so that data older than one day is deleted from your bucket.

1.  In your Google Cloud Console, go [Storage > Browser](https://console.cloud.google.com/storage/browser?_ga=2.91914202.-115928388.1548358412) to see the list of buckets in your current project.

2.  In the list, find the bucket you are using for Fivetran, and in the Lifecycle rules column, select its rules.

    ![Select_Bucket's_lifecycle_rule](https://fivetran.com/static-assets-docs/_next/static/media/bucket_life_cycle.13c7ef0a.png)

3.  Click Add rule. A detail view will open.

4.  In Select object conditions, select Age and enter 1.

5.  Click Continue.

    ![Set_age_of_object](https://fivetran.com/static-assets-docs/_next/static/media/set_object_lifecycle_rule.58bd4bd7.png)

6.  In Select action, select Delete.

7.  Click Continue and then click Save.

    ![Set_action_of_object](https://fivetran.com/static-assets-docs/_next/static/media/set_object_lifecycle_rule_2.abd031f2.png)

### Complete Fivetran configuration[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#completefivetranconfiguration_1)

1.  Log in to your Fivetran account.
2.  Go to the [Destinations page](https://fivetran.com/dashboard/destinations), then click + Add Destination.
3.  On the Add destination to your account page, enter a Destination name of your choice.
4.  Click Add.
5.  Select BigQuery as the destination type.
6.  In the destination setup form, enter the Project ID you found in [Step 1](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#findprojectid).
7.  (Optional) If you want to use your service account, set the Use own Service Account toggle to ON, and then paste the whole contents of the private key JSON file that you created in [Step 3](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#optionalcreateserviceaccount) into the Service Account Private Key field.
8.  Enter the Data Location.
9.  (Optional) If you want to use your GCS bucket to process the data instead of a Fivetran-managed bucket, set the Use GCP Service Parameter toggle to ON, and then enter the Customer Bucket name you configured in [Step 5](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#optionalvpcserviceperimeterconfiguration).

    > NOTE: Make sure that the bucket is present in the same location as the datasets and the service account has Storage Object Admin permission for the bucket.

10. Choose the Data processing location. Depending on the plan you are on and your selected cloud service provider, you may also need to choose a Cloud service provider and cloud region as described in our [Destinations documentation](https://fivetran.com/docs/destinations#instructions_1).

    > NOTE: To use a [Private Google Access](https://fivetran.com/docs/destinations/bigquery#privateconnectivitytobigquery) connection, choose GCP as the Cloud service provider.

11. Choose your Time zone.
12. (Optional for Business Critical accounts) To enable [regional failover](https://fivetran.com/docs/using-fivetran/features/regional-failover), set the Use Failover toggle to ON, and then select your Failover Location and Failover Region. Make note of the IP addresses of the secondary region and safelist these addresses in your firewall.
13. Click Save & Test.

Fivetran [tests and validates](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#setuptests) the BigQuery connection. On successful completion of the setup tests, you can sync your data using Fivetran connectors to the BigQuery destination.

### Setup tests[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#setuptests_1)

Fivetran performs the following BigQuery connection tests:

-   The Connection test checks if we can connect to your BigQuery data warehouse and retrieve a list of the datasets.

-   The Check Permissions test validates if we have the required permissions on your data warehouse. The test also checks if billing has been enabled on your account and is not a sandbox account. As part of the test we:

    -   create a dataset to check if we have `bigquery.datasets.create` permissions on your data warehouse.
    -   create a table in the dataset (`bigquery.tables.create` permissions) and insert a row in the table (`bigquery.tables.updateData` permissions) to check if billing has been enabled.
    -   create a job to check if we have `bigquery.jobs.create` permissions.
-   The Bucket Configuration Test verifies if we have the Storage Object Admin permission on your data bucket if you are using your own data bucket to process the data. The test also checks if the bucket is located in the same dataset. We skip this test if you are using a Fivetran-managed bucket.

    > NOTE: The tests may take a couple of minutes to finish running.

* * * * *

Related articles[link](https://fivetran.com/integrations/big_query?groupId=admirable_durability&unsaved=false&testing=false#relatedarticles_1)
----------------------------------------------------------------------------------------------------------------------------------------------

[description Destination Overview](https://fivetran.com/docs/destinations/bigquery)

[assignment Release Notes](https://fivetran.com/docs/destinations/bigquery/changelog)

[settings API Destination Configuration](https://fivetran.com/docs/rest-api/destinations/config#bigquery)

[home Documentation Home](https://fivetran.com/docs/getting-started)
