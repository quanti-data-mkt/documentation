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

***

### Sync fails with error 403 "Search Analytics load quota exceeded"

**Symptom**\
A sync returns the following error:

```
analytics request failed for web: HTTP 403: Search Analytics load quota exceeded.
```

**Explanation**\
The Google Search Console API enforces request rate limits on the Search Analytics endpoint. When a sync triggers too many requests in a short window — typically when syncing multiple properties, multiple report types, or a large date range simultaneously — the quota is exceeded and the API returns a 403 error.

The applicable limits are:

| Scope | Limit |
|---|---|
| Per site | 1,200 requests/minute |
| Per user | 1,200 requests/minute |
| Per GCP project | 40,000 requests/minute / 30,000,000 requests/day |

**What to do**

The sync will be retried automatically by Quanti on the next scheduled run. If the error persists:

* Reduce the number of report types enabled on the connector — deselect tables you don't need
* Increase the sync interval to reduce concurrent load
* If you have multiple GSC connectors on the same GCP project, stagger their sync schedules

**Reference**: [Google Search Console API usage limits](https://developers.google.com/webmaster-tools/limits?hl=fr#qps-quota)
