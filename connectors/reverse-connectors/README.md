# Reverse connectors

### reverse_resync — Resend the full audience

Sends every member of the source to the provider once, instead of only the changes since the last sync — to rebuild an audience that is much smaller at the provider than in your data warehouse.

**Where to find it**

On the push card of the Mapping tab, left of Active. It is offered for audience pushes (Mirror, Add only) and becomes available once the first sync has run — before that, nothing has been sent and there is nothing to resend. Event and conversion pushes (Insert) do not have it: they feed an object you already own, there is no audience to rebuild. The action starts a sync right away, and is refused while a sync is running.

**Why it matters**

Deleting the audience in the ad account and expecting QUANTI: to rebuild it. At the next sync QUANTI: creates a new audience under the same name, but only sends it the changes of the day: the audience stays almost empty while every sync shows as successful. Click Resend full audience once after the audience has been recreated. Note that a resend never removes anyone: people who left your source since the last sync stay in the audience until you remove them at the provider.
