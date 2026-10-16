# Okoumé

> La marketplace e-commerce du Gabon. Tout le Gabon, dans ma poche.

Okoumé est une application mobile Flutter qui connecte acheteurs, vendeurs et livreurs à travers le Gabon. Interface inspirée des guidelines Apple avec animations fluides, ressorts physiques et matériaux translucides.

## Fonctionnalités

- **3 rôles** : Acheteur, Vendeur, Livreur — shell adaptatif selon le rôle
- **Catalogue** : 42 produits, 12 vendeurs, categories, recherche avec filtres
- **Panier & Commande** : Panier avec variantes, codes promo, livraison offerte dès 25 000 FCFA
- **Paiement** : Airtel Money, Moov Money, carte bancaire, cash, portefeuille
- **Suivi commandes** : 7 états (confirmée → livrée), OTP de livraison, escrow
- **Messagerie** : Chat temps réel avec réponses automatiques (démo)
- **Espace vendeur** : Dashboard, produits, vente rapide, finances
- **Espace livreur** : Courses disponibles, gains, wallet
- **Design system** : Material 3 + custom (ressorts, translucides, haptique)
- **Navigation adaptative** : BottomNavigationBar (mobile) / NavigationRail (tablette)
- **Thème clair/sombre** avec mode bas débit

## Stack technique

| Technologie | Usage |
|---|---|
| Flutter/Dart | SDK ^3.13.5 |
| Riverpod | État global (NotifierProvider, Provider.family) |
| GoRouter | Navigation déclarative (~60 routes) |
| flutter_animate | Animations |
| Lottie / Rive | Animations complexes |
| Hugeicons | Icônes |

## Architecture

```
lib/
├── main.dart              → Point d'entrée
├── app.dart               → MaterialApp.router + thème
├── router.dart            → GoRouter (toutes les routes)
├── core/                  → Design system & utilitaires
│   ├── art.dart           → ProductArt, SellerAvatar, AppLogo
│   ├── format.dart        → formatXaf, formatDate, timeAgo
│   ├── theme/             → Couleurs, thème Material 3, spacing
│   └── ui/                → Composants modulaires
│       ├── components/    → buttons, pills, price, inputs, cards, product, stats, helpers
│       ├── app_icons.dart
│       └── motion.dart
├── data/                  → Modèles, providers, mock data
│   ├── models.dart        → 30+ classes
│   ├── providers/         → 13 fichiers par domaine
│   ├── mock_data.dart     → Données démo
│   └── screen_catalog.dart → Catalogue CDC 317 écrans
└── features/              → Écrans par module
    ├── shell/             → Navigation adaptative
    ├── auth/              → 8 écrans
    ├── home/              → Accueil, flash, local, stories
    ├── catalog/           → Catégorie, produit, avis, vendeur
    ├── search/            → Recherche
    ├── cart/              → Panier
    ├── checkout/          → Commande, paiement, succès/échec
    ├── orders/            → Commandes, suivi, reçu
    ├── chat/              → Messagerie
    ├── profile/           → Profil, paramètres, wallet, adresses
    ├── seller/            → Dashboard, produits, finances
    ├── livreur/           → Courses, gains, wallet
    └── extra/             → Écrans bonus
```

## Démarrage

```bash
# Installer les dépendances
flutter pub get

# Lancer en mode debug
flutter run

# Lancer les tests
flutter test

# Build APK
flutter build apk --release
```

## Données

L'application fonctionne **100% hors-ligne** avec des données mock locales. Aucun backend requis.

## Licence

Projet privé — Tous droits réservés.
