---
title: "RTB House connector"
description: "Follow our setup guide to connect RTB House to QUANTI:"
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

Follow our setup guide to connect RTB House to QUANTI:

* * * * *

Prerequisites
----------------------------------------------------------------------------------------------------------------------------------------------------

To connect RTB House to QUANTI, you need an [RTB House](https://www.rtbhouse.com/) account with API access.

* * * * *

Setup instructions
-------------------------------------------------------------------------------------------------------------------------------------------------------------

### Find Username and Password

1.  Username and Password needed are simply your account credentials used to connect to your RTB House platform.

### Find Advertiser ID

1.  Log in to your [RTB House account](https://panel.rtbhouse.com/#/auth/login).
2.  When you are connected to your account, the advertiser Id is displayed in the url of your search bar after '/dashboard/' and before the '?'.
    https://panel.rtbhouse.com/#/dashboard/__*******__?
3.  Make a note of the advertiser ID. You will need it to configure QUANTI:.

### Conversions counting convention

1. In some cases, it is possible that RTB House count conversions and use some specifics metrics : conversionsCount, ecpa, cr, conversionsValue, roas, ecps
2. This field is usefull only if you are in this case and it is only considered if is needed. If you are not in this case, do not pay attention to it.
2. His default value is 'Attributed'.

### Finish Quanti: configuration

1.  In the connector setup form, enter the name of your choice.
2.  Enter your Account credentials you found in Step 1.
3.  Enter your advertiser ID you found in Step 2.
4.  Click Save & Test. Quanti: will take it from here and sync your RTB House data.

### [Tables](https://dbdiagram.io/d/[RTB-House-connector]-Data-model-65bcd2efac844320ae4e9293)