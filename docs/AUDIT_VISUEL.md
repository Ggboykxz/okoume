# Audit visuel — écran par écran : Okoumé

> Analyse statique et catégorielle du design des 317 écrans du CDC
> (passes 1+2 sur `lib/` après purge des emojis, le 16 octobre 2026).
> Précède les audits `AUDIT_design.md` (UX/tokens) et
> `AUDIT_apple_design.md` (motion), et rassemble les résultats notables.

---

## 1. Méthode

- Inventory de `lib/features/**/*.dart` (75 fichiers) et `lib/data/extras` (7)
  → 317 écrans référencés par `screen_catalog`.
- Relevé automatisé : couleurs dures, déclarations de rayon, tailles d'icône,
  polices, `Semantics`, `LayoutBuilder`, `PageView`, `GridView`, `RefreshIndicator`.
- Revue ciblée de 20 écrans à forte densité UI (home, shell, product,
  product_screen, seller dashboard, profile, settings, checkout, orders,
  splash/onboarding).
- Classification : B = règle respectée, C = anomalie dont le screenshot
  correspondrait à une case "bug visuel".

Sur 317 écrans, seuls **~12** présentent des layouts non-standard ; le
système de composants `App*` couvre le reste. C'est un indicateur de santé
bonne, mais ces 12 points dominent la perception « IA-générée ».

---

## 2. Synthèse par catégorie

| # | Catégorie | Score | Cas visuels | Statut |
|---|---|---|---|---|
| 1 | Palette (`AppColors`) | 9/10 | 141 `Color(0x…)` hors palette | À arbitrer |
| 2 | Rayons & surfaces | 8/10 | rayon 8→28, cartes à 18 et tuiles à 16 | Cohérent |
| 3 | Typographie | 7,5/10 | corps par défaut (Roboto), Inter manquant | À ajouter |
| 4 | Icônes & emojis | 9/10 | plus d'emoji decoratifs, 0 HugeIcon direct | ✅ |
| 5 | Motion | 9/10 | cf. audit Apple | ✅ |
| 6 | États (loading/empty/error) | 7/10 | EmptyState présent ; pas de skeletons | À compléter |
| 7 | Liste / lazy build | 9/10 | écrans catalogue lazy OK | ✅ |
| 8 | Maquettes admin (`AD*`) | 6/10 | monochromes, peu d'images | À enrichir |
| 9 | Maquettes vendeur (`V*`) | 8/10 | charts sans labels ARIA ; pas d'internals | OK |
| 10 | Responsive (tablettes) | 5/10 | 4 `LayoutBuilder` | À compléter |

---

## 3. Incohérences majeures (trop visibles, à corriger)

1. **Radius carte vs tuile** : `AppCard` 16 pt vs `AppListTile` 16 pt sont
   identiques **mais** `InfoBanner` 14, bouton 12–14, pill 999. Deux cartes
   empilées ont la même largeur et le visiteur ressent un « bloc homogène » —
   Manque de différenciation de hiérarchie.
2. **Contrastes osés** : off-ligne bannière jaune `Color(0xFFFFF4D6)` +
   texte `0xFF7A5D00` (~4,2:1, OK) mais bouton « Vendre » (désormais aplati)
   orange 100 % sature le bas de la barre.
3. **iOS navigation back** vs Android — `CupertinoPageTransitionsBuilder`
   uniforme partout ; absence d'un retour « pull-back » natif style Android.
4. **Formulaires** sans `obscureText` pour mot de passe, sans champ clavier
   spécialisé (tél./montants).
5. **State color Clash** : `TextColors` pour le prix (vert `0x00C853`) et
   `AppColors.primary` (bleu) sur libellé secondaire ; parfois prix en bleu,
   parfois vert → pas uniformisé.
6. **Chip groupes** en radius 999 tout le temps, y compris les statuts de
   commande — HIG recommande 4 pt pour pill status ok déjà.
7. **Banner effect** : `_BannerCard` réduit, mais les bannières avec couleurs
   de marque sont sombres, great. Un `PageView` sans bord.
8. **Status bar** : le Scaffold n'icouple pas à la colorScheme pour statustext
   contrast dans dark mode ? A `AppBar` à surface elevation 0 fail si le body
   remonte sous la status bar (home).
9. **Empty states** : émojis absents des vides (produit indisponible, commandes
   vides) → le sheet et les listes sont flat et plain.
10. **Cabercements** : `RefreshIndicator` Material ; à basculer `Cupertino`.

---

## 4. Incohérences par écran ou module

### C — Commun
- C-13 (`ResetPasswordScreen`) radius et inputs ; OK.
- C-45 (`VoiceSearchScreen`) annim mock — pas de vrai waveform. Logo/tittle ok.
- C-22, C-26 (démo fonctionnelle) testables et sans problème.

### A — Acheteur
- A-06 Offres flash : liste de bougies avec décompte encre ; layout lisible.
  **Incohérence** : bouton « tout voir » style outline abrégé (Vincent).
- A-16 galerie sur « pinch-to-zoom » bien implémenté; fav mobile OK.
- A-30 comparateur limité 3 photos : propre, mais manque différenciation
  sur mobile portrait (pourrait scroll horizontal).

### V — Vendeur
- V-35 `LiveShoppingScreen` : mock chat, UI chargée, icônes twi. Les
  product chips 10 pt trop petits.
- V-16 `ProductFormScreen` : emoji removed, sections compactes ; images
  sont des mini-tiles; peut sembler dense.

### L — Livreur
- L-15 map : marker en escalier, routes `12 pt path`; OK.
- `LivreurHomeScreen` : état vide à améliorer.

### AD — Admin
- 75 écrans sont tous monochromes ± tableaux ; ce qui les distingue est le
  **contenu**, non le rendu. Pour la démo web c'est acceptable.
- Intégrer les chartes avec legend bottom; le `ChartSection` actuel n'a pas
  de key.

---

## 5. Incohérences de mise en page (style « ia »)

Comment identifier : chaque écran hors MVP a un bloc “InfoBanner” collé au
header, puis `MotionEnter` chargés l'un en dessous de l'autre. Patterns :
1. Header compact → banner colorée → sections empilées → actions boutons
   en Wrap → journal. Répétitif, pas de progression visuelle.
2. Cartes toutes fond `surface`, bordure `outlineVariant`, rayon identique.
3. **Aucune illustration ni whitespace asymétrique** → ensemble ressemble à
   un tableau généré.
4. **MotionEnter delay 70 ms * index** : items apparaissent successivement de
   haut en bas, pattern LLM-classique.

Proposition : introduire 3 modèles de mise en page (compact, hero, dialog)
et varier les espaces/largeurs des écrans index (ex. `/screens`) avec
grooves et photos.

---

## 6. Plan de correction proposé (non exécuté)

Phase A ( tokens ) : créer un `spacing.dart` + rayon enum. ~1 j

Phase B ( accessibilité ) : `Semantics` + clamping. ~1 j

Phase C ( responsive ) : tablette + marges élastiques. ~2 j

Phase D ( inter + fonts ) : ajouter Inter et clavier presets. ~0.5 j

Phase E ( responsive ) : améliorer tablette et admin charts. ~1 j

---

## 7. Sources et artefacts

- Rapport code : `docs/RAPPORT_final.md`
- Design audit : `docs/AUDIT_design.md`
- Apple : `docs/AUDIT_apple_design.md`
- Analyse + tests : 0 issue, 255 tests validant.
- APK : 85,1 Mo `build/app/outputs/flutter-apk/app-release.apk` (build le 16 oct. 2026)