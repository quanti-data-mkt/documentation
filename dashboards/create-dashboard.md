# Create & share a dashboard

***

## How it works

Dashboards in QUANTI: are **AI-generated**. You describe what you want to see — the metrics, the time range, the layout — and the AI assistant builds the dashboard for you. Under the hood, each dashboard is a declarative spec that binds SQL queries to visual blocks. You never write HTML or JavaScript.

Each dashboard:
- runs its queries **live** against your data warehouse when opened
- always shows **up-to-date data** (relative time windows, not hardcoded date ranges)
- is accessible via a **persistent URL** that can be shared with your team

***

## Creating a dashboard

To create a dashboard, open the AI assistant and describe what you want:

> *"Create a dashboard showing our last 30 days of Meta Ads performance — spend, CPC, CTR, and ROAS — with a daily trend chart and a campaign breakdown table."*

The assistant will:
1. Identify the relevant tables in your warehouse
2. Estimate the query cost before building
3. Generate the dashboard and return its URL

You can ask for changes at any time — the assistant will update the existing dashboard rather than creating a new one, preserving its URL and sharing settings.

{% hint style="info" %}
The more specific your request, the better the result. Mention the metrics you care about, the time window, and how you want data grouped (by campaign, by channel, by day…).
{% endhint %}

***

## Dashboard structure

A dashboard is organised into **pages** (tabs). Each page contains **blocks** laid out vertically.

### Block types

**KPI cards**

Display a single key metric with an optional comparison to the previous period and a sparkline trend. Best used at the top of a page for the 3–4 most important numbers.

**Charts**

Visualise trends and comparisons. Available chart types: line, area, bar, stacked bar, pie, donut, scatter. Charts use relative time windows by default so they stay current.

**Tables**

Display detailed row-level data with optional sorting and filtering. Columns can be formatted as numbers, percentages, currencies, or badges.

**Card grids**

Display one card per data row — useful for catalogue views, campaign scorecards, or any ranking where each item deserves its own visual block. Cards can include images, colour-coded status badges, and multiple metrics.

**Editorial blocks**

Add context to your dashboard with headings, text (markdown), callout boxes (info, success, warning, error), and dividers.

***

## Time windows

Dashboards always use **relative time windows** — data is computed relative to today each time the dashboard is opened. This means a dashboard built today will still show the correct "last 30 days" in six months, without any manual update.

If you need a fixed period (e.g. "January 2026 only"), ask explicitly when creating the dashboard.

***

## Sharing & permissions

Dashboards can be shared with any member of your QUANTI: workspace. Only the dashboard **owner** can manage sharing.

To share a dashboard, ask the AI assistant:

> *"Share dashboard [name or URL] with user@example.com as viewer."*

Two roles are available:

| Role | Can view | Can edit |
|---|:---:|:---:|
| Viewer | ✅ | ❌ |
| Editor | ✅ | ✅ |

The invited person receives a notification on their QUANTI: home page. They do not need to be a member of the project — only a member of the workspace.

{% hint style="warning" %}
Sharing a dashboard does not grant access to the underlying data warehouse. The dashboard displays pre-rendered query results only.
{% endhint %}

***

## Modifying a dashboard

To update an existing dashboard, ask the AI assistant to modify it by name or URL. The assistant reads the current state of the dashboard before making any changes, so you can ask for incremental updates:

> *"Add a weekly breakdown by country to the Meta Ads dashboard."*
> *"Replace the bar chart with a stacked bar, grouped by campaign type."*

The dashboard URL, sharing settings, and page structure are preserved across updates.
