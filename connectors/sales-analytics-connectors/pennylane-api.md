---
description: 'Follow our setup guide to connect Pennylane to QUANTI: via the public REST API'
---

# Pennylane API

{% hint style="info" %}
This connector uses the [Pennylane public REST API](https://pennylane.readme.io/docs/oauth-20-walkthrough) with **OAuth2** authentication. It is distinct from the **Pennylane** connector (which uses Redshift Data Sharing) and targets clients who prefer or require API access. One connection = one Pennylane company.
{% endhint %}

***

## Overview

The Pennylane API connector centralizes your accounting and financial data into your data warehouse. It covers the full accounting scope accessible via the Pennylane REST API: ledger entries, invoices, bank transactions, customers, suppliers, bank accounts, fiscal years, and analytical tags.

Data is split into two types:

* **Dimension tables** (append-only) — reference data fetched in full on every run: `companies`, `fiscal_years`, `customers`, `suppliers`, `bank_accounts`, `tags`
* **Transaction tables** (delete-insert on `_quanti_date`) — fact data fetched day by day using a lookback window: `bank_transactions`, `customer_invoices`, `supplier_invoices`, `general_ledger`, `analytical_ledger`

{% hint style="warning" %}
**`_quanti_date` semantics differ from the Pennylane (Redshift) connector.** On this connector, `_quanti_date` maps to the **accounting or issue date** (the date field used as the API filter), not the record creation timestamp. A migration from the Redshift connector may produce gaps or overlaps on historical data for ledger and invoice tables.
{% endhint %}

***

## Prerequisites

* An active **Pennylane account** with at least one company configured
* A user role of **Administrator** or **Accountant** in the target company

No API token or manual credential generation is required — authentication is handled via OAuth2.

***

## Setup Instructions

{% stepper %}
{% step %}
**Authorize your Pennylane account**

Click **Continue with Pennylane**. You will be redirected to Pennylane to authorize QUANTI: to access your accounting data in read-only mode.

QUANTI: requests the following scopes: `fiscal_years`, `customers`, `suppliers`, `bank_accounts`, `transactions`, `customer_invoices`, `supplier_invoices`, `ledger_entries`, `journals`, `categories` — all read-only.

{% hint style="info" %}
**Refresh token rotation**: Pennylane invalidates the refresh token on every use and issues a new one. QUANTI: automatically persists the new token after each renewal — no manual re-authorization is needed as long as runs occur at least once every 90 days.
{% endhint %}
{% endstep %}

{% step %}
**Select your Prebuilt reports**

Choose which tables to activate. You can enable all reports or select only those relevant to your use case. See the [Prebuilt Reports](#prebuilt-reports) section for a description of each table.
{% endstep %}

{% step %}
**Name your connector**

Give the connector a unique name within your QUANTI: project, then click **Create**.
{% endstep %}
{% endstepper %}

***

## Prebuilt Reports

The connector provides **11 tables** grouped into dimensions and transaction tables.

### Reference tables (append-only)

Reference data is always fetched in full — there is no date filter on these endpoints.

#### `companies`

The Pennylane company the connection is scoped to. Populated from `GET /me` — Pennylane's public API has no company list or detail endpoint, so this table only contains the three fields exposed on the current user's company.

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Company identifier (quantiId) |
| `name` | STRING | Company legal name |
| `registration_number` | STRING | SIREN/SIRET or local equivalent |

#### `fiscal_years`

Fiscal year periods defined in Pennylane. Used as a reference for scoping accounting reports to an open or closed exercise.

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Fiscal year identifier (quantiId) |
| `start_date` | DATE | Start date of the fiscal year |
| `end_date` | DATE | End date of the fiscal year |
| `status` | STRING | `open`, `reopen`, `closed`, or `frozen` |
| `created_at` | TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

#### `customers`

All client records declared in Pennylane, fetched in full on every run.

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Customer identifier (quantiId) |
| `name` | STRING | Customer name |
| `customer_type` | STRING | `company` or `individual` |
| `ledger_account_id` | INTEGER | Linked ledger account identifier |
| `registration_number` | STRING | SIREN/SIRET or equivalent |
| `vat_number` | STRING | VAT number |
| `postal_code` | STRING | Billing address postal code |
| `city` | STRING | Billing address city |
| `country_alpha2` | STRING | Billing address country (ISO 3166-1 alpha-2) |
| `external_reference` | STRING | Reference to an external system (CRM, ERP…) |
| `created_at` | TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

#### `suppliers`

All vendor records declared in Pennylane, fetched in full on every run.

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Supplier identifier (quantiId) |
| `name` | STRING | Supplier name |
| `ledger_account_id` | INTEGER | Linked ledger account identifier |
| `registration_number` | STRING | SIREN/SIRET or equivalent |
| `vat_number` | STRING | VAT number |
| `postal_code` | STRING | Postal address postal code |
| `city` | STRING | Postal address city |
| `country_alpha2` | STRING | Postal address country (ISO 3166-1 alpha-2) |
| `external_reference` | STRING | Reference to an external system |
| `created_at` | TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

#### `bank_accounts`

All bank accounts linked to Pennylane, fetched in full on every run. The `balance` field reflects the current balance at sync time.

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Bank account identifier (quantiId) |
| `name` | STRING | Bank account name |
| `currency` | STRING | Account currency (ISO 4217) |
| `balance` | FLOAT | Current account balance |
| `bank_establishment_id` | INTEGER | Bank establishment identifier |
| `journal_id` | INTEGER | Linked journal identifier |
| `ledger_account_id` | INTEGER | Linked ledger account identifier |
| `created_at` | TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

#### `tags`

Analytical tag assignments on ledger entry lines, one row per `(line, tag)`. A single line can carry multiple weighted analytical tags — this table exposes the full breakdown. Use `analytical_ledger.analytical_code` for the primary tag only.

Fetched incrementally: new lines since `startDate` are added on each run (not a full reload).

| Field | Type | Description |
|---|---|---|
| `analytical_ledger_id` | INTEGER | Ledger entry line this tag belongs to (quantiId, composite with `tag_label` + `tag_group` + `tag_weight`) |
| `tag_label` | STRING | Analytical tag label (quantiId component) |
| `tag_group` | STRING | Analytical tag group label, resolved from the `category_groups` dictionary (quantiId component) |
| `tag_weight` | FLOAT | Share of the line amount allocated to this tag, between 0 and 1 (quantiId component) |

***

### Transaction tables (delete-insert on `_quanti_date`)

Transaction tables are partitioned by date and refreshed using a lookback window. The `_quanti_date` column maps to the **accounting or issue date** used as the API filter — not the record creation timestamp.

#### `bank_transactions`

Bank transactions from all connected bank accounts. `_quanti_date` = `execution_date` (transaction date as recorded by the bank).

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Transaction identifier (quantiId) |
| `execution_date` | DATE | Transaction date (`_quanti_date`) |
| `label` | STRING | Transaction label |
| `amount` | FLOAT | Transaction amount in the account currency (positive = credit, negative = debit) |
| `currency` | STRING | Account currency (ISO 4217) |
| `currency_amount` | FLOAT | Amount in the original transaction currency (for foreign currency transactions) |
| `outstanding_balance` | FLOAT | Bank account balance after this transaction |
| `bank_account_id` | INTEGER | Bank account identifier — join to `bank_accounts.id` |
| `customer_id` | INTEGER | Matched customer identifier, if Pennylane has reconciled this transaction — join to `customers.id` |
| `supplier_id` | INTEGER | Matched supplier identifier, if Pennylane has reconciled this transaction — join to `suppliers.id` |
| `archived_at` | TIMESTAMP | Archival timestamp — null if not archived |
| `created_at` | TIMESTAMP | Record creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

#### `customer_invoices`

Invoices issued to customers. `_quanti_date` = `issue_date` (the invoice date, not the creation date in Pennylane).

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Invoice identifier (quantiId) |
| `issue_date` | DATE | Invoice issue date (`_quanti_date`) |
| `deadline` | DATE | Payment deadline |
| `customer_id` | INTEGER | Customer identifier — join to `customers.id` |
| `invoice_number` | STRING | Invoice number as displayed in Pennylane |
| `label` | STRING | Invoice label |
| `amount` | FLOAT | Total invoice amount, tax included, in `currency` |
| `tax` | FLOAT | Total tax amount |
| `currency` | STRING | Invoice currency (ISO 4217) |
| `status` | STRING | Invoice status: `draft`, `pending`, `paid`, `partially_paid`, `late`, `cancelled` |
| `is_paid` | BOOLEAN | Whether the invoice is fully paid |
| `is_draft` | BOOLEAN | Whether the invoice is still a draft |
| `outstanding_balance` | FLOAT | Remaining amount to be paid, tax included |
| `external_reference` | STRING | Reference to an external system (order ID, CRM deal…) |
| `created_at` | TIMESTAMP | Record creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

{% hint style="info" %}
`amount` is always in the invoice `currency`. The Pennylane API does not expose an EUR-converted amount for foreign-currency invoices — for multi-currency analysis, apply your own exchange rate conversion.
{% endhint %}

#### `supplier_invoices`

Invoices received from suppliers. `_quanti_date` = `issue_date` (the invoice date).

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Invoice identifier (quantiId) |
| `issue_date` | DATE | Invoice issue date (`_quanti_date`) |
| `deadline` | DATE | Payment deadline |
| `supplier_id` | INTEGER | Supplier identifier — join to `suppliers.id` |
| `invoice_number` | STRING | Invoice number |
| `amount` | FLOAT | Total invoice amount, tax included, in `currency` |
| `tax` | FLOAT | Total tax amount |
| `currency` | STRING | Invoice currency (ISO 4217) |
| `payment_status` | STRING | `to_be_paid`, `paid`, or similar |
| `is_paid` | BOOLEAN | Whether the invoice is fully paid |
| `outstanding_balance` | FLOAT | Remaining amount to be paid, tax included |
| `source` | STRING | Import channel: `dropbox`, `email`, `manual`, etc. |
| `external_reference` | STRING | Reference to an external system |
| `created_at` | TIMESTAMP | Record creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |

#### `general_ledger`

All journal entry lines at the most granular level, joined with their parent ledger entries and the journals dictionary. `_quanti_date` = `date` (the accounting date on the line).

The table is built by QUANTI: by joining three API resources: `ledger_entry_lines` (line data), `ledger_entries` (parent document header), and `journals` (resolved in-memory cache). Fields with no API equivalent (`thirdparty_*`, `created_by`, `lettering`) are intentionally absent — see the Pennylane vs Redshift connector note below.

| Field | Type | Description |
|---|---|---|
| `id` | INTEGER | Ledger entry line identifier (quantiId) |
| `date` | DATE | Accounting date (`_quanti_date`) |
| `label` | STRING | Line label |
| `debit` | FLOAT | Debit amount (0 if credit line) |
| `credit` | FLOAT | Credit amount (0 if debit line) |
| `plan_item_number` | STRING | Chart of accounts (Plan Comptable) account number — e.g. `411000` |
| `journal_code` | STRING | Journal code, resolved from the journals dictionary — e.g. `VT`, `ACH` |
| `journal_label` | STRING | Journal label, resolved from the journals dictionary |
| `document_id` | INTEGER | Parent ledger entry identifier — joins lines from the same accounting document |
| `document_label` | STRING | Parent ledger entry label (document header) |
| `invoice_number` | STRING | Related invoice number, if this entry is linked to an invoice |
| `fec_pieceref` | STRING | FEC piece reference (`piece_number`) — used for French regulatory export (FEC) |
| `invoice_link` | STRING | URL of the attached document (invoice PDF or receipt), if any |
| `document_created_at` | TIMESTAMP | Parent ledger entry creation timestamp |
| `document_updated_at` | TIMESTAMP | Parent ledger entry last update timestamp |

#### `analytical_ledger`

All journal entry lines enriched with their **primary analytical tag** and the bounds of their fiscal year. Identical structure to `general_ledger` plus three additional columns. `_quanti_date` = `date`.

For lines with multiple analytical tags, only `categories[0]` (the primary tag) is exposed here — use the `tags` table for the full multi-tag breakdown with weights.

| Field | Type | Description |
|---|---|---|
| *(all `general_ledger` fields)* | — | Same columns as `general_ledger` |
| `analytical_code` | STRING | Primary analytical tag code (`categories[0].analytical_code`) — null if no tag is assigned |
| `fiscal_start_date` | DATE | Start date of the fiscal year containing this entry |
| `fiscal_end_date` | DATE | End date of the fiscal year containing this entry |

***

## Pennylane API vs Pennylane (Redshift)

Two Pennylane connectors are available in QUANTI:. Choose based on your setup:

| | **Pennylane API** (this connector) | **Pennylane** (Redshift) |
|---|---|---|
| Auth | OAuth2 | Redshift Data Sharing credentials |
| Tables | 11 | 13 |
| Missing tables | `company_users`, `tax_declarations` | — |
| `_quanti_date` on ledger/invoices | Accounting / issue date | Record creation date |
| Field count | Fewer (API surface is limited) | More (full Redshift schema) |

`company_users` and `tax_declarations` are not available on this connector — the Pennylane public API does not expose the corresponding endpoints.

***

## Scheduling

| Setting | Options |
|---|---|
| **Frequency** | Daily (recommended) or Weekly |
| **Lookback window** | 1, 3, 5, 7, 14, 30, or 90 days (default: **30 days**) |
| **Historical load** | Up to 3 years (3, 6, or 12 month quick options, or custom date range) |

{% hint style="info" %}
A 30-day lookback is recommended to capture invoices and ledger entries that are entered or modified after their accounting date (e.g. a January invoice entered in February).

Dimension tables (`companies`, `fiscal_years`, `customers`, `suppliers`, `bank_accounts`) are always fetched in full, regardless of the lookback window.
{% endhint %}

***

## Troubleshooting

<details>

<summary>Authentication fails after several weeks — "invalid_grant" or token error</summary>

The OAuth refresh token is valid for 90 days from its last use. If no sync ran for more than 90 days, the token has expired and cannot be renewed automatically. Go to the connector **Settings** tab, disconnect, and reconnect via **Continue with Pennylane** to obtain a new token.

</details>

<details>

<summary>Ledger or invoice data is missing for a specific date range</summary>

The connector fetches data by accounting/issue date using the lookback window. If an entry was created in Pennylane after its accounting date (e.g. a back-dated entry), it will only appear in a run that covers the accounting date. Extend the lookback window to 90 days and trigger a manual sync, or use the historical load to re-fetch the affected date range.

</details>

<details>

<summary>Some fields available in the Pennylane (Redshift) connector are missing here</summary>

The Pennylane public API does not expose all fields available via Redshift Data Sharing. Missing fields include `thirdparty_*`, `created_by`, `lettering` on ledger tables, and most company metadata. These will be added if Pennylane extends its public API. If you need these fields today, use the Pennylane (Redshift) connector instead.

</details>

<details>

<summary>Discrepancy between `general_ledger` totals and Pennylane reports</summary>

Verify that the date range in your query matches the `date` (accounting date) field, not `document_created_at`. Unlike the Redshift connector, `_quanti_date` here is the accounting date. Also check that the lookback window is large enough to capture any back-dated entries entered after your last sync.

</details>

<details>

<summary>Need help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>
