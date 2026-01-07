---
description: Follow our setup guide to connect Pennylane to QUANTI.
---

# Pennylane

<a href="https://dbdiagram.io/e/69443722e4bb1dd3a996db63/69443737e4bb1dd3a996dd95" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Pennylane to QUANTI, ensure you have:

* **Pennylane Account**: An active Pennylane account with appropriate access level
* **API Access**: Administrator or Accountant role to generate API credentials
* **Active Company**: At least one company configured in your Pennylane account
* **Financial Data**: Existing invoices, transactions, or accounting data to synchronize

***

## Setup Instructions

{% stepper %}
{% step %}
**Generate API Token**

* Log in to your Pennylane account
* Navigate to **Settings** > **Connectivity** > **data sharing**
* Click on **Generate new API token**
* Copy the generated token immediately (it will only be shown once)
* Store it securely
{% endstep %}

{% step %}
**Connect to QUANTI**

* In QUANTI, click on **Connect to Pennylane**
* Paste your API token in the authentication field
* Click **Validate** to verify the connection
* Select the company you want to synchronize data from
* Click **Next**
{% endstep %}

{% step %}
**Select Pre-built Tables**

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete financial data tracking
* Click **Next**
{% endstep %}

{% step %}
**Finish setup**

* Define a sync period and a lookback window - Click save
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the Sync now button
* Wait for the sync to complete. Then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built Tables

* **analytical\_ledger**: All accounting entries with analytical tags at the most granular level. Includes company information, dates, labels, debit/credit amounts, account details, journal codes, document references, invoice links, third party information, analytical tags, and synchronization timestamps.
* **bank\_accounts**: Bank accounts linked to Pennylane. Contains account details including establishment information, connection type, associated accounting plan items, currency, synchronization status, balance, and timestamps.
* **bank\_transactions**: Bank transactions with execution dates and payment status. Includes transaction details, company and third party information, amounts in EUR and original currency, source, duplicate detection flags, SFTP/EBICS file information, and status indicators.
* **general\_ledger**: All journal entries at the most granular level for comprehensive accounting records. Contains company information, dates, labels, debit/credit amounts, account details, journal codes, document and invoice references, third party information, and creation metadata.
* **companies**: Legal entities with registration details and platform configuration. Includes company name, trade name, registration numbers, VAT details, address information, SaaS plan, accounting settings (cash-based, VAT frequency), fiscal information, activity codes, legal form, and timestamps.
* **company\_users**: Users associated with companies. Contains user identification (email, first name, last name), company association, role, last activity date, accounting firm information, invitation timestamps, and synchronization data.
* **customer\_invoices**: Invoices issued to customers. Includes creation and issue dates, payment deadline, company and customer information, amounts (including and excluding taxes), currency, invoice number, source, payment status, outstanding balance, and timestamps.
* **customers**: Client data with identification and location. Contains customer name, company association, VAT rate, accounting plan items, address details, registration numbers, VAT numbers, activity codes, legal information, and synchronization timestamps.
* **fiscal\_years**: Fiscal year periods. Includes company information, fiscal year dates (start and end), descriptor, closure timestamp, and synchronization data.
* **supplier\_invoices**: Supplier invoices received through various channels. Contains creation and issue dates, payment deadline, company and supplier information, amounts (including and excluding taxes), currency, invoice number, source, payment status, and timestamps.
* **suppliers**: Vendor legal entities. Includes supplier name, company association, VAT rate, accounting plan items, address details, registration numbers, VAT numbers, activity codes, legal information, and synchronization timestamps.
* **tax\_declarations**: Tax declarations submitted to tax authorities. Contains company information, declaration type and form, declaration period dates, status indicators (declaration and payment validation), payment amount, rejection reasons if applicable, and timestamps.

***

<a href="pennylane.md" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Data Refresh**: Pennylane data can be synchronized multiple times per day depending on your subscription plan
* **Historical Data**: Full historical data is available with no API limitations on date ranges
* **Real-time Sync**: For critical financial operations, use manual sync to get the most up-to-date data
* **Currency**: All amounts are stored in the company's default currency as configured in Pennylane
* **VAT Rates**: VAT rates are stored as decimal values (e.g., 0.20 for 20%)
* **Invoice Status**: Invoice statuses include: draft, pending, paid, partially\_paid, late, cancelled
* **Payment Terms**: Payment terms are stored in days (e.g., 30 for "30 days net")
* **API Rate Limits**: Pennylane enforces rate limits on API requests. QUANTI automatically manages these limits to ensure reliable data extraction
* **Accounting Standards**: Data follows French accounting standards (Plan Comptable Général)

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your API token is valid and hasn't expired
* Ensure your Pennylane account has Administrator or Accountant permissions
* Check that API access is enabled in your Pennylane subscription plan
* Verify that the selected company is active in Pennylane

</details>

<details>

<summary>Missing Data</summary>

* Draft invoices may not be synchronized by default
* Archived transactions or documents may be excluded
* Check date filters in your sync configuration
* Some data may require specific Pennylane modules to be activated

</details>

<details>

<summary>Data Discrepancies</summary>

* Ensure all invoices are validated/finalized in Pennylane before sync
* Check that journal entries are posted (not in draft status)
* Verify that the sync period covers the expected date range
* Compare amounts in the base currency if multi-currency is enabled

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
