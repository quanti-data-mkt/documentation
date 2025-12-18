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
#### Generate API Token

* Log in to your Pennylane account
* Navigate to **Settings** > **Integrations** > **API**
* Click on **Generate new API token**
* Copy the generated token immediately (it will only be shown once)
* Store it securely
{% endstep %}

{% step %}
#### Connect to QUANTI

* In QUANTI, click on **Connect to Pennylane**
* Paste your API token in the authentication field
* Click **Validate** to verify the connection
* Select the company you want to synchronize data from
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended: Keep all tables enabled for complete financial data tracking
* Click **Next**
{% endstep %}

{% step %}
#### Finish setup

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

* **Customers**: Customer information including company details, contact information, billing addresses, and customer identifiers.
* **Suppliers**: Supplier information including company details, contact information, payment terms, and supplier identifiers.
* **Customer\_invoices**: Sales invoices issued to customers with invoice details, amounts, tax information, payment status, and due dates.
* **Supplier\_invoices**: Purchase invoices received from suppliers with invoice details, amounts, tax information, payment status, and due dates.
* **Customer\_invoice\_lines**: Detailed line items for customer invoices including products, quantities, unit prices, VAT rates, and amounts.
* **Supplier\_invoice\_lines**: Detailed line items for supplier invoices including products, quantities, unit prices, VAT rates, and amounts.
* **Products**: Product catalog with descriptions, pricing, VAT rates, and accounting classifications.
* **Transactions**: Bank transactions synchronized from connected bank accounts including transaction dates, amounts, labels, and categories.
* **Chart\_of\_accounts**: Complete chart of accounts with account numbers, names, types, and hierarchical structure.
* **Journal\_entries**: Accounting journal entries with posting dates, descriptions, and reference documents.
* **Journal\_entry\_lines**: Detailed line items for journal entries including accounts, debits, credits, and analytical allocations.

***

<a href="https://dbdiagram.io/e/69443722e4bb1dd3a996db63/69443737e4bb1dd3a996dd95" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

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
