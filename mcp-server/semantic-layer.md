---
description: >-
  Quanti: syncs Prebuilt reports to simplify data analysis. Let's jump into
  transformations.
hidden: true
---

# Semantic Layer

***

## Why pre-prebuilt transformations ?



QUANTI: manage some transformations, always useful for 100% of our customers.

<figure><img src="../.gitbook/assets/Capture d’écran 2024-05-18 à 09.40.21.png" alt=""><figcaption></figcaption></figure>

## How

This chapter deals with the topic of **transformation** and the aggregation work also called [**RECONCILIATION**](../transformations/the-principle-of-reconciliation.md)**.** This is made possible thanks to:&#x20;

* Perfect knowledge of the specificities of advertising partners' APIs allows us to extract data correctly and centralize their storage in client-dedicated Data Warehouses.
* A method to standardize and harmonize data originally coming from different advertising platforms.
* A method to align navigation data (Site-centric - e.g., Google Analytics 4) with campaign data (Ad-centric - e.g., Meta) to automate the calculation of key performance indicators (e.g., Return On Ads Spend).

<figure><img src="../.gitbook/assets/Capture d’écran 2024-05-15 à 10.38.14.png" alt=""><figcaption><p>Reconciliation = Automatic calculated fields</p></figcaption></figure>

The general idea of this transformation step is to make the data more digestible and more usable for visualization, analysis, and decision-making purposes.

## Prebuilt reports

{% content-ref url="../transformations/pre-built-tables/ads_import.md" %}
[ads\_import.md](../transformations/pre-built-tables/ads_import.md)
{% endcontent-ref %}

{% content-ref url="../transformations/pre-built-tables/ads_import_conv.md" %}
[ads\_import\_conv.md](../transformations/pre-built-tables/ads_import_conv.md)
{% endcontent-ref %}

{% content-ref url="../transformations/pre-built-tables/quanti_ids.md" %}
[quanti\_ids.md](../transformations/pre-built-tables/quanti_ids.md)
{% endcontent-ref %}

## Describing a connected account

Two fields, on the **Reports** tab of any connected account. They are read by the
assistant, not by the pipeline: nothing in your data changes if you leave them
empty — but the answers you get do.

### account_description — What this connected account holds

A sentence describing what this particular account brings in: which perimeter,
which market, which brand.

**Where to find it**

Connector → **Reports** tab → *Description*, at the top of the page. It is saved
per connected account, not per connector.

**Why it matters**

When a project has several accounts of the same connector — two Google Ads
accounts, one per country, or three Google Sheets — the assistant has no way to
tell them apart without this. Asked for "last month's spend", it picks one, and
the figure looks perfectly plausible while being the wrong perimeter. Left empty,
the mistake is silent; filled in, it cannot happen.

### account_purpose — What this account is used for

What the data serves: which decision, which reporting, which team.

**Where to find it**

Connector → **Reports** tab → *Purpose*, just below the description.

**Why it matters**

The description says what the data *is*, the purpose says what it is *for*. The
second is what lets the assistant choose between two accounts that hold similar
data but answer different questions — a paid-media account fed for budget
arbitration, and a second one kept for reconciling invoices.

