# Audit de design — Okoumé (UI / UX)

> Analyse statique de la cohérence visuelle, typographique, ergonomique et
> accessible de l'application (`lib/`, le 16 octobre 2026).
> Complète `docs/AUDIT_apple_design.md` (motion Apple uniquement).

---

## 1. Synthèse

**Verdict : B+ / 10.** Un système de design solide et bien exploité sur les
écrans principaux (shell, composants communs, palette officielle), mais
quelques dérives de tokens, des trous d'accessibilité et une adaptation
responsive limitée. La démo fonctionnelle (317 écrans) s'appuie sur le même
système, ce qui donne une cohérence réelle malgré un grand nombre d'écrans.

<|end|> Domaine | Score | Commentaire |
|---|---|---|
| Tokens de couleur | 9/10 | palette `AppColors` fidèle au §7, dérives ponctuelles |
| Typographie | 7,5/10 | Poppins / Montserrat / Roboto par défaut — **Inter absent** (CDC) |
| Radii & espaces | 8,5/10 | multiples de 2/4/8 cohérents (12–28 pt) |
| Composants | 9/10 | Pressable, AppCard, Pill, Frosted réutilisés massivement |
| Iconographie | 8/10 | Hugeicons stroke-rounded centralisés, états conservés en MaterialIcons |
| Formulaires | 8/10 | champs uniformes, validation stricte |
| Accessibilité | 4/10 | **aucun `Semantics`**, cibles tangibles < 44 pt |
| Responsive | 5/10 | essentially single-column, 4 `LayoutBuilder` |
| Thèmes clair/sombre | 9,5/10 | excellent, contrastes respectés |
| Motion | 9/10 | audité séparément (`docs/AUDIT_apple_design.md`) |

Score global : **≈ 7,6 / 10**.

---

## 2. Détail par domaine

### 2.1 Couleurs & tokens (9/10)
- `AppColors` : 7 couleurs de marque + surfaces + accents opérateurs et
  statuts commander — fidèle §7.2 (primaire `#0066CC`, secondaire `#FF6B00`,
  succès `#00C853`, danger `#FF1744`, alerte `#FFC107`, fonds `#F5F7FA`/
  `#1A1A2E`).
- **Dérives** : `const Color(0xFF…)` ponctuelles dans 10 fichiers (sudo :
  `main_shell.dart` (bannière hors-ligne, accent vendre), `hero_screens.dart`
  fond `0xFF0B0E14`, AppColors redéfinis) — devraient passer par `AppColors`.
- `0xFFF1F4F9` hardcode dans `app_theme.dart` (surface) au lieu de
  `AppColors.surfaceContainerLow`.
- **Gain facile** : audit mécanique via script grep `const Color(0x` +
  noms canonicals à ajouter (`AppColors.offlineBanner`, ...).

### 2.2 Typographie (7,5/10)
- Polices déclarées : Poppins (titres, tracking optique négatif), Montserrat
  (accents « wallets / stories »), défaut Roboto (corps).
- `app_theme.dart `_textTheme` couvre display/headline/title/body/label avec
  hauteurs, spacings à la Apple (-0.6 … +0.2).
- **Écart CDC** : Inter est mentionné comme police corps dans §7.1 mais
  **absent** de `pubspec.yaml` et `AppTheme` (dernier fallback = Roboto). Les
  corps 14–16 restent lisibles mais ne sont pas Inter (visible sur les builds
  Android où Roboto = Inter-style déjà). Pas bloquant.
- Quelques titres hardcodés (`TextStyle(fontFamily: AppTheme.montserrat, …)`)
  plutôt que via thème.
- Pas de montée de grande échelle en cas de `textScaleFactor` fort : les tailles
  de cards piston ne sont pas clamped, le risque d'overflow à 200 % de scale
  existe (Style home, settings, onboarding).

### 2.3 Rayons et espacement (8,5/10)
Distribution des rayons observés : 12 (boutons/pills), 14 (input/avatars),
16 (tuiles), 18 (cartes), 20 (hero), 28 (bottom sheet), 99 (chips).
Cohérent et documenté à travers `AppCard` (18), `InfoBanner` (14), `Pill` (999).
Les espacements suivent multiples de 4/8 (4, 7, 8, 10, 14, 16) — ordonné.
- Manque un fichier `spacing.dart` (tokens : `xs4, sm8, md16, lg24, xl32,
  xxl48`) pour centraliser ; aujourd'hui les valeurs sont en dur.

### 2.4 Composants (9/10)
- `Pressable`, `AppButton` (enabled/disabled opacity 0.45, loading),
  `AppCard`, `AppChip`, `AppTextField`, `AppListTile`, `Pill`, `InfoBanner`,
  `EmptyState`, `AppIconButton` : touch points couverts.
- Toutes les entrées (actions, tabs, listes) ont un retour haptique via
  `AppMotion`; hit test opaque sur les NAV items.
- **Cibles tactiles** : `AppIconButton.size = 42` par défaut — en dessous du
  min Apple/iOS 44×44. Aucune contrainte `minimumSize` n'est appliquée.
- `AppListTile` padding `horizontal 14, vertical 13` → hauteur effective ~40 pt
  pour une ligne simple — acceptable Apple, mais les icônes usérables (chevrons)
  restent petites.

### 2.5 Iconographie (8/10)
- 85 entrées dans `AppIcons` depuis `HugeIcons.strokeRounded…` (cohérence
  stroke-rounded Apple-friendly).
- Exception documentée et pragmatique : les icônes à état (étoiles, cœurs) en
  Material pour tenir le remplissage. Compréhensible.
- AppIcon wrapper rend la taille 24/20 univoque — pas de dérive de taille.

### 2.6 Formulaires (8/10)
- `AppTextField` unique — radius 14, bordure focused en primary 1.4,
  error states déclarés dans le thème.
- `FormSection` rendu de façon cohérente dans extra + réels : emojis + hint,
  bouton « Valider » pleine largeur en bas.
- Validation **stricte all-fields** — robuste mais manque de messages inline
  d'erreur par champ (`InputDecoration.errorText`), seuls des toasts globaux.
- **Jamais de `TextField` iOS-style autocorrect / clavier numérique** : tous
  les champs reçoivent un clavier générique, y compris les téléphones/montants
  (`keyboardType: TextInputType.number` jamais posé).
- Pas d'`obscureText` pour mots de passe visibles → risque UX (caché/œil).

### 2.7 Accessibilité (4/10)
- **Zéro `Semantics`** dans `lib/` (hors Cupertino stock), donc : pas de labels
  pour les screen readers, pas de `accessibilityLabel` sur les icônes
  indicateurs.
- `AppMotion.reduce` et `MediaQuery.disableAnimationsOf` sont honorés.
- Alt text des icônes absentes. App `AppIcon` ne rend pas `label`.
- `Material` focus visible : border bleue fine, OK mais bas.
- Pas de contraste dynamique dans le thème (certains gris `0xFFE3E8F0` sur
  `surface` atteignent ~1,5:1) — pas critique pour des séparateurs, mais à
  vérifier pour les libellés secondaires.

### 2.8 Responsive / adaptive (5/10)
- 4 `LayoutBuilder` : `ScanPickupScreen`, `courier_map`, hero, extra sections.
- **Aucun breakpoint** `>=600 pt` (tablette), pas de layouts `Row`/`Column`
  adaptés, pas d'usage `MaxWidth` contraint aux contenus larges. Les écrans
  admin/comparateur reste single-column même sur tablette.
- Sliver app grids (`GridView` probablement fixes à 2 colonnes) — acceptable
  pour e-commerce mobile.
- Orientation : pas de layout différent portrait/paysage.

### 2.9 Dark mode (9,5/10)
- Thème sombre bien pensé : surfaces basses (`0xFF0F1218`), gradients néon non
  saturés, swirls hero équivalents.
- Le bouton « Carte galerie » et quelques `surfaceContainerHighest` dark.
- Incohérence mineure : `Color(0xFF0B0E14)` dans hero_screens (pas
  `AppColors.darkBackground`).
- Les ombres convient dark (`0x66000000` scrim).
- Test d'exemple : `FakeColorMetric` non pertinent.

### 2.10 Motion (9/10)
- Détail dans `docs/AUDIT_apple_design.md`. Synthèse : spring damping 0.8/1.0,
  fade+slide 320-380 ms, haptique multi-niveaux ; `AppMotion.reduce` respecté.
- `Rive` et `Lottie` fallback en mode réduit — testable.

### 2.11 Contenu / UX microcopie
- Français soigné, cohérent, omniprésent (cinématiques CTA « Ajouter au panier »,
  « Remboursement »).
- Toasts (SnackBar flottant) ronds `12` — cohérents.
- L'« emoji » de test UI (`🧪`, `<Tagline>`) dans les aperçus est cohérent avec
  la démo.
- Vesicule `MotionEnter` partout via extra, montants « 12 500 FCFA ».
- **Erreur d'UX** : pour l'auth OTP il n'y a pas d'`onboarding` back button
  explicite ? (à vérifier live — non dans l'audit statique).

### 2.12 Performance
- `BackdropFilter` seulement sur la barre de navigation et widgets isolés
  (bon cursus, pas de blur par l'arbre).
- `RiveStage` chargé paresseusement et désactivé en mode réduit.
- Images (network) : ne semble pas utiliser de cache réseau (`cached_network_image`
  absent). Lenteur perçue en bas débit.
- `IndexedStack` sur le shell : toutes les pages montées — plus de RAM mais
  pas de dispose. Acceptable.
- Lottie tree-shedding = 85,2 Mo APK — l'input de démarrage est OK.
- Les `ListView` des aperçus lazy build — bien testé.

### 2.13 Hiérarchie visuelle
- Page title 18 bold, hero 26 bold, display 34. Hiérarchie importante.
- Valeur des montants en success color (`AppColors.success` = vert) — Apple-ish.
- Des styles de prix parfois en `AppColors.primary` (bleu) ailleurs : à uniformiser.
- Cartes ont une frontière `outlineVariant` subtile + `radius 18`. **Pas d'ombre
  Material** — volonté « flat/material » ; acceptable pour HIG (elevation zero).
- Les ombres sont rarissimes (bottom nav, bouton Vendre). Cohérent avec Apple.

---

## 3. Top 5 actions recommandées (non demandées, de haute valeur)

1. **Accessibility** : ajouter `Semantics(label:)` et role aux `AppCard`,
   `AppListTile`, `AppIconButton` ; augmenter les tap targets à 44–48 ;
   clamping des `textScaleFactor`.
2. **Tokens Inter** : ajouter le fichier `Inter-Regular/Medium/SemiBold/Bold.ttf`
   déclaré dans pubspec et wire dans `_textTheme()` pour remplacer le fallback
   Roboto (CDC).
3. **Clavier** : `keyboardType` + `obscureText`/toggle œil dans les forms
   et écrans auth.
4. **Tokens spacing** : introduire `lib/core/theme/spacing.dart`.
5. **Responsive** : breakpoints `>= 840` pour comparer/grands tableaux
   (comparateur, Admin).

---

## 4. Résultat testé

Aucune régression introduite : ce document est une **analyse**.
`flutter analyze` 0 · `flutter test` 255/255 verts · sources inchangées.
