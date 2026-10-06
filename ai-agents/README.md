# AI agents

A team of agents watches your data and sends you recommendations. You do not ask them anything: they run on their own, on the data you have already connected, and write to you when something deserves attention.

## An organisation, not a chatbot

The agents are organised like a company: a CEO, directions (data, finance, marketing, operations), and specialists under each of them — paid media pacing, campaign anomalies, tracking audit, data quality, FinOps, stock, churn, and so on. The structure is the same for every project. What changes from one project to the next is which agents are applicable (a stock agent needs an orders or inventory source), which ones you follow, and what you tell them.

Two kinds of agents:

- **Specialists** watch the data. Each one writes its own plan, runs it on schedule and produces recommendations.
- **Managers** never look at the data. Every week or month, they read what their team found and write a short summary for a decision maker: what puts the activity at risk, what improved, the two decisions to take.

## How a specialist works

1. **You follow it** (Analyze › Agents › My agents). It is applicable when the project has the sources it needs; if not, the row says which source is missing.
2. **It writes its plan.** Within the hour, the agent reads your project context, the tables of your connected sources and your instructions, and decides what to check: a few precise checks, each tied to one of its actions, with the reason it chose it. The plan is visible in the agent’s panel, including the checks it rejected and why.
3. **It runs on schedule** — daily for most specialists, after the night’s synchronisations — without rediscovering your data: the same checks, every time. Only when a check finds something does it write a recommendation, in your language.
4. **It learns from your answers.** Dismissing a recommendation with a reason, changing a threshold, adding an instruction: all of it is read at the next planning.

The plan is rewritten when your instructions change, when a connector is added or removed, or when you ask for it (“Plan again”).

## What you control

| Where | What | Shared or personal |
|---|---|---|
| My agents › switch | which agents you follow | personal — but the agent runs for the project as soon as one member follows it |
| My agents › Edit › Your instructions | what the data does not say: budgets, goals, exclusions | shared by the project |
| My agents › Edit › What it watches | each action on or off, and its thresholds | shared by the project |
| Recommendations | Got it, Later, Dismiss | shared: a recommendation answered by one member is answered for everyone |
| Email alerts | instantly, daily, weekly, off; minimum severity | personal |
| Settings › Personal settings | your language | personal — recommendations and emails are written in it |

## What arrives by email

One email per member, grouping everything new for you since the previous one: the recommendations of the agents you follow, by agent, with the managers’ summaries first. Nothing is sent when there is nothing new. Each recommendation carries a short reference you can use with your assistant (ChatGPT, Claude): “review recommendation a1b2c3d4”.

## From your assistant

The same objects are available through the Quanti MCP server: list the agents, follow one, give it instructions, read a plan, list and review recommendations. Writing actions need a signed-in user: with an API key (Open WebUI), the assistant can read but not change anything.

See the [field reference](field-reference.md) for each screen element.
