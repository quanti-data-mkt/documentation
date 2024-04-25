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
