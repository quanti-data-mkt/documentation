---
description: Follow our setup guide to connect Stripe to QUANTI.
---

# Stripe

<a href="https://dbdiagram.io/e/698c5794bd82f5fce25fed7f/698c5875bd82f5fce26009fe" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting Stripe to QUANTI, ensure you have:

* **Stripe Account**: An active Stripe account (Standard or Express)
* **API Access**: Administrator access to your Stripe Dashboard
* **API Keys**: Ability to generate restricted API keys with read permissions
* **Live Mode**: For production data, ensure you're using live mode API keys (test mode is also supported for development)

***

## Setup Instructions

{% stepper %}
{% step %}
#### Generate Stripe API Key

* Log into your [Stripe Dashboard](https://dashboard.stripe.com/)
* Navigate to **Developers** > **API keys**
* Click on **Create restricted key**
* Configure the following read permissions:
  * Customers: Read
  * Payment Intents: Read
  * Products: Read
  * Prices: Read
  * Refunds: Read
  * Disputes: Read
  * Subscriptions: Read
  * Setup Intents: Read
  * Shipping Rates: Read
  * Orders: Read (if using Order Returns)
* Name your key (e.g., "QUANTI Integration")
* Copy and securely store the generated API key
{% endstep %}

{% step %}
#### Connect to QUANTI

* In QUANTI, navigate to **Connectors**
* Select **Stripe** from the available connectors
* Paste your Stripe API key in the authentication field
* Choose your environment:
  * **Live mode**: For production data
  * **Test mode**: For development and testing
* Click **Verify Connection**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended tables for most use cases:
  * **Customers**: Customer master data
  * **Payment Intents**: All payment transactions
  * **Subscriptions**: Recurring revenue tracking
  * **Refunds**: Refund analysis
* Click **Next**
{% endstep %}

{% step %}
#### Finish setup

* Define a sync period and a lookback window
* Click **Save**
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete. Then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built Tables

### Dimension Tables

* **customers**: Customer master data including billing information, shipping addresses, discounts, and balance. Contains customer profile, contact details, default payment methods, and tax information.
* **products**: Product catalog with descriptions, pricing information, shipping dimensions, and tax codes. Includes product images, URLs, and metadata for flexible categorization.
* **prices**: Pricing plans for products, including one-time and recurring billing schemes. Defines currency, billing intervals, tiers, and trial periods for subscription products.
* **shipping\_rates**: Configured shipping rates with delivery estimates, pricing (fixed or dynamic), and tax behavior. Used for e-commerce order fulfillment.
* **subscription\_items**: Individual line items within subscriptions, linking prices to subscriptions. Tracks quantity, billing thresholds, and usage-based billing configuration.

### Fact Tables

* **payment\_intents**: Complete payment transaction lifecycle including amounts, statuses (succeeded, failed, canceled), payment methods, and customer references. Core table for revenue analysis and payment tracking.
* **refunds**: Refund transactions with amounts, reasons, statuses, and references to original payment intents. Essential for refund analysis and revenue adjustments.
* **disputes**: Payment disputes and chargebacks with amounts, reasons, statuses, evidence submission deadlines, and associated charges. Critical for fraud monitoring and dispute management.
* **subscriptions**: Subscription lifecycle data including billing cycles, trial periods, cancellation dates, and renewal information. Key for MRR (Monthly Recurring Revenue) analysis.
* **setup\_intents**: Payment method setup attempts for future charges, including status tracking and error details. Used to analyze payment method onboarding success rates.
* **setup\_attempts**: Individual attempts to set up payment methods, with detailed error information and success/failure tracking. Useful for optimizing payment method collection flows.
* **order\_returns**: Product returns linked to orders (Beta API), including amounts, currencies, and refund references. For e-commerce return analysis.
* **usage\_record\_summaries**: Aggregated usage data for metered billing subscriptions, tracking total usage per billing period. Essential for usage-based revenue reporting.

***

<a href="https://dbdiagram.io/e/698c5794bd82f5fce25fed7f/698c5875bd82f5fce26009fe" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Notes

* **Historical Data**: Stripe's API provides access to all historical data without date limitations. However, initial syncs of large datasets may take several hours.

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify your API key is correct and has not been revoked
* Ensure the API key has the required read permissions for all selected tables
* Check that you're using the correct mode (test vs live) matching your API key
* Confirm your Stripe account is active and not restricted

</details>

<details>

<summary>Missing Data</summary>

* Some objects may be filtered by Stripe's API based on account configuration
* Verify the date range for your sync includes the expected time period

</details>

<details>

<summary>Sync Performance</summary>

* Large datasets (millions of records) may require several hours for initial sync
* Consider reducing the lookback period for faster incremental syncs
* Deselect unused tables to improve sync performance

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

For Stripe-specific API questions, refer to [Stripe's official documentation](https://stripe.com/docs/api)

</details>
