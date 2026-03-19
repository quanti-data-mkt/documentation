---
description: 'Follow our setup guide to connect Piano to QUANTI:'
hidden: true
---

# Piano Analytics

<a href="https://dbdiagram.io/e/684ae2df1dff20a534ca7171/684ae3f71dff20a534ca9d5f" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

{% hint style="warning" %}
**Piano Analytics limits the number of rows returned per query to 1,500,000.**\
We split our queries by day and by account, but it’s important to understand that if a single query for one account exceeds 1,500,000 rows, the API returns an error.\
As a result, the query fails, and the data is not inserted into our system.

To avoid this, make sure to use the filtering feature to reduce the number of returned rows and stay within the API limits.
{% endhint %}

***

## <mark style="background-color:yellow;">Prerequisites</mark>

To connect Piano to QUANTI, you need an [Piano](https://piano.io/fr/?utm_source=quanti.io\&utm_medium=partnership\&utlm_campaign=campaign=ecommerce-data-connector) account.

***

## <mark style="background-color:yellow;">Setup instructions</mark>

### Find your credentials

1.  Go on your profile parameters to the top-right corner : See profile < API Key<br>

    <figure><img src="../../.gitbook/assets/piano1 (1).png" alt="Access path to API keys on Piano interface"><figcaption><p>Access path to API keys on Piano interface<br></p></figcaption></figure>
2.  Create a new API Key clicking on the blue button "Create a new API Key".\
    <br>

    <figure><img src="../../.gitbook/assets/piano2 (1).png" alt="Button to generate a new API key on Piano interface" width="263"><figcaption><p>Button to generate a new API key</p></figcaption></figure>


3.  Give it a name and a description. Let the box ticked and save it.\
    <br>

    <figure><img src="../../.gitbook/assets/piano3 (1).png" alt="Description pop-in of API key in Piano interface" width="563"><figcaption><p>Description pop-in of API key</p></figcaption></figure>


4. Make a note of the API credentials. You will need it to configure QUANTI:.

### Find your Website ID

Your **Website ID** is in the url when you are connected to your Piano account. This is the value of the parameter **site**.

`https://explorer.atinternet-solutions.com/core/#/overview/overview/020202?period.shortcut=yesterday&period.granularity=3&site=`**`612329`**`&graph.options.defaultlist=minmax&graph.options.comparisonlist=nocomparison&graph.options.eventloglist=eventlog&isIgnoreNullProperties=false`

### Connector configuration

1. Authorize your account
   1. Access Key and Secret Key retrieved following the steps above.
   2. Site ID retrieved following the steps above.
2. Connector information
   1. Connector Name : Name your connector. It must be unique.
   2. Dataset ID : Define the ID of the dataset. It must not exist yet, as it will be created and data will be sent there.
3. Create queries : Create your own custom queries. To help you, refer to the 'Custom Query' chapter below."

***

## <mark style="background-color:yellow;">Prebuilt reports</mark>

* **content\_pages**: Contains daily records of user interactions for each website page, enabling content-level performance tracking.
* **traffic\_sources**: Describes how users arrive on the site, with detailed information about traffic origin, campaigns, and referrers.
* **transaction\_source**: Stores transactional data along with marketing attribution fields, providing insight into the source and context of each purchase.

***

<a href="https://dbdiagram.io/e/684ae2df1dff20a534ca7171/684ae3f71dff20a534ca9d5f" class="button primary" data-icon="table-tree">Pre-built tables and definition  </a>

***

### \<mark style="background-color:yellow;">Custom reports\</mark>

\{% hint style="warning" %\} **Piano Analytics limits the number of rows returned per query to 1,500,000.**\
We split our queries by day and by account, but it's important to understand that if a single query for one account exceeds 1,500,000 rows, the API returns an error.\
As a result, the query fails, and the data is not inserted into our system.

To avoid this, make sure to use the filtering feature to reduce the number of returned rows and stay within the API limits. \{% endhint %\}

\{% stepper %\} \{% step %\}

#### Retrieve your field names from Piano Analytics

The easiest way to identify the field names expected by the Piano API is to use the **Data Query** tool directly in the Piano Analytics interface.

* In Piano Analytics, navigate to **Data Query** (top-right corner, icon with 4 squares)
* Build the report you want to extract via the QUANTI connector by selecting your dimensions and metrics
* Once your report is configured, click the **copy/paste button** in the top-right corner, then select **Copy the API body (POST)**

`[📸 Screenshot — Copy the API body (POST) button location]`

* A pop-in appears with the full API body. Retrieve:
  * The content of the `columns` object → this will populate the `fields` array in your JSON
  * The content of the `filter` object (if any) → this will populate the `filter` field in your JSON

\{% endstep %\}

\{% step %\}

#### Configure the custom report query

In QUANTI, at the **Create reports** step, click **Add custom report**. A pop-in opens with two steps: **Query** and **Schema**.

In the **Query** step:

* Give your report a name in the **Query name** field — this name will become the table name in your data warehouse

\{% hint style="danger" %\} The name chosen for your custom report is the one that names your table in the data warehouse. \{% endhint %\}

* Fill in the **Query configuration (JSON)** with the following structure:

json

```json
{
  "fields": [],
  "sort": [],
  "filter": ""
}
```

* **`fields`** _(required)_: Paste the field names retrieved from Piano Analytics. Each field name must be a quoted string, separated by commas.\
  Example: `"fields": ["src", "page", "m_visits", "m_page_loads"]`
* **`sort`** _(optional)_: List of fields to sort by. Can be left empty.
* **`filter`** _(optional)_: Paste the filter expression copied from the Piano API body. Can be left as an empty string if no filter is needed.

`[📸 Screenshot — Query configuration pop-in (step 1 : Query)]`

Once your JSON is filled in, click **Next**.

\{% endstep %\}

\{% step %\}

#### Map your fields (Schema)

The second step of the pop-in is the **Schema** mapping. QUANTI infers the type of each field and displays them in a table.

`[📸 Screenshot — Schema mapping step (step 2 : Schema)]`

For each field, you can:

* Adjust the **Type** (STRING, INTEGER, FLOAT, etc.)
* Check **Quanti ID** to mark the field as a primary key identifier — this should include all dimension fields of your report, as they collectively form the unique identifier of each row
* Check **Quanti Date** to mark the field used as the partition date
* Check **Metric** to flag a field as a numeric metric

Once all fields are correctly mapped, click **Save** to create the custom report table.

\{% endstep %\} \{% endstepper %\}

\{% hint style="info" %\} **Limits**

* Max 50 dimensions and metrics per Custom Report
* Piano Analytics limits the number of rows returned per query to 1,500,000 — use filters to stay within this limit \{% endhint %\}

***

## <mark style="background-color:yellow;">Limits</mark>

* Max 50 dimensions and metrics per Custom Query
*   Piano Analytics limits the number of rows returned per query to 1,500,000.\
    We split our queries by day and by account, but it’s important to understand that if a single query for one account exceeds 1,500,000 rows, the API returns an error.\
    As a result, the query fails, and the data is not inserted into our system.

    To avoid this, make sure to use the filtering feature to reduce the number of returned rows and stay within the API limits.

