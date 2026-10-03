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

## Audience pushes and event pushes

Pushes fall into two families, and they do not behave the same way.

### Audience pushes — Mirror, Add only, Remove only

The push **creates an object** at the provider: a Customer Match list in Google Ads, a Custom Audience in Meta.

* **On the first sync**, QUANTI: creates the audience under the push's **Destination name**. Pick a name that is not already used in the ad account: QUANTI: adopts an existing audience with the same name and writes into it.
* QUANTI: **keeps a snapshot** of what it sent. Each later sync compares the source with that snapshot and sends **only the differences**: new members, and with Mirror, removed members.
* The audience is then **followed by its ID**. You can rename it at the provider, the sync keeps working. In QUANTI:, the Destination name is **locked after the first sync**: changing it would no longer rename anything at the provider.

| Sync mode | What each sync sends |
| --- | --- |
| Mirror | members added to and removed from the source since the last sync |
| Add only | members added to the source since the last sync, never a removal |
| Remove only | members removed from the source since the last sync, never an addition |

### Event pushes — Insert

The push **feeds an object you already own**: a conversion action in Google Ads, a Meta Pixel, an Adobe data source. Nothing is created and nothing is removed at the provider.

Depending on how the source is set up, a sync sends either **every row** of the source or only the rows added since the last sync. If your source keeps the same events from one day to the next, the same events are sent again at each sync: check how the provider handles an event it already received.

## Resending an audience

Because an audience push only sends differences, an audience that is incomplete at the provider does not fill itself up again: the next syncs keep sending the changes of the day. This happens when the audience is deleted at the provider and created again by QUANTI:, or when an earlier sync could not deliver it in full. The fix is to resend the whole source once.

### reverse_resync — Resend the full audience

Sends every member of the source to the provider once, instead of only the changes since the last sync — to rebuild an audience that is much smaller at the provider than in your data warehouse.

**Where to find it**

On the push card of the Mapping tab, left of Active. It is offered for audience pushes (Mirror, Add only) and becomes available once the first sync has run — before that, nothing has been sent and there is nothing to resend. Event and conversion pushes (Insert) do not have it: they feed an object you already own, there is no audience to rebuild. The action starts a sync right away, and is refused while a sync is running.

**Why it matters**

Deleting the audience in the ad account and expecting QUANTI: to rebuild it. At the next sync QUANTI: creates a new audience under the same name, but only sends it the changes of the day: the audience stays almost empty while every sync shows as successful. Click Resend full audience once after the audience has been recreated. Note that a resend never removes anyone: people who left your source since the last sync stay in the audience until you remove them at the provider.
