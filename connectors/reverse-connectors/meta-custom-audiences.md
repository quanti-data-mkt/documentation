# Meta Custom Audiences

Le connecteur **Meta Custom Audiences** est un connecteur reverse : il pousse des segments d'audience depuis votre data warehouse vers Meta (Facebook & Instagram Ads) sous forme de Custom Audiences. Il permet d'activer du retargeting, de l'exclusion ou des Lookalike Audiences directement à partir de vos données first-party.

{% hint style="info" %}
Ce connecteur gère uniquement les **Custom Audiences** (correspondance CRM). Pour l'envoi d'événements de conversion côté serveur (Conversions API / CAPI), utilisez le connecteur **Meta Pixel (Reverse)**.
{% endhint %}

***

## Prérequis

* Un compte **Meta Business Manager** avec accès à au moins un compte publicitaire
* Le compte publicitaire doit disposer de la permission `ads_management`
* Les données à pousser doivent être disponibles dans une table de votre data warehouse QUANTI: (typiquement via une **Semantic View** ou un connecteur source)
* Les champs PII (email, téléphone, etc.) doivent être présents dans la table source — ils seront hachés automatiquement en SHA-256 avant l'envoi

***

## Authentification

La connexion se fait via **OAuth2 Facebook**. Lors de la configuration, vous serez redirigé vers Meta pour autoriser QUANTI: à gérer vos Custom Audiences.

Les permissions demandées sont : `ads_management`, `ads_read`, `business_management`, `leads_retrieval`.

***

## Configuration

{% stepper %}
{% step %}
### Connexion Meta

Cliquez sur **Continue with Facebook** et autorisez QUANTI: sur votre compte Meta Business.
{% endstep %}

{% step %}
### Sélection du compte publicitaire

Renseignez le ou les **Ad Account IDs** au format `act_XXXXXXXXXX` (visible dans le Business Manager ou dans l'URL de votre compte publicitaire).
{% endstep %}

{% step %}
### Type de push

Sélectionnez le template **Custom Audience** et choisissez le mode de synchronisation adapté à votre cas d'usage.
{% endstep %}

{% step %}
### Mapping

Depuis l'onglet **Mapping**, associez les colonnes de votre table source aux champs attendus par Meta. Nommez votre connecteur et créez-le.
{% endstep %}
{% endstepper %}

***

## Modes de synchronisation

| Mode | Comportement |
|------|-------------|
| `mirror` | Synchronisation complète — les membres ajoutés dans la source sont ajoutés à l'audience, ceux supprimés en sont retirés |
| `add_only` | Ajout uniquement — les nouveaux membres sont ajoutés, aucune suppression n'est effectuée |
| `remove_only` | Suppression uniquement — les membres présents dans la source sont retirés de l'audience |

***

## Champs de matching disponibles

Meta accepte les identifiants suivants pour la correspondance. QUANTI: applique un hachage **SHA-256** automatiquement avant l'envoi pour tout champ PII.

| Champ QUANTI: | Type Meta | Format attendu |
|---|---|---|
| `email` | `EMAIL` | Adresse email en minuscules |
| `phone` | `PHONE` | Numéro au format E.164 (ex. `+33612345678`) |
| `first_name` | `FN` | Prénom en minuscules, sans accents |
| `last_name` | `LN` | Nom en minuscules, sans accents |
| `date_of_birth` | `DOBY` / `DOBM` / `DOBD` | Année, mois, jour séparés |
| `gender` | `GEN` | `m` ou `f` |
| `city` | `CT` | Ville en minuscules, sans espaces |
| `state` | `ST` | Code d'état/région (2 lettres) |
| `zip` | `ZIP` | Code postal sans espaces |
| `country` | `COUNTRY` | Code ISO 3166-1 alpha-2 (ex. `fr`) |

{% hint style="warning" %}
Pour maximiser le taux de correspondance, fournissez au minimum **email** ou **téléphone**, idéalement combinés avec prénom et nom.
{% endhint %}

***

## Notes

* Les Custom Audiences créées par QUANTI: sont visibles dans votre **Meta Ads Manager > Audiences**
* La taille minimale pour diffuser une campagne est de **100 membres** après correspondance
* Meta applique ses propres règles de confidentialité — assurez-vous d'avoir obtenu le consentement approprié de vos utilisateurs avant de pousser leurs données
* Les Lookalike Audiences peuvent être créées manuellement dans Meta Ads Manager à partir d'une Custom Audience existante
