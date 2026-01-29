# Primary key

The **Primary Key (PK)** is the set of fields that **uniquely** identify a row in your table.

**Concrete examples:**

**Daily metrics table** (fact table)

```
Primary Key: (date, campaign_id, ad_id)
```

| date       | campaign\_id | ad\_id  | impressions | clicks |
| ---------- | ------------ | ------- | ----------- | ------ |
| 2025-01-15 | camp\_123    | ad\_456 | 1000        | 50     |
| 2025-01-15 | camp\_123    | ad\_789 | 800         | 30     |

Each combination (date + campaign\_id + ad\_id) identifies a unique row.

**Campaign attributes table** (dimension table)

```
Primary Key: (campaign_id)
```

| campaign\_id | name            | status | budget |
| ------------ | --------------- | ------ | ------ |
| camp\_123    | Summer Campaign | ACTIVE | 5000   |
| camp\_456    | Winter Campaign | PAUSED | 3000   |

Each campaign\_id identifies a unique campaign.

{% hint style="info" %}
Why is this important?

The Primary Key concept allows you to define which table attributes identify each row as unique. This is essential for:

* **Determining the behavior of the UPSERT method**: should an existing row be updated or should a new row be inserted?
* **Avoiding duplicates** in your tables
* **Guaranteeing the uniqueness of each row and data integrity**, two essential concepts in data management
{% endhint %}
