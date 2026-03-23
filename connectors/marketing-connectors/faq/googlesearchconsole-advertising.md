---
description: Frequently asked questions about Google Search Console
---

# Google Search Console — FAQ

***

### Les clics/impressions dans Quanti ne correspondent pas à l'interface GSC

**Symptôme**\
Les totaux de clics et impressions dans les tables Quanti diffèrent de ceux affichés dans l'interface Google Search Console, à filtres identiques.

**Comprendre les méthodes d'agrégation**

L'API GSC expose deux méthodes d'agrégation — la correspondance avec les tables Quanti est la suivante :

| Méthode | Tables Quanti | Comportement |
|---|---|---|
| `byProperty` | `*_by_site` | 1 impression/clic max par requête, même si plusieurs URLs s'affichent → chiffres plus bas |
| `byPage` | `*_by_page` | 1 impression/clic par URL affichée → chiffres plus élevés |

**L'interface GSC utilise `byProperty` par défaut** pour le graphique de performance global. La table en dessous bascule en `byPage` si la dimension *Pages* est sélectionnée.

> ℹ️ Pour reproduire les chiffres du graphique de l'interface GSC, utiliser les tables `*_by_site`.

**Si la discrepancy persiste malgré la même méthode d'agrégation**

Même méthode d'agrégation mais résultats différents ? Vérifier en priorité :

* La plage de dates est-elle strictement identique des deux côtés ?
* Les filtres (pays, device, type de recherche) sont-ils les mêmes ?
* Le type de propriété GSC : une propriété **domaine** agrège les sous-domaines, une propriété **préfixe d'URL** non.

**Référence** : [How Search Console data is calculated](https://support.google.com/webmasters/answer/6155685)
