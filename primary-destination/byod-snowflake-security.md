---
description: >-
  What QUANTI:'s Snowflake setup script grants, how to share your own tables,
  how to cut access, and what it costs.
---

# Snowflake: security and costs

Setting up the project: [Snowflake](byod-snowflake.md).

## What the script does

The script creates **who** QUANTI: is in your account (a user), and **what** it may do (two roles). Nothing else.

```
ACCOUNTADMIN ──creates──▶ QUANTI_<ID>_ROLE ◀──held by── QUANTI_<ID>_USER (public key)
                              │                                 │
                              ├─ USAGE                  → your warehouse  (run loads)
                              ├─ USAGE + CREATE SCHEMA  → your database   (1 schema per source)
                              └─ EXECUTE (MANAGED) TASK → account         (webhook visits, optional)
                                                                │
ACCOUNTADMIN ──creates──▶ QUANTI_<ID>_READER ◀──held by─────────┘
                              ├─ USAGE                  → your warehouse  (AI assistant queries)
                              ├─ USAGE                  → your database
                              └─ SELECT, granted by QUANTI: → only the schemas QUANTI: creates
```

1. **The `SET` lines** are worksheet variables, used only while the script runs. `identifier($x)` turns a variable into an object name.
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
9. **`EXECUTE MANAGED TASK`, `EXECUTE TASK`**: webhooks only, see [Webhooks: visits](byod-snowflake.md#webhooks-visits).
10. **The read-only role `QUANTI_<ID>_READER`**: the AI assistant queries your data with it, never with the loading role. The script gives it no read right: each time QUANTI: creates a schema, it grants this role `SELECT` on that schema's tables and views, and nothing else. So the assistant cannot write, and cannot read your own schemas unless you grant them yourself (see **Tables you created yourself**).
11. **`WITH MANAGED ACCESS`**: QUANTI: creates its schemas in this mode. Only the schema's owner, QUANTI:'s loading role, or ACCOUNTADMIN can grant access to its tables. That is what lets QUANTI: open them to the read-only role without any account-wide privilege.

## Tables you created yourself

QUANTI: sees the schemas and tables it creates: they belong to its role. A table you created yourself, in `PUBLIC` or any other schema, belongs to **your** role, and QUANTI: cannot see it. Give read access to the role that needs it:

| To… | Grant to |
|---|---|
| push the table to a destination with a **reverse connector** | `QUANTI_<ID>_ROLE`, the loading role |
| declare it in a **semantic view**, so the AI assistant can query it | `QUANTI_<ID>_READER`, the read-only role |

The AI assistant only reads with `QUANTI_<ID>_READER`: a table granted to `QUANTI_<ID>_ROLE` alone stays invisible to it. For both uses, grant both roles.

Give read access, nothing more: `USAGE` on the schema, `SELECT` on the table. Run as ACCOUNTADMIN, or as the role that owns the table. For the reverse connector:

```sql
GRANT USAGE  ON SCHEMA NEW_DB.PUBLIC        TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON TABLE  NEW_DB.PUBLIC.ADOBE1 TO ROLE QUANTI_P2F89CC8E_ROLE;
```

For the AI assistant, the same lines with the read-only role:

```sql
GRANT USAGE  ON SCHEMA NEW_DB.PUBLIC        TO ROLE QUANTI_P2F89CC8E_READER;
GRANT SELECT ON TABLE  NEW_DB.PUBLIC.ADOBE1 TO ROLE QUANTI_P2F89CC8E_READER;
```

For every table of a schema, including the ones you create later (replace `_ROLE` by `_READER` for the AI assistant):

```sql
GRANT USAGE  ON SCHEMA NEW_DB.PUBLIC                    TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON ALL TABLES    IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON ALL VIEWS     IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
GRANT SELECT ON FUTURE VIEWS  IN SCHEMA NEW_DB.PUBLIC   TO ROLE QUANTI_P2F89CC8E_ROLE;
```

In Snowsight, you can also open the table, go to **Access › + Privilege**, pick QUANTI:'s role and the `SELECT` privilege; the schema still needs `USAGE`.

{% hint style="info" %}
Run the `FUTURE` lines as ACCOUNTADMIN: in a schema of your own, Snowflake refuses them to the schema's owner.
{% endhint %}

{% hint style="warning" %}
Never grant `OWNERSHIP` or write privileges on your tables: QUANTI: only reads them.
{% endhint %}

## Cut or remove QUANTI:'s access

To cut it at once, reversibly:

```sql
ALTER USER QUANTI_P2F89CC8E_USER SET DISABLED = TRUE;
```

When you delete the project in QUANTI:, its user and role stay in your account. Remove them yourself:

```sql
DROP USER IF EXISTS QUANTI_P2F89CC8E_USER;
DROP ROLE IF EXISTS QUANTI_P2F89CC8E_ROLE;
DROP ROLE IF EXISTS QUANTI_P2F89CC8E_READER;
```

The schemas QUANTI: created stay in your database, with your data: drop them only if you no longer need them.

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
