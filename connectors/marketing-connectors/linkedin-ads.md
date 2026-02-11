---
description: 'Follow our setup guide to connect Linkedin Ads to QUANTI:'
---

# Linkedin Ads

<a href="https://dbdiagram.io/e/682b4daf1227bdcb4eff888a/682b4fa51227bdcb4effdd6c" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Prerequisites

Before connecting LinkedIn Ads to QUANTI, ensure you have:

* **LinkedIn Campaign Manager Access**: You need access to a [LinkedIn Campaign Manager](https://www.linkedin.com/campaignmanager/accounts) account with appropriate permissions
* **Account Manager or Campaign Manager Role**: Sufficient permissions to authorize third-party applications and access campaign data
* **Active Campaigns**: At least one LinkedIn Ads account with campaigns (historical or active)

***

## Setup Instructions

{% stepper %}
{% step %}
#### Authorize LinkedIn Connection

* Click on **Connect to LinkedIn Ads**
* You will be redirected to LinkedIn's authorization page
* Log in with your LinkedIn account credentials (the one with Campaign Manager access)
* Review and accept the requested permissions to allow QUANTI to access your LinkedIn Ads data
* Click **Allow** to grant access
{% endstep %}

{% step %}
#### Configure Connector

* **Connector Name**: Enter a unique name for this connector (e.g., "LinkedIn Ads - North America Campaigns")
* **Dataset ID**: Define the BigQuery dataset ID where data will be stored (will be created automatically if it doesn't exist)
{% endstep %}

{% step %}
#### Select Accounts

* Review the list of LinkedIn Ads accounts accessible with your credentials
* Select the account(s) you want to synchronize
* You can connect multiple accounts by creating separate connectors
* Click **Next**
{% endstep %}

{% step %}
#### Select Pre-built Tables

* Review the available pre-built tables (see section below for details)
* All tables are selected by default - you can deselect tables you don't need
* Recommended configurations:
  * **Basic setup**: Account, Campaign, Creative history + Core performance tables
  * **Advanced setup**: Add demographic breakdown tables for audience analysis
* Click **Next**
{% endstep %}

{% step %}
#### Finish Setup

* Define a sync period and lookback window
* For the first sync, you have the following options:
  * Activate auto-sync for recurring syncs based on your sync settings by clicking the switch button
  * Launch a historical data recovery by choosing your desired dates in the historical data tab
  * Launch a manual sync immediately by clicking the **Sync now** button
* Wait for the sync to complete, then navigate to your data warehouse to verify that tables are populated
* Check the connector dashboard for sync status and any potential errors
{% endstep %}
{% endstepper %}

***

## Pre-built Tables

### Dimension Tables

These tables track the structure and configuration of your LinkedIn Ads account, providing context for performance analysis and enabling audit trails.

* **Account History**: Account-level configuration including currency, account type, notification preferences (campaign optimization, creative approval/rejection, end of campaign alerts), serving statuses, and version tracking. Essential for multi-account management and understanding account-level settings that impact campaign delivery.
* **Campaign Group History**: Campaign group (formerly known as campaigns) information including name, status, serving statuses, run schedule start dates, creation and modification timestamps with actor information, allowed campaign types, test flag, and backfill status. Campaign groups organize multiple campaigns under a common budget and objective, enabling portfolio-level analysis.
* **Campaign History**: Comprehensive campaign configuration including account reference, campaign group association, audience expansion settings, daily budget (amount and currency), campaign format, objective type (brand awareness, website visits, engagement, video views, lead generation, website conversions, job applicants), locale (country and language), optimization target type, pacing strategy, creative selection mode, cost type, serving statuses, status, campaign type, unit cost, run schedule, offsite delivery settings, publisher restrictions, and complete audit trail with creation and modification timestamps. Central table for understanding campaign strategy and configuration evolution.
* **Creative History**: Individual creative asset details including account and campaign references, content reference, creation and modification timestamps with actor information, serving hold reasons, serving status, and intended status. Tracks the lifecycle of ad creatives from creation through approval to serving, essential for creative performance analysis and understanding what assets are active.

### Reference Data Tables (Dimensions)

These standardized reference tables provide demographic and targeting classification data for joining with performance tables.

* **Job Function**: Standardized LinkedIn job function taxonomy with function ID, name in English, and localized name. Used for targeting and reporting on professional roles (e.g., Accounting, Engineering, Marketing, Sales). Essential for B2B audience analysis and understanding which job functions respond best to campaigns.
* **Industries**: LinkedIn's standardized industry classification with industry ID, name in English, and localized name. Covers all LinkedIn industry verticals from technology to healthcare to finance. Critical for analyzing campaign performance by target industry and vertical-specific optimization.
* **Job Title**: Comprehensive LinkedIn job title reference with title ID, name, category (e.g., C-level, Director, Manager, Entry level), seniority (numeric ranking), and localized name. Enables granular analysis of which seniority levels and specific titles drive the best campaign results.
* **Geo Location**: Geographic location reference data with location ID, location type (country, region, city), English name, and localized name. Used for geographic targeting and performance analysis by location. Enables regional performance comparison and location-based budget allocation.
* **Organization**: LinkedIn organization (company) profiles including organization ID, localized name, English name, vanity name (custom URL), logo URL, and localized website URL. Links to member company demographics in performance tables, enabling account-based marketing analysis and understanding which companies are engaging with your ads.

### Metric Tables

These tables contain aggregated performance metrics at different levels, forming the foundation for campaign analysis and optimization.

* **Ad Analytics by Creative**: Daily performance metrics aggregated by creative including impressions, clicks, cost, engagement metrics (likes, comments, shares, follows), video metrics (views, completions, starts), conversion metrics (leads, other conversions), click-through rate, cost per click, cost per impression, viral metrics (viral impressions, viral clicks, viral engagement), and LinkedIn-specific metrics like lead form opens and sends. Essential for creative performance optimization and understanding which ad assets drive the best results.
* **Ad Analytics by Creative with Conversion Breakdown**: Creative-level performance with detailed conversion breakdown by conversion type. Contains all creative analytics metrics plus conversion-specific data including conversion ID, conversion name, conversion type, conversion value, post-click conversions, view-through conversions, and conversion rates. Critical for understanding ROI by conversion action and optimizing campaigns toward specific conversion goals like form fills, downloads, or purchases.
* **Ad Analytics by Campaign**: Campaign-level performance metrics aggregated across all creatives and ad groups. Includes impressions, clicks, cost, engagement, video metrics, conversions, efficiency metrics (CTR, CPC, CPM), viral metrics, and LinkedIn-specific conversion events (lead form submissions, follows, website actions). Provides high-level campaign performance overview for budget management and strategic optimization decisions.

### Demographic Breakdown Tables

These tables segment performance by LinkedIn's professional demographic dimensions, enabling deep audience insights and targeting optimization.

* **Ad Analytics by Member Company**: Campaign performance segmented by the company where LinkedIn members work. Includes all standard performance metrics plus member company ID (links to Organization table). Essential for account-based marketing, identifying high-value companies, and optimizing targeting for specific organizations. Enables analysis like "which companies generate the most leads" or "what's our CPL for Fortune 500 companies."
* **Ad Analytics by Member Company Size**: Campaign performance broken down by company size brackets (1-10, 11-50, 51-200, 201-500, 501-1000, 1001-5000, 5001-10000, 10001+ employees, self-employed). Identifies whether your campaigns perform better with SMBs, mid-market, or enterprise audiences. Critical for optimizing targeting strategies and budget allocation by company size segment.
* **Ad Analytics by Member Country**: Campaign performance segmented by the country of LinkedIn members. Includes all performance metrics plus member country (links to Geo table). Enables geographic performance analysis, identification of high-performing markets, and localization strategy optimization. Essential for international campaigns and market expansion planning.
* **Ad Analytics by Member Industry**: Campaign performance broken down by the industry of LinkedIn members (links to Industries reference table). Shows which industry verticals are most engaged and cost-effective. Critical for B2B campaigns targeting specific industries and for understanding cross-industry performance patterns.
* **Ad Analytics by Member Job Function**: Campaign performance segmented by job function (links to Job Function reference table). Identifies which professional functions (e.g., Marketing, Sales, IT, HR) respond best to your campaigns. Essential for role-based targeting optimization and understanding functional buying behaviors.
* **Ad Analytics by Member Job Title**: Campaign performance broken down by specific job titles (links to Job Title reference table). Provides granular insights into which titles and seniority levels drive the best results. Enables precise targeting optimization for decision-maker roles and analysis of engagement patterns by career level.
* **Ad Analytics by Member Region**: Campaign performance segmented by geographic region within countries (e.g., California, Ontario, Bavaria). More granular than country-level analysis, useful for regional campaigns and understanding sub-national performance patterns. Enables region-specific optimization and budget allocation strategies.

***

<a href="https://dbdiagram.io/e/682b4daf1227bdcb4eff888a/682b4fa51227bdcb4effdd6c" class="button primary" data-icon="table-tree">Pre-built tables and definition</a>

***

## Troubleshooting

<details>

<summary>Connection Issues</summary>

* Verify that your LinkedIn account has Campaign Manager access
* Check that you have appropriate permissions (Account Manager or Campaign Manager role)
* Ensure your account is not suspended or restricted
* Try disconnecting and reconnecting the LinkedIn authorization
* Verify that you're using the correct LinkedIn account with access to the desired ad accounts

</details>

<details>

<summary>Missing Data</summary>

* Campaign and creative data requires campaigns to have been active and serving
* Demographic breakdowns may be limited for campaigns with small audience sizes (privacy protection)
* Conversion data requires proper LinkedIn Insight Tag implementation
* Historical data depends on when campaigns were created and started serving
* Reference data (job functions, industries, titles) is standardized by LinkedIn and may not include all variations

</details>

<details>

<summary>Metric Discrepancies</summary>

* Slight differences between LinkedIn Campaign Manager and QUANTI data can occur due to:
  * Time zone differences (LinkedIn uses Pacific Time)
  * Data aggregation timing
  * Currency conversions
  * Viral metrics being calculated differently
* Demographic breakdowns sum to campaign totals but individual members may be counted in multiple demographic segments

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io/)

</details>
