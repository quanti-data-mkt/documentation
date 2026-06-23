# Custom Webhook

Le connecteur **Custom Webhook** permet d'ingérer des événements provenant de n'importe quel système tiers via un endpoint HTTPS dédié. QUANTI: génère automatiquement l'URL de réception, infère le schéma à partir de votre premier payload de test, puis route les données directement dans votre data warehouse.

Cas d'usage typiques : événements CRM, alertes applicatives, formulaires web, notifications e-commerce, exports de plateformes tierces qui ne disposent pas de connecteur natif QUANTI:.

{% hint style="info" %}
Pour l'ingestion du tag de tracking web QUANTI:, utilisez le connecteur dédié **Real-Time Analytics** — il gère la session, l'attribution et le consentement de façon native.
{% endhint %}

***

## Comment ça fonctionne

1. QUANTI: génère un **endpoint HTTPS unique** pour votre tenant
2. Vous pointez le webhook de votre source vers cet endpoint
3. À la réception du premier payload, QUANTI: **infère automatiquement le schéma** (noms et types des champs)
4. Vous validez le schéma et le connecteur commence à ingérer

Chaque payload reçu est inséré tel quel dans votre data warehouse, sans transformation. Les champs sont mappés directement depuis la structure JSON du payload.

***

## Configuration

{% stepper %}
{% step %}
### Nommez votre tenant

Donnez un nom à votre connecteur webhook (ex. `crm-events`, `shop-notifications`). Ce nom déterminera le nom de la table dans votre warehouse.
{% endstep %}

{% step %}
### Récupérez l'URL d'endpoint

Une fois le connecteur créé, QUANTI: vous fournit l'URL HTTPS à configurer dans votre source tierce. Elle est unique par tenant.
{% endstep %}

{% step %}
### Envoyez un payload de test

Déclenchez un événement depuis votre source ou envoyez manuellement un payload JSON représentatif via cURL ou Postman :

```bash
curl -X POST https://webhook.quanti.io/<votre-endpoint> \
  -H "Content-Type: application/json" \
  -d '{"event": "order.created", "order_id": "12345", "amount": 99.90}'
```
{% endstep %}

{% step %}
### Validez le schéma inféré

QUANTI: affiche le schéma détecté à partir de votre payload. Vérifiez que les types sont corrects (STRING, NUMERIC, TIMESTAMP…) et confirmez pour activer l'ingestion.
{% endstep %}
{% endstepper %}

***

## Format de payload

* Le payload doit être au format **JSON**
* Méthode HTTP : **POST**
* Content-Type : `application/json`
* Taille maximale par payload : **1 MB**
* Les tableaux (arrays) et objets imbriqués sont acceptés — QUANTI: les aplatit ou les stocke en JSON selon la configuration du schéma

***

## Données dans le warehouse

Chaque événement reçu génère une ligne dans votre table BigQuery. QUANTI: ajoute automatiquement les colonnes système suivantes :

| Colonne | Type | Description |
|---|---|---|
| `_quanti_received_at` | TIMESTAMP | Horodatage de réception par QUANTI: |
| `_quanti_id` | STRING | Identifiant unique de l'événement |

Les autres colonnes correspondent aux champs de votre payload JSON.

***

## Notes

* L'endpoint est **public** — il n'y a pas d'authentification par défaut sur l'URL. Si votre source le permet, ajoutez un secret partagé dans un header custom et vérifiez-le côté QUANTI: via les filtres de payload
* Le schéma est inféré sur le **premier payload** — si votre payload évolue (nouveaux champs), des colonnes supplémentaires seront ajoutées automatiquement lors des prochains envois
* Il n'y a pas de lookback ni d'historique : seuls les événements reçus après la création du connecteur sont stockés
* Le connecteur ne gère pas la déduplication — si votre source peut renvoyer le même événement plusieurs fois, gérez l'idempotence dans votre pipeline aval
