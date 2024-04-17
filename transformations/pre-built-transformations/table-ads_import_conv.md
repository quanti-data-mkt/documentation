---
description: >-
  Présentation de la table d'agrégation des conversions issues des plateformes
  publicitaires.
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

# Table ads\_import\_conv

## Présentation

Ads\_import\_conv est une table construite par une méthode Quanti: qui permet de regrouper les données de conversion de toutes ses plateformes au sein d'une seule table.\
Afin de pouvoir respecter ce principe de centralisation, il est indispensable que les données soient regroupées autour de champs communs à chaque plateforme.

## Les champs de la table



<figure><img src="../../.gitbook/assets/Capture d’écran 2024-04-10 à 14.54.52.png" alt="" width="375"><figcaption></figcaption></figure>

### Les clés primaires

Les clés primaires de la table sont :

* Date : qui agrège les données à la journée.
* Quanti\_id : qui agrège les données à un niveau de granularité à la publicité.

{% hint style="info" %}
Pour en apprendre plus sur les quanti\_ids, se rendre dans [table-quanti\_ids.md](table-quanti\_ids.md "mention")
{% endhint %}

### Les métriques

Les métriques de la table sont spécifiques à chaque client. La liste correspond aux ID des conversions utilisées et alimentées par le tag publicitaire de chaque plateforme intégré sur votre site.\
Les métriques sont toutes préfixées par `platform_conversion` et suivi ensuite de l'ID attribué par la plateforme publicitaire.\
Les valeurs de conversion sont toutes suffixées par `_value`. Ce type de métrique est particulièrement utile quand il s'agit de conversion e-commerce et dont le chiffre d'affaires est une élément important. Néanmoins dans notre modèle de données, ce type de métrique est présent par défaut et peut avoir une valeur `null` quand il s'agit de conversion lead par exemple.

#### Exemple de métriques (personnalisées)

Sur Google Ads, si vous alimentez par exemple une conversion `purchase` dont l'ID de la conversion est 12345678 (automatiquement attribué par Google), vous retrouverez ses valeurs de conversions dans les métriques :&#x20;

* `platform_conversion_12345678` qui comptabilise le nombre de cette conversion.
* `platform_conversion_12345678_value` qui comptabilise les valeurs associées à cette conversion.

{% hint style="info" %}
Toutes les plateformes publicitaires ne permettent pas la création/ l'utilisation de conversion personnalisée. Ce sont surtout les grandes plateformes publicitaire qui offrent ce niveau de service. Généralement, il est uniquement possible de comptabiliser les conversions sans en connaitre la distinction. Parfois, les API ne permettent même pas de connaitre les conversions comptabilisées par leur plateforme. La comptabilisation et la distinction des conversions se fait au cas par cas (connecteur par connecteur) et pour en connaitre la liste, veuillez vous rapprocher de votre consultant Quanti:.
{% endhint %}

#### Exemple de métriques (standards)

Lorsque que le connecteur ne permet pas de faire la distinction entre les différents types de connexion ou bien que la distinction des types de conversion n'existe tout simplement pas sur plateforme publicitaire, Quanti agrège ces conversions dans des métriques standardisées :&#x20;

* `platform_conversion_conversions` : qui comptabilise le nombre de conversion.
* `platform_conversion_conversions_value` : qui comptabilise les valeurs associées aux conversions.
