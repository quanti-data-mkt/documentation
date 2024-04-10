---
description: >-
  Ce chapitre traite le sujet des pre-build transformations et du travail
  d'agrégation proposés par Quanti:
---

# PRE-BUILD TRANSFORMATIONS

## Automatisation des processus

L'un des principaux enjeux du pilotage des performances e-commerce est la méthode choisie pour accéder aux données. Le système mis en place est considéré comme performant quand celui-ci permet au responsable de gagner du temps dans la prise de décisions par l'**automatisation des processus** d'accès aux données :

1. Centralisation de la collecte (API)
2. Organisation des données (Transformations)
3. Exploitation des données et calcul des KPIs (Visualisations de rapports)

<figure><img src="../.gitbook/assets/Capture d’écran 2024-04-09 à 16.39.08.png" alt=""><figcaption></figcaption></figure>

## Une méthode exclusive développée par Quanti:

Ce chapitre traite le sujet de la **transformation** et du travail d'agrégation mené par Quanti: appelé [**LA RÉCONCILIATION**](le-principe-de-reconciliation.md) qui nécessite des connaissances métier acquises par d'importants investissements en R\&D qui ont permit de développer :&#x20;

* Une connaissance parfaite des particularités des API des partenaires publicitaires qui nous permet d'extraire les données correctement et de centraliser leur stockage sur des Data-Warehouses dédiés par client. Les API mettent à disposition des annonceurs de nombreuses données de campagne. Celles-ci peuvent être très variées d'un partenaire à l'autre. Les données rendues accessibles par un partenaire publicitaire, correspondent à chaque fois au contexte de diffusion et à leurs spécificités (levier utilisé, type de support, technologies, ...). La recherche et l'accès aux informations peut s'avérer complexe par la diversité et la quantité de données disponibles.&#x20;
* Une méthode qui permet de standardiser et d'uniformiser les données initialement en provenance de plateformes publicitaires différentes.
* Une méthode qui permet de rapprocher des données de navigation (Site-centric - Ex: Google Analytics 4) et de données de campagnes (Ad-centric - Ex: Meta) en vue du calcul automatisé d'indicateurs clé de performances (Ex: Return On Ads Spend).

L'idée générale de cette étape de transformation est de rendre les données plus digestes et plus exploitables à des fins de visualisation, d'analyses et de prises de décision.

## Découvrir nos pre-build transformations

{% content-ref url="ads_import.md" %}
[ads\_import.md](ads\_import.md)
{% endcontent-ref %}

{% content-ref url="ads_import_conv.md" %}
[ads\_import\_conv.md](ads\_import\_conv.md)
{% endcontent-ref %}

{% content-ref url="quanti_ids.md" %}
[quanti\_ids.md](quanti\_ids.md)
{% endcontent-ref %}

