---
description: >-
  How QUANTI: writes webhook hits into your Snowflake account, and how it groups
  them into visits each night.
---

# Webhooks on Snowflake

On a Snowflake project, webhook data lands in your account in two stages: the **hits** arrive within about a minute, the **visits** are computed once a night. Neither stage starts your warehouse.

```
your website ──hit──▶ QUANTI: ──Snowpipe Streaming──▶ RAW_HITS            (~1 min)
                                                        │
                    each night, 02:30 UTC               ▼
                    serverless task RAW_SESSIONS_BUILD ──▶ RAW_SESSIONS   (previous day)
                                                        │
                                                        ▼
                                          view RAW_HITS_WITH_SESSION
                                          (each hit with its visit)
```

## Hits: Snowpipe Streaming

QUANTI: collects the hits of your webhook, groups them for up to **60 seconds**, then sends them to your account with **Snowpipe Streaming**: rows go straight into the table over HTTPS, without files and without a warehouse. Snowflake makes them visible about **20 seconds** later.

A hit therefore shows up in `RAW_HITS` about a minute after it was sent.

In Snowsight, the table has a pipe named `RAW_HITS-STREAMING`. Snowflake creates and manages it. Its graph shows **Stage not found**: this is expected, streaming uses no stage.

## Visits: a nightly serverless task

A **visit** (or session) groups the hits of one visitor until **30 minutes** pass without a new hit. Each visit gets its source, its landing and exit pages, its page views, events and conversions. The fields are described in [raw\_sessions](../tag-tracker/tag-data-model/raw_sessions.md).

On Snowflake, a task in your account computes them:

1. Each night at **02:30 UTC**, the task `RAW_SESSIONS_BUILD` reads the hits of the **previous day**.
2. It groups them into visits and replaces that day in `RAW_SESSIONS`, in one transaction: running it twice never duplicates a visit.
3. The view `RAW_HITS_WITH_SESSION` gives every hit with the `session_id` of its visit.

The task is **serverless**: Snowflake provides the compute, your warehouse is never started. QUANTI: creates the task and the view the first time it checks your webhook, then every day makes sure the task is still there and ran.

{% hint style="info" %}
**Visits arrive the next day.** On BigQuery, a visit appears 30 minutes after its last hit. On Snowflake, the visits of a day appear after 02:30 UTC the next night, and the hits of today have no `session_id` in the view until then.
{% endhint %}

A visit that starts before midnight UTC and goes on after it belongs to the day it started.

### The privilege the task needs

Creating and running a serverless task needs one more privilege, once per project. The **Install code** tab of your webhook shows it with your role filled in:

```sql
GRANT EXECUTE MANAGED TASK, EXECUTE TASK ON ACCOUNT TO ROLE QUANTI_P2F89CC8E_ROLE;
```

Run it as ACCOUNTADMIN. Without it, hits are still collected, but no visits are computed. See [BYOD Snowflake](byod-snowflake.md).

## Objects in your account

All of them are in the schema of your webhook, in the database of your project.

| Object | Type | Created by | What it is |
|---|---|---|---|
| `RAW_HITS` | table | QUANTI: | One row per hit. |
| `RAW_HITS-STREAMING` | pipe | Snowflake | Receives the hits. Managed by Snowflake. |
| `RAW_SESSIONS` | transient table | QUANTI: | One row per visit. Transient: no Fail-safe, since it is rebuilt from `RAW_HITS`. |
| `RAW_SESSIONS_BUILD` | serverless task | QUANTI: | Computes the visits of the previous day, each night. |
| `RAW_HITS_WITH_SESSION` | view | QUANTI: | `RAW_HITS` with the `session_id` of each hit. |

## Check the last run

The task writes the result of its last run in the comment of `RAW_SESSIONS`:

```sql
SHOW TABLES LIKE 'RAW_SESSIONS' IN SCHEMA MY_DATABASE.MY_WEBHOOK_SCHEMA;
-- comment: intake-sessions ok day=2026-10-20 sessions=1234 at=…
-- or:      intake-sessions error day=… at=… <message>
```

Snowflake keeps the history of the runs:

```sql
SELECT name, state, error_message, query_start_time, completed_time
FROM TABLE(MY_DATABASE.INFORMATION_SCHEMA.TASK_HISTORY(TASK_NAME => 'RAW_SESSIONS_BUILD', RESULT_LIMIT => 7));
```

A failed run leaves the visits already computed untouched.

## Pause the visits

To stop computing visits, suspend the task:

```sql
ALTER TASK MY_DATABASE.MY_WEBHOOK_SCHEMA.RAW_SESSIONS_BUILD SUSPEND;
```

QUANTI: never resumes a task you suspended. Hits keep arriving in `RAW_HITS`. To start again: `ALTER TASK … RESUME;`.

## Cost

Everything is billed to your Snowflake account, and neither stage uses your warehouse.

| What | Billing |
|---|---|
| Hits | Snowpipe Streaming, **0.0037 credit per GB** received. See [Snowpipe Streaming costs](https://docs.snowflake.com/en/user-guide/snowpipe-streaming/snowpipe-streaming-high-performance-cost). |
| Visits | A few seconds of serverless compute per night. A test run on 2026-10-20 took 2.9 seconds. |
| Storage | Normal Snowflake storage for `RAW_HITS` and `RAW_SESSIONS`. |
