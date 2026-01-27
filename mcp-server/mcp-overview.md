---
description: >-
  This page describe the main features, tools and ressources listed in the
  QUANTI MCP
---

# MCP overview

## What is Quanti MCP?

Quanti MCP Server implements the MCP (Model Context Protocol) protocol, allowing your favorite AI assistants to directly query your marketing data warehouse.

In practice, this means you can ask questions to Claude, ChatGPT, or Copilot, and instantly get analyses of your advertising, marketing and sales data.

> 💬 "What are my top 10 Google Ads campaigns this month in terms of ROAS ?"

The AI assistant automatically generates the SQL query, executes it on your data warehouse, and presents the results clearly.

## Features



* Natural language to SQL: ask your questions as you think them
* DatawareHouse : BigQuery, ClickHouse (Coming soon)
* Compatible with all AI assistants: Claude, ChatGPT, Copilot, Le Chat
* Automatic schema discovery: AI understands your tables and columns via RAG
* Reusable Use Cases: save your favorite analyses
* Secure: OAuth 2.0, read-only queries, project-level access control

## Prerequisites

Before getting started, make sure you have:

* A Quanti account with access to at least one project
* A connected data warehouse (BigQuery, Snowflake, Redshift, or Azure Synapse)
* An MCP-compatible AI assistant (see Installation section)

## MCP Server URL

{% hint style="info" %}
The URL to connect your AI assistant is:

```
https://mcp-public.app.quanti.io/mcp
```
{% endhint %}

## Available Tools

Once connected, your AI assistant has access to the following tools:

| Tool                     | Description                                                   |
| ------------------------ | ------------------------------------------------------------- |
| `list_projects`          | Lists your accessible Quanti projects                         |
| `get_project_context`    | Retrieves project context (connectors, datasets, date ranges) |
| `get_schema_context`     | Builds schema context for your question via RAG               |
| `execute_query`          | Executes read-only SQL queries on your data warehouse         |
| `get_use_cases`          | Searches for relevant analysis templates                      |
| `list_my_use_cases`      | Lists your saved personal analyses                            |
| `list_project_use_cases` | Lists team-shared analyses                                    |
| `create_use_case`        | Saves an analysis for reuse                                   |
| `update_use_case`        | Updates an existing use case                                  |
| `delete_use_case`        | Deletes a use case                                            |
| `collect_feedback`       | Provides feedback on results                                  |

## Example Questions

Here are some example questions you can ask:

<details>

<summary>Example prompts</summary>

* "What are my top 10 campaigns by conversions this month?"
* "Show me the daily spend trend for Google Ads over the last 30 days"
* "Compare Meta vs Google Ads performance this quarter"
* "What is my ROAS by acquisition channel?"
* "Identify campaigns with a CPA above €50"

</details>

## Supported Data Sources

Quanti connects over 50 marketing sources, including:

* Advertising: Google Ads, Meta Ads, LinkedIn Ads, TikTok Ads, Microsoft Ads, Pinterest Ads, Snapchat Ads
* Analytics: Google Analytics 4, Adobe Analytics, Matomo
* CRM: Salesforce, HubSpot, Pipedrive
* E-commerce: Shopify, WooCommerce, PrestaShop, Magento
* Email & Automation: Brevo, Mailchimp, Klaviyo, ActiveCampaign

## Security

* OAuth 2.0 Authentication: secure connection with your Quanti account
* Read-only: no modification of your data is possible
* Project-level access control: you only access projects you're authorized for
* 100% French infrastructure: data hosted in France, GDPR compliant
