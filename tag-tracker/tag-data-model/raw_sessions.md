---
description: >-
  The raw_sessions table is a "session" scope table. It records every sessions
  of all users, which are defined by a succession of events within a given time.
---

# raw\_sessions

***

## <mark style="background-color:purple;">Syncing</mark>

The new sessions appear in the `raw_sessions` table once the session has expired, which occurs after a **30-minute** period of inactivity following the last hit.

***

[Tables and definition](https://dbdiagram.io/e/67bf2e04263d6cf9a08d27a6/67c08ae8263d6cf9a0b33078) :link:[ ](https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8)

<figure><img src="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8" alt=""><figcaption></figcaption></figure>

<figure><img src="../../.gitbook/assets/Capture d’écran 2025-02-07 à 11.45.23.png" alt="https://dbdiagram.io/e/65c0ca08ac844320ae7740d3/67a5e256263d6cf9a06049b8"><figcaption><p>Source : <a href="https://dbdiagram.io/e/67bf2e04263d6cf9a08d27a6/67c08ae8263d6cf9a0b33078">https://dbdiagram.io/e/67bf2e04263d6cf9a08d27a6/67c08ae8263d6cf9a0b33078</a></p></figcaption></figure>

***

## <mark style="background-color:purple;">Fields definition</mark>

### datetime&#x20;

Date and time of the start of the session. The datetime of a session is calculated from `raw_hits` table: Quanti: takes the datetime's value from session's first hit.

### session\_id

**Unique session identifier**. A session (also called visit) is a set of events from the same visitor within a given amount of time. It ends when the tag does not record any events for 30 minutes. **session\_id** is automatically created by Quanti:. A visitor can make multiple sessions. **session\_id** can be overridable

### visitor\_id

**Unique visitor identifier**. Automatically created by Quanti: based on the value of the cookie placed on the user's browser, by the tag itself. One visitor = one browser. A visitor can make multiple hits and sessions. Its value is overridable if needed.

### user\_id

**Unique user identifier** from the client / contact base. This identifier has to be specified in the tag. It is typically based on a hashed version of the user's email address (using **SHA256**, for example).\
The **user\_id** of a session is calculated from `raw_hits` table. Quanti: takes the last known value  (different from `empty` or `null` values).

{% hint style="info" %}
A user (identified by a **user\_id**) can make sessions (identified by multiple **session\_id**) on multiple devices, and as a result, several browsers (identified by different **visitors\_id**). For each user, pages and events are recorded  (identified by different **hit\_id**).
{% endhint %}

<figure><img src="../../.gitbook/assets/userr.jpg" alt="Explanation of the Different Types of Identifiers"><figcaption><p>Explanation of the Different Types of Identifiers</p></figcaption></figure>

### device\_type

The type of the device used to navigate. 3 possible choices: **desktop**, **mobile**, or **tablet**. The device\_type of a session is calculated from the `raw_hits` table. For each session, the value is taken from the last hit.

### landing\_url

**First** page of a session. The landing\_url of a session is calculated from `raw_hits` table.

### exit\_url

Last page of a session. The exit\_url of a session is calculated from `raw_hits` table.&#x20;

### s\_source

The s\_source field is the traffic source of a session. It is calculated from `raw_hits` table. Quanti: applies rules to determine its value based on information contained in the [url field](raw_hits.md#url) and the [referrer field](raw_hits.md#referrer) of session's **first** hit.

{% hint style="info" %}
To learn more about **Campaign parameters calculated rules**, read this [attribution calculated rules](../rules-for-calculated-attribution.md).
{% endhint %}

### s\_medium

The s\_medium field is the traffic medium of a session. It is calculated from `raw_hits` table. Quanti: applies rules to determine its value based on information contained in the [url field](raw_hits.md#url) and [referrer field](raw_hits.md#referrer) of session's first hit.

{% hint style="info" %}
To learn more about **Campaign parameters calculated rules**, read this [article](../rules-for-calculated-attribution.md).
{% endhint %}

### s\_campaign

The s\_campaign of a session is calculated from `raw_hits` table. Quanti: extract value of **utm\_campaign** parameter of session's first hit.

### s\_content

The s\_content of a session is calculated from `raw_hits` table. Quanti: extract value of **utm\_content** parameter of session's first hit.

### s\_keyword

The s\_keyword of a session is calculated from `raw_hits` table. Quanti: extract value of **utm\_term** parameter of session's first hit.

### s\_utm\_id

The s\_keyword of a session is calculated from `raw_hits` table. Quanti: extract value of **utm\_id** parameter of session's first hit.

### s\_consent

The value of consent given by the user upon arrival through your consent management platform. The s\_consent of a session is calculated from `raw_hits` table. Quanti: keeps the last value known from session's hits.

### s\_referrer

The referrer is the visitor's originating page, or in other words, the page that precedes the opening of the session. The s\_referrer of a session is calculated from `raw_hits` table: Quanti: takes the [referrer](raw_hits.md#referrer)'s value from session's first hit.

### page\_views

The number of page views counted during the session.

### events

The number of events counted during the session.

### total\_conversions

The number of conversions counted during the session.

### total\_conversion\_values

The sum of conversions values counted during the session.

### account\_id

Unique account identifier given by Quanti: during tag creation. It can't be modified.

### s\_ad\_user\_data

Calculated from the `raw_hits` table. For each session, we keep the last known value.

### s\_ad\_personalization

Calculated from the `raw_hits` table. For each session, we keep the last known value.

### s\_ad\_storage

Calculated from the `raw_hits` table. For each session, we keep the last known value.

### s\_analytics\_storage

Calculated from the `raw_hits` table. For each session, we keep the last known value.

