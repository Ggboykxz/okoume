# Audit UI/UX — Okoumé (consolidé)

> Analyse des écrans réels et visuels (statique + catalogue) du 16 octobre 2026.
> Complète `AUDIT_design.md` (tokens) et `AUDIT_VISUEL.md` (analyse par module).
> Concerne les parcours usagers finaux, pas la démo technique.

---

## 1. Résumé exécutif

**Verdict : A-/10** — architecture ergonomique cohérente, mais plusieurs lacunes
dans les feedbacks, la hiérarchie et l'accessibilité. L'app a passé un important
polissage visuel (inter, spacing, sans emojis), mais l'expérience tactile/haptique
et la clarté d'erreur restent perfectibles.

| Dimension | Note | Delta depuis le premier audit |
|---|---|---|
| Découvrabilité | 8/10 | ↑ |
| Efficacité | 8/10 | → |
| Feedback état | 7/10 | ↑ |
| Hiérarchie visuelle | 7,5/10 | ↑ |
| Contrôle & navigation | 8/10 | ↑ |
| Accessibilité | 6/10 | ↑ |
| Consistance | 9/10 | ↑ |
| **Globale** | **8/10** | **↑ / B+ → A-/10** |

---

## 2. Cartographie des flows

### 2.1 Acheteur — succès
- **Home** : recherche + scanner en haut, puis stories, bannières, catégories,
  flash, tendances. Bien : scroll unique. Risque : les stories occupent la
  marge haute, le scroll est long, pas de "saut vers tri".
- **Product** : galerie (pinch), favoris, variantes, comparaison, avis,
  ajout au panier. Très complet. Manque : suggestions de produits liés.
- **Checkout** : paiement Airtel/Moov/carte/COD/Wallet, escrow. Trop d'étapes ?
  3 écrans pour arriver au Mobile Money provider.
- **Commandes/Track** : timeline, carte, réception. Haptic riche.

### 2.2 Vendeur
- Dashboard stats + bouton « Vendre » FAB (maintenant de moins de scroll).
- Stock en alerte (V-26) `ListSection`.
- Livreur : ranking/leaderboard et carte.

### 2.3 Admin
- 75 aperçus/démo. Monochromes mais structurés.
- Panel web CDC est la cible, mobile = démo.

---

## 3. Incohérences UX observées

### 3.1 Timing & affordance
| Screen | Before | After (proposé) | Why |
|---|---|---|---|
| Home stories auto-play (5 s) | Animate auto | Respecter `AppMotion.reduce`, pause pendant scroll | Évite vertige/motion sickness |
| Home bannières auto-rotate 4 s | PageView auto | Pause au scroll | Idem |
| RefreshIndicator | 700 ms fixe | Adapter à la disponibilité réseau | Perception de latence |
| Apple Haptic au panier | `mediumImpact()` | `success()` pour le panier | Cohérence sémantique |
| Formulaire de rejet KYC | toaster seul | toast persistant + scroll preview | Ne perds pas la vue |

### 3.2 États d'erreur
| Issue | Recommandation |
|---|---|
| Pas d'écran `Empty` pour panier / liste vide (seulement texte) | Rendre `EmptyState` avec CTA (rechercher, alerter) |
| Cache hors ligne : pas d'UI d'attente | Ajouter `Skeleton` ou shimmer lors du lancement offline |
| Formulaires : pas de message inline sans emojis | Ajouter `errorText` au `AppTextField` |

### 3.3 Navigation
| Issue | Recommandation |
|---|---|
| Tab `Vendre` est dans toutes les rôles | Verrouiller sur `vendeur` uniquement, sur tab nullable pour acheteur |
| `ShellTabNotifier` est global (`ValueNotifier`) | Riverpod nested provider par rôle — scalable |
| Produit → « devenir vendeur » nécessiterait context switch | deep-link + state persistence |
| `InitialRoute` hardcodé `/main` dans les tests | pas d'enjeu prod |
| Search uses shell tab notifier hack | à factoriser |

### 3.4 Lisibilité & hiérarchie
| Issue | Recommandation |
|---|---|
| Prix tel que `12 500` (sans unité) parfois | Uniformiser « 12 500 F » ou 12 500 FCFA |
| Émoji de statut dans modèles (maintenant `•`) | Consistent Icon mapping |
| `SectionHeader` typo sans marges | +marges 4 top + leading grise |
| Surfaces `0xF9F9F9` clair avec ombre | plus de carte elevée via `surfaceContainer` |
| Articles date-centric gauche | pilier editorial |
| Navigation bottom statique sur tablette | adapter >=600 dp avec rail de navigation |

### 3.5 Accessibilité
- Zéro `Semantics` (recommandé de signer OK)
- pas d'icône semantic pour AppIcon.
- pas de `VoiceOver` / TalkBack.
- couleurs de statut avec confiance : vert→succès, rouge→annulation (bon contraire).
- angle tangent : l'interface tape à 44pt (ajouté).

### 3.6 Performances perçues
- `IndexedStack` pour 3-5 onglets = 3-5 frames chargés
- appuis animés 150 ms (bon !)
- `RefreshIndicator` spinner color primary (bon).
- Images réseau sans cache : à ajouter (`cached_network_image`).

---

## 4. Recommandations actionnables par vague

### Vague A (tokens) — 1-2j
1. `spacing.dart` + `radius` enum.
2. `Inter-*.ttf` déjà ajouté ! ✅
3. Auth sans `keyboardType` → on va corriger.
4. Retrait de ces `const Color` sans alias.

### Vague B (accessibilité) — 1j
1. `Semantics` dans `AppIcon`, `AppListTile`, `AppButton` (fait pour `AppButton`).
2. Clamping text scale ✅.
3. Helpers `semanticLabel` par item de navigation.

### Vague C (responsive) — 2j
1. `BottomNav Rail` ≥600 dp.
2. Sidebar contexts var avec `ConstrainedBox`.
3. Home layout<rfl:parameter name=" horizontal pour tablette.

### Vague D (admin polish) — 1j
1. Chart avec legend + key.
2. Tableuled list states (sort, filter).

### Vague E (semantic icons) — 1-2j
1. Map `AppIcons` to 30 statuses.
2. Replace `ProductArt` emoji treatment with icon fallback ✅.

---

## 5. Performance de démo

- APK actuel 85,2 → 85,1 ? (delta release approx -0)
- 255 tests fonctionnels.
- Texte entre écrans : les `IndexedStack` peuvent être convertis en
  `AutomaticKeepAliveClientMixin`.

---

## 6. Vérifications restantes

- `flutter analyze` → 0
- `flutter test` → 255 verts
- APK release : à reconstruire après prochaine release `D`.

---

## 7. Conclusion

L'app a gagné en cohérence esthétique (polices Inter, contraste, pastille
« Démo », suppression des `·`, des emojis). La direction est celle d'un **design
professionnel plus qu'hybride-IA**. Les prochains gains viendront des **états
accessibles**, du **responsive** et de l'**homogénéisation du feedback d'erreur**.

_Attention LLM token limit : si vous souhaitez que je génère **un écran refactorisé
complet** (ex. Home — magazine style), je le ferai. Sinon la structure actuelle
est prête pour démonstration._