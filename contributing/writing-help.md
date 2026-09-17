# Écrire une aide contextuelle

Ce guide n'est pas publié sur docs.quanti.io : il est absent de `SUMMARY.md`,
donc ni dans la navigation, ni indexé par l'assistant. Il vit ici pour être
versionné à côté du contenu qu'il gouverne, et lu par la tool `help_write`.

## Règle zéro : en anglais

Toute la documentation est en anglais. On pense et on prompte en français, donc
sans y faire attention la moitié des fragments part en français — et passe la
relecture, parce que le relecteur est français lui aussi.

## Les trois parties, toutes obligatoires

Un fragment répond à trois questions, dans cet ordre. `help_write` refuse d'écrire
s'il en manque une.

1. **À quoi sert ce champ**, en une phrase.
2. **Où le lecteur trouve la valeur** : l'écran, le menu, chez quel prestataire.
3. **L'erreur classique, et ce qu'elle produit.**

La troisième fait toute la différence. C'est aussi la seule qu'on ne peut pas
déduire : elle vient de quelqu'un qui a vu la panne.

## Trois paires, et ce qu'elles enseignent

### 1. La paraphrase

❌ « **Container Config** — the configuration of your container. »

✅ « The **Container Config** of your Tag Manager **server** container: a long
encoded string that carries your container ID, its environment and its
authorization code. It is not the `GTM-XXXXXXX` identifier. »

Le lecteur sait déjà que c'est une configuration : c'est écrit sur le champ. Ce
qu'il ignore, c'est où elle se cache et ce qui se passe s'il prend l'identifiant
à la place.

### 2. L'étape arrachée à son fil

❌ « In QUANTI:, enter the credentials **you retrieved**. You will need both in
**the next step**. »

Récupérés où ? Étape suivante de quoi ? Dans un panneau, il n'y a ni étape
précédente ni étape suivante — le lecteur tombe au milieu d'une conversation dont
il n'a pas entendu le début.

✅ Deux issues : viser la **section parente** pour que la séquence arrive entière
(`#Setup Instructions` plutôt que `#step:…`), ou réécrire le fragment pour qu'il
se tienne debout tout seul.

### 3. L'explication plausible et fausse

❌ « Safari caps the cookies set behind a CNAME to **7 days**. »

✅ « A subdomain cloaked by a CNAME towards someone else's domain is recognisable
as such — uBlock Origin uncloaks CNAMEs on Firefox — and it makes your measurement
depend on a name you do not own. »

La première phrase est bien tournée, technique, crédible. **Elle est fausse** :
mesuré sur Safari 26 avec ITP activé, un cookie `_ga` first-party expire à treize
mois. Elle a été publiée aux clients pendant une heure.

C'est la phrase qu'un LLM produit quand il écrit de mémoire, et c'est exactement
pour ça que la troisième partie doit venir d'une **source** : une mesure, un
ticket, un post-mortem, ou quelqu'un qui était là. Si personne ne sait, on écrit
les deux premières parties et on laisse la troisième vide plutôt que de
l'inventer — `help_write` refusera, et c'est le signal qu'il faut aller demander.

## Les interdits mécaniques

- **Aucune directive GitBook dans un fragment** (`{% hint %}`, `{% step %}`…) :
  elles s'afficheraient en clair dans le panneau. La tool refuse.
- **Longueur** : viser 300 à 1 200 caractères. En dessous, c'est une infobulle
  qui ne valait pas un panneau. Au-dessus, personne ne lit.
- **Pas de tableau large** : au-delà de trois colonnes, ça ne rentre pas dans un
  panneau. Si l'information l'exige, elle appartient à la page, pas au fragment.

## Les médias

- **Uniquement les interfaces qu'on ne contrôle pas** : Tag Manager, Adobe, Meta.
  Jamais notre propre interface — le lecteur l'a sous les yeux à trois
  centimètres, et le moindre écart après une refonte ruine la confiance dans toute
  l'aide.
- **Compte de démo Quanti, jamais un compte client.** Ces consoles affichent en
  permanence le nom du compte, l'e-mail connecté et les identifiants ; le stockage
  des médias est public et définitif.
- **Vidéo plutôt que GIF** : dix à vingt fois plus léger à rendu identique.
  Cadrer serré, zoomer le navigateur à 125–150 % — un plein écran en 1920 px est
  illisible dans un panneau de 420 px. Cinq à dix secondes, une seule action, pas
  de curseur qui hésite.
- **Nom daté, jamais écrasé** : `gtm-container-config-20260917.mp4`. Le stockage
  est mis en cache partout ; réenregistrer par-dessus laisserait des lecteurs sur
  l'ancienne version.
- Le média **complète**, il ne remplace pas : il n'est pas indexable par
  l'assistant, et c'est le texte qui survivra à la prochaine refonte.

## Le déroulé

1. **`help_coverage`** — ce qui manque, ce qui pointe dans le vide. Lecture seule,
   à lancer avant d'écrire quoi que ce soit.
2. **`help_write`** — le fragment part dans le dépôt et la clé au manifeste.
3. **Poser la clé côté produit.** Pour un champ de connecteur elle est dérivée
   automatiquement, il n'y a rien à faire. Ailleurs, un développeur ajoute
   `helpKey` sur le champ. Tant que ce n'est pas fait, le fragment existe mais
   aucun « ? » ne l'ouvre.

## Où écrire

- Une **page de référence par produit**, une section par champ, le titre EST la
  clé : `### container_config — Where to find your container configuration`.
- Pour la documentation qui existe déjà, ne pas réécrire : **pointer**. Une
  section, une étape, ou la page entière — `help_coverage` dit ce qui est
  adressable.
