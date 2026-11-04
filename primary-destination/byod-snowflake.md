---
description: >-
  Create a QUANTI: project that loads your data into your own Snowflake
  account.
---

# Snowflake

**BYOD Snowflake** (Bring Your Own Data Warehouse): QUANTI: loads your data into your own Snowflake account. You keep your data, your warehouse and your bill.

It works like a BigQuery project you own: you provide the place where the data lands, QUANTI: provides its identity, you give that identity access.

| | BigQuery (your project) | Snowflake |
|---|---|---|
| You provide | a GCP project | a database and a warehouse |
| QUANTI: identity | a service account created by QUANTI: | a user you create with the script QUANTI: gives you |
| Access you grant | BigQuery Data Editor, BigQuery Job User | `USAGE` on the warehouse, `USAGE` and `CREATE SCHEMA` on the database |
| QUANTI: creates | one dataset per data source | one schema per data source |

You need:

* a Snowflake **warehouse** and a **database** that already exist: QUANTI: does not create them, you enter their names in the form;
* the **ACCOUNTADMIN** role, for step 2 only.

## Step 1. Create the project in QUANTI:

1. Start a new project, name it, select **Snowflake**, click **Next**.
2. Fill in the form:

| Field | What to enter |
|---|---|
| **Host** | Your account host, for example `myorg-myaccount.snowflakecomputing.com`. |
| **Database** | The database QUANTI: writes into. |
| **Warehouse** | The warehouse QUANTI: loads run on. |

3. Check the summary, then click **Create your project**.

QUANTI: generates a key pair for this project. The private key stays in QUANTI:, it is never shown. You only handle the public key, which cannot be used to sign in.

## Step 2. Run the setup script in Snowflake

When you open the project, a window shows a **setup script**, complete: your database, your warehouse, your project's user and role, and its public key are already in it. Nothing is left to edit.

1. Click **Copy the script**.
2. Open a worksheet in Snowsight and paste it.
3. Run it as is, with the **ACCOUNTADMIN** role.

The script only creates QUANTI:'s user and its two roles, one that loads and one that only reads, and gives them access to the database and warehouse from the form. It looks like this, for a project `P2F89CC8E` with the database `SHOP` and the warehouse `LOAD_WH`:

```sql
-- Run as ACCOUNTADMIN.
SET warehouse_name = 'LOAD_WH';
SET database_name  = 'SHOP';
SET role_name      = 'QUANTI_P2F89CC8E_ROLE';
SET user_name      = 'QUANTI_P2F89CC8E_USER';

USE ROLE ACCOUNTADMIN;

CREATE ROLE IF NOT EXISTS identifier($role_name);
GRANT ROLE identifier($role_name) TO ROLE SYSADMIN;

CREATE USER IF NOT EXISTS identifier($user_name)
  TYPE = SERVICE
  DEFAULT_ROLE = $role_name
  DEFAULT_WAREHOUSE = $warehouse_name
  DEFAULT_SECONDARY_ROLES = ()
  RSA_PUBLIC_KEY = 'MIIBIjANBgkqh...';
GRANT ROLE identifier($role_name) TO USER identifier($user_name);

GRANT USAGE ON WAREHOUSE identifier($warehouse_name) TO ROLE identifier($role_name);
GRANT USAGE, CREATE SCHEMA ON DATABASE identifier($database_name) TO ROLE identifier($role_name);

-- Read-only role for QUANTI:'s AI assistant: it only reads the schemas QUANTI: creates.
SET reader_role_name = 'QUANTI_P2F89CC8E_READER';
CREATE ROLE IF NOT EXISTS identifier($reader_role_name);
GRANT ROLE identifier($reader_role_name) TO USER identifier($user_name);
GRANT USAGE ON WAREHOUSE identifier($warehouse_name) TO ROLE identifier($reader_role_name);
GRANT USAGE ON DATABASE identifier($database_name) TO ROLE identifier($reader_role_name);

-- Webhooks only: a nightly serverless task computes the visits. Uncomment if you use webhooks.
-- GRANT EXECUTE MANAGED TASK, EXECUTE TASK ON ACCOUNT TO ROLE identifier($role_name);

-- To cut QUANTI:'s access at any time:
-- ALTER USER identifier($user_name) SET DISABLED = TRUE;
```

{% hint style="warning" %}
Each project has its **own** user and roles. Do not replace them by a user you already have: QUANTI: would sign in with all its roles.
{% endhint %}

## Step 3. Check the access

Back in QUANTI:, click **Check**. QUANTI: signs in with its key and checks, without starting your warehouse:

| Check | What it means | If it fails |
|---|---|---|
| **Sign in with QUANTI:'s key** | QUANTI: signs in with the key from the setup script. | The script did not run, or ran on another account. Run it again, as ACCOUNTADMIN. |
| **Role QUANTI_…_ROLE** | QUANTI:'s user works with this role only, the one the script creates. | The role is not granted to the user. Run the `GRANT ROLE … TO USER` line again. |
| **USAGE on the user's default warehouse** | Loads run on this warehouse. | The warehouse from the form does not exist, or the script failed on it. Check its name in Snowsight, under **Compute » Warehouses**. |
| **USAGE, CREATE SCHEMA on database …** | QUANTI: creates one schema per source in this database, never elsewhere. | The database name differs from the one in the form, or the grant failed. |
| **QUANTI:'s user has no admin role** | For your security, QUANTI: refuses a user that can take an admin role. | The user holds ACCOUNTADMIN, SECURITYADMIN, SYSADMIN, USERADMIN or ORGADMIN. Revoke it: QUANTI: does not need it. |

When every check passes, the window closes: add your first data source.

{% hint style="info" %}
What each line of the script grants, how to open your own tables to QUANTI:, how to cut access, and what it costs: [Snowflake: security and costs](byod-snowflake-security.md).
{% endhint %}

## Webhooks: visits

On Snowflake, a serverless task in your account groups the hits into **visits** once a night, at **02:30 UTC**, for the previous UTC day. Today's visits appear tomorrow after 02:30 UTC, up to about 26 hours after the hit. On BigQuery, visits are updated every 15 minutes. The task runs on Snowflake serverless compute, not on your warehouse.

It needs one more privilege, once per project. The **Install code** tab of your webhook shows the command with your role filled in:

```sql
GRANT EXECUTE MANAGED TASK, EXECUTE TASK ON ACCOUNT TO ROLE QUANTI_P2F89CC8E_ROLE;
```

Run it as ACCOUNTADMIN. Without it, hits are still collected, but no visits are computed. You can also uncomment this line in the setup script before running it.

***

## Field reference

### host — Your Snowflake account host

The host name of the Snowflake account QUANTI: connects to, for example `myorg-myaccount.snowflakecomputing.com`.

**Where to find it**

In Snowsight, open the account selector, then select **View account details**. In the **Account Details** dialog, copy the **Account/Server URL** field, for example `myorg-myaccount.snowflakecomputing.com`. See [Account identifiers](https://docs.snowflake.com/en/user-guide/admin-account-identifier).

**Why it matters**

Entering only the account name, or another address. QUANTI: only accepts hosts that end with `.snowflakecomputing.com`, PrivateLink ones included, and always connects on port 443.

### database — The database QUANTI: writes into

Your Snowflake database, where QUANTI: creates one schema per data source, then its tables.

**Where to find it**

QUANTI: does not create the database: it must exist before you create the project.

* **Existing database**: in Snowsight, **Catalog » Explorer** lists your databases. Copy its name.
* **New database**: run this as `ACCOUNTADMIN`, or as a role allowed to create databases, then enter `QUANTI_DB` in the form. Do not put the name in double quotes.

```sql
CREATE DATABASE QUANTI_DB;
```

The setup script grants QUANTI:'s role `USAGE` and `CREATE SCHEMA` on it.

**Common mistake**

A database created with a quoted lower-case name, such as `"quanti_db"`. QUANTI: converts the name to upper case and looks for `QUANTI_DB`, which does not exist: the check fails. Use a database created without double quotes.

### warehouse — The warehouse QUANTI: loads run on

The warehouse QUANTI: loads run on. It becomes the default warehouse of QUANTI:'s user.

**Where to find it**

In Snowsight, **Compute » Warehouses** lists your warehouses: copy the name shown in the list. It must already exist: QUANTI: does not create it. You can create one from the same page.

**Why it matters**

A warehouse suspended with auto-resume off: loads fail with `No active warehouse`. Turn `AUTO_RESUME` on, or grant `OPERATE` on it to QUANTI:'s role.

***

## Troubleshooting

| Message | What to do |
|---|---|
| `Enter your Snowflake host, for example myorg-myaccount.snowflakecomputing.com` | The host does not end with `.snowflakecomputing.com`. |
| `Snowflake access is not complete` | One of the checks failed: see [Step 3](#step-3-check-the-access). |
| `Can't load the setup script` | Reload the page. If it persists, contact support. |
| Loads fail with `No active warehouse` | The warehouse is suspended with auto-resume off: turn `AUTO_RESUME` on, or grant `OPERATE` on it to QUANTI:'s role. |
