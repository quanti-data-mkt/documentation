---
description: >-
  Create a QUANTI: project that loads your data into your own Snowflake
  account.
---

# Create a project with Snowflake as destination

**BYOD Snowflake** (Bring Your Own Data Warehouse) lets you create a QUANTI: project that loads your data directly into your own Snowflake account. You keep full ownership of your data and infrastructure.

{% hint style="warning" %}
BYOD Snowflake is available on the **Enterprise** plan only.
{% endhint %}

## Before you start, in Snowflake

QUANTI: signs in to Snowflake as a dedicated user, with a **key pair**. Passwords are not accepted.

Prepare the following with a Snowflake administrator. Creating users, roles, warehouses and key pairs is standard Snowflake administration: follow the Snowflake documentation linked below.

1. **A user for QUANTI:** with a key pair. See [Key-pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth) and [CREATE USER](https://docs.snowflake.com/en/sql-reference/sql/create-user). Keep the **private** key: you will paste it into QUANTI:.
2. **A role, a database and a warehouse** for that user. See [Overview of Access Control](https://docs.snowflake.com/en/user-guide/security-access-control-overview).
3. **The privileges QUANTI: needs**, granted to that role:

| Object | Privilege | Why QUANTI: needs it |
|---|---|---|
| Account | `CREATE INTEGRATION` | When the project is created, QUANTI: creates **once** a storage integration that lets Snowflake read the files QUANTI: stages in its cloud storage. Only an `ACCOUNTADMIN` can grant it. **You can revoke it once the project is created.** |
| Database | `USAGE`, `CREATE SCHEMA` | QUANTI: creates one schema per data source, then its tables. |
| Warehouse | `USAGE` | Loads run on a warehouse. |
| User | `DEFAULT_ROLE` = this role | The storage integration is created with the user's default role. |
| User | `DEFAULT_WAREHOUSE` = this warehouse | QUANTI: uses the user's default warehouse. |

```sql
-- Replace QUANTI_ROLE, QUANTI_USER, QUANTI_DB and QUANTI_WH with your own names
USE ROLE ACCOUNTADMIN;

GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE QUANTI_ROLE;
GRANT USAGE, CREATE SCHEMA ON DATABASE QUANTI_DB TO ROLE QUANTI_ROLE;
GRANT USAGE ON WAREHOUSE QUANTI_WH TO ROLE QUANTI_ROLE;
GRANT ROLE QUANTI_ROLE TO USER QUANTI_USER;

ALTER USER QUANTI_USER SET
  DEFAULT_ROLE = QUANTI_ROLE
  DEFAULT_WAREHOUSE = QUANTI_WH;
```

Once the project is created, you can revoke the account-level privilege:

```sql
USE ROLE ACCOUNTADMIN;
REVOKE CREATE INTEGRATION ON ACCOUNT FROM ROLE QUANTI_ROLE;
```

The storage integration stays: it belongs to `QUANTI_ROLE`, which keeps using it for every load.

Each QUANTI: project has its own storage integration: to create another project on the same Snowflake account, grant the privilege again for the time of the creation.

{% hint style="warning" %}
Use the **same role** in the QUANTI: form and as the user's `DEFAULT_ROLE`. The storage integration is created with the default role and used with the role from the form: with two different roles, loads fail.
{% endhint %}

***

## Create the project in QUANTI:

### 1. Name the project and choose Snowflake

Start a new project. Enter a name in **Name your project**, then select **Snowflake** in **Choose a data warehouse type**. Click **Next**.

### 2. Connect your Snowflake account

Fill in the connection form:

| Field | What to enter |
|---|---|
| **Name of connexion** | Any name that helps you recognize this connection. |
| **Host** | The host name of your Snowflake account, for example `myorg-myaccount.snowflakecomputing.com`. See [Account identifiers](https://docs.snowflake.com/en/user-guide/admin-account-identifier). |
| **User** | The Snowflake user created for QUANTI:. |
| **Role** | The role that received the privileges above. |
| **Database** | The database QUANTI: writes into. |
| **Private Key** | The **whole** private key, `-----BEGIN …-----` and `-----END …-----` lines included. QUANTI: accepts an unencrypted key or an encrypted one. |
| **Is Private Key Encrypted** | Turn it on if your key is encrypted (it starts with `-----BEGIN ENCRYPTED PRIVATE KEY-----`). |
| **Pass phrase** | The passphrase of the encrypted key. Used once to decrypt the key, never stored. |

Click **Next**: QUANTI: tests the connection before moving on.

{% hint style="info" %}
An encrypted key is decrypted **once**, when the project is created. QUANTI: does not store the passphrase.
{% endhint %}

Common errors:

* Pasting the **public** key (`BEGIN PUBLIC KEY`). The public key goes on the Snowflake user; QUANTI: needs the private one.
* A host with a path or a trailing slash (`…snowflakecomputing.com/`), or only the account name.
* A database created with a quoted lower-case name (`"quanti_db"`). QUANTI: converts the name to upper case and does not find it.
* A key encrypted in the legacy OpenSSL format (a `BEGIN RSA PRIVATE KEY` block with `Proc-Type: 4,ENCRYPTED`). Re-export it as PKCS#8 (`openssl pkcs8 -topk8 -v2 aes-256-cbc`), see [Key-pair authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth).

### 3. Review and create

Check the summary, then click **Create your project**. QUANTI: connects with your key and creates a storage integration whose name ends with `_STAGE`. You have nothing to configure on it.

Your project is ready: add your first data source. When it runs, QUANTI: creates one schema per data source in your database, then its tables.

***

## Troubleshooting

| Message | What to do |
|---|---|
| `Error connexion, check your credentials or database.` (on **Next**) | Check the host, user, database and key. Check that the public key is set on this user and that the user has the role. |
| `… invalid PEM block` | The key is incomplete. Paste it again, `BEGIN` and `END` lines included. |
| `… this private key is encrypted: a passphrase is required` | Turn on **Is Private Key Encrypted** and enter the passphrase. |
| `… cannot decrypt the private key, check the passphrase` | The passphrase is wrong. |
| `… legacy OpenSSL key encryption is not supported` | Re-export the key as PKCS#8: `openssl pkcs8 -topk8 -v2 aes-256-cbc`. |
| `… not an RSA private key` | Snowflake key-pair authentication requires an RSA key. |
| `… failed to create storage integration` (when creating the project) | The role lacks `CREATE INTEGRATION ON ACCOUNT`, or it is not the user's `DEFAULT_ROLE`. |

***

## Cost

Everything QUANTI: runs in your Snowflake account is billed to your account:

* **Connector loads** run on the user's default warehouse.
* **Webhook data** is ingested with Snowpipe Streaming: no warehouse is used, and Snowflake bills per GB received. See [Snowpipe Streaming costs](https://docs.snowflake.com/en/user-guide/snowpipe-streaming/snowpipe-streaming-high-performance-cost).

### host — Your Snowflake account host

The host name of the Snowflake account QUANTI: connects to, for example `myorg-myaccount.snowflakecomputing.com`.

**Where to find it**

In Snowsight, open the account menu and use **Connect a tool to Snowflake**, or build it from your account identifier: `<orgname>-<account_name>.snowflakecomputing.com`. See [Account identifiers](https://docs.snowflake.com/en/user-guide/admin-account-identifier).

**Why it matters**

Entering only the account name, or a URL with a path or a trailing slash (`…snowflakecomputing.com/`). QUANTI: reads the account identifier from the part before the first dot of the host, so the connection test fails on **Next**.
