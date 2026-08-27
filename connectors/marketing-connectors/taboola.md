---
description: 'Follow our setup guide to connect Taboola to QUANTI:'
---

# Taboola

<a href="https://dbdiagram.io/e/68d2990c7c85fb9961f96134/68d299e47c85fb9961f98ba6" class="button primary" data-icon="table-tree">Prebuilt reports and definition  </a>

***

## <mark style="background-color:blue;">Prerequisites</mark>

To connect Taboola to Quanti:, you need to access a [Taboola](https://authentication.taboola.com/authentication/login) account as well as a Client ID and Secret ID, which are only available by contacting your Taboola Account Manager.

***

## <mark style="background-color:blue;">Setup instructions</mark>

1. Connect your Taboola account to permit Quanti: to access to your data
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Select accounts to sync.
4. Select queries: You can select pre-built queries you want to sync.

***

## <mark style="background-color:blue;">Prebuilt reports</mark>

* **account\_history**: Contains historical records of advertising accounts, including their configurations and activity status.
* **campaign\_history**: Tracks the lifecycle and setup of advertising campaigns over time.
* **campaign\_site\_day\_report**: Provides daily performance insights for campaigns across different sites and time periods.
* **campaign\_item\_report**: Daily performance by promoted item (article), including destination URL, thumbnail and content provider.
* **user\_segment\_report**: Daily campaign performance broken down by 3rd party audience segment (Marketplace Audiences).

***

## <mark style="background-color:blue;">Data Schema</mark>

### Dimensions

#### `account_history`

```mermaid
erDiagram
    account_history {
        timestamp _quanti_loaded_at PK
        int id PK
        string account_id PK
        boolean is_active
        string language
        string name
        string parent_network
        string timezone
        string type
    }
```

#### `campaign_history`

```mermaid
erDiagram
    campaign_history {
        timestamp _quanti_loaded_at PK
        string account_id PK
        int id PK
        string approval_state
        float cpc
        string daily_ad_delivery_model
        float daily_cap
        date end_date
        boolean is_active
        string name
        float spending_limit
        string spending_limit_model
        float spent
        date start_date
        string status
        string tracking_code
        string traffic_allocation_mode
    }
```

### Reports

#### `campaign_site_day_report`

```mermaid
erDiagram
    campaign_site_day_report {
        timestamp _quanti_date PK
        int campaign_id PK
        string site PK
        string campaign_name
        string site_name
        int impressions
        int visible_impressions
        int clicks
        float spent
        float ctr
        float vctr
        float cpc
        float cpm
        float vcpm
        float cpa
        float roas
        float conversions_value
        string currency
        string timezone
    }
```

#### `campaign_item_report`

```mermaid
erDiagram
    campaign_item_report {
        timestamp _quanti_date PK
        int campaign_id PK
        string item_id PK
        string campaign_name
        string item_name
        string url
        string thumbnail_url
        string content_provider
        int impressions
        int visible_impressions
        int clicks
        float spent
        float conversions_value
        float ctr
        float vctr
        float cpc
        float cpm
        float vcpm
        float cpa
        float cvr
        float roas
        string currency
    }
```

#### `user_segment_report`

```mermaid
erDiagram
    user_segment_report {
        timestamp _quanti_date PK
        int campaign_id PK
        string data_partner_audience_id PK
        string partner_name
        string audience_name
        string audience_description
        int impressions
        int visible_impressions
        int clicks
        float spent
        float conversions_value
        float ctr
        float vctr
        float cpc
        float cpm
        float vcpm
        float cpa
        float cvr
        float roas
        string currency
        string timezone
    }
```

***

<a href="https://dbdiagram.io/e/68d2990c7c85fb9961f96134/68d299e47c85fb9961f98ba6" class="button primary" data-icon="table-tree">Prebuilt reports and definition  </a>
