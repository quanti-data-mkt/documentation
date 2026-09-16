# sGTM — field reference

Field-level reference for server-side tagging servers.

Each section below is addressed directly by the in-product help panel: **the
heading is the key**, so keep it stable. A readable title may follow after an em
dash — it becomes the panel title.

This page is deliberately absent from `SUMMARY.md` while contextual help is being
piloted: it is therefore neither published in the documentation navigation nor
indexed by the assistant.

### web_container — Where to find your web container ID

The ID your website **already loads** — from the **web** container in your Tag
Manager account. It is *not* the server container ID shown further down this
page, even though both look like `GTM-XXXXXXX`.

**Where to find it**

1. Open [Tag Manager](https://tagmanager.google.com) and select your account.
2. In the container list, pick the one whose **Type** is *Web*.
3. The ID appears at the top right of the workspace, next to the container name.

**Why it matters**

The snippet generated here replaces the one currently on your site. If you paste
your **server** container ID instead, the snippet is perfectly valid — and the
tagging server answers `400`. Your site ends up with no tags at all, with nothing
on the page to show it.

We reject the value when it matches the server container of *this* server, but we
cannot detect a different wrong container: only your Tag Manager account knows
which one your site loads.

**Several containers?**

Declare every web container you load through this server. Each one gets its own
snippet: the container ID is scrambled differently per container, so a snippet
cannot be reused from one to the next.
