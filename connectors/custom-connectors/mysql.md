---
description: 'Follow our setup guide to connect MySQL to QUANTI:'
---

# MySQL

## Prerequisites

Before setting up the MySQL connector, ensure you have:

* A **MySQL database** accessible from the internet (host must be reachable)
* **Connection credentials**: host, port, database name, username, and password
* A **database user with SELECT privileges** on the tables you want to sync
* If your database is behind a firewall, allow inbound access from QUANTI:'s IP: **`51.158.117.103`**

## Setup Instructions

{% stepper %}
{% step %}
**Database Connection**

Enter your MySQL credentials to let QUANTI: connect to your server:

* **Host**: Your MySQL server hostname or IP address (e.g., `db.yourdomain.com` or `127.0.0.1`)
* **Port**: Server port (default: `3306`)
* **User**: Your MySQL username (e.g., `quanti_readonly`)
* **Password**: Your MySQL password
* **Database**: The name of the database to connect to
* **SSL Mode**: Choose the SSL security level for the connection:
  * `required` — Encrypted connection, no certificate verification (recommended default)
  * `verify-ca` — Encrypted + verifies the server certificate authority
  * `verify-identity` — Encrypted + verifies the server certificate and hostname
  * `preferred` — Encrypts if the server supports it, falls back to unencrypted
  * `disabled` — No SSL (local/dev environments only — not recommended for production)

Click **Save** to create the connector.
{% endstep %}

{% step %}
**Add Tables to Sync**

Once the connector is created, go to the **Reports** tab and click **Add table** to configure each table you want to sync:

* **Table**: Select the MySQL table to sync (the connector displays all accessible tables in the connected database)
* **Destination table name**: Define the BigQuery table name (lowercase, underscores only)
* **Table Type**: Select your table type:
  * **Fact table**: A table containing metrics and date-based data (e.g., events, transactions, orders)
  * **Dimension table**: A table composed exclusively of descriptive attributes (e.g., products, customers, categories)
* **Sync Method**: Choose your insertion method — [Learn more](https://docs.quanti.io/key-concepts/data-insertion-strategies)
  * [**INSERT**](https://docs.quanti.io/key-concepts/data-insertion-strategies/insert-mode): Add new rows without checking for duplicates (recommended for append-only time-series data)
  * [**REPLACE**](https://docs.quanti.io/key-concepts/data-insertion-strategies/replace-mode-delete-and-insert): Delete rows within the table scope and reload fresh data
  * [**UPSERT**](https://docs.quanti.io/key-concepts/data-insertion-strategies/upsert-mode-update-and-insert): Update existing rows or insert new ones based on a primary key — no rows deleted

{% hint style="info" %}
You can add as many tables as needed from the same database — each table is configured independently with its own sync method and mapping.
{% endhint %}

{% hint style="info" %}
If you have difficulties determining the most accurate configuration for your case, [discover our guide](https://docs.quanti.io/key-concepts/data-insertion-strategies/insertion-method-selection-guide).
{% endhint %}
{% endstep %}

{% step %}
**Field Mapping**

For each table, map the MySQL columns to BigQuery fields:

* **Destination field name**: Define the column name in BigQuery (lowercase, underscores recommended)
* **Data type**: Choose the appropriate type:
  * `STRING` — Text values, alphanumeric data
  * `INTEGER` — Whole numbers (e.g., 42, -10, 0)
  * `FLOAT` — Decimal numbers (e.g., 3.14, -0.5)
  * `BOOLEAN` — True/False values
  * `DATE` — Date only (format: YYYY-MM-DD)
  * `TIMESTAMP` — Date and time stored in UTC
  * `DATETIME` — Date and time without timezone

{% hint style="info" %}
MySQL-specific type mappings: `DECIMAL`/`NUMERIC` → `FLOAT`, `TINYINT(1)` → `BOOLEAN`, `JSON` → `STRING`, `ENUM`/`SET` → `STRING`, `BLOB`/`LONGTEXT` → `STRING`.
{% endhint %}

**Date Column** (mandatory for Fact tables)

* Select the date field used for table partitioning
* Mandatory when **Fact table** was selected
* Used to optimize query performance and data organization
* Must be a valid `DATE`, `TIMESTAMP`, or `DATETIME` field

**Historize Changes**

* **Required** if UPSERT was selected in the previous step
* **Optional** for INSERT and REPLACE methods
* **Selected fields**: Previous values are kept (full history)
* **Deselected fields**: Values are overwritten without keeping history

Click **Save** to apply the table configuration.
{% endstep %}

{% step %}
**Sync Settings**

* **Sync frequency**: Choose how often QUANTI: syncs your data — every 3, 6, or 12 hours, daily, weekly, or monthly
* **Lookback window**: Number of days to re-sync on each run to capture late-arriving updates (default: 3 days)
* You can also launch a **historical data load** to backfill past data (up to 3, 6, or 12 months, or a custom date range)

Click **Save** then activate auto-sync or launch a first sync manually.
{% endstep %}
{% endstepper %}

## Notes

* **Multiple tables per connector**: A single MySQL connector can sync multiple tables from the same database. Add tables from the **Reports** tab after the connector is created.
* **Read-only access**: The database user only needs `SELECT` access — no write permissions are required.
* **Network access**: Your MySQL server must be reachable from QUANTI:'s infrastructure. Allow inbound access from IP **`51.158.117.103`**.
* **SSL**: Using `required` or `verify-ca` is strongly recommended for databases accessible over the public internet.
* **Incremental sync**: If the table has a `TIMESTAMP` or `DATETIME` column, QUANTI: can sync only the rows modified since the last run (incremental). Otherwise, a full refresh is performed.

## Troubleshooting

<details>

<summary>Connection refused</summary>

* Verify the hostname or IP address is correct
* Check that port `3306` (or your custom port) is open and not blocked by a firewall
* Ensure MySQL accepts external connections (`bind-address = 0.0.0.0` in `my.cnf`)
* Confirm your username and password are valid

</details>

<details>

<summary>Permission denied on table</summary>

* Ensure the database user has `SELECT` privileges on the target table
* Run the following on your MySQL instance:

```sql
GRANT SELECT ON your_db.your_table TO 'your_user'@'%';
FLUSH PRIVILEGES;
```

* To grant access to all tables in the database:

```sql
GRANT SELECT ON your_db.* TO 'your_user'@'%';
FLUSH PRIVILEGES;
```

</details>

<details>

<summary>SSL connection error</summary>

* If the server does not have a valid SSL certificate, switch to `required` instead of `verify-ca` or `verify-identity`
* If SSL is not configured on the server, use `preferred` or `disabled` (dev only)
* Check that the MySQL server version supports SSL (MySQL 5.7.11+ has SSL enabled by default)

</details>

<details>

<summary>Data type mapping issues</summary>

* MySQL `DECIMAL` / `NUMERIC` columns → use `FLOAT` in the mapping
* MySQL `TINYINT(1)` columns → use `BOOLEAN` in the mapping
* MySQL `JSON` columns → use `STRING` in the mapping
* MySQL `ENUM` / `SET` columns → use `STRING` in the mapping
* Check for `NULL` values in columns defined as non-nullable types

</details>

<details>

<summary>Need Help?</summary>

Contact QUANTI: support at support@quanti.io or consult our documentation at https://docs.quanti.io

</details>
