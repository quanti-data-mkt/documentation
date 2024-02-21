---
title: "Big Query Data Warehouse setup"
description: "Follow our setup guide to connect QUANTI: to BigQuery"
lead: ""
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "prologue"
weight: 110
toc: true
---

*Last update : 2024-02-16*

Follow our setup guide to connect QUANTI: to BigQuery

* * * * *

Prerequisites
----------------------------------------------------------------------------------------------------------------------------------------------------

To connect QUANTI: to BigQuery, you need an [Google Cloud Platform](https://cloud.google.com/gcp) account.

* * * * *

Setup instructions
-------------------------------------------------------------------------------------------------------------------------------------------------------------

### Quanti: configuration

1.  In the connector setup form, enter a distinctive name of your choice.
2.  Select your sector category and company size.
3.  Enter your BigQuery projet ID. You can find it by clicking in the selection field on the header of your BigQuery UI.
</br><img src="bigquery1.png" style="width:100%;" />
4.  Select your Data Location. The physical place where QUANTI: will use to deposit your datas.
5.  Click Next.

### Service Account configuration

In this step, copy the service account email adresse provided by QUANTI: and follow the steps bellow:
1.  Go on IAM & Admin product on BigQuery UI. Click on icon Menu < IAM & Admin < IAM
</br><img src="bigquery2.png" style="width:400px;" />
2.  Click on GRANT ACCESS button.
</br><img src="bigquery3.png" style="width:100%;" />
3.  Copy/ paste the service account email adresse, assign roles bellow and click Save :
- Browser
- Bigquery Admin
- Storage Admin
</br><img src="bigquery4.png" style="width:400px;" />
4.  In QUANTI: UI, click Next Button to launch the connections tests.