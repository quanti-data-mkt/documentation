---
description: 'Follow our setup guide to connect RTB House to QUANTI:'
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

# RTB House

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect RTB House to QUANTI, you need an [RTB House](https://www.rtbhouse.com/) account with API access.

***

## <mark style="background-color:blue;">Setup instructions</mark>

### User informations

* **Username** and **Password** of your RTB account

### Advertiser ID

1. Log in to your [RTB House account](https://panel.rtbhouse.com/#/auth/login).
2. When you are connected to your account, the advertiser Id is displayed in the url of your search bar after '/dashboard/' and before the '?'. https://panel.rtbhouse.com/#/dashboard/**\*\*\*\*\*\*\***?
3. Make a note of the advertiser ID. You will need it to configure QUANTI:.

### Conversions counting convention

1. In some cases, it is possible that RTB House count conversions and use some specifics metrics : conversionsCount, ecpa, cr, conversionsValue, roas, ecps
2. This field is usefull only if you are in this case and it is only considered if is needed. If you are not in this case, do not pay attention to it.
3. His default value is 'Attributed'.

### Finish Quanti: configuration

1. In the connector setup form, enter the name of your choice.
2. Enter your Account credentials you found in Step 1.
3. Enter your advertiser ID you found in Step 2.
4. Click Save & Test. Quanti: will take it from here and sync your RTB House data.

***

## <mark style="background-color:blue;">Pre-built Tables</mark>

* rtb\_campaigns\_import
* rtb\_stats\_import

***

## <mark style="background-color:blue;">Tables Diagram (ERD)</mark>

To zoom, open the ERD in a new window : [ERD](https://dbdiagram.io/e/65bcd2efac844320ae4e9293/65ce242eac844320ae3a13b6)
