---
description: Recommended URL patterns for ad click reconciliation across platforms
---

# Tracking Templates

Tracking templates are URL parameters appended to your ad click URLs. QUANTI: uses them to reconcile ad performance data (impressions, clicks, spend) with conversion data collected by the Real-Time Analytics tag.

Each template follows the same structure:

```
qid_{platform}_{c{campaign_id}}_g{ad_group_id}_a{ad_id}
```

Where `c`, `g`, and `a` stand for **campaign**, **group**, and **ad** respectively. When a field is not available for a given platform, the placeholder is left empty.

***

## Affilae

```
qid_aff_c{affiliateTrackingId}_g_a
```

***

## Amazon Ads

```
qid_amz_c[campaign.id]_g[ad_group.id]_a
```

***

## Awin

```
qid_awn_c{publisherId}_g_a
```

***

## Commission Junction

```
qid_cmj_c{pubCid}_g{pid}_a
```

***

## Criteo

```
qid_crt_c{{campaign_id}}_g{{adset_id}}_a
```

***

## DV360

```
qid_dv3_c${CAMPAIGN_ID}_g_a
```

***

## Effinity

```
qid_efi_c{id_programme}_g{id_affilie}_a{id_link}
```

***

## Google Ads

```
qid_gad_c{campaignid}_g{adgroupid}_a{creative}
```

Reference: [Google Ads ValueTrack parameters](https://developers.google.com/google-ads/api/docs/reporting/valuetrack-mapping)

***

## LinkedIn Ads

```
qid_lkd_c_CAMPAIGN_GROUP_ID_g_CAMPAIGN_ID_a_CREATIVE_ID
```

***

## Meta Ads

```
qid_fbk_c{{campaign.id}}_g{{adset.id}}_a{{ad.id}}
```

Reference: [Meta dynamic URL parameters](https://www.facebook.com/business/help/2360940870872492)

***

## Microsoft Advertising

```
qid_bga_c{CampaignId}_g{AdGroupId}_a{AdId}
```

Reference: [Microsoft Ads URL tracking parameters](https://help.ads.microsoft.com/#apex/ads/en/56799/2)

***

## Outbrain

```
qid_otb_c{{campaign_id}}_g{{publisher_id}}_a
```

***

## Pinterest Ads

```
qid_pin_c{campaignid}_g{adgroupid}_a{adid}
```

***

## Rakuten Advertising

```
qid_rak_c_g_a
```

***

## RTB House

```
qid_rtb_c{{subcampaignhash}}_g{{user_segment_id}}_a{{creative_hash}}
```

***

## Snapchat

```
qid_snp_c{{campaign.id}}_g{{adSet.id}}_a{{ad.id}}
```

***

## Stylight

```
qid_stl_c_g_a
```

***

## Taboola

```
qid_tbl_c{campaign_id}_g_a
```

***

## TikTok Ads

```
qid_tik_c__CAMPAIGN_ID__g__AID__a__CID
```

***

## Wonderpush

```
qid_wdp_c{{ campaign.id }}_g_a
```
