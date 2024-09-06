---
description: Pattern recommanded to use for reconciliation
layout:
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: false
---

# Tracking templates

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

## Google ads

```
qid_gad_c{campaignid}_g{adgroupid}_a{creative}
```

source doc : [https://developers.google.com/google-ads/api/docs/reporting/valuetrack-mapping](https://developers.google.com/google-ads/api/docs/reporting/valuetrack-mapping?hl=fr)



***

## Linkedin ads

```
qid_lkd_c_CAMPAIGN_GROUP_ID_g_CAMPAIGN_ID_a_CREATIVE_ID
```

***

## Meta ads

```
qid_fbk_c{{campaign.id}}_g{{adset.id}}_a{{ad.id}}
```

Source doc : [https://www.facebook.com/business/help/2360940870872492](https://www.facebook.com/business/help/2360940870872492)

***

## Microsoft ads

```
qid_bga_c{CampaignId}_g{AdGroupId}_a{AdId}
```

Source doc : [https://help.ads.microsoft.com/#apex/ads/en/56799/2](https://help.ads.microsoft.com/#apex/ads/en/56799/2)

***

## Outbrain

```
qid_otb_c{{campaign_id}}_g{{publisher_id}}_a
```

***

## Pinterest ads

```
qid_pin_c{campaignid}_g{adgroupid}_a{adid}
```



***

## Powerspace

```
qid_pwr_c_g_a
```

***

## Rakuten advertising

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

## Tiktok ads

```
qid_tik_c__CAMPAIGN_ID__g__AID__a__CID
```

***

## Twitter

```
qid_twi_c{campaign_id}_g{line_item_id}_a{tweet_id}
```

***

## Verizon

```
qid_vrz_c{campaignid}_g{adgroupid}_a{adid}
```

***

## Verizon dsp

```
qid_dsp_c_g_a
```

***

## Wonderpush

```
qid_wdp_c{{ campaign.id }}_g_a 
```
