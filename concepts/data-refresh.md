# Data Refresh

**Data Refresh** is QUANTI:'s scheduling feature. It lets you programmatically plan and automate the launch of your data sync processes on a recurring basis.

On the Free plan, syncs must be triggered manually. From the Pro plan onwards, Data Refresh automates this with a daily schedule. The Enterprise plan extends this to hourly scheduling.

| Plan | Data Refresh |
|---|---|
| Free | Manual only |
| Pro | Daily |
| Growth | Daily |
| Expert | Daily |
| Enterprise | Daily or Hourly |

### sync_schedule — Choosing the hour your sync runs

Sets the time of day Data Refresh starts this connector, which decides what its source already contains when it reads it.

**Where to find it**

In the Sync tab of the connector, next to the frequency. To pick it, open the connectors that feed this one and read the end time of their last runs in their execution history: your sync must start after the latest of them, not at the same hour.

**Why it matters**

Leaving every connector on the same default hour. It is harmless as long as each one reads an outside platform, but any connector reading a table that another one writes will then read it mid-refresh. It returns no row, the run ends green, and nothing is reported: an empty source and a source with nothing new look identical. Measured on a reverse push reading a warehouse view at 03:00, while the orders table it joins finished loading at 03:13 and the margin table at 06:40. Four nights in a row returned zero, and 45 purchase events were never sent to the ad platform. The same windows replayed by hand at 07:00 sent them without a single rejection.
