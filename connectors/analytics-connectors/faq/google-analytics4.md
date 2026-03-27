---
description: Frequently asked questions about Google Analytics 4
---

# Google Analytics 4 — FAQ

***

### Why do I see `(data not available)` or `(not set)` as source values in my acquisition report?

**`(data not available)`** — This value appears when GA4 has not yet finalized attribution processing for recent sessions. Google typically takes 2 to 3 days to fully process acquisition data. During that window, affected rows are returned with `(data not available)` as a placeholder and are corrected retroactively once processing is complete.

For this correction to apply in your BigQuery table, two conditions must be met:
- The connector must have a **lookback window of at least 3 days**
- The insertion method must be **REPLACE or UPSERT** — with an INSERT-only setup, rows containing `(data not available)` are never overwritten

**`(not set)`** — GA4 has no attribution information for these sessions at all. This is permanent and will not change over time. Common causes: direct traffic (URL typed manually or via bookmark), referrer blocked by the browser, or events imported without acquisition context.

Neither value originates from Quanti — the connector returns data exactly as exposed by the GA4 Data API.
