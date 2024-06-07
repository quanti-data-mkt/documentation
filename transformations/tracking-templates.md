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

```
qid_lkd_c_CAMPAIGN_GROUP_ID_g_CAMPAIGN_ID_a_CREATIVE_ID
```

```
qid_wdp_c{{ campaign.id }}_g_a 
```

```
qid_stl_c_g_a
```

qid\_efi\_c{id\_programme}\_g{id\_affilie}\_a{id\_link} qid\_otb\_c\{{campaign\_id\}}\_g\{{publisher\_id\}}\_a qid\_aff\_c{affiliateTrackingId}\_g\_a A definir A definir a confirmer : qid\_dv3\_c${CAMPAIGN\_ID}\_g\_a qid\_pin\_c{campaignid}\_g{adgroupid}\_a{adid} qid\_crt\_c\{{campaign\_id\}}\_g\{{adset\_id\}}\_a qid\_rtb\_c\{{subcampaignhash\}}\_g\{{user\_segment\_id\}}\_a\{{creative\_hash\}} qid\_snp\_c\{{campaign.id\}}\_g\{{adSet.id\}}\_a\{{ad.id\}} qid\_fbk\_c\{{campaign.id\}}\_g\{{adset.id\}}\_a\{{ad.id\}} qid\_bga\_c{CampaignId}\_g{AdGroupId}_a{AdId} qid\_tik\_c\_\_CAMPAIGN\_ID\_\_g\_\_AID\_\_a\_\_CID_ qid\_gad\_c{campaignid}\_g{adgroupid}\_a{creative}

qid\_jko\_c\_g\_a qid\_rak\_c\_g\_a qid\_pwr\_c\_g\_a A confirmer : qid\_tbl\_c{campaign\_id}\_g\_a qid\_vrz\_c{campaignid}\_g{adgroupid}\_a{adid} qid\_dsp\_c\_g\_a

qid\_pin\_c{campaignid}\_g{adgroupid}\_a{adid} qid\_pin\_c{campaignid}\_g{adgroupid}\_a{adid} qid\_jko\_c\_g\_a qid\_twi\_c{campaign\_id}\_g{line\_item\_id}\_a{tweet\_id}
