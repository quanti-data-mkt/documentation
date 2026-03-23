---
description: Frequently asked questions about Google Search Console
---

# Google Search Console — FAQ

***

### Clicks/impressions in Quanti don't match the GSC interface

**Symptom**\
Clicks and impressions totals in Quanti tables differ from what is displayed in the Google Search Console interface, even with identical filters.

**Understanding aggregation methods**

The GSC API exposes two aggregation methods — here is how they map to Quanti tables:

| Method | Quanti tables | Behavior |
|---|---|---|
| `byProperty` | `*_by_site` | Max 1 impression/click per query, even if multiple URLs appear → lower numbers |
| `byPage` | `*_by_page` | 1 impression/click per URL shown in results → higher numbers |

**The GSC interface uses `byProperty` by default** for the global performance graph. The table below the graph switches to `byPage` when the *Pages* dimension is selected.

> ℹ️ To replicate the numbers shown in the GSC interface graph, use the `*_by_site` tables.

**If the discrepancy persists despite using the same aggregation method**

Same aggregation method but still different numbers? Check the following:

* Is the date range strictly identical on both sides?
* Are the filters (country, device, search type) the same?
* Check the GSC property type: a **domain property** aggregates subdomains, a **URL prefix property** does not.

**Reference**: [How Search Console data is calculated](https://support.google.com/webmasters/answer/6155685)
