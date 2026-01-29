# Data insertion strategies

## Introduction

When synchronizing data from your source platforms to your data warehouse, a fundamental question arises: **how should new data interact with existing data?**

The answer lies in choosing the appropriate **insertion strategy**. This choice determines whether data is added, replaced, or updated, and has direct consequences on data quality, storage costs, and analytical capabilities.

The three insertion strategies Quanti uses:

{% tabs %}
{% tab title="INSERT Mode" %}
* Append new data without deleting anything.

Use case: when you want to keep a full audit trail of every record as ingested, and duplicates are acceptable or deduplicated later.

Advantages: simple, append-only; minimal risk of accidental data loss.

Limitations: can lead to duplicate rows, larger storage needs, and more complex downstream deduplication logic.
{% endtab %}

{% tab title="REPLACE Mode" %}
* Delete existing data within a defined scope, then insert new data.

Use case: when entire partitions or ranges (e.g., a day, a month) should be replaced atomically with refreshed data.

Advantages: ensures the target scope contains only the refreshed data; simpler to reason about for partitioned refreshes.

Limitations: risk of data loss if the replacement is partial or incorrect; can be more disruptive and require careful scoping.
{% endtab %}

{% tab title="UPSERT Mode" %}
* Update existing rows or insert new ones based on the Primary Key.

Use case: when records must be kept up-to-date without duplicating primary-keyed entities.

Advantages: preserves existing rows while applying updates; balances data preservation and correctness.

Limitations: requires a defined primary key and support from the target system; may be more expensive or complex than append-only.
{% endtab %}
{% endtabs %}

{% hint style="info" %}
Quanti automatically selects the most appropriate insertion method for each table in its connectors. The preferred method is **UPSERT Mode**, which offers the best balance between data preservation and updates. However, depending on the nature of the data and business requirements, **INSERT** or **REPLACE** methods may be more suitable.
{% endhint %}

## Why this matters

Understanding insertion strategies is crucial to:

* Comprehend the behavior of your data over time
* Anticipate how updates and corrections are handled
* Identify potential risks (duplicates, data loss, performance issues)
* Make informed decisions when configuring custom connectors
* Troubleshoot data inconsistencies effectively

## What you'll learn

This section provides a detailed explanation of each insertion method, including:

* How each method works technically
* When to use each method
* Advantages and limitations
* Concrete examples with fact and dimension tables
* Impact on data warehouse performance and costs
