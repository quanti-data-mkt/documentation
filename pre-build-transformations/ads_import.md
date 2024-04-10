---
description: Présentation de la table d'agrégation des données de diffusion publicitaire
---

# Ads\_import

## Présentation

Ads\_import est une table construite par la méthode Quanti: qui permet de regrouper les données de diffusion publicitaire de toutes ses plateformes au sein d'une seule table.\
Afin de pouvoir respecter ce principe de centralisation, il est indispensable que les données soient regroupées autour de champs communs à chaque plateforme.

## Les champs de la table

<figure><img src="../.gitbook/assets/Capture d’écran 2024-04-10 à 11.56.17.png" alt="" width="375"><figcaption></figcaption></figure>

### Les clés primaires

Les clés primaires de la table sont :

* Date : qui agrège les données à la journée.
* Quanti\_id : qui agrège les données à un niveau de granularité à la publicité.

{% hint style="info" %}
Pour en apprendre plus sur les quanti\_ids, se rendre dans [quanti\_ids.md](quanti\_ids.md "mention")
{% endhint %}

### Les métriques

Les métriques de la table sont :&#x20;

* platform\_spend : qui somme les dépenses publicitaires faites.
* platform\_clicks : qui somme les clics sur les publicités faites par les internautes.
* platform\_impressions : qui somme les impressions des publicités sur le réseau de diffusion des plateformes.

