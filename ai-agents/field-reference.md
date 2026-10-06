# Field reference

Field-level reference. The heading of each section is its help key.

### active — What “active” means for an agent

An agent is active for the project when at least one member follows it: it then writes its plan, runs it every day (or week, or month for managers) and produces recommendations that are shared by the whole project.

**Where to find it**

Analyze › Agents › My agents. The switch on each row means “I follow this agent”; the green badge “active · N members” tells how many members follow it. An agent nobody follows is paused: it stops running and keeps its instructions and settings for the next time someone follows it.

**Why it matters**

Expecting to receive recommendations from an agent that is active because a colleague follows it. Recommendations are computed once for the project, but each member only receives, by email, those of the agents they follow themselves — an active agent with no follower of your own writes to nobody. Follow it from My agents to get its emails; the Recommendations screen, however, always shows everything the project’s agents found.

### plan_status — The plan and its status

The plan is what the agent decided to check on your data: one or more checks (KPIs), each tied to one of its actions, with the reason it chose it. The agent writes it once, from your connectors and your instructions, then runs it unchanged every time — it does not rediscover your data at each run.

**Where to find it**

In the agent’s panel, section “What it actually checks on your data”. The badge next to the version gives the status: active = the plan has at least one valid check and runs on schedule; failed = none of its checks passed validation, the error line says why and each check carries its own reason; superseded = replaced by a newer version (after “Plan again”, new instructions or a change in your connectors).

**Why it matters**

Reading “failed” as a bug and planning again right away with the same instructions: the agent will reach the same conclusion. A plan fails when the agent could not build a reliable check — typically a data source it needs is not connected yet (no orders table for a revenue check), or the figures it needs are not in the tables it can see. Read the reason on each check first, then either connect the missing source or adjust the instructions, and only then plan again.
