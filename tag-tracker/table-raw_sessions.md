---
description: >-
  The raw_sessions table is a session scope table. It records the visits users,
  which are defined by a succession of events within a given time.
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

# Table raw\_sessions

***

## <mark style="background-color:purple;">Syncing</mark>

The new sessions appear in the `raw_sessions` table once the session has expired, which occurs after a 30-minute period of inactivity following the last hit.

***

## <mark style="background-color:purple;">Tables Diagram (ERD)</mark>

{% embed url="https://docs.google.com/presentation/d/13HhIjItxg_pbIgJoKtM03njw2YpWU-J1guYn4bJeTT4" %}
Tag Tracker Tables Diagram
{% endembed %}

***

## <mark style="background-color:purple;">Fields definition</mark>

### datetime&#x20;

Date and time of the beginning of the session. The datetime of a session is calculated from `raw_hits` table: Quanti: takes the [datetime](table-raw\_hits.md#datetime)'s value from session's first hit.

### session\_id

Unique session identifier (can be also called visit). A session is a set of events from the same visitor. It ends when the tag does not record any events for 30 minutes. Session\_id is automatically created by Quanti: from the value of a cookie placed on the user's browser by the tag. A visitor can make multiple sessions. It can be overridable if is needed like in a server-side setup.

### visitor\_id

Unique visitor identifier. Automatically created by Quanti: from the value of a cookie placed on the user's browser by the tag. One visitor = one browser. A visitor can make multiple hits and sessions. It can be overridable if is needed like in a server-side setup.

### user\_id

Unique user identifier which is an individual who has logged into their personal account. This identifier has to be specify in the tag and typically based on a hashed version of the user's email address (using SHA256, for example).\
The user\_id of a session is calculated from `raw_hits` table: Quanti: takes the last value known from session's hits.

{% hint style="info" %}
A user (identified by a user\_id) can have several devices, and therefore several browsers (identified by several visitors\_id). They can have multiple sessions (identified by multiple session\_id) during which they navigate from page to page and record multiple events, event and page\_view (identified by multiple hit\_id).
{% endhint %}

<figure><img src="../.gitbook/assets/userr.jpg" alt="Explanation of the Different Types of Identifiers"><figcaption><p>Explanation of the Different Types of Identifiers</p></figcaption></figure>

### device\_type

The type of device automatically recovered by the tag. 3 possible choices: desktop, mobile, or tablet. The device\_type of a session is calculated from `raw_hits` table: Quanti: takes the [device\_type field](table-raw\_hits.md#device\_type)'s value from session's first hit.

### landing\_url

As its name suggest, it is the landing page of the session. The landing\_url of a session is calculated from `raw_hits` table: Quanti: takes the [url field](table-raw\_hits.md#url)'s value from session's first hit.

### exit\_url

As its name suggest, it is the exit page of the session. The exit\_url of a session is calculated from `raw_hits` table: Quanti: takes the [url field](table-raw\_hits.md#url)'s value from session's last hit.

### s\_source

The s\_source of a session is calculated from `raw_hits` table: Quanti: applies rules to determine its value based on information contained in the [url field](table-raw\_hits.md#url) and [referrer field](table-raw\_hits.md#referrer)  of session's first hit.

To learn more about **Campaign params calculated rules**, read this [article](attribution-calculated-rules.md).

### s\_medium

### s\_campaign

### s\_content

### s\_consent

### s\_keyword

### s\_utmid

### s\_referrer

### page\_views

### events

### total\_conversions

### total\_conversion\_values

### account\_id
