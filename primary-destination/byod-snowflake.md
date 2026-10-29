---
description: >-
  Create a QUANTI: project that loads your data into your own Snowflake
  account.
---

# Create a project with Snowflake as destination

**BYOD Snowflake** (Bring Your Own Data Warehouse): QUANTI: loads your data into your own Snowflake account. You keep your data, your warehouse and your bill.

{% hint style="warning" %}
BYOD Snowflake is available on the **Enterprise** plan only.
{% endhint %}

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
| **Name of connexion** | Any name that helps you recognize this connection. |
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

The script only creates QUANTI:'s user and role, and gives them access to the database and warehouse from the form. It looks like this, for a project `P2F89CC8E` with the database `SHOP` and the warehouse `LOAD_WH`:

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

-- Webhooks only: a nightly serverless task computes the visits. Uncomment if you use webhooks.
-- GRANT EXECUTE MANAGED TASK, EXECUTE TASK ON ACCOUNT TO ROLE identifier($role_name);

-- To cut QUANTI:'s access at any time:
-- ALTER USER identifier($user_name) SET DISABLED = TRUE;
```

{% hint style="warning" %}
Each project has its **own** user and role. Do not replace them by a user you already have: QUANTI: would sign in with all its roles.
{% endhint %}

## Step 3. Check the access

Back in QUANTI:, click **Check**. QUANTI: signs in with its key and checks, without starting your warehouse:

| Check | If it fails |
|---|---|
| **Sign in with QUANTI:'s key** | The script did not run, or ran on another account. Run it again, as ACCOUNTADMIN. |
| **Role QUANTI_…_ROLE** | The role is not granted to the user. Run the `GRANT ROLE … TO USER` line again. |
| **USAGE on the user's default warehouse** | The warehouse from the form does not exist, or the script failed on it. Check its name in Snowsight, under **Admin › Warehouses**. |
| **USAGE, CREATE SCHEMA on database …** | The database name differs from the one in the form, or the grant failed. |
| **No admin role on the user** | The user holds ACCOUNTADMIN, SECURITYADMIN, SYSADMIN, USERADMIN or ORGADMIN. Revoke it: QUANTI: does not need it. |

When every check passes, the window closes: add your first data source.

## Webhooks: visits

On Snowflake, a serverless task in your account groups the hits into **visits** once a night, at **02:30 UTC**, for the previous UTC day. Today's visits appear tomorrow after 02:30 UTC, up to about 26 hours after the hit. On BigQuery, visits are updated every 15 minutes. The task runs on Snowflake serverless compute, not on your warehouse.

It needs one more privilege, once per project. The **Install code** tab of your webhook shows the command with your role filled in:

```sql
GRANT EXECUTE MANAGED TASK, EXECUTE TASK ON ACCOUNT TO ROLE QUANTI_P2F89CC8E_ROLE;
```

Run it as ACCOUNTADMIN. Without it, hits are still collected, but no visits are computed. You can also uncomment this line in the setup script before running it.

***

## Tables you created yourself

QUANTI: sees the schemas and tables it creates: they belong to its role. A table you created yourself, in `PUBLIC` or any other schema, belongs to **your** role, and QUANTI: cannot see it. You need it to:

* push it to a destination with a **reverse connector**;
* declare it in a **semantic view**, so the AI assistant can query it.

Give QUANTI:'s role read access, nothing more: `USAGE` on the schema, `SELECT` on the table. Run as ACCOUNTADMIN, or as the role that owns the table:

```sql
GRANT USAGE  ON SCHEMA NEW_DB.PUBLIC        TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON TABLE  NEW_DB.PUBLIC.ADOBE1 TO ROLE QUANTI_P2F89CC8E_ROLE;
```

For every table of a schema, including the ones you create later:

```sql
GRANT USAGE  ON SCHEMA NEW_DB.PUBLIC                    TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON ALL TABLES    IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON ALL VIEWS     IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON FUTURE VIEWS  IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
```

In Snowsight, you can also open the table, go to **Access › + Privilege**, pick QUANTI:'s role and the `SELECT` privilege; the schema still needs `USAGE`.

{% hint style="warning" %}
Never grant `OWNERSHIP` or write privileges on your tables: QUANTI: only reads them.
{% endhint %}

## What the script does

The script creates **who** QUANTI: is in your account (a user), and **what** it may do (a role). Nothing else.

```
ACCOUNTADMIN ──creates──▶ QUANTI_<ID>_ROLE ◀──held by── QUANTI_<ID>_USER (public key)
                              │
                              ├─ USAGE                  → your warehouse  (run loads)
                              ├─ USAGE + CREATE SCHEMA  → your database   (1 schema per source)
                              └─ EXECUTE (MANAGED) TASK → account         (webhook visits, optional)
```

1. **The four `SET` lines** are worksheet variables, used only while the script runs. `identifier($x)` turns a variable into an object name.
2. **`USE ROLE ACCOUNTADMIN`**: the only role allowed to create a user and grant account privileges. QUANTI: never uses it.
3. **`CREATE ROLE`**: in Snowflake, privileges are never given to a user directly, only to a role. This role holds every privilege QUANTI: gets.
4. **`GRANT ROLE … TO ROLE SYSADMIN`**: SYSADMIN inherits QUANTI:'s role, never the other way round. In Snowflake an object belongs to the role that created it, and even SYSADMIN cannot see it otherwise. With this grant, your admins see and manage every schema and table QUANTI: creates. QUANTI: gains nothing from it.
5. **`CREATE USER … TYPE = SERVICE`**: the identity QUANTI: signs in with. A service user has no password and cannot sign in to Snowsight: only the key works.
   * `DEFAULT_ROLE`: the role used when QUANTI: signs in.
   * `DEFAULT_WAREHOUSE`: the warehouse QUANTI: loads run on.
   * `DEFAULT_SECONDARY_ROLES = ()`: QUANTI: only ever acts with its own role, even if more roles are granted to this user later.
   * `RSA_PUBLIC_KEY`: Snowflake checks QUANTI:'s signature with it.
6. **`GRANT ROLE … TO USER`**: without it, the user signs in with no privilege.
7. **`USAGE` on the warehouse**: run queries on it. QUANTI: cannot resize or change it.
8. **`USAGE`, `CREATE SCHEMA` on the database**: enter the database and create one schema per data source. QUANTI: owns what it creates and never touches your other schemas.
9. **`EXECUTE MANAGED TASK`, `EXECUTE TASK`**: webhooks only, see above.

## Cut or remove QUANTI:'s access

To cut it at once, reversibly:

```sql
ALTER USER QUANTI_P2F89CC8E_USER SET DISABLED = TRUE;
```

When you delete the project in QUANTI:, its user and role stay in your account. Remove them yourself:

```sql
DROP USER IF EXISTS QUANTI_P2F89CC8E_USER;
DROP ROLE IF EXISTS QUANTI_P2F89CC8E_ROLE;
```

The schemas QUANTI: created stay in your database, with your data: drop them only if you no longer need them.

***

## Field reference

### host — Your Snowflake account host

The host name of the Snowflake account QUANTI: connects to, for example `myorg-myaccount.snowflakecomputing.com`.

**Where to find it**

In Snowsight, open the account menu, then your account › **View account details**, and copy the **Account/Server URL** field, for example `myorg-myaccount.snowflakecomputing.com`. See [Account identifiers](https://docs.snowflake.com/en/user-guide/admin-account-identifier).

**Why it matters**

Entering only the account name, or another address. QUANTI: only accepts hosts that end with `.snowflakecomputing.com`, PrivateLink ones included, and always connects on port 443.

### database — The database QUANTI: writes into

Your Snowflake database, where QUANTI: creates one schema per data source, then its tables.

**Where to find it**

In Snowsight, under **Data › Databases**. The setup script grants QUANTI:'s role `USAGE` and `CREATE SCHEMA` on it.

**Common mistake**

A database created with a quoted lower-case name, such as `"quanti_db"`. QUANTI: converts the name to upper case and looks for `QUANTI_DB`, which does not exist: the check fails. Use a database created without double quotes.

### warehouse — The warehouse QUANTI: loads run on

The warehouse QUANTI: loads run on. It becomes the default warehouse of QUANTI:'s user.

**Where to find it**

In Snowsight, under **Admin › Warehouses**. It must already exist: QUANTI: does not create it.

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

***

## Cost

Everything QUANTI: runs in your Snowflake account is billed to your account.

1. **Connector loads** run on your warehouse. Each load resumes it: Snowflake bills at least 60 seconds, then every second until the warehouse suspends. Its `AUTO_SUSPEND` delay is billed after every load: with 300 seconds, a 20-second load bills about 5 minutes. See [Warehouse considerations](https://docs.snowflake.com/en/user-guide/warehouses-considerations).
2. **Webhook visits** are computed once a night, at 02:30 UTC, by a serverless task: a few seconds of serverless compute.
3. **The access check** only reads metadata: it never starts your warehouse.

If nothing else needs your warehouse to stay on, lower its delay:

```sql
SHOW WAREHOUSES LIKE 'MY_WAREHOUSE';   -- auto_suspend column, in seconds
ALTER WAREHOUSE MY_WAREHOUSE SET AUTO_SUSPEND = 30;
```
