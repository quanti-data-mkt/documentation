---
description: Follow our setup guide to connect PostgreSQL to QUANTI:
---

# PostgreSQL

{% hint style="info" %}
The PostgreSQL connector is currently in **beta**. Reach out to your CSM to enable it for your project.
{% endhint %}

## Prerequisites

Before setting up the PostgreSQL connector, ensure you have:

* A **PostgreSQL database** accessible from the internet (host must be reachable)
* **Connection credentials**: host, port, database name, username, and password
* A **database user with SELECT privileges** on the tables you want to sync
* If your database is behind a firewall, whitelist the QUANTI: IP addresses — contact your CSM for the list

## Setup Instructions

{% stepper %}
{% step %}
**Authorize your PostgreSQL Connection**

Enter your database credentials to let QUANTI: connect to your PostgreSQL server:

* **Host**: Your PostgreSQL server hostname or IP address (e.g., `db.yourdomain.com`)
* **Port**: Server port (default: `5432`)
* **Database**: The name of the database to connect to
* **Username**: Your PostgreSQL username
* **Password**: Your PostgreSQL password
* **SSL Mode** (optional): Enable SSL for encrypted connections — recommended for databases exposed over the public internet

Click **Next**
{% endstep %}

{% step %}
**Connector Information**

* **Connector Name**: Define a unique name for your connector
* **Dataset ID**: Specify the BigQuery dataset ID where tables will be created (the dataset is created automatically if it doesn't exist)

Click **Next**
{% endstep %}

{% step %}
**Table Selection**

Select the PostgreSQL table to sync to BigQuery:

* **Schema**: The PostgreSQL schema containing your table (default: `public`)
* **Table**: The name of the table to sync

{% hint style="info" %}
Each connector instance syncs a single table. To sync multiple tables, create one connector per table.
{% endhint %}

Click **Next**
{% endstep %}

{% step %}
**Sync Behavior**

Choose the data insertion method that fits your use case:

* **Table Type**: Select your table type:
  * **Fact table**: A table containing metrics and date-based data (e.g., events, transactions, orders)
  * **Dimension table**: A table composed exclusively of descriptive attributes (e.g., products, customers, categories)
* **Sync Method**: Choose your insertion method — [Learn more](https://docs.quanti.io/key-concepts/data-insertion-strategies)
  * [**INSERT**](https://docs.quanti.io/key-concepts/data-insertion-strategies/insert-mode): Add new rows without checking for duplicates (recommended for append-only time-series data)
  * [**REPLACE**](https://docs.quanti.io/key-concepts/data-insertion-strategies/replace-mode-delete-and-insert): Delete rows within the table scope and reload fresh data
  * [**UPSERT**](https://docs.quanti.io/key-concepts/data-insertion-strategies/upsert-mode-update-and-insert): Update existing rows or insert new ones based on a primary key — no rows deleted

{% hint style="info" %}
If you have difficulties determining the most accurate configuration for your case, [discover our guide](https://docs.quanti.io/key-concepts/data-insertion-strategies/insertion-method-selection-guide).
{% endhint %}

Click **Next**
{% endstep %}

{% step %}
**Mapping Configuration**

**Table Configuration**

* **Destination table name**: Define your BigQuery table name (lowercase, underscores only)

**Field Mapping**

For each column detected in your PostgreSQL table:

* **Destination field name**: Define the column name in BigQuery (lowercase, underscores recommended)
* **Data type**: Choose the appropriate type:
  * `STRING` — Text values, alphanumeric data
  * `INTEGER` — Whole numbers (e.g., 42, -10, 0)
  * `FLOAT` — Decimal numbers (e.g., 3.14, -0.5)
  * `BOOLEAN` — True/False values
  * `DATE` — Date only (format: YYYY-MM-DD)
  * `TIMESTAMP` — Date and time with timezone
  * `DATETIME` — Date and time without timezone

{% hint style="info" %}
PostgreSQL-specific types: `NUMERIC`/`DECIMAL` → `FLOAT`, `JSONB`/`JSON` → `STRING`, `UUID` → `STRING`.
{% endhint %}

**Date Column** (mandatory for Fact tables)

* Select the date field for table partitioning
* Mandatory when **Fact table** was selected
* Used to optimize query performance and data organization
* Must be a valid `DATE`, `TIMESTAMP`, or `DATETIME` field

**Historize Changes**

* **Required** if UPSERT was selected in the previous step
* **Optional** for INSERT and REPLACE methods
* **Selected fields**: Previous values are kept (full history)
* **Deselected fields**: Values are overwritten without keeping history

Click **Next**
{% endstep %}

{% step %}
**Finish Setup**

* Save your sync settings
* You can now activate auto-sync or launch a first sync manually
{% endstep %}
{% endstepper %}

## Notes

* **One table per connector**: Each connector instance syncs a single PostgreSQL table. Create multiple connectors to sync multiple tables from the same database.
* **Read-only access**: The database user only needs `SELECT` access — no write permissions are required on the PostgreSQL side.
* **Network access**: Your PostgreSQL server must be reachable from QUANTI:'s infrastructure. Contact your CSM to obtain the IP addresses to whitelist if needed.
* **SSL**: Enabling SSL is recommended for databases accessible over the public internet.

## Troubleshooting

<details>

<summary>Connection refused</summary>

* Verify the hostname or IP address is correct
* Check that the configured port is open and not blocked by a firewall
* Ensure PostgreSQL accepts external connections (`listen_addresses` in `postgresql.conf`)
* Confirm your username and password are valid

</details>

<details>

<summary>Permission denied on table</summary>

* Ensure the database user has `SELECT` privileges on the target table
* Run the following on your PostgreSQL instance:

```sql
GRANT CONNECT ON DATABASE your_db TO your_user;
GRANT USAGE ON SCHEMA public TO your_user;
GRANT SELECT ON TABLE your_table TO your_user;
```

</details>

<details>

<summary>Data type mapping issues</summary>

* PostgreSQL `NUMERIC` / `DECIMAL` columns → use `FLOAT` in the mapping
* PostgreSQL `JSONB` / `JSON` columns → use `STRING` in the mapping
* Check for `NULL` values in columns defined as non-nullable types

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>
