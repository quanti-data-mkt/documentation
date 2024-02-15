---
title: "CJ connector"
description: "Follow our setup guide to connect CJ to QUANTI:"
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

Follow our setup guide to connect CJ to QUANTI:

* * * * *

Prerequisites
----------------------------------------------------------------------------------------------------------------------------------------------------

To connect CJ to QUANTI, you need an [CJ](https://www.cj.com/) account.

* * * * *

Setup instructions
-------------------------------------------------------------------------------------------------------------------------------------------------------------

### Find Advertiser ID

1.  Log in to your [CJ account](https://signin.cj.com/login).
2.  In the top-right corner, you can click on a multi-selection field which permit you to pick your different accounts. The advertiser IDs are the CID near each account name.
</br><img src="cj1.png" style="width:250px;" />
3.  Make a note of the advertiser ID. You will need it to configure QUANTI:.
4.  N.B : With the CJ connector, you will can recover datas from only one advertiser. You have to create several connector if you have several advertiser accounts.

### Find Token

1.  To recover the token needed, no other way that to request it to your account manager.
2.  Make a note of the API token. You will need it to configure QUANTI:.

### Finish Quanti: configuration

1.  In the connector setup form, enter the name of your choice.
2.  Enter the advertiser ID you found in Step 1.
3.  Enter the token you found in Step 2.
3.  Click Save & Test. Quanti: will take it from here and sync your CJ data.

### Tables

Link trought the complete document : [ERD](https://dbdiagram.io/e/655780093be149578736156c/65ce18c5ac844320ae3901e3)
<iframe width="400" height="315" src='https://dbdiagram.io/e/655780093be149578736156c/65ce18c5ac844320ae3901e3'> </iframe>