# sGTM — field reference

Field-level reference for server-side tagging servers.

Each section below is addressed directly by the in-product help panel: **the
heading is the key**, so keep it stable. A readable title may follow after an em
dash — it becomes the panel title.

### container_config — Where to find your container configuration

The **Container Config** of your Tag Manager **server** container: a long encoded
string that carries your container ID, its environment and its authorization
code. It is not the `GTM-XXXXXXX` identifier.

**Where to find it**

[Watch: find your container config in Tag Manager](https://quanti-docs-assets.s3.fr-par.scw.cloud/sgtm/gtm-container-config-20260917.mp4)

In [Tag Manager](https://tagmanager.google.com), open your **Server** container →
*Admin* → *Container Settings* → *Manually provision tagging server* → copy the
**Container Config** block.

**Why it matters**

If you paste the container ID instead of the config, the server has no
authorization code and cannot fetch your container from Google — it starts, then
answers nothing useful. The config is the only value that carries all three
pieces at once.

**Is it secret?**

Yes. It encodes the authorization code of your container. We store it in a secret
vault, never in our database, and it is never displayed again after setup.

### subdomain — The subdomain your site will call

The host part of your collection domain, before your own domain: `gtm` gives
`gtm.yoursite.com`. Every tagging request from your site goes there.

**Pick it before you start:** changing it later means editing the snippet on every
page of every site that uses it.

**Why it must be your own domain**

A tagging server on a third-party domain is treated as third-party by browsers,
and its cookies are capped or dropped. Serving from your own domain is the entire
point of the product — it is what keeps measurement alive under Safari and under
ad blockers.

### dns_zone — Your domain, as your registrar knows it

The domain you own and manage: `yoursite.com`. Not the subdomain, and not the
full host — just the zone in which you will add the records.

If your site is `shop.yoursite.com` but your DNS zone is `yoursite.com`, enter
`yoursite.com` here. The subdomain field above holds the rest.

### region — Where your server runs

The physical location of the machine that receives your traffic. Pick the one
closest to your visitors: it is the only field here that affects response time.

It cannot be changed afterwards — moving a server means creating a new one and
repointing DNS.

### dns_records — The records to add at your registrar

Add these at your DNS provider, in the zone you declared. We check them
automatically and the server goes live once they have propagated — usually
minutes, sometimes a few hours.

**Why A and AAAA, and never a CNAME**

This is the most important thing on this page. Safari's tracking prevention
recognises a subdomain that is a CNAME pointing outside your domain, and caps the
cookies it sets to **7 days** — after which every returning visitor looks new.
Pointing A and AAAA records directly at IP addresses is invisible to that
mechanism, and your cookies keep their full lifetime.

Several hosting providers only offer a CNAME. We do not, and that is deliberate.

**TTL**

Use the value we suggest. A shorter TTL costs nothing here and makes a future
change take effect quickly.

### domain_change — Changing the collection domain

Changing this domain does **not** update the snippet already installed on your
pages. Until you deploy the new one, your sites keep calling the old host, which
stops answering — so collection stops.

Plan it in this order: change the domain here, add the new DNS records, wait for
the check to pass, then deploy the new snippet. Not the other way around.

### web_container — Where to find your web container ID

The ID your website **already loads** — from the **web** container in your Tag
Manager account. It is *not* the server container ID shown further down that
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

### snippet — Installing the snippet on your site

Two blocks: the first goes in `<head>`, as high as possible; the second goes right
after the opening `<body>` tag. They replace the Google Tag Manager snippet you
have today.

**You can migrate one site at a time.** The standard paths keep being served, so a
site still running the old snippet keeps collecting normally. You can also roll
back at any point by restoring the previous snippet — nothing is lost on the
server side.

**Do not edit the URLs by hand.** The paths are specific to this server and to
this container; a hand-written variation will be answered with a `404`.

### adblock_paths — Why the paths look unusual

Ad blockers do not only match domains. Their public filter lists contain patterns
for Google's default paths and for the `?id=GTM-…` parameter — including on
first-party domains. A tagging server that keeps the default paths is recognised
whatever domain it runs on.

This server answers on paths that belong to it alone, and hides your container ID
in the query string. The result is a request that no published rule matches today.

**This works only if your site uses the generated snippet.** Serving unusual paths
changes nothing as long as the page still requests the standard one.

### library_slug — The path this library will be served under

The name that appears in the URL your pages will call: `tracker` gives
`/lib/tracker`. Choose something neutral — the point is to avoid the vendor's own
domain and file name, both of which are widely filtered.

### library_origin — The publisher URL to proxy

The address where the script lives at the vendor's, copied exactly as they publish
it.

**The trailing slash is not cosmetic.** An origin without one is a **precise
file**: `https://cdn.vendor.com/tracker.js` proxies that file and nothing else. An
origin with one is a **directory**: everything underneath is reachable. Adding a
slash to a file address makes every request miss, and the vendor answers `404` —
so the tag silently stops working.

Copy what the vendor gives you, do not tidy it up.

### billable_hits — What counts as a billable hit

A request is billable when all three are true:

* it is a `GET` or a `POST`;
* the tagging container answered it with a `2xx` status;
* its path is not one of the technical endpoints (health checks and similar).

**What is never billed:** the loader script, the proxied libraries, anything this
server answers on its own, and every request the container rejects. If no tag of
yours claims a request, the container answers `404` and it is not counted.

**A dash instead of a number** means this server predates hit counting and has no
meter yet — not that it received no traffic. Ask us to migrate it.

### traffic — Requests served

The number of requests this server handled over the period, as measured by the
load balancer in front of it.

⚠️ **This is not the billable hit count.** It counts every request that reached the
server, including our own health checks and requests the container rejected, and
it cannot see the path. Use it to watch trends and spot an outage; use *Billable
hits* for anything related to your invoice.

The error rate counts `5xx` responses only: a `4xx` means the request itself was
malformed or unclaimed, which says something about the caller, not about the
server.

### availability — How availability is measured

The share of time the server answered our health check over the period. The check
is a real HTTP request to the container, not a simple port test — a container that
is up but broken is counted as down, which is what you would expect.

**No verdict before the server is active.** During setup the infrastructure exists
before the containers finish starting; showing "not responding" then would
announce an outage where there is only a wait.

**History:** our metrics provider keeps 31 days. We archive every day to keep a
full year, so a long-term figure remains available even after a server is deleted.

### server_status — What each status means

| Status | What is happening |
| --- | --- |
| Creating | The machine is being created. |
| Pending DNS | Waiting for your records to resolve. Nothing to do on our side. |
| Issuing certificate | The HTTPS certificate is being issued for your domain. |
| Starting | The machine is up and installing the tagging containers. |
| Active | The server is answering on your domain. |

**Starting can last up to fifteen minutes.** The server downloads Google's
container image on first boot; it is not stuck. We only declare the server active
once both the tagging endpoint and the preview endpoint answer — announcing it
earlier would send the preview mode onto a server that is not ready, which looks
exactly like a broken setup.

Beyond fifteen minutes, we stop and report an error rather than leave a server
that looks healthy while answering nothing.
