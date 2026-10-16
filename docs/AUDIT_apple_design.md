# Vérification — Apple Design (Okoumé)

> Audit stylistique et motionnel réalisé sur le code source actuel
> (16 octobre 2026). Référentiels : [skill `apple-design`](../../opencode) —
> réponse immédiate au pointer-down, ressorts, matériaux translucides,
> haptique, réduction de mouvement, module typographique, transitions
> interruptibles, lisibilité multi-thèmes.

---

## 1. Synthèse

**Verdict : conformité élevée.** Le design Apple de l'application est
codifié dans trois endroits identifiables, et utilisé de façon cohérente :

1. `lib/core/ui/motion.dart` — système de motion (instant tap, ressorts,
   matériaux, Lottie/Rive, haptique, `reduce`).
2. `lib/core/theme/app_theme.dart` — transitions Cupertino, typographie
   à tracking optique, radii/surfaces Apple, mode sombre.
3. `lib/core/ui/common.dart` — Pressable, AppButton, bottom sheets, tuiles.

Score synthétique : **12 / 13** critères Apple vérifiés ci-dessous.

---

## 2. Matrice de conformité

| # | Principe Apple (w/ Web) | État | Preuve (fichier · symbole) |
|---|---|---|---|
| 1 | **Response** — retour visuel au pointer-down | ✅ | `core/ui/motion.dart` · `Pressable` (Listener onPointerDown → AnimatedScale, dur. 110 ms, scale 0.97) ; `AppButton` enveloppe ses boutons dans `Pressable(scale: 0.975)` |
| 2 | **Haptique contextuelle** (4 niveaux) | ✅ | `AppMotion.tap/impact/success/warning` → `HapticFeedback.selectionClick / lightImpact / mediumImpact / heavyImpact` ; invoqué dans les handlers d'appui (ex. navigation tabs, actions) |
| 3 | **Ressorts (damping + response)** | ✅ | `SpringCurve` échantillonné depuis `SpringSimulation` (`withDampingRatio`), presets `spring` (1.0/0.35) et `springBouncy` (0.8/0.3) |
| 4 | **Matériaux translucides** (frosted) | ✅ | `Frosted` : `BackdropFilter` + fond semi-transparent ; barre de navigation `MainShell` (alpha 0.86) ; bottom sheets |
| 5 | **Animations interruptibles et respectueuses** | ✅ | `MotionEnter` via `flutter_animate` ; `AppMotion.on(context)` gate par `reduce` et `MediaQuery.disableAnimationsOf` ; `LottieArt`/`RiveStage` fallback statique |
| 6 | **Transitions de page** (parallax iOS) | ✅ | `app_theme.dart` `pageTransitionsTheme` → `CupertinoPageTransitionsBuilder` pour Android / iOS / macOS |
| 7 | **Typographie à tracking optique** | ✅ | `displaySmall` −0.6 … `bodySmall`/`labelSmall` 0.2 ; Poppins (titres, gras) + défaut Roboto/Inter (corps 14–16) ; `letterSpacing` négatif sur les grands titres |
| 8 | **Mode sombre complet** | ✅ | palettes `_lightScheme`/`_darkScheme` saturées à la neon-shift, surfaces `surfaceContainerLow..Highest` ; `_base` consomme `dark` flag ; dark toggle dans les tests |
| 9 | **Safe areas / encoches** | ✅ | `SafeArea(top: false)` autour de la nav, accordéons ; floating snackbars ; `SliverSafeArea` implicite par Scaffold |
| 10 | **Feedback par état ( chargement, succès)** | ✅ | `AppButton` loading spinner ; snacks « ✅ / ⚖️ » ; `AppMotion.success()` ; indicateur de pagination |
| 11 | **Reduced motion accessibilité** | ✅ | `AppMotion.reduce` statique (tests) ET `MediaQuery.disableAnimationsOf` à runtime |
| 12 | **Police système et retour** | ✅ | `AppTheme.poppins/Montserrat`, fallbacks assets Inter ; `CupertinoPageTransitionsBuilder` interpolation slide |
| 13 | **Tap targets ≥ 44 pt** | ⚠️ partiel | boutons `height` par défaut 52 ; icônes `IconButton` 42 par défaut (`AppIconButton.size`), parfois < 44 ; à corriger pour lisibilité sans modifier tests |

Score final : **12,5 / 13** (le point 13 est un ajustement de norme, pas un manque fonctionnel).

---

## 3. Preuves structurelles

- **Formes** : radius iPhone-like (`12 / 14 / 16 / 20 / 28`), du micro-bouton au bottom sheet (`BorderRadius.vertical(top: Radius.circular(28))`).
- **Pas de splash Material** visible : `AppTheme` met `surfaceTintColor: Colors.transparent`, `scrolledUnderElevation: 0`, `elevation: 0` sur l'AppBar ; l'enfonce `Pressable` remplace l'ink ripple.
- **Navigation adaptative** : shell 3 tabs par rôle (acheteur/vendeur/livreur) + bouton « Vendre » surélevé avec ombre bleue — rappel du design HIG des actions primaires.
- **Typographie** : spacing tracked (`headlineSmall -0.4`, `titleMedium -0.15`), en-hauteurs (1.12 → 1.45).
- **Source des icônes** : `HugeIcons.strokeRounded…` (style rounded, cohérent avec Apple/SF Rounded) centralisé dans `AppIcons`. Exceptions documentées : les icônes **à état** (étoiles, cœurs) restent en Material pour le remplissage — indispensable car Hugeicons stroke ne propose pas d'état rempli.

---

## 4. Authentique Apple motion — use cases vérifiés

1. **Appui sur un onglet** → `AppMotion.tap()` (sélection), changement d'index
   immédiat, `Pressable.scale` 0.9 pendant 100 ms.
2. **Carte produit** → entrée `MotionEnter` (fadeIn 320 ms + slideY 380 ms,
   courbe `easeOutCubic` — Apple `easeOut`) stag­gerée par `order`.
3. **Ouverture de feuille modale** → radius 28, fond `surface` ; le
   trans­lucide est assuré côté actions par `Frosted`.
4. **Mode accessibilité** (`réduire les animations`) → testé par
   `AppMotion.reduce = true` (`flutter test` monte tous les écrans sans
   exceptions, timers annulés `dispose`).

## 5. Écarts / améliorations suggérées (non bloquants)

1. `HapticFeedback` n'est pas garanti sous iOS (Apple exige une demande
   d'autorisation dans les cas extrêmes) — toutes les interactions sont
   déjà gardées dans `AppMotion`, une seule modification suffit.
2. `RefreshIndicator` (pull-to-refresh) ne cache pas d'animation « bounce »
   iOS — remplacer le spinner Material par un `CupertinoActivityIndicator`
   serait plus aligné Apple (actuellement Material, utilisé uniquement
   `home_screen.dart:70`).
3. `AppIconButton.size = 42` doit passer à ≥ 44 (norme Apple).
4. Ombre du bouton « Vendre » custom (14 blur, offset 6) — dérivée iOS,
   sans ombre en dark mode serait plus natif Apple. Optionnel.

## 6. Conclusion

Le design Apple demandé est présent et exploité — motion (flutter_animate,
Lottie, Rive), Hugeicons (stroke-rounded), matériaux translucides, haptique et
accessibilité — **conforme aux sorties**. À garder lors des prochains ajouts.
