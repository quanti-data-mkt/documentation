---
description: >-
  The raw_hits table is a event scope table. It records all incoming tag calls
  whatever their type (page_view or event).
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

# Table raw\_hits

<mark style="background-color:purple;">Syncing</mark>

Les hits apparaissent dans la table raw\_hits une fois que la session à laquelle ils appartiennent, a expiré. Soit après une période d'inactivité de 30minutes suivant le dernier hit.

***

## <mark style="background-color:purple;">Table Diagram (ERD)</mark>

{% embed url="https://docs.google.com/presentation/d/13HhIjItxg_pbIgJoKtM03njw2YpWU-J1guYn4bJeTT4/edit?usp=sharing" %}

***

## <mark style="background-color:purple;">Fields description</mark>

