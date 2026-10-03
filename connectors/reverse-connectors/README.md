---
description: 'How QUANTI: reverse connectors send data from your data warehouse to advertising and analytics platforms'
---

# Reverse connectors

A reverse connector sends data **from** your data warehouse **to** a platform: an audience to Google Ads or Meta, conversions to Google Ads, events to a Meta Pixel, data to Adobe Analytics. It is the opposite of a regular connector, which brings data **into** your data warehouse.

## How a push works

Each reverse connector offers one or more **pushes**. A push has:

* a **source**: a table or a view of your data warehouse;
* a **mapping**: which column of the source fills which field of the destination (email, phone, conversion value…);
* a **sync mode**, set by the push itself and shown on its card: it decides what each sync sends.

Pushes run with the connector: on the **Auto-sync** schedule, or on demand with **Sync now**.

## Two families of pushes

Pushes fall into two families, and they do not behave the same way. The sync mode shown on the push card tells which one a push belongs to.

### Pushes that keep a destination in sync — Mirror, Add only, Remove only

The push **creates an object** at the provider and keeps it in line with your source: for example a Customer Match list in Google Ads or a Custom Audience in Meta.

* **On the first sync**, QUANTI: creates the destination under the push's **Destination name**. Pick a name that is not already used in the ad account: QUANTI: adopts an existing destination with the same name and writes into it.
* QUANTI: **keeps a snapshot** of what it sent. Each later sync compares the source with that snapshot and sends **only the differences**.
* The destination is then **followed by its ID**. You can rename it at the provider, the sync keeps working. In QUANTI:, the Destination name is **locked after the first sync**: changing it would no longer rename anything at the provider.

| Sync mode | What each sync sends |
| --- | --- |
| Mirror | rows added to and removed from the source since the last sync |
| Add only | rows added to the source since the last sync, never a removal |
| Remove only | rows removed from the source since the last sync, never an addition |

### Pushes that send events — Insert

The push **feeds an object you already own**: a conversion action in Google Ads, a Meta Pixel, an Adobe data source. Nothing is created and nothing is removed at the provider.

Depending on how the source is set up, a sync sends either **every row** of the source or only the rows added since the last sync. If your source keeps the same events from one day to the next, the same events are sent again at each sync: check how the provider handles an event it already received.

## Full resync

Because a Mirror or Add only push only sends differences, a destination that is incomplete at the provider does not fill itself up again: the next syncs keep sending the changes of the day. This happens when the destination is deleted at the provider and created again by QUANTI:, or when an earlier sync could not deliver it in full. The fix is to resend the whole source once.

### reverse_resync — Full resync

Sends every row of the source to the provider once, instead of only the changes since the last sync — to rebuild a destination that holds much less at the provider than your data warehouse.

**Where to find it**

On each push card of the Mapping tab, under Active. It is usable on Mirror and Add only pushes once the first sync has run; until then it is greyed out, since nothing has been sent yet. It stays greyed out on Insert pushes, which keep no record of what they sent, and on Remove only pushes, where a resync would only send additions that the mode ignores — hover the button to see why. The action starts a sync right away, and is refused while a sync is running.

**Why it matters**

Deleting the destination at the provider — an audience in the ad account, for example — and expecting QUANTI: to rebuild it. At the next sync QUANTI: creates a new one under the same name, but only sends it the changes of the day: it stays almost empty while every sync shows as successful. Run a Full resync once after it has been recreated. Note that a full resync never removes anything: rows that left your source since the last sync stay at the provider until you remove them there.
