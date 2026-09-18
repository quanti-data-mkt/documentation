# Server-side tagging

A tagging server of your own, on your own domain.

Your site sends its measurement hits to `gtm.yoursite.com` instead of Google's
domains. That server runs the official Google Tag Manager **server** container and
forwards the data to GA4 and to your other destinations.

**Your container stays yours.** We host and operate the server; the Tag Manager
account, the tags and the decisions remain in your hands. Delete the server and
your container is untouched.

## What it changes

**Measurement travels first-party.** Requests go to a subdomain of your own
domain, through DNS records you control.

**Fewer requests are dropped.** The paths and the container identifier are
specific to your server, so the published filter lists do not recognise them.

**Cookies can be written by the server.** A cookie set by the server in a
`Set-Cookie` header is not subject to the cap Safari applies to storage written in
JavaScript — which clears it after seven days of browsing without a visit to your
site. Set your GA4 tag's cookie management to *server-managed* to benefit from it.

**Your pages get lighter.** Vendor scripts you route through the server are served
from your domain, and you can proxy several of them.

**You see what leaves.** Everything passes through your container, so you decide
what each destination actually receives.

## What we promise, and what we do not

✅ Paths and a container identifier **specific to your server**, that the public
filter lists do not recognise.

❌ **Not immunity to blockers.** A share of requests remains blockable on their
parameters alone, which we deliberately do not alter — changing them would break
the requests your tags send to Google. Anyone promising immunity is setting you up
for a bad surprise the first time you compare figures.

This is measured, not assumed: we check our paths against the real filter lists —
EasyPrivacy, EasyList and uBlock's privacy filters, together more than a hundred
thousand rules.

One consequence worth knowing: a provider that gives all its customers the *same*
pattern sees that pattern end up in the lists, and it then fails for their whole
fleet on the same day. Yours are derived for your server alone.

## Setting one up

Four steps, in this order.

1. **Your container configuration.** Copy it from your Tag Manager *server*
   container — not the container identifier, which is a different value.
2. **Your collection domain.** Pick the subdomain your site will call, for example
   `gtm.yoursite.com`. Choose carefully: changing it later means editing the
   snippet on every page.
3. **Two DNS records.** Add them at your registrar. We check them automatically
   and the server goes live once they have propagated — usually minutes.
4. **The snippet.** Replace the Google Tag Manager snippet on your pages with the
   one we generate.

You can migrate one site at a time. The standard paths keep being served, so a
site still running the old snippet keeps collecting normally, and you can roll
back at any point.

## Preview and debugging

The *Preview* button in Tag Manager works as usual, on the server as on the web
container.

Always open it **from Tag Manager**. A preview link carries a debug session
identifier that is regenerated every time you open the preview; replaying an old
link sends your hits to a session nobody is watching, which looks exactly like a
server that is not answering.

## One server, several sites

A single server can serve several web containers. Declare each one, and each gets
its own snippet — the container identifier is scrambled differently for each, so a
snippet cannot be reused from one site to the next.

## What is measured

Two different figures, and they do not mean the same thing.

**Billable hits** — the requests your tags actually claimed: a `GET` or `POST`
answered successfully by your container. The loader script, the proxied libraries
and everything the server answers on its own are never counted.

**Traffic** — every request that reached the server, health checks included. Use
it to watch trends and spot an outage, never to check an invoice.

Availability is measured with a real request to the container, not a simple port
test: a server that is up but broken counts as down. We keep a full year of daily
history, so the figure survives the server itself.

## Field by field

Every field of the setup screens — the container configuration, the subdomain,
the DNS records, the snippet, the proxied libraries, and what exactly counts as a
billable hit — is described one by one in the
[field reference](field-reference.md).

That page is also what the **?** buttons open inside the product: the explanation
you read next to a field and the one published here are the same text, so they
can never drift apart.

