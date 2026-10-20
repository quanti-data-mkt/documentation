---
description: 'Step-by-step guide to set up a server-side tagging server on QUANTI:'
---

# Setting up server-side tagging

This guide walks you through the complete setup: creating the server in QUANTI:, linking it to your GTM server container, adding DNS records, and replacing the snippet on your site. From start to finish, it takes about 30 minutes — the DNS step is the only one where you wait.

{% hint style="info" %}
**Prerequisites**

* A Google Tag Manager account with at least one **Web** container already deployed on your site.
* Access to your domain's DNS settings (or your webmaster on standby).
* A QUANTI: project with the Server-side tagging feature enabled.
{% endhint %}

***

## Step 1 — Create a GTM server container

Before configuring anything in QUANTI:, you need a **server** container in Google Tag Manager. If you already have one, skip to [Step 2](#step-2-configure-the-server-in-quanti).

{% stepper %}
{% step %}
**Open Google Tag Manager**

Go to [tagmanager.google.com](https://tagmanager.google.com) and select your account.
{% endstep %}

{% step %}
**Create a new container**

Click **Create Container**, name it (e.g. *My site — Server*), and select **Server** as the target platform.
{% endstep %}

{% step %}
**Choose manual provisioning**

When asked how you want to provision the server, select **Manually provision tagging server**. Google will display a **Container Config** string — a long encoded block that looks nothing like a `GTM-XXXXXXX` identifier.

Copy it now. You will paste it into QUANTI: in the next step.

{% hint style="warning" %}
**Container Config ≠ Container ID**. The `GTM-XXXXXXX` identifier at the top of the workspace is not what you need here. The Container Config is the full encoded block shown only during manual provisioning. If you pasted the wrong value, the server will start but answer nothing useful.
{% endhint %}
{% endstep %}
{% endstepper %}

***

## Step 2 — Configure the server in QUANTI:

{% stepper %}
{% step %}
**Open Server-side tagging**

In your QUANTI: project, go to **Server-side tagging** and click **New server**.
{% endstep %}

{% step %}
**Paste the Container Config**

Paste the string you copied from GTM. QUANTI: stores it in a secret vault and never displays it again — there is no way to retrieve it afterwards, so keep the GTM page open until the server is active.
{% endstep %}

{% step %}
**Choose your collection domain**

Enter the subdomain your site will use to reach the server, for example `tag` to get `tag.yoursite.com`.

A few things to keep in mind:

* **Pick it carefully.** Changing it later means editing the snippet on every page.
* **Avoid obvious tracking names** like `gtm`, `analytics`, `sgtm`, `tracking` or `collect`. Ad blockers maintain lists of such subdomains. Something neutral or brand-specific (`tag`, `s7b3`, `shop`) works better.
* **It must be on your own domain.** A server running on a third-party domain is treated as third-party by browsers, which defeats the purpose entirely.
{% endstep %}

{% step %}
**Select a region**

Pick the region closest to the bulk of your visitors. This is the only field that affects response time, and it cannot be changed afterwards.
{% endstep %}

{% step %}
**Confirm**

QUANTI: will provision the infrastructure and display the DNS records you need to add.
{% endstep %}
{% endstepper %}

***

## Step 3 — Add DNS records

QUANTI: gives you two records to add in your DNS zone: an **A record** and an **AAAA record**, both pointing the chosen subdomain to fixed IP addresses.

Add them at your domain registrar or DNS provider, then wait. Propagation usually takes a few minutes; it can occasionally reach an hour.

{% hint style="info" %}
**Why A and AAAA, and never a CNAME?**

A CNAME pointing to someone else's infrastructure is detectable — uBlock Origin uncloaks CNAMEs on Firefox — and it makes your measurement depend on a name you do not own. Records pointing straight at IP addresses keep the full chain inside your domain.

QUANTI: uses fixed IP addresses specifically to make this possible. Not all providers can.
{% endhint %}

QUANTI: checks the records automatically. Once they resolve correctly, the server moves from **Pending DNS** to **Starting**, then to **Active** (up to 15 minutes for the container image to initialise).

***

## Step 4 — Configure your GTM server container

Now that the server is running, configure GTM to use it correctly.

{% stepper %}
{% step %}
**Set the Server container URL**

In GTM, open your **Server** container → *Admin* → *Container settings*. Add your collection domain (`https://tag.yoursite.com`) in the **Server container URLs** field. This tells GTM where to open the Preview debugger.
{% endstep %}

{% step %}
**Edit the GA4 client**

Go to **Clients** in the server container. A default GA4 client is already there — edit it and check the **Migrate from JavaScript Managed Client ID** box. This ensures the server-managed `FPID` cookie is seeded from the existing GA4 cookie rather than creating a new one, so visitor histories are preserved across the migration.
{% endstep %}

{% step %}
**Create a GA4 tag**

Go to **Tags** → **New**, select **Google Analytics: GA4**.

Key settings:

* **Measurement ID** — leave blank to forward whatever ID the web container sends, or enter a specific ID to force all server hits to a single GA4 property.
* **Cookie management** — set to **Server-managed** so the server writes the GA4 cookie via `Set-Cookie`. This is what removes the Safari 7-day cap on cookie lifetime.

{% hint style="info" %}
**Why server-managed cookies matter**

Safari's Intelligent Tracking Prevention caps cookies written by JavaScript to 7 days of activity. A cookie written by the server in a response header is not subject to this cap. Switching to server-managed cookies is one of the highest-impact changes you can make for measurement quality on Apple devices.
{% endhint %}
{% endstep %}

{% step %}
**Create the trigger**

Add a trigger of type **Custom** with the rule: `Client Name` **equals** `GA4`. This fires the tag for every GA4 event the server receives.

Save the tag, then **Submit** the server container.
{% endstep %}
{% endstepper %}

***

## Step 5 — Configure the GA4 tag in your web container

This is the step that actually routes your measurement hits through the server. Without it, the server sits idle — your web container keeps sending data directly to Google.

{% stepper %}
{% step %}
**Open your web container in GTM**

Go to your **Web** container — the one currently deployed on your site.
{% endstep %}

{% step %}
**Edit your GA4 Configuration tag**

Open your GA4 Configuration tag (or GA4 Event tags if you don't use a configuration tag). Find the **Server container URL** field — it may be hidden under *Advanced settings* depending on your GTM version.

Enter your collection domain: `https://tag.yoursite.com`.

This tells the GA4 tag to send its hits to your server instead of directly to Google. Every event — page views, purchases, custom events — will transit through sGTM before reaching GA4 and your other destinations.

{% hint style="warning" %}
Make sure to use `https://` and no trailing slash. An incorrect URL means hits go nowhere and the server sees nothing.
{% endhint %}
{% endstep %}

{% step %}
**Submit and publish**

Save the tag and **Submit** the web container. From this moment, hits flow through your server.
{% endstep %}
{% endstepper %}

***

## Step 6 — Replace the snippet on your site

Back in QUANTI:, go to your server → **Web containers** → add your web container ID (the `GTM-XXXXXXX` from your **Web** container, not the server one).

QUANTI: generates a replacement snippet. It looks like the standard GTM snippet but the paths and container identifier are specific to your server — that is how it bypasses the patterns ad blockers target.

Replace the existing GTM snippet on every page of your site with the generated one: the first block goes as high as possible in `<head>`, the second goes right after the opening `<body>` tag.

{% hint style="warning" %}
**Do not edit the URLs in the snippet by hand.** The paths are tied to your specific server and container. A hand-edited variation will return a `404`.

You can migrate one site at a time. Sites still running the original snippet keep collecting normally — you can also roll back at any point by restoring the previous snippet.
{% endhint %}

***

## Step 7 — Verify the setup

Open the **Preview** in your GTM server container (always from GTM, never by replaying an old link). Load a page on your site and confirm that:

* Hits appear in the GTM server preview with **Client Name: GA4**.
* The GA4 tag fires on those hits.
* The response sets a cookie named `FPID` on your collection domain.

In QUANTI:, the server status should be **Active** and you should see **Billable hits** incrementing within a few minutes.

{% hint style="info" %}
**Billable hits vs. traffic**

*Traffic* counts every request that reached the server, including health checks. *Billable hits* count only `GET` or `POST` requests answered with a `2xx` by your container. The two numbers will differ — that is expected. See [Field reference](field-reference.md) for the full breakdown.
{% endhint %}

***

## What to do next

With the server running and the snippet in place, you can go further:

* **Add CAPI destinations** — send server-side conversion events directly to Meta, TikTok, Pinterest and others from the same server container.
* **Declare your other sites** — a single server can serve several web containers, each with its own snippet. See [One server, several sites](README.md#one-server-several-sites).
