# FAQ — Google Ads

## Why is Auction Insights data not available?

The Auction Insights report lets you compare your performance against other advertisers competing in the same auctions. It exposes six metrics: Impression Share, Overlap Rate, Position Above Rate, Top of Page Rate, Absolute Top of Page Rate, and Outranking Share.

These metrics exist in the Google Ads API (`metrics.auction_insight_search_*`), but access is restricted to accounts explicitly approved by Google through an allowlisting programme. This programme is currently closed — Google is no longer accepting new requests, including through a Google representative. This has been confirmed by the Google Ads API team in public exchanges on the official developer forum (June 2025).

**Source**: [Google Ads API Forum — Feature Request Auction Insights](https://groups.google.com/g/adwords-api/c/30s21wGZkOU)

### Accessing this data in the meantime

The only available option is the Google Ads interface:

1. Log in to your Google Ads account
2. Go to **Insights** > **Reports** > **Auction Insights**
3. Select the period and level (campaign, ad group, keyword) and export the report manually

### What we are doing

We monitor the [Google Ads API Release Notes](https://developers.google.com/google-ads/api/docs/release-notes) and the [Google Ads developer blog](https://ads-developers.googleblog.com/search/label/google_ads_api). As soon as Google opens access to these metrics, we will integrate them into the connector.
