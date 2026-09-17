# Field reference

Field-level reference. The heading of each section is its help key.

### hub_id — Where to find your HubSpot Hub ID

Identifies the HubSpot portal the connector reads from; every request is scoped to this Hub ID.

**Where to find it**

In HubSpot, open the account menu at the top right of the navigation bar: the Hub ID is displayed under your account name. It also appears in the URL of any HubSpot screen, as in app.hubspot.com/contacts/26488960/. It is an 8-digit number.

**Why it matters**

Entering a Hub ID that belongs to a different portal than the one authorized during the OAuth connection. Authentication and scoping are two independent settings here: the run authenticates successfully against the authorized portal, then queries the Hub ID you typed, so the process reports success and every table comes back empty.
