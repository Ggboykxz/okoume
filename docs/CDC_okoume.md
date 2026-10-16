# 📱 CAHIER DES CHARGES COMPLET & FICHE TECHNIQUE

## Application Mobile E-Commerce — Marché Gabonais

**Projet** : Plateforme e-commerce nationale gabonaise
**Cible** : Tous les vendeurs et acheteurs au Gabon
**Date** : Août 2026
**Version** : 1.0 — Document de référence

---

## TABLE DES MATIÈRES

1. [Vision & Contexte](#1-vision--contexte)
2. [Analyse du Marché](#2-analyse-du-marché)
3. [Architecture Fonctionnelle](#3-architecture-fonctionnelle)
4. [Parcours Utilisateur (UX Flows)](#4-parcours-utilisateur-ux-flows)
5. [Spécifications Techniques Détaillées](#5-spécifications-techniques-détaillées)
6. [Stack Technique Recommandée](#6-stack-technique-recommandée)
7. [Design System & UX/UI](#7-design-system--uxui)
8. [Sécurité & Conformité](#8-sécurité--conformité)
9. [Monétisation & Modèle Économique](#9-monétisation--modèle-économique)
10. [Roadmap & Phases de Développement](#10-roadmap--phases-de-développement)
11. [Budget Estimatif](#11-budget-estimatif)
12. [KPIs & Métriques de Succès](#12-kpis--métriques-de-succès)
13. [Annexes](#13-annexes)

---

## 1. VISION & CONTEXTE

### 1.1 Vision Produit

Créer **la plateforme e-commerce de référence au Gabon** — un super-app qui centralise l'achat et la vente de tous les produits du pays, en connectant vendeurs, acheteurs et livreurs dans un écosystème digital fluide, sécurisé et accessible à tous.

### 1.2 Problématiques Résolues

| Problématique | Solution apportée |
| --- | --- |
| Fragmentation des ventes (WhatsApp, Facebook, physique) | Plateforme centralisée avec vente rapide et social commerce |
| Confiance entre acheteurs et vendeurs | Système d'escrow, notation, vérification KYC, garantie satisfait/remboursé |
| Logistique chaotique | Marketplace de livreurs intégrée avec géolocalisation temps réel |
| Paiement complexe | Intégration native Airtel Money, Moov Money, cartes bancaires |
| Barrière à l'entrée pour les petits vendeurs | Onboarding simplifié, vente en 3 clics, pas de stock requis |
| Couverture limitée | Fonctionnement offline-first avec synchronisation différée |

### 1.3 Positionnement

- **Pour les acheteurs** : "Tout le Gabon, dans ma poche"
- **Pour les vendeurs** : "Vends partout, livre partout, encaisse partout"
- **Pour les livreurs** : "Gagne de l'argent en livrant autour de toi"

---

## 2. ANALYSE DU MARCHÉ

### 2.1 Contexte Digital Gabonais (2026)

- **Population** : ~2,4 millions d'habitants
- **Taux de pénétration Internet** : ~62% (en progression)
- **Utilisateurs de smartphones** : ~1,8 million
- **Transactions Mobile Money (2024)** : 4 087 milliards FCFA
- **Opérateurs dominants** : Airtel Gabon, Moov Africa (Gabon Telecom)
- **Devises** : Franc CFA (XAF) — pas de décimales dans les prix
- **Villes principales** : Libreville, Port-Gentil, Franceville, Lambaréné, Mouila, Oyem

### 2.2 Acteurs Concurrentiels

| Acteur | Forces | Faiblesses |
| --- | --- | --- |
| Facebook Marketplace | Audience massive | Pas de paiement intégré, pas de livraison, pas de confiance |
| WhatsApp Business | Familier, gratuit | Pas de catalogue structuré, pas de paiement sécurisé |
| Jumia Gabon | Livraison structurée | Catalogue limité, pas de social commerce, pas de livreurs indépendants |
| Boutiques physiques | Proximité | Pas de visibilité digitale, pas de livraison |

### 2.3 Opportunité de Marché

- **Marché informel massif** : La majorité des ventes se font via réseaux sociaux sans infrastructure
- **Besoin de confiance** : Les acheteurs hésitent à payer en avance sans garantie
- **Besoin de livraison** : Aucune solution de livraison à la demande structurée
- **Inclusion financière** : Mobile Money comme levier principal (60%+ des transactions)

---

## 3. ARCHITECTURE FONCTIONNELLE

### 3.1 Vue d'Ensemble des Modules

```javascript
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION MOBILE                        │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │ ACHETEUR│ │ VENDEUR │ │LIVREUR  │ │ADMIN    │           │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘           │
│       └─────────────┴───────────┴───────────┘               │
│                         │                                    │
│              ┌──────────┴──────────┐                        │
│              │   BACKEND API       │                        │
│              │  (REST + WebSocket) │                        │
│              └──────────┬──────────┘                        │
│       ┌─────────────────┼─────────────────┐                │
│  ┌────┴────┐ ┌────────┴────────┐ ┌──────┴──────┐          │
│  │Paiement │ │  Livraison      │ │  Catalogue  │          │
│  │Engine   │ │  Engine         │ │  Engine     │          │
│  └─────────┘ └─────────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Module ACHETEUR — Fonctionnalités Détaillées

#### 3.2.1 Découverte & Recherche

- **Page d'accueil personnalisée** : Algorithme de recommandation basé sur l'historique, la localisation, les tendances locales
- **Recherche avancée** : Par mot-clé, catégorie, prix, localisation, note vendeur, disponibilité livraison
- **Filtres intelligents** : Prix croissant/décroissant, proximité géographique, livraison express, produits locaux, promotions
- **Catégories principales** :
- Alimentation & Boissons
- Électronique & Téléphonie
- Mode & Accessoires
- Maison & Décoration
- Beauté & Santé
- Auto & Moto
- Services & Prestations
- Artisanat & Produits locaux
- Immobilier (location/vente)
- Animaux
- **Stories/Shorts produits** : Format vertical pour découvrir les nouveautés (inspiré de TikTok/Reels)
- **Wishlist** : Sauvegarde de produits avec alerte de prix

#### 3.2.2 Fiche Produit

- Galerie photos/vidéos HD (jusqu'à 10 médias)
- Description détaillée avec formatage riche
- Caractéristiques techniques (attributs dynamiques par catégorie)
- Variantes (taille, couleur, etc.)
- Prix + frais de livraison estimés
- Disponibilité stock en temps réel
- Évaluations et avis clients (photos incluses)
- Questions/Réponses publiques
- Produits similaires et complémentaires
- Bouton "Négocier le prix" (chat direct avec le vendeur)

#### 3.2.3 Panier & Commande

- Panier multi-vendeurs (commande groupée ou séparée)
- Calcul automatique des frais de livraison par vendeur
- Code promo / coupons de réduction
- Choix du mode de livraison :
- Livraison à domicile
- Point de retrait (lockers ou partenaires)
- Retrait chez le vendeur
- Récapitulatif détaillé avant paiement
- Suivi de commande en temps réel (tracking GPS)
- Historique complet des commandes
- Réclamation / retour produit intégré

#### 3.2.4 Paiement

- **Airtel Money** (intégration API marchand)
- **Moov Money** (intégration API marchand)
- **Carte bancaire** (Visa/Mastercard via passerelle sécurisée)
- **Paiement à la livraison** (Cash on Delivery)
- **Portefeuille interne** (crédit prépayé sur l'app)
- **Paiement fractionné** (payement en 2-3 fois)
- **Système d'escrow** : L'argent est bloqué jusqu'à confirmation de réception

#### 3.2.5 Messagerie

- Chat intégré acheteur-vendeur
- Partage de photos/vidéos
- Messages vocaux (adapté au contexte gabonais)
- Traduction automatique (français ↔ langues locales si besoin)
- Notifications push intelligentes

#### 3.2.6 Profil & Compte

- Informations personnelles (KYC léger)
- Adresses de livraison multiples
- Moyens de paiement enregistrés
- Notifications personnalisables
- Paramètres de confidentialité
- Programme de fidélité / points
- Parrainage (gagne des crédits en invitant des amis)

### 3.3 Module VENDEUR — Fonctionnalités Détaillées

#### 3.3.1 Types de Vendeurs

| Type | Description | Fonctionnalités |
| --- | --- | --- |
| **Vendeur Social** | Vente via réseaux sociaux, pas de boutique physique | Catalogue simple, partage lien produit, vente rapide |
| **Commerçant** | Boutique physique ou en ligne existante | Gestion stock complète, analytics, promotions avancées |
| **Artisan/Producteur** | Créateur de produits locaux | Mise en avant "Made in Gabon", storytelling |
| **Entreprise** | Marques et distributeurs | API B2B, gestion multi-points de vente, facturation |

#### 3.3.2 Onboarding Vendeur

- Inscription en 3 étapes (téléphone → infos boutique → vérification)
- Vérification KYC :
- Pièce d'identité (CNI, passeport, permis)
- Selfie en temps réel (liveness detection)
- NIF (Numéro d'Identification Fiscale) optionnel pour les pros
- Vérification du numéro marchand Airtel/Moov
- Création de boutique personnalisée :
- Nom, description, logo, bannière
- Horaires d'ouverture
- Politique de retour
- Zones de livraison couvertes

#### 3.3.3 Gestion de Catalogue

- Ajout de produits (photo, vidéo, description, prix, stock)
- Gestion des variantes (taille, couleur, poids)
- Catégorisation automatique par IA
- Import en masse (CSV/Excel)
- Gestion des stocks avec alertes seuil
- Produits en vedette / promotions
- Mode "Vente Rapide" : création d'un produit en moins de 60 secondes (photo + prix + description courte)

#### 3.3.4 Social Commerce

- **Partage sur réseaux sociaux** : Génération automatique de visuels optimisés pour WhatsApp, Facebook, Instagram, TikTok
- **Lien produit universel** : Un lien partageable qui redirige vers l'app ou le web
- **Catalogue WhatsApp** : Synchronisation avec WhatsApp Business
- **Live Shopping** : Diffusion en direct pour présenter et vendre des produits
- **Stories produits** : Publication de stories visibles par les abonnés de la boutique

#### 3.3.5 Gestion des Commandes

- Tableau de bord des commandes (en attente, en préparation, expédiées, livrées, annulées)
- Impression de bons de livraison
- Gestion des retours et remboursements
- Statistiques de vente (CA, produits les plus vendus, panier moyen)
- Export des données (Excel/PDF)

#### 3.3.6 Gestion des Livraisons

- Demande de livreur à la demande
- Tarification automatique selon distance/poids
- Suivi en temps réel des livraisons
- Confirmation de livraison avec code OTP + signature + photo

#### 3.3.7 Finances

- Tableau de bord financier
- Historique des transactions
- Demandes de retrait vers Airtel Money / Moov Money / compte bancaire
- Génération automatique de factures
- Rapports fiscaux (TVA, etc.)

### 3.4 Module LIVREUR — Fonctionnalités Détaillées

#### 3.4.1 Inscription Livreur

- Formulaire d'inscription (identité, véhicule, permis)
- Vérification des documents :
- CNI
- Permis de conduire
- Photo du véhicule (moto, voiture, camionnette)
- Casque/équipement de sécurité (pour les motos)
- Extrait de casier judiciaire (optionnel selon zone)
- Test de connaissance du quartier (quiz géographique)
- Entretien vidéo ou présentiel (selon le niveau de service)

#### 3.4.2 Types de Livraison

| Type | Description | Véhicule |
| --- | --- | --- |
| **Express** | < 2h | Moto |
| **Standard** | Same day / Next day | Moto / Voiture |
| **Programmée** | Date et créneau choisis | Voiture / Camionnette |
| **Lourde** | Meubles, gros volumes | Camionnette |
| **Inter-villes** | Entre villes du Gabon | Camion / Transporteur partenaire |

#### 3.4.3 Application Livreur

- **Mode disponible/indisponible** (bouton simple)
- **Acceptation/refus de courses** avec infos (distance, prix, poids, adresses)
- **Navigation GPS intégrée** (Google Maps / Waze / Maps.me offline)
- **Scanner QR code** pour validation de prise en charge
- **Code OTP** pour remise au client
- **Photo de preuve de livraison**
- **Signature digitale** du client
- **Chat avec client** (anonymisé)
- **Historique des courses et gains**
- **Portefeuille interne** pour les gains
- **Demande de retrait** instantanée vers mobile money

#### 3.4.4 Tarification & Rémunération

- Tarification dynamique selon :
- Distance (km)
- Poids/volume
- Type de livraison (express vs standard)
- Zone (urbain vs périurbain vs rural)
- Heure (surcoût nuit/we)
- Commission plateforme : 15-25% selon le type
- Prime de performance (notation, ponctualité)
- Bonus de rush (heures de pointe)
- Assurance livreur incluse (accident, vol)

#### 3.4.5 Notation & Réputation

- Système de notation double (livreur noté par client, client noté par livreur)
- Badge de qualité (Or, Argent, Bronze)
- Suspension automatique sous 3,5/5
- Programme de formation continue

### 3.5 Module ADMIN — Fonctionnalités Détaillées

#### 3.5.1 Dashboard Global

- KPIs en temps réel (CA, nombre de commandes, utilisateurs actifs, livraisons)
- Carte thermique des ventes par zone
- Alertes automatiques (fraude, litige, livreur inactif)

#### 3.5.2 Gestion des Utilisateurs

- Liste des acheteurs/vendeurs/livreurs
- Vérification KYC manuelle
- Suspension/activation de comptes
- Gestion des rôles et permissions

#### 3.5.3 Gestion des Transactions

- Suivi de toutes les transactions
- Gestion des litiges et remboursements
- Rapports financiers
- Reconciliation avec Airtel/Moov

#### 3.5.4 Gestion du Catalogue

- Validation des nouvelles boutiques
- Modération des produits (contrefaçon, interdits)
- Gestion des catégories et attributs
- Bannières et promotions

#### 3.5.5 Gestion des Livraisons

- Suivi de toutes les courses en cours
- Attribution manuelle de courses
- Gestion des zones de couverture
- Tarification des zones

#### 3.5.6 Support Client

- Tickets de support
- Chat en direct
- Base de connaissances
- Escalade automatique

#### 3.5.7 Marketing & Communication

- Gestion des notifications push
- Campagnes email/SMS
- Codes promo et coupons
- Programme de fidélité
- Analytics marketing

---

## 4. PARCOURS UTILISATEUR (UX FLOWS)

### 4.1 Parcours Acheteur — Achat Complet

```javascript
[Ouverture App] → [Home personnalisée] → [Recherche/Filtres] → [Fiche Produit]
    → [Ajout Panier] → [Validation Panier] → [Choix Livraison] → [Paiement]
    → [Confirmation] → [Suivi Livraison] → [Réception + Notation]
```

**Temps cible** : De la découverte à la commande < 3 minutes pour un utilisateur régulier

### 4.2 Parcours Vendeur — Première Vente

```javascript
[Téléchargement] → [Inscription] → [Vérification KYC] → [Création Boutique]
    → [Ajout Premier Produit] → [Partage Réseaux Sociaux] → [Réception Commande]
    → [Préparation] → [Demande Livreur] → [Livraison] → [Encaissement]
```

**Temps cible** : De l'inscription à la première vente < 15 minutes

### 4.3 Parcours Livreur — Première Course

```javascript
[Téléchargement App Livreur] → [Inscription] → [Vérification Documents]
    → [Formation Rapide] → [Activation Mode Disponible] → [Réception Course]
    → [Acceptation] → [Prise en Charge] → [Livraison] → [Validation OTP]
    → [Encaissement Commission]
```

**Temps cible** : De l'inscription à la première course < 24h

### 4.4 Parcours Vente Rapide (Social Commerce)

```javascript
[App Vendeur] → [Bouton "Vendre Maintenant"] → [Photo Produit]
    → [Prix + Description] → [Génération Lien] → [Partage WhatsApp/Facebook]
    → [Client clique lien] → [Paiement direct] → [Notification vendeur]
    → [Demande livreur ou retrait]
```

**Temps cible** : Création et partage d'un produit < 60 secondes

---

## 5. SPÉCIFICATIONS TECHNIQUES DÉTAILLÉES

### 5.1 Exigences Fonctionnelles (FR)

#### FR-001 : Authentification & Sécurité

- FR-001.1 : Inscription par numéro de téléphone avec OTP SMS
- FR-001.2 : Authentification biométrique (empreinte, Face ID)
- FR-001.3 : Authentification à deux facteurs (2FA) optionnelle
- FR-001.4 : JWT avec refresh token rotation
- FR-001.5 : Déconnexion à distance depuis tous les appareils
- FR-001.6 : Détection de connexion suspecte (nouvel appareil, nouvelle localisation)

#### FR-002 : Catalogue Produits

- FR-002.1 : CRUD produits avec validation des champs
- FR-002.2 : Upload multi-photos (jusqu'à 10, compression auto)
- FR-002.3 : Upload vidéos (jusqu'à 60 secondes)
- FR-002.4 : Gestion des variantes (attributs dynamiques)
- FR-002.5 : Catégorisation hiérarchique (3 niveaux)
- FR-002.6 : Tags et mots-clés
- FR-002.7 : Recherche full-text avec correction orthographique
- FR-002.8 : Indexation pour recherche rapide (< 200ms)
- FR-002.9 : Suggestions de recherche autocomplete
- FR-002.10 : Historique de recherche personnel

#### FR-003 : Panier & Commandes

- FR-003.1 : Panier persistant (local + cloud)
- FR-003.2 : Panier multi-vendeurs avec séparation
- FR-003.3 : Calcul temps réel des totaux
- FR-003.4 : Gestion des codes promo (pourcentage, montant fixe, livraison gratuite)
- FR-003.5 : Limites d'utilisation des coupons
- FR-003.6 : Workflow commande : En attente → Confirmée → En préparation → Expédiée → En livraison → Livrée → Terminée
- FR-003.7 : Annulation avec motif et politique de remboursement
- FR-003.8 : Système de litige avec médiation

#### FR-004 : Paiement

- FR-004.1 : Intégration API Airtel Money (marchand)
- FR-004.2 : Intégration API Moov Money (marchand)
- FR-004.3 : Intégration passerelle carte bancaire (Stripe/PayPal)
- FR-004.4 : Paiement à la livraison (Cash on Delivery)
- FR-004.5 : Portefeuille interne (crédit/débit)
- FR-004.6 : Système d'escrow avec libération conditionnelle
- FR-004.7 : Historique des transactions
- FR-004.8 : Reçus électroniques (PDF)
- FR-004.9 : Gestion des remboursements
- FR-004.10 : Paiement récurrent (abonnements)

#### FR-005 : Livraison

- FR-005.1 : Calcul automatique des frais (distance × poids × type)
- FR-005.2 : Matching livreur-géolocalisation (algorithme de proximité)
- FR-005.3 : Suivi GPS temps réel (WebSocket)
- FR-005.4 : Notifications d'étape (pris en charge, en route, arrivé)
- FR-005.5 : Code OTP de validation
- FR-005.6 : Photo de preuve
- FR-005.7 : Signature digitale
- FR-005.8 : Chat anonymisé livreur-client
- FR-005.9 : Points de retrait (lockers/partenaires)
- FR-005.10 : Livraison inter-villes

#### FR-006 : Messagerie

- FR-006.1 : Chat 1-to-1 (acheteur-vendeur)
- FR-006.2 : Messages texte, photo, vidéo, vocal
- FR-006.3 : Indicateurs de lecture
- FR-006.4 : Suppression de messages
- FR-006.5 : Signalement de contenu inapproprié
- FR-006.6 : Chatbot FAQ automatique

#### FR-007 : Notifications

- FR-007.1 : Push notifications (Firebase/APNs)
- FR-007.2 : Notifications in-app
- FR-007.3 : SMS de fallback
- FR-007.4 : Notifications par email
- FR-007.5 : Paramétrage granulaire des notifications
- FR-007.6 : Notifications géolocalisées (promos proches)

#### FR-008 : Mode Hors Ligne

- FR-008.1 : Navigation catalogue en cache
- FR-008.2 : Ajout au panier hors ligne
- FR-008.3 : Synchronisation différée
- FR-008.4 : Indicateur de connectivité
- FR-008.5 : Mode "bas débit" (images compressées)

### 5.2 Exigences Non-Fonctionnelles (NFR)

#### NFR-001 : Performance

- Temps de chargement initial de l'app < 3 secondes
- Temps de chargement d'une page < 1 seconde
- Recherche de produits < 200ms
- Upload photo < 5 secondes (3G)
- Support de 10 000 utilisateurs simultanés (Phase 1)
- Support de 100 000 utilisateurs simultanés (Phase 3)

#### NFR-002 : Disponibilité

- Uptime cible : 99.9%
- Maintenance planifiée : fenêtre 2h-5h du matin (heure locale)
- RTO (Recovery Time Objective) : < 1 heure
- RPO (Recovery Point Objective) : < 5 minutes

#### NFR-003 : Sécurité

- Chiffrement AES-256 pour les données au repos
- TLS 1.3 pour les données en transit
- Conformité PCI-DSS pour les paiements
- Stockage sécurisé des tokens (Keychain/Keystore)
- Protection contre les attaques courantes (SQL injection, XSS, CSRF)
- Rate limiting sur les APIs
- Audit trail de toutes les actions sensibles

#### NFR-004 : Scalabilité

- Architecture microservices
- Auto-scaling horizontal
- CDN pour les assets statiques
- Cache distribué (Redis)
- Base de données avec sharding capability

#### NFR-005 : Compatibilité

- Android 8.0+ (API 26+)
- iOS 14+
- Responsive Web App (PWA)
- Support des écrans de 4" à 6.7"
- Support du mode sombre
- Support des langues : Français (principal), Anglais

#### NFR-006 : Accessibilité

- Conformité WCAG 2.1 AA
- Support VoiceOver/TalkBack
- Contraste suffisant
- Tailles de texte ajustables
- Navigation au clavier (web)

---

## 6. STACK TECHNIQUE RECOMMANDÉE

### 6.1 Architecture Globale

```javascript
┌─────────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │
│  │   iOS App    │  │ Android App  │  │    PWA / Web App         │  │
│  │  (SwiftUI)   │  │  (Flutter)   │  │   (React / Next.js)      │  │
│  └──────┬───────┘  └──────┬───────┘  └───────────┬──────────────┘  │
│         └─────────────────┴────────────────────────┘                │
│                              │                                       │
│                    ┌─────────┴──────────┐                          │
│                    │   API GATEWAY      │                          │
│                    │  (Kong / AWS API)  │                          │
│                    └─────────┬──────────┘                          │
└──────────────────────────────┼──────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────────────┐
│                    BACKEND LAYER (Microservices)                     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │  Auth    │ │ Catalogue│ │  Order   │ │ Payment  │ │Delivery  │  │
│  │ Service  │ │ Service  │ │ Service  │ │ Service  │ │ Service  │  │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘  │
│       └─────────────┴────────────┴────────────┴────────────┘        │
│                              │                                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │  Chat    │ │ Notification│ │  Admin   │ │ Analytics│ │  Search  │  │
│  │ Service  │ │ Service  │ │  Panel   │ │ Service  │ │ Service  │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘  │
└─────────────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────────────┐
│                    DATA & INFRASTRUCTURE LAYER                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │PostgreSQL│ │  Redis   │ │Elasticsearch│ │  Kafka   │ │  S3/MinIO│  │
│  │(Primary) │ │ (Cache)  │ │ (Search) │ │(Events)  │ │ (Files)  │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                            │
│  │MongoDB   │ │TimescaleDB│ │  Grafana │                            │
│  │(Logs)    │ │(Metrics) │ │(Monitoring)│                            │
│  └──────────┘ └──────────┘ └──────────┘                            │
└─────────────────────────────────────────────────────────────────────┘
```

### 6.2 Détail par Couche

#### 6.2.1 Applications Mobiles

| Aspect | Recommandation | Justification |
| --- | --- | --- |
| **Framework** | Flutter (Dart) | Code unique iOS + Android, performance native, écosystème mature, excellent support offline |
| **State Management** | Riverpod / BLoC | Gestion d'état prévisible, testable |
| **Local DB** | Hive / Isar | Base de données locale rapide, support offline |
| **HTTP Client** | Dio | Intercepteurs, retry, cache |
| **Image Cache** | CachedNetworkImage | Cache intelligent des images |
| **Maps** | Google Maps Flutter | Navigation, géolocalisation, calcul d'itinéraire |
| **Push Notifs** | Firebase Cloud Messaging | Multi-plateforme, fiable |
| **Analytics** | Firebase Analytics + Mixpanel | Comportement utilisateur, funnels |
| **Crash Reporting** | Firebase Crashlytics | Détection temps réel des bugs |
| **Deep Links** | Firebase Dynamic Links | Partage de liens universels |

#### 6.2.2 Backend

| Aspect | Recommandation | Justification |
| --- | --- | --- |
| **Langage** | Node.js (TypeScript) / Go | Haute performance, async, écosystème riche |
| **Framework** | NestJS (Node) / Gin (Go) | Architecture modulaire, injection de dépendances |
| **API Style** | REST + WebSocket | REST pour CRUD, WebSocket pour temps réel (livraison, chat) |
| **Documentation API** | OpenAPI 3.0 / Swagger | Documentation auto-générée |
| **Authentication** | OAuth 2.0 + JWT + Refresh Tokens | Sécurisé, standard |
| **Validation** | Zod / Joi / class-validator | Validation stricte des entrées |

#### 6.2.3 Base de Données

| Type | Technologie | Usage |
| --- | --- | --- |
| **Relationnelle** | PostgreSQL 16 | Données métier (utilisateurs, commandes, produits) |
| **Cache** | Redis 7 | Sessions, cache API, rate limiting, pub/sub temps réel |
| **Search Engine** | Elasticsearch 8 | Recherche full-text, filtres, suggestions |
| **Time-Series** | TimescaleDB | Métriques, analytics, tracking livraisons |
| **Document** | MongoDB | Logs, événements, données non structurées |
| **File Storage** | AWS S3 / MinIO | Images, vidéos, documents |

#### 6.2.4 Infrastructure & DevOps

| Aspect | Recommandation |
| --- | --- |
| **Cloud Provider** | AWS / DigitalOcean / Hetzner (selon budget) |
| **Containerisation** | Docker + Docker Compose (dev) / Kubernetes (prod) |
| **CI/CD** | GitHub Actions / GitLab CI |
| **Monitoring** | Prometheus + Grafana |
| **Logging** | ELK Stack (Elasticsearch + Logstash + Kibana) |
| **APM** | New Relic / Datadog |
| **CDN** | CloudFlare / AWS CloudFront |
| **Load Balancer** | NGINX / AWS ALB |
| **Reverse Proxy** | NGINX / Traefik |

#### 6.2.5 Intégrations Tierces

| Service | Intégration | Usage |
| --- | --- | --- |
| **Airtel Money** | API Marchand | Paiement mobile |
| **Moov Money** | API Marchand | Paiement mobile |
| **Stripe** | API | Paiement carte bancaire |
| **Google Maps** | SDK + API | Géolocalisation, calcul d'itinéraire, autocomplétion adresses |
| **Firebase** | SDK | Push notifications, analytics, crash reporting |
| **Twilio / Africa's Talking** | API | SMS OTP, notifications SMS |
| **SendGrid / Mailgun** | API | Emails transactionnels |
| **Cloudinary** | API | Optimisation et transformation d'images |

---

## 7. DESIGN SYSTEM & UX/UI

### 7.1 Principes de Design

1. **Simplicité** : Maximum 3 taps pour atteindre une fonction clé
2. **Confiance** : Badges, vérifications, avis visibles partout
3. **Local** : Couleurs, icônes, langage adaptés au contexte gabonais
4. **Accessible** : Grandes zones de touch, contrastes forts, textes lisibles
5. **Rapide** : Feedback immédiat, animations subtiles, pas de chargement bloquant

### 7.2 Palette de Couleurs

```javascript
Couleur Primaire    : #0066CC (Bleu Gabon — confiance, technologie)
Couleur Secondaire  : #FF6B00 (Orange — action, achat, alerte)
Couleur Accent      : #00C853 (Vert — succès, livraison, validation)
Couleur Danger      : #FF1744 (Rouge — erreur, annulation, alerte)
Couleur Warning     : #FFC107 (Jaune — attention, en attente)
Couleur Fond        : #F5F7FA (Gris très clair)
Couleur Surface     : #FFFFFF (Blanc)
Couleur Texte       : #1A1A2E (Noir doux)
Couleur Texte Sec.  : #6B7280 (Gris)
```

### 7.3 Typographie

- **Titres** : Poppins / SF Pro Display — Bold, 20-32px
- **Corps** : Inter / Roboto — Regular/Medium, 14-16px
- **Prix** : Montserrat — SemiBold, 18-24px
- **Boutons** : Uppercase ou Title Case, 14-16px, SemiBold

### 7.4 Composants Clés

#### 7.4.1 Home Screen

- Header avec logo, recherche, notifications, panier
- Carrousel de bannières promotionnelles
- Catégories en grille (icônes + labels)
- Section "Tendances près de chez vous" (géolocalisée)
- Section "Nouveautés"
- Section "Promos du jour"
- Barre de navigation bottom (Accueil, Recherche, Vendre, Messages, Profil)

#### 7.4.2 Fiche Produit

- Carrousel photo plein écran (swipe)
- Badge "Vendeur vérifié" + note
- Prix en gros (XAF, sans décimales)
- Bouton "Acheter maintenant" (pleine largeur, couleur primaire)
- Bouton "Ajouter au panier" (outline)
- Bouton "Négocier" (chat)
- Onglets : Détails | Avis | Livraison | Vendeur

#### 7.4.3 Processus de Paiement

- Barre de progression (3 étapes : Livraison → Paiement → Confirmation)
- Récapitulatif clair avec détails
- Sélection du mode de paiement avec icônes
- Confirmation avec animation de succès
- Partage sur réseaux sociaux

#### 7.4.4 Suivi de Livraison

- Carte interactive avec position du livreur
- Timeline des étapes
- Photo du livreur + nom + téléphone (masqué)
- Bouton "Appeler" (numéro masqué)
- Bouton "Chat"

### 7.5 Responsive & Adaptations

- **Mode sombre** : Palette inversée automatique
- **Mode bas débit** : Images compressées, pas d'auto-play vidéo
- **Mode hors ligne** : Indicateur visuel, données en cache
- **Tablette** : Layout adapté (2 colonnes catalogue)
- **Petits écrans** (< 5") : Interface simplifiée, moins d'informations par écran

---

## 8. SÉCURITÉ & CONFORMITÉ

### 8.1 Sécurité des Données

| Mesure | Implémentation |
| --- | --- |
| Chiffrement données sensibles | AES-256-GCM |
| Chiffrement transport | TLS 1.3 obligatoire |
| Stockage mots de passe | Argon2id (hashing) |
| Stockage tokens | Keychain (iOS) / Keystore (Android) |
| Protection screenshots | FLAG_SECURE (Android) |
| Root/Jailbreak detection | SafetyNet / DeviceCheck |
| Obfuscation code | ProGuard / R8 / SwiftShield |

### 8.2 Conformité Réglementaire

- **KYC/AML** : Conformité aux exigences de la CEMAC et de la BEAC
- **Protection des données** : Conformité à la loi gabonaise sur la protection des données
- **Paiements** : Conformité PCI-DSS niveau 1 pour le traitement des cartes
- **E-commerce** : Respect des droits du consommateur (droit de rétractation, garantie)
- **Fiscalité** : Génération de factures conformes, gestion de la TVA

### 8.3 Lutte contre la Fraude

- Détection de comportements suspects (ML)
- Vérification des transactions anormales
- Système de litige avec preuves
- Blacklist des utilisateurs frauduleux
- Vérification des avis (détection de faux avis)

---

## 9. MONÉTISATION & MODÈLE ÉCONOMIQUE

### 9.1 Revenus Plateforme

| Source | Description | Taux |
| --- | --- | --- |
| **Commission sur ventes** | % prélevé sur chaque transaction | 5-15% selon catégorie |
| **Commission livraison** | % prélevé sur les frais de livraison | 15-25% |
| **Abonnement vendeur** | Formule premium avec avantages | 5 000 - 50 000 FCFA/mois |
| **Mise en avant** | Produits sponsorisés en home | CPC ou CPM |
| **Bannières publicitaires** | Espaces publicitaires dans l'app | CPM |
| **Frais de retrait** | Commission sur les retraits vendeurs | 1-2% |

### 9.2 Formules Vendeur

| Formule | Prix/mois | Avantages |
| --- | --- | --- |
| **Gratuit** | 0 FCFA | 50 produits, commission 10%, support basique |
| **Starter** | 5 000 FCFA | 200 produits, commission 8%, analytics basiques |
| **Pro** | 15 000 FCFA | Produits illimités, commission 5%, mise en avant, support prioritaire |
| **Entreprise** | 50 000 FCFA | API access, multi-boutiques, account manager dédié |

### 9.3 Modèle Livreur

- Commission par course (distance × tarif de base)
- Prime de performance
- Bonus de rush
- Programme de parrainage

---

## 10. ROADMAP & PHASES DE DÉVELOPPEMENT

### Phase 1 : MVP (Mois 1-4) — "Fondations"

**Objectif** : Lancer une version fonctionnelle avec les features essentielles

- [ ] Architecture technique et mise en place infrastructure
- [ ] Auth (inscription, connexion, KYC basique)
- [ ] Catalogue produits (CRUD, recherche, filtres)
- [ ] Panier et commandes (workflow basique)
- [ ] Paiement Airtel Money + Moov Money
- [ ] Système de livraison simplifié (retrait chez vendeur)
- [ ] Chat basique acheteur-vendeur
- [ ] Panel admin minimal
- [ ] Apps iOS + Android

**Livrable** : Beta fermée (100 testeurs à Libreville)

### Phase 2 : Croissance (Mois 5-8) — "Expansion"

**Objectif** : Ajouter les features de différenciation et ouvrir au public

- [ ] Système de livraison avec livreurs indépendants
- [ ] App livreur dédiée
- [ ] Social commerce (partage, liens, vente rapide)
- [ ] Système d'escrow
- [ ] Notation et avis
- [ ] Programme de fidélité
- [ ] Paiement carte bancaire
- [ ] Notifications push avancées
- [ ] Support client intégré
- [ ] Ouverture à Port-Gentil et Franceville

**Livrable** : Lancement public (v1.0)

### Phase 3 : Scale (Mois 9-14) — "Domination"

**Objectif** : Optimiser, automatiser et conquérir le marché

- [ ] Live shopping
- [ ] IA recommandation personnalisée
- [ ] Mode hors ligne complet
- [ ] Livraison inter-villes
- [ ] API ouverte pour développeurs tiers
- [ ] Programme partenaires (lockers, points relais)
- [ ] Analytics avancés vendeur
- [ ] Publicité ciblée
- [ ] Expansion vers d'autres villes
- [ ] Version PWA complète

**Livrable** : v2.0 — Plateforme mature

### Phase 4 : Innovation (Mois 15+) — "Super-App"

- [ ] Services financiers intégrés (crédit, épargne)
- [ ] Marketplace de services (plombier, coiffeur, etc.)
- [ ] Livraison de repas (food delivery)
- [ ] Location de véhicules
- [ ] Intégration avec services publics (SEEG, etc.)
- [ ] Expansion CEMAC (Cameroun, Congo, etc.)

---

## 11. BUDGET ESTIMATIF

### 11.1 Développement (Coûts Uniques)

| Poste | Durée | Coût Estimé (FCFA) |
| --- | --- | --- |
| **Architecture & Setup** | 1 mois | 2 000 000 |
| **Backend (API + Services)** | 4 mois | 15 000 000 |
| **App Mobile (Flutter)** | 4 mois | 12 000 000 |
| **App Livreur** | 2 mois | 5 000 000 |
| **Panel Admin Web** | 2 mois | 5 000 000 |
| **UX/UI Design** | 2 mois | 3 000 000 |
| **Intégrations Paiement** | 1 mois | 2 000 000 |
| **Tests QA & Sécurité** | 1 mois | 2 000 000 |
| **Documentation** | 0,5 mois | 500 000 |
| **Sous-total Développement** |  | **46 500 000 FCFA** |

### 11.2 Infrastructure (Coûts Mensuels)

| Service | Coût Mensuel (FCFA) |
| --- | --- |
| **Serveurs Cloud** (prod + staging) | 500 000 |
| **Base de données managée** | 300 000 |
| **Stockage fichiers (S3)** | 100 000 |
| **CDN** | 100 000 |
| **Monitoring & Logging** | 100 000 |
| **SMS Gateway** (variable) | 200 000 |
| **Push Notifications** | 50 000 |
| **API Google Maps** | 150 000 |
| **Sous-total Infrastructure** | **1 500 000 FCFA/mois** |

### 11.3 Opérationnel (Coûts Mensuels)

| Poste | Coût Mensuel (FCFA) |
| --- | --- |
| **Équipe technique** (2-3 devs) | 3 000 000 |
| **Community Manager** | 500 000 |
| **Support Client** | 500 000 |
| **Marketing** | 2 000 000 |
| **Légal & Comptable** | 300 000 |
| **Bureaux & Divers** | 500 000 |
| **Sous-total Opérationnel** | **6 800 000 FCFA/mois** |

### 11.4 Récapitulatif

| Période | Coût Total (FCFA) |
| --- | --- |
| **MVP (4 mois)** | ~74 000 000 FCFA |
| **Année 1** | ~130 000 000 FCFA |
| **Année 2** | ~100 000 000 FCFA |
| **Année 3** | ~120 000 000 FCFA |

---

## 12. KPIs & MÉTRIQUES DE SUCCÈS

### 12.1 KPIs Produit

| Métrique | Cible MVP | Cible Année 1 | Cible Année 3 |
| --- | --- | --- | --- |
| **Utilisateurs actifs mensuels (MAU)** | 1 000 | 50 000 | 500 000 |
| **Vendeurs actifs** | 200 | 5 000 | 50 000 |
| **Livreurs actifs** | 50 | 1 000 | 10 000 |
| **Commandes/mois** | 500 | 20 000 | 200 000 |
| **Panier moyen** | 15 000 FCFA | 20 000 FCFA | 25 000 FCFA |
| **Taux de conversion** | 2% | 3% | 5% |
| **NPS (Net Promoter Score)** | > 30 | > 40 | > 50 |
| **Temps moyen livraison** | 48h | 24h | 12h (express) |
| **Taux de retour** | < 5% | < 3% | < 2% |
| **Note App Store** | > 4.0 | > 4.2 | > 4.5 |

### 12.2 KPIs Business

| Métrique | Cible Année 1 | Cible Année 3 |
| --- | --- | --- |
| **Chiffre d'affaires total** | 500 M FCFA | 5 Mds FCFA |
| **Revenus plateforme** | 50 M FCFA | 500 M FCFA |
| **Commission moyenne** | 8% | 7% |
| **Coût d'acquisition client (CAC)** | 2 000 FCFA | 1 000 FCFA |
| **Lifetime Value (LTV)** | 50 000 FCFA | 100 000 FCFA |
| **LTV/CAC Ratio** | > 5x | > 10x |
| **Burn rate mensuel** | < 8 M FCFA | < 15 M FCFA |
| **Break-even** | Mois 18 | Atteint |

---

## 13. ANNEXES

### Annexe A : Glossaire

| Terme | Définition |
| --- | --- |
| **KYC** | Know Your Customer — Vérification d'identité |
| **Escrow** | Compte séquestre pour sécuriser les transactions |
| **COD** | Cash on Delivery — Paiement à la livraison |
| **MAU** | Monthly Active Users |
| **NPS** | Net Promoter Score — Mesure de satisfaction |
| **PWA** | Progressive Web App |
| **USSD** | Unstructured Supplementary Service Data — Menus téléphoniques |

### Annexe B : Liste des API à Intégrer

1. **Airtel Money API** — Paiement marchand
2. **Moov Money API** — Paiement marchand
3. **Stripe API** — Paiement carte bancaire
4. **Google Maps Platform** — Maps, Routes, Places
5. **Firebase** — Auth, FCM, Analytics, Crashlytics
6. **Twilio / Africa's Talking** — SMS
7. **SendGrid** — Emails
8. **Cloudinary** — Gestion médias

### Annexe C : Matrice de Risques

| Risque | Probabilité | Impact | Mitigation |
| --- | --- | --- | --- |
| Retards de développement | Moyenne | Élevé | Méthodologie agile, MVP strict |
| Faible adoption vendeurs | Élevée | Élevé | Onboarding simplifié, incentives |
| Problèmes de livraison | Élevée | Élevé | Partenariats logistiques, formation |
| Fraude paiement | Moyenne | Élevé | Escrow, KYC, ML détection |
| Concurrence Jumia | Moyenne | Moyen | Différenciation social commerce + local |
| Instabilité réseau | Élevée | Moyen | Mode offline, compression données |
| Régulation mobile money | Faible | Élevé | Conformité stricte, relations opérateurs |

### Annexe D : User Stories Exemples

**US-001** : En tant qu'acheteur, je veux rechercher un produit par mot-clé pour trouver rapidement ce dont j'ai besoin.

- **Critères d'acceptation** : Résultats en < 200ms, correction orthographique, suggestions autocomplete

**US-002** : En tant que vendeur, je veux créer un produit en moins d'une minute pour vendre rapidement sur les réseaux sociaux.

- **Critères d'acceptation** : Flow de 3 écrans max, génération automatique de lien partageable

**US-003** : En tant que livreur, je veux voir les courses disponibles près de ma position pour maximiser mes gains.

- **Critères d'acceptation** : Rayon de 5km par défaut, tri par distance/prix, acceptation en 1 tap

**US-004** : En tant qu'acheteur, je veux payer avec mon Airtel Money pour ne pas avoir besoin de carte bancaire.

- **Critères d'acceptation** : Redirection USSD ou paiement in-app, confirmation SMS, reçu dans l'app

---

## CONCLUSION

Ce cahier des charges définit une vision ambitieuse mais réalisable pour une plateforme e-commerce gabonaise complète. Le succès dépendra de :

1. **L'exécution rapide du MVP** (4 mois) avec un focus sur la confiance et le paiement mobile
2. **L'acquisition de vendeurs** par un onboarding ultra-simplifié et des incitations
3. **La qualité de la livraison** par une flotte de livreurs motivés et formés
4. **L'adaptation au contexte local** (réseau instable, mobile money dominant, commerce informel)
5. **L'itération continue** basée sur les retours utilisateurs et les données

Le marché gabonais est prêt pour une solution e-commerce intégrée. L'adoption massive du mobile money (4 087 milliards FCFA en 2024), la progression de la connectivité et la densité économique de Libreville créent un terreau fertile pour ce projet.

---

*Document rédigé en Août 2026 — Version 1.0*
*Pour toute question ou précision, contacter l'équipe produit.* # **📱 LISTE EXHAUSTIVE DES ÉCRANS DE L'APPLICATION**

## **E-Commerce Gabon — Navigation & Architecture d'Écrans**

**Version : 1.0 | Date : Août 2026 | Total Écrans : 312+**

---

## **TABLE DES MATIÈRES**

1. **Vue d'Ensemble de la Navigation**
2. **Écrans Communs (Tous les Profils)**
3. **Module ACHETEUR**
4. **Module VENDEUR**
5. **Module LIVREUR**
6. **Module ADMIN**
7. **Diagramme de Navigation Global**
8. **Logique de Navigation Détaillée**
9. **Matrice de Connexion des Écrans**
10. **Règles de Navigation**
11. **Récapitulatif & MVP**

---

## **1. VUE D'ENSEMBLE DE LA NAVIGATION**

### **1.1 Types de Navigation Utilisés**

| **Type** | **Description** | **Utilisé Pour** |
| --- | --- | --- |
| **Bottom Tab Navigation** | **Barre de navigation fixe en bas** | **Navigation principale entre les 5 onglets** |
| **Stack Navigation** | **Empilement d'écrans (push/pop)** | **Exploration profonde (produit → panier → paiement)** |
| **Modal Navigation** | **Écran qui glisse par le bas** | **Actions rapides (filtres, partage, confirmation)** |
| **Drawer Navigation** | **Menu latéral coulissant** | **Menu profil, paramètres, options secondaires** |
| **Bottom Sheet** | **Panneau glissant depuis le bas** | **Sélections rapides (adresse, paiement, quantité)** |
| **Full-Screen Modal** | **Écran plein écran modal** | **Caméra, lecteur vidéo, live shopping** |
| **WebView** | **Contenu web intégré** | **CGU, politique de confidentialité, blog** |

### **1.3 Profils Utilisateur & Accès aux Écrans**

| **Profil** | **Écrans Accessibles** | **Badge** |
| --- | --- | --- |
| **Visiteur** | **Écrans communs + découverte limitée** | **Aucun** |
| **Acheteur** | **Tous les écrans acheteur + communs** | **🛒** |
| **Vendeur** | **Tous les écrans vendeur + acheteur + communs** | **🏪** |
| **Livreur** | **Tous les écrans livreur + communs** | **🛵** |
| **Admin** | **Tous les écrans admin + tous les autres** | **👑** |

---

## **2. ÉCRANS COMMUNS (TOUS LES PROFILS)**

### **2.1 Onboarding & Authentification**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **C-01** | **Splash Screen** | **Logo animé, chargement initial** | **C-02** | **Auto** |
| **C-02** | **Onboarding 1** | **Présentation slide 1 — Découvrez** | **C-03** | **Push** |
| **C-03** | **Onboarding 2** | **Présentation slide 2 — Vendez** | **C-04** | **Push** |
| **C-04** | **Onboarding 3** | **Présentation slide 3 — Livrez** | **C-05** | **Push** |
| **C-05** | **Choix Profil** | **"Je veux acheter / vendre / livrer"** | **C-06 / C-20 / C-30** | **Push** |
| **C-06** | **Connexion** | **Téléphone + mot de passe** | **C-07 / C-08 / C-09** | **Push** |
| **C-07** | **Inscription Téléphone** | **Saisie numéro + OTP** | **C-08** | **Push** |
| **C-08** | **Vérification OTP** | **Code SMS 6 chiffres** | **C-09** | **Push** |
| **C-09** | **Création Profil** | **Nom, prénom, email, photo** | **C-10** | **Push** |
| **C-10** | **Choix Localisation** | **Ville, quartier, GPS** | **C-11** | **Push** |
| **C-11** | **Notifications Permission** | **Demande push notifs** | **C-12** | **Push** |
| **C-12** | **Home (Première Connexion)** | **Home personnalisée nouvel utilisateur** | **—** | **Tab** |
| **C-13** | **Mot de Passe Oublié** | **Réinitialisation par SMS** | **C-08** | **Push** |
| **C-14** | **Biométrie Setup** | **Empreinte / Face ID** | **C-12** | **Modal** |
| **C-15** | **Sélection Langue** | **Français / Anglais** | **C-01** | **Modal** |

### **2.2 Profil Utilisateur**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **C-16** | **Mon Profil** | **Photo, nom, note, stats** | **C-17 / C-18 / C-19 / C-20** | **Tab** |
| **C-17** | **Modifier Profil** | **Édition infos personnelles** | **C-16** | **Push** |
| **C-18** | **Mes Adresses** | **Liste des adresses enregistrées** | **C-19 / C-20** | **Push** |
| **C-19** | **Ajouter Adresse** | **Formulaire nouvelle adresse + carte** | **C-18** | **Push** |
| **C-20** | **Modifier Adresse** | **Édition adresse existante** | **C-18** | **Push** |
| **C-21** | **Mes Moyens de Paiement** | **Cartes, mobile money enregistrés** | **C-22 / C-23** | **Push** |
| **C-22** | **Ajouter Carte Bancaire** | **Saisie carte + vérification** | **C-21** | **Modal** |
| **C-23** | **Ajouter Mobile Money** | **Lier Airtel/Moov** | **C-21** | **Modal** |
| **C-24** | **Paramètres** | **Notifications, langue, sécurité, données** | **C-25 / C-26 / C-27 / C-28** | **Push** |
| **C-25** | **Notifications Settings** | **Granularité push/email/SMS** | **C-24** | **Push** |
| **C-26** | **Sécurité** | **2FA, mot de passe, sessions actives** | **C-24** | **Push** |
| **C-27** | **Mode Hors Ligne** | **Gestion cache, données** | **C-24** | **Push** |
| **C-28** | **À Propos** | **Version, mentions légales, CGU** | **C-29 / C-30** | **Push** |
| **C-29** | **CGU** | **Conditions générales d'utilisation** | **C-28** | **WebView** |
| **C-30** | **Politique Confidentialité** | **RGPD / Protection données** | **C-28** | **WebView** |
| **C-31** | **Centre d'Aide** | **FAQ, tutoriels, contact support** | **C-32 / C-33** | **Push** |
| **C-32** | **FAQ** | **Questions fréquentes par catégorie** | **C-31** | **Push** |
| **C-33** | **Contact Support** | **Chat / Email / Téléphone** | **C-31** | **Push** |
| **C-34** | **Signaler un Problème** | **Formulaire de bug/abus** | **C-31** | **Modal** |
| **C-35** | **Déconnexion** | **Confirmation + retour onboarding** | **C-05** | **Alert** |
| **C-36** | **Supprimer Compte** | **Confirmation avec raison** | **C-24** | **Alert** |

### **2.3 Notifications & Messages**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **C-37** | **Notifications Centre** | **Liste de toutes les notifications** | **C-38 / C-39 / C-40** | **Push** |
| **C-38** | **Détail Notification** | **Contenu complet d'une notif** | **C-37** | **Push** |
| **C-39** | **Paramètres Notifications** | **Par type de notification** | **C-37** | **Push** |
| **C-40** | **Marquer Tout Lu** | **Action rapide** | **C-37** | **Action** |

### **2.4 Recherche Globale**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **C-41** | **Recherche** | **Barre + suggestions + historique** | **C-42 / C-43 / C-44** | **Tab** |
| **C-42** | **Résultats Recherche** | **Grille/liste produits + filtres** | **C-43 / C-44 / C-45** | **Push** |
| **C-43** | **Filtres Avancés** | **Prix, catégorie, localisation, note** | **C-42** | **Bottom Sheet** |
| **C-44** | **Détail Produit** | **Fiche complète (voir A-15)** | **A-15** | **Push** |
| **C-45** | **Recherche Vocale** | **Micro + transcription** | **C-42** | **Modal** |

---

## **3. MODULE ACHETEUR (🛒)**

### **3.1 Home & Découverte**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **A-01** | **Home Acheteur** | **Carrousel, catégories, tendances, promos** | **A-02/03/04/05/06/07/08/09/10/11/12/13/14/15** | **Tab** |
| **A-02** | **Catégorie Détail** | **Liste produits d'une catégorie** | **A-15 / A-42** | **Push** |
| **A-03** | **Sous-Catégorie** | **Sous-liste filtrée** | **A-15 / A-42** | **Push** |
| **A-04** | **Tendances Près de Chez Vous** | **Produits populaires géolocalisés** | **A-15 / A-42** | **Push** |
| **A-05** | **Nouveautés** | **Derniers produits ajoutés** | **A-15 / A-42** | **Push** |
| **A-06** | **Promos du Jour** | **Produits en promotion** | **A-15 / A-42** | **Push** |
| **A-07** | **Produits Recommandés** | **Algorithme IA personnalisé** | **A-15 / A-42** | **Push** |
| **A-08** | **Stories Découverte** | **Stories verticales produits (format TikTok)** | **A-15** | **Full-Screen** |
| **A-09** | **Bannière Promo** | **Page détail d'une promotion** | **A-15 / A-42** | **Push** |
| **A-10** | **Vendeurs Populaires** | **Liste boutiques tendance** | **A-11 / A-15** | **Push** |
| **A-11** | **Boutique Vendeur** | **Page publique d'une boutique** | **A-15 / A-42 / A-43 / A-44** | **Push** |
| **A-12** | **Flash Sales** | **Ventes flash avec compte à rebours** | **A-15** | **Push** |
| **A-13** | **Événements Spéciaux** | **Black Friday, Noël, Fête du Travail** | **A-15 / A-42** | **Push** |
| **A-14** | **Produits Locaux** | **"Made in Gabon" — artisanat local** | **A-15 / A-42** | **Push** |

### **3.2 Produit & Décision d'Achat**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **A-15** | **Fiche Produit** | **Photos, prix, description, avis, vendeur** | **A-16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/42/43/44/45** | **Push** |
| **A-16** | **Galerie Photos** | **Visionneuse plein écran HD** | **A-15** | **Full-Screen** |
| **A-17** | **Lecteur Vidéo** | **Vidéo produit plein écran** | **A-15** | **Full-Screen** |
| **A-18** | **Zoom Photo** | **Pinch-to-zoom sur image** | **A-16** | **Modal** |
| **A-19** | **Sélection Variante** | **Taille, couleur, etc. (bottom sheet)** | **A-15** | **Bottom Sheet** |
| **A-20** | **Quantité** | **Sélecteur +/-** | **A-15** | **Bottom Sheet** |
| **A-21** | **Détail Livraison** | **Estimation, modes, frais** | **A-15** | **Bottom Sheet** |
| **A-22** | **Politique Retour** | **Conditions de retour du vendeur** | **A-15** | **Bottom Sheet** |
| **A-23** | **Avis Clients** | **Liste des avis avec photos** | **A-24 / A-25** | **Push** |
| **A-24** | **Détail Avis** | **Avis complet avec photos** | **A-23** | **Push** |
| **A-25** | **Écrire un Avis** | **Formulaire note + commentaire + photos** | **A-23** | **Modal** |
| **A-26** | **Questions & Réponses** | **Q&A publiques sur le produit** | **A-27** | **Push** |
| **A-27** | **Poser une Question** | **Formulaire nouvelle question** | **A-26** | **Modal** |
| **A-28** | **Signaler Produit** | **Contrefaçon, contenu inapproprié** | **A-15** | **Modal** |
| **A-29** | **Partager Produit** | **Options de partage (WhatsApp, FB, etc.)** | **A-15** | **Bottom Sheet** |
| **A-30** | **Comparer Produits** | **Comparaison côte à côte (jusqu'à 3)** | **A-15** | **Push** |
| **A-31** | **Produits Similaires** | **Recommandations basées sur le produit** | **A-15** | **Push** |
| **A-32** | **Négocier Prix** | **Chat direct avec le vendeur pour négocier** | **A-15 / A-43** | **Push** |

### **3.3 Panier & Commande**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **A-33** | **Mon Panier** | **Liste articles, totaux, vendeurs** | **A-15/34/35/36/37/38** | **Push** |
| **A-34** | **Modifier Quantité Panier** | **+/- dans le panier** | **A-33** | **Bottom Sheet** |
| **A-35** | **Supprimer Article** | **Confirmation suppression** | **A-33** | **Alert** |
| **A-36** | **Sauvegarder pour Plus Tard** | **Déplacer vers wishlist** | **A-33 / A-42** | **Action** |
| **A-37** | **Appliquer Code Promo** | **Saisie code + validation** | **A-33** | **Bottom Sheet** |
| **A-38** | **Validation Commande** | **Récapitulatif avant paiement** | **A-39/40/41** | **Push** |
| **A-39** | **Choisir Adresse Livraison** | **Sélection ou ajout adresse** | **A-38 / C-19** | **Bottom Sheet** |
| **A-40** | **Choisir Mode Livraison** | **Express, standard, retrait** | **A-38** | **Bottom Sheet** |
| **A-41** | **Choisir Mode Paiement** | **Airtel, Moov, carte, cash, wallet** | **A-38** | **Bottom Sheet** |
| **A-42** | **Wishlist** | **Produits sauvegardés** | **A-15 / A-33** | **Push** |
| **A-43** | **Chat avec Vendeur** | **Conversation privée** | **A-15 / A-32 / C-41** | **Push** |
| **A-44** | **Profil Vendeur Public** | **Infos boutique, avis, produits** | **A-11 / A-15** | **Push** |
| **A-45** | **Suivre Vendeur** | **S'abonner aux nouveautés** | **A-11 / A-15** | **Action** |

### **3.4 Paiement**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **A-46** | **Paiement Airtel Money** | **Redirection USSD / in-app** | **A-47 / A-48** | **Push** |
| **A-47** | **Paiement Moov Money** | **Redirection USSD / in-app** | **A-48 / A-49** | **Push** |
| **A-48** | **Paiement Carte Bancaire** | **Formulaire Stripe sécurisé** | **A-49** | **Push** |
| **A-49** | **Paiement Cash on Delivery** | **Confirmation mode cash** | **A-50** | **Push** |
| **A-50** | **Paiement Portefeuille** | **Utilisation crédit interne** | **A-51** | **Push** |
| **A-51** | **Confirmation Paiement** | **Animation succès + détails** | **A-52/53/54** | **Push** |
| **A-52** | **Échec Paiement** | **Erreur + options retry** | **A-46/47/48** | **Push** |
| **A-53** | **Partager Commande** | **Story réseaux sociaux** | **A-51** | **Bottom Sheet** |
| **A-54** | **Reçu Électronique** | **PDF de la transaction** | **A-51** | **Modal** |

### **3.5 Suivi de Commande**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **A-55** | **Mes Commandes** | **Liste toutes les commandes** | **A-56/57/58/59/60/61/62** | **Push** |
| **A-56** | **Détail Commande** | **Infos complètes + timeline** | **A-57/58/59/60/61/62** | **Push** |
| **A-57** | **Suivi GPS Livraison** | **Carte temps réel + position livreur** | **A-56** | **Push** |
| **A-58** | **Contacter Livreur** | **Chat / Appel masqué** | **A-56** | **Bottom Sheet** |
| **A-59** | **Annuler Commande** | **Formulaire motif + confirmation** | **A-56** | **Modal** |
| **A-60** | **Demander Remboursement** | **Formulaire litige** | **A-56** | **Modal** |
| **A-61** | **Confirmer Réception** | **Code OTP + signature + photo** | **A-56 / A-62** | **Push** |
| **A-62** | **Noter Commande** | **Évaluation vendeur + livreur + produit** | **A-61** | **Modal** |
| **A-63** | **Commande à Réceptionner** | **Alertes commandes en attente** | **A-56** | **Push** |
| **A-64** | **Historique Achats** | **Toutes les commandes passées** | **A-56** | **Push** |
| **A-65** | **Achats Récents** | **Commandes des 30 derniers jours** | **A-56** | **Push** |

### **3.6 Points de Retrait & Lockers**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **A-66** | **Carte Points Retrait** | **Carte interactive des points relais** | **A-67 / A-68** | **Push** |
| **A-67** | **Détail Point Retrait** | **Horaires, infos, itinéraire** | **A-66** | **Push** |
| **A-68** | **Itinéraire Point Retrait** | **Navigation GPS vers le point** | **A-67** | **External** |
| **A-69** | **Scan QR Retrait** | **Scanner pour récupérer colis** | **A-56** | **Full-Screen** |

---

## **4. MODULE VENDEUR (🏪)**

### **4.1 Onboarding & Dashboard Vendeur**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-01** | **Devenir Vendeur** | **Présentation + formulaire** | **V-02 / V-03** | **Push** |
| **V-02** | **Type de Vendeur** | **Social / Commerçant / Artisan / Entreprise** | **V-03** | **Push** |
| **V-03** | **KYC Vendeur** | **Upload CNI, selfie, NIF** | **V-04** | **Push** |
| **V-04** | **Vérification en Cours** | **Écran d'attente + statut** | **V-05** | **Auto** |
| **V-05** | **KYC Validé** | **Confirmation + création boutique** | **V-06** | **Push** |
| **V-06** | **Créer Boutique** | **Nom, description, logo, bannière** | **V-07** | **Push** |
| **V-07** | **Configurer Livraison** | **Zones, tarifs, modes** | **V-08** | **Push** |
| **V-08** | **Configurer Paiement** | **Lier Airtel/Moov marchand** | **V-09** | **Push** |
| **V-09** | **Dashboard Vendeur** | **CA, commandes, stats, alertes** | **V-10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31** | **Tab** |
| **V-10** | **Analytics Vente** | **Graphiques CA, évolution** | **V-09** | **Push** |
| **V-11** | **Produits Populaires** | **Top produits vendus** | **V-15** | **Push** |
| **V-12** | **Clients Fidèles** | **Top acheteurs** | **V-09** | **Push** |
| **V-13** | **Performance Boutique** | **Note, taux conversion, retours** | **V-09** | **Push** |

### **4.2 Gestion Catalogue**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-14** | **Mes Produits** | **Liste tous les produits** | **V-15/16/17/18/19/20/21** | **Push** |
| **V-15** | **Fiche Produit Vendeur** | **Vue vendeur du produit** | **V-16/17/18/19/20/21/25/A-15** | **Push** |
| **V-16** | **Ajouter Produit** | **Formulaire complet** | **V-14 / V-22** | **Push** |
| **V-17** | **Modifier Produit** | **Édition fiche produit** | **V-15** | **Push** |
| **V-18** | **Dupliquer Produit** | **Copie rapide** | **V-14** | **Action** |
| **V-19** | **Supprimer Produit** | **Confirmation + motif** | **V-14** | **Alert** |
| **V-20** | **Gérer Stock** | **Quantité, alertes seuil** | **V-15** | **Bottom Sheet** |
| **V-21** | **Importer Produits** | **Upload CSV/Excel** | **V-14** | **Modal** |
| **V-22** | **Ajouter Photos Produit** | **Camera / Galerie (jusqu'à 10)** | **V-16 / V-17** | **Full-Screen** |
| **V-23** | **Ajouter Vidéo Produit** | **Enregistrement / Upload** | **V-16 / V-17** | **Full-Screen** |
| **V-24** | **Catégories & Attributs** | **Gestion catégorisation** | **V-16 / V-17** | **Bottom Sheet** |
| **V-25** | **Promotions Produits** | **Réductions, flash sales** | **V-15** | **Bottom Sheet** |
| **V-26** | **Produits en Rupture** | **Alertes stock bas** | **V-14** | **Push** |
| **V-27** | **Produits en Vedette** | **Mise en avant payante** | **V-14** | **Push** |

### **4.3 Vente Rapide & Social Commerce**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-28** | **Vendre Maintenant** | **Bouton rapide vente** | **V-29/30/31** | **Tab / Push** |
| **V-29** | **Vente Rapide — Photo** | **Prendre photo produit** | **V-30** | **Full-Screen** |
| **V-30** | **Vente Rapide — Infos** | **Prix + description courte (3 champs)** | **V-31** | **Push** |
| **V-31** | **Vente Rapide — Partage** | **Génération lien + partage réseaux** | **V-32/External** | **Bottom Sheet** |
| **V-32** | **Catalogue WhatsApp** | **Synchronisation statuts produits** | **V-28** | **Push** |
| **V-33** | **Générer Visuel** | **Image optimisée pour réseaux sociaux** | **V-31** | **Modal** |
| **V-34** | **Live Shopping Setup** | **Planifier un live** | **V-35** | **Push** |
| **V-35** | **Live Shopping En Direct** | **Diffusion + chat + achat intégré** | **V-36** | **Full-Screen** |
| **V-36** | **Fin Live Shopping** | **Stats, ventes, replay** | **V-35** | **Push** |
| **V-37** | **Stories Boutique** | **Publier story produit** | **V-28** | **Full-Screen** |
| **V-38** | **Lien Produit Universel** | **Gestion des liens partagés** | **V-31** | **Push** |

### **4.4 Gestion Commandes**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-39** | **Commandes Reçues** | **Liste toutes les commandes** | **V-40/41/42/43/44/45/46/47** | **Push** |
| **V-40** | **Détail Commande Reçue** | **Infos complètes client + produits** | **V-41/42/43/44/45/46/47** | **Push** |
| **V-41** | **Confirmer Commande** | **Accepter la commande** | **V-40** | **Action** |
| **V-42** | **Préparer Commande** | **Marquer "en préparation"** | **V-40** | **Action** |
| **V-43** | **Imprimer Bon Livraison** | **Génération PDF** | **V-40** | **Modal** |
| **V-44** | **Demander Livreur** | **Matching livreur disponible** | **V-40 / L-01** | **Push** |
| **V-45** | **Marquer Expédiée** | **Commande prête, livreur assigné** | **V-40** | **Action** |
| **V-46** | **Annuler Commande** | **Motif + confirmation** | **V-40** | **Modal** |
| **V-47** | **Contacter Client** | **Chat / Appel** | **V-40** | **Bottom Sheet** |
| **V-48** | **Commandes en Attente** | **À confirmer** | **V-39** | **Push** |
| **V-49** | **Commandes en Cours** | **En préparation / expédiées** | **V-39** | **Push** |
| **V-50** | **Commandes Livrées** | **Historique livrées** | **V-39** | **Push** |
| **V-51** | **Commandes Annulées** | **Historique annulées** | **V-39** | **Push** |
| **V-52** | **Commandes en Litige** | **Réclamations clients** | **V-39 / V-53** | **Push** |
| **V-53** | **Gérer Litige** | **Répondre + proposer solution** | **V-52** | **Push** |
| **V-54** | **Retours & Remboursements** | **Gestion des retours** | **V-52** | **Push** |

### **4.5 Livraison Vendeur**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-55** | **Mes Livraisons** | **Suivi des livraisons en cours** | **V-56/57/58** | **Push** |
| **V-56** | **Détail Livraison** | **Infos livreur, client, statut** | **V-55** | **Push** |
| **V-57** | **Contacter Livreur** | **Chat / Appel** | **V-56** | **Bottom Sheet** |
| **V-58** | **Tarification Livraison** | **Configurer zones et tarifs** | **V-09** | **Push** |
| **V-59** | **Zones de Couverture** | **Carte des zones livrables** | **V-58** | **Push** |
| **V-60** | **Ajouter Zone** | **Dessiner zone sur carte** | **V-59** | **Push** |

### **4.6 Finances Vendeur**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-61** | **Portefeuille Vendeur** | **Solde, transactions, gains** | **V-62/63/64/65** | **Push** |
| **V-62** | **Historique Transactions** | **Liste détaillée** | **V-61** | **Push** |
| **V-63** | **Détail Transaction** | **Infos complètes** | **V-62** | **Push** |
| **V-64** | **Demander Retrait** | **Montant + mode (Airtel/Moov/Banque)** | **V-61** | **Modal** |
| **V-65** | **Confirmation Retrait** | **Récapitulatif + code OTP** | **V-64** | **Push** |
| **V-66** | **Factures** | **Liste factures générées** | **V-67** | **Push** |
| **V-67** | **Détail Facture** | **PDF facture** | **V-66** | **Modal** |
| **V-68** | **Rapports Fiscaux** | **TVA, exports comptables** | **V-61** | **Push** |
| **V-69** | **Abonnement Vendeur** | **Gérer formule (Gratuit/Starter/Pro)** | **V-70/71/72** | **Push** |
| **V-70** | **Choisir Formule** | **Comparaison des formules** | **V-69** | **Push** |
| **V-71** | **Paiement Abonnement** | **Renouvellement / Upgrade** | **V-70** | **Push** |
| **V-72** | **Avantages Formule** | **Détail des avantages actuels** | **V-69** | **Push** |

### **4.7 Boutique & Profil Public**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **V-73** | **Ma Boutique** | **Vue publique de ma boutique** | **V-74/75/76/77** | **Push** |
| **V-74** | **Modifier Boutique** | **Nom, description, visuels** | **V-73** | **Push** |
| **V-75** | **Horaires Ouverture** | **Configurer jours et heures** | **V-73** | **Push** |
| **V-76** | **Politique Retour** | **Rédiger politique** | **V-73** | **Push** |
| **V-77** | **À Propos Boutique** | **Story, valeurs, équipe** | **V-73** | **Push** |
| **V-78** | **Avis Clients** | **Tous les avis reçus** | **V-79** | **Push** |
| **V-79** | **Répondre à un Avis** | **Réponse publique** | **V-78** | **Modal** |
| **V-80** | **Signaler Avis** | **Avis frauduleux** | **V-78** | **Modal** |

---

## **5. MODULE LIVREUR (🛵)**

### **5.1 Onboarding & Dashboard**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **L-01** | **Devenir Livreur** | **Présentation + formulaire** | **L-02 / L-03** | **Push** |
| **L-02** | **Infos Personnelles** | **Nom, téléphone, email** | **L-03** | **Push** |
| **L-03** | **Documents Véhicule** | **Type, photo, permis** | **L-04** | **Push** |
| **L-04** | **Upload Documents** | **CNI, permis, casier judiciaire** | **L-05** | **Push** |
| **L-05** | **Selfie Vérification** | **Photo temps réel** | **L-06** | **Full-Screen** |
| **L-06** | **Quiz Géographique** | **Test connaissance quartiers** | **L-07** | **Push** |
| **L-07** | **Vérification en Cours** | **Écran attente** | **L-08** | **Auto** |
| **L-08** | **Validation Livreur** | **Confirmation + activation** | **L-09** | **Push** |
| **L-09** | **Dashboard Livreur** | **Gains, courses, statut, stats** | **L-10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25** | **Tab** |
| **L-10** | **Gains du Jour** | **Détails gains journaliers** | **L-09** | **Push** |
| **L-11** | **Gains de la Semaine** | **Récap hebdomadaire** | **L-09** | **Push** |
| **L-12** | **Gains du Mois** | **Récap mensuel + graphique** | **L-09** | **Push** |
| **L-13** | **Performance** | **Note, ponctualité, taux acceptation** | **L-09** | **Push** |

### **5.2 Gestion des Courses**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **L-14** | **Mode Disponible** | **Bouton ON/OFF + zone** | **L-15 / L-16** | **Tab** |
| **L-15** | **Carte des Courses** | **Carte avec courses disponibles** | **L-16 / L-17** | **Push** |
| **L-16** | **Nouvelle Course** | **Popup notification course** | **L-17** | **Modal** |
| **L-17** | **Détail Course** | **Distance, prix, poids, adresses** | **L-18 / L-19** | **Push** |
| **L-18** | **Accepter Course** | **Confirmation** | **L-20** | **Action** |
| **L-19** | **Refuser Course** | **Motif + confirmation** | **L-14** | **Alert** |
| **L-20** | **Navigation vers Prise en Charge** | **GPS vers point de retrait** | **L-21** | **External** |
| **L-21** | **Scanner QR Prise en Charge** | **Validation récupération colis** | **L-22** | **Full-Screen** |
| **L-22** | **Navigation vers Livraison** | **GPS vers adresse client** | **L-23** | **External** |
| **L-23** | **Arrivée Chez Client** | **Confirmation géolocalisée** | **L-24** | **Push** |
| **L-24** | **Validation Livraison** | **Code OTP + photo + signature** | **L-25** | **Push** |
| **L-25** | **Course Terminée** | **Récap + gains + notation** | **L-09** | **Push** |
| **L-26** | **Courses en Cours** | **Liste courses actives** | **L-17** | **Push** |
| **L-27** | **Historique Courses** | **Toutes les courses passées** | **L-28** | **Push** |
| **L-28** | **Détail Course Passée** | **Infos complètes** | **L-27** | **Push** |
| **L-29** | **Courses Annulées** | **Historique annulations** | **L-27** | **Push** |

### **5.3 Communication & Support**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **L-30** | **Chat Client** | **Conversation anonymisée** | **L-17** | **Push** |
| **L-31** | **Appel Client** | **Numéro masqué** | **L-17** | **External** |
| **L-32** | **Signaler Problème** | **Incident, accident, retard** | **L-17** | **Modal** |
| **L-33** | **Support Livreur** | **Aide dédiée livreurs** | **L-34 / L-35** | **Push** |
| **L-34** | **FAQ Livreur** | **Questions fréquentes** | **L-33** | **Push** |
| **L-35** | **Contacter Support** | **Chat / Téléphone** | **L-33** | **Push** |

### **5.4 Finances Livreur**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **L-36** | **Portefeuille Livreur** | **Solde disponible** | **L-37/38/39** | **Push** |
| **L-37** | **Historique Gains** | **Détail par course** | **L-36** | **Push** |
| **L-38** | **Demander Retrait** | **Montant + mode paiement** | **L-36** | **Modal** |
| **L-39** | **Confirmation Retrait** | **Récap + OTP** | **L-38** | **Push** |
| **L-40** | **Primes & Bonus** | **Liste des bonus obtenus** | **L-36** | **Push** |
| **L-41** | **Programme Parrainage** | **Inviter un livreur** | **L-36** | **Push** |

### **5.5 Paramètres Livreur**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **L-42** | **Mon Véhicule** | **Infos et photo véhicule** | **L-43** | **Push** |
| **L-43** | **Modifier Véhicule** | **Mise à jour infos** | **L-42** | **Push** |
| **L-44** | **Zones Préférées** | **Quartiers où je préfère livrer** | **L-45** | **Push** |
| **L-45** | **Ajouter Zone Préférée** | **Sélection sur carte** | **L-44** | **Push** |
| **L-46** | **Horaires Disponibilité** | **Quand je suis disponible** | **L-09** | **Push** |
| **L-47** | **Assurance** | **Infos assurance livreur** | **L-09** | **Push** |
| **L-48** | **Formation** | **Vidéos et guides** | **L-09** | **Push** |

---

## **6. MODULE ADMIN (👑)**

### **6.1 Dashboard & Analytics**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-01** | **Dashboard Admin** | **KPIs globaux, alertes, activité** | **AD-02/03/04/05/06/07/08/09/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30** | **Tab** |
| **AD-02** | **Vue Globale Ventes** | **CA temps réel, évolution** | **AD-01** | **Push** |
| **AD-03** | **Carte Thermique Ventes** | **Ventes par zone géographique** | **AD-01** | **Push** |
| **AD-04** | **Utilisateurs Actifs** | **MAU, DAU, retention** | **AD-01** | **Push** |
| **AD-05** | **Commandes en Temps Réel** | **Flux live des commandes** | **AD-01** | **Push** |
| **AD-06** | **Alertes Système** | **Fraude, litiges, anomalies** | **AD-01** | **Push** |
| **AD-07** | **Rapports Automatisés** | **Génération rapports périodiques** | **AD-01** | **Push** |

### **6.2 Gestion Utilisateurs**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-08** | **Liste Utilisateurs** | **Tous les utilisateurs** | **AD-09/10/11/12** | **Push** |
| **AD-09** | **Détail Utilisateur** | **Profil complet, historique** | **AD-08** | **Push** |
| **AD-10** | **Vérification KYC** | **File d'attente KYC à valider** | **AD-11/12** | **Push** |
| **AD-11** | **Valider KYC** | **Vérifier documents + approuver** | **AD-10** | **Push** |
| **AD-12** | **Rejeter KYC** | **Motif + retour utilisateur** | **AD-10** | **Modal** |
| **AD-13** | **Suspendre Utilisateur** | **Bloquer temporairement** | **AD-09** | **Alert** |
| **AD-14** | **Bannir Utilisateur** | **Bannissement définitif** | **AD-09** | **Alert** |
| **AD-15** | **Liste Vendeurs** | **Tous les vendeurs** | **AD-16/17** | **Push** |
| **AD-16** | **Détail Vendeur** | **Boutique, stats, alertes** | **AD-15** | **Push** |
| **AD-17** | **Valider Boutique** | **Approbation nouvelle boutique** | **AD-15** | **Push** |
| **AD-18** | **Liste Livreurs** | **Tous les livreurs** | **AD-19/20** | **Push** |
| **AD-19** | **Détail Livreur** | **Performance, documents, stats** | **AD-18** | **Push** |
| **AD-20** | **Valider Livreur** | **Approbation inscription livreur** | **AD-18** | **Push** |

### **6.3 Gestion Catalogue**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-21** | **Liste Produits** | **Tous les produits** | **AD-22/23/24** | **Push** |
| **AD-22** | **Détail Produit Admin** | **Vue admin fiche produit** | **AD-21** | **Push** |
| **AD-23** | **Modérer Produit** | **Approuver / rejeter / modifier** | **AD-21** | **Push** |
| **AD-24** | **Produits Signalés** | **Signalements contrefaçon, etc.** | **AD-21** | **Push** |
| **AD-25** | **Gestion Catégories** | **CRUD catégories** | **AD-26** | **Push** |
| **AD-26** | **Ajouter Catégorie** | **Nouvelle catégorie** | **AD-25** | **Modal** |
| **AD-27** | **Attributs Produits** | **Gestion champs dynamiques** | **AD-25** | **Push** |
| **AD-28** | **Bannières Home** | **Gestion carrousels promo** | **AD-29** | **Push** |
| **AD-29** | **Ajouter Bannière** | **Upload + ciblage** | **AD-28** | **Modal** |

### **6.4 Gestion Commandes & Transactions**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-30** | **Toutes les Commandes** | **Liste globale** | **AD-31/32/33/34** | **Push** |
| **AD-31** | **Détail Commande Admin** | **Vue complète** | **AD-30** | **Push** |
| **AD-32** | **Litiges** | **Commandes en conflit** | **AD-33/34** | **Push** |
| **AD-33** | **Médiation Litige** | **Arbitrer entre parties** | **AD-32** | **Push** |
| **AD-34** | **Remboursements** | **Gestion remboursements** | **AD-32** | **Push** |
| **AD-35** | **Transactions Financières** | **Toutes les transactions** | **AD-36** | **Push** |
| **AD-36** | **Détail Transaction** | **Infos complètes** | **AD-35** | **Push** |
| **AD-37** | **Reconciliation** | **Matching avec Airtel/Moov** | **AD-35** | **Push** |
| **AD-38** | **Retraits Vendeurs** | **Demandes de retrait en attente** | **AD-39** | **Push** |
| **AD-39** | **Traiter Retrait** | **Valider / rejeter retrait** | **AD-38** | **Push** |
| **AD-40** | **Retraits Livreurs** | **Demandes livreurs** | **AD-41** | **Push** |
| **AD-41** | **Traiter Retrait Livreur** | **Valider / rejeter** | **AD-40** | **Push** |

### **6.5 Gestion Livraisons**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-42** | **Suivi Livraisons** | **Carte temps réel toutes les courses** | **AD-43** | **Push** |
| **AD-43** | **Détail Course Admin** | **Infos livreur, client, statut** | **AD-42** | **Push** |
| **AD-44** | **Attribuer Course** | **Assigner manuellement un livreur** | **AD-42** | **Modal** |
| **AD-45** | **Zones de Couverture** | **Gestion zones livrables** | **AD-46** | **Push** |
| **AD-46** | **Configurer Zone** | **Tarifs, livreurs assignés** | **AD-45** | **Push** |
| **AD-47** | **Tarification Livraison** | **Grille tarifaire** | **AD-45** | **Push** |
| **AD-48** | **Performance Livreurs** | **Classement, stats** | **AD-18** | **Push** |

### **6.6 Marketing & Communication**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-49** | **Campagnes Push** | **Créer notifications push** | **AD-50** | **Push** |
| **AD-50** | **Nouvelle Campagne Push** | **Ciblage + contenu + planning** | **AD-49** | **Modal** |
| **AD-51** | **Campagnes Email/SMS** | **Créer campagnes** | **AD-52** | **Push** |
| **AD-52** | **Nouvelle Campagne Email** | **Template + liste + envoi** | **AD-51** | **Modal** |
| **AD-53** | **Codes Promo** | **Gestion coupons** | **AD-54** | **Push** |
| **AD-54** | **Créer Code Promo** | **Règles, limites, ciblage** | **AD-53** | **Modal** |
| **AD-55** | **Programme Fidélité** | **Configuration points** | **AD-56** | **Push** |
| **AD-56** | **Règles Fidélité** | **Gains de points, récompenses** | **AD-55** | **Push** |
| **AD-57** | **Analytics Marketing** | **ROI campagnes** | **AD-01** | **Push** |

### **6.7 Support & Modération**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-58** | **Tickets Support** | **Tous les tickets clients** | **AD-59/60** | **Push** |
| **AD-59** | **Détail Ticket** | **Conversation + historique** | **AD-58** | **Push** |
| **AD-60** | **Répondre Ticket** | **Réponse agent** | **AD-59** | **Push** |
| **AD-61** | **Chat en Direct** | **Support temps réel** | **AD-58** | **Push** |
| **AD-62** | **Contenu Signalé** | **Avis, messages, produits signalés** | **AD-63** | **Push** |
| **AD-63** | **Modérer Contenu** | **Approuver / supprimer / avertir** | **AD-62** | **Push** |
| **AD-64** | **Base de Connaissances** | **Articles aide** | **AD-65** | **Push** |
| **AD-65** | **Ajouter Article** | **Nouvel article aide** | **AD-64** | **Modal** |
| **AD-66** | **Chatbot Configuration** | **Réponses automatiques** | **AD-64** | **Push** |

### **6.8 Paramètres Système**

| **#** | **Nom de l'Écran** | **Description** | **Connecté À** | **Type Nav** |
| --- | --- | --- | --- | --- |
| **AD-67** | **Paramètres Globaux** | **Configuration plateforme** | **AD-68/69/70/71** | **Push** |
| **AD-68** | **Commission Plateforme** | **Taux par catégorie** | **AD-67** | **Push** |
| **AD-69** | **Frais Livraison** | **Configuration tarifs de base** | **AD-67** | **Push** |
| **AD-70** | **Seuils Alertes** | **Configuration notifications système** | **AD-67** | **Push** |
| **AD-71** | **Maintenance** | **Mode maintenance ON/OFF** | **AD-67** | **Alert** |
| **AD-72** | **Logs Système** | **Logs techniques** | **AD-73** | **Push** |
| **AD-73** | **Détail Log** | **Log complet** | **AD-72** | **Push** |
| **AD-74** | **Gestion Rôles** | **Permissions admin** | **AD-75** | **Push** |
| **AD-75** | **Ajouter Admin** | **Nouvel utilisateur admin** | **AD-74** | **Modal** |

---

## **7. DIAGRAMME DE NAVIGATION GLOBAL**

```javascript
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ONBOARDING & AUTHENTIFICATION                             │
│                                                                              │
│   Splash → Onboarding 1 → Onboarding 2 → Onboarding 3 → Choix Profil      │
│     │                                                                      │
│     └──────────────────────────────────────────────────────────────────┐    │
│                                                                      │    │
│   ┌──────────────────────┐  ┌──────────────────────┐                │    │
│   │   CONNEXION          │  │   INSCRIPTION        │                │    │
│   │   Téléphone + MDP    │  │   Téléphone → OTP    │                │    │
│   │        ↓             │  │        ↓             │                │    │
│   │   MDP Oublié → OTP   │  │   Profil → Localis.  │                │    │
│   └──────────┬───────────┘  └──────────┬───────────┘                │    │
│              │                         │                            │    │
│              └─────────────────────────┘                            │    │
│                        │                                            │    │
│                        ▼                                            │    │
│              ┌─────────────────┐                                    │    │
│              │  HOME (Tab Bar) │                                    │    │
│              └────────┬────────┘                                    │    │
│                       │                                             │    │
└───────────────────────┼─────────────────────────────────────────────┘    │
                        │                                                  │
                        ▼                                                  │
┌─────────────────────────────────────────────────────────────────────────┐│
│                         BOTTOM TAB NAVIGATION                            ││
│                                                                          ││
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐     ││
│   │  HOME   │  │RECHERCHE│  │ VENDRE  │  │ MESSAGES│  │  PROFIL │     ││
│   │  (A-01) │  │ (C-41)  │  │ (V-28)  │  │ (A-43)  │  │ (C-16)  │     ││
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘     ││
│        │            │            │            │            │           ││
└────────┼────────────┼────────────┼────────────┼────────────┼───────────┘│
         │            │            │            │            │            │
         ▼            ▼            ▼            ▼            ▼            │
┌────────────────────────────────────────────────────────────────────────┐│
│                      STACK NAVIGATION (Push/Pop)                        ││
│                                                                         ││
│  HOME STACK:                                                            ││
│  A-01 → A-02(Catégorie) → A-15(Produit) → A-33(Panier) → A-38(Val.)  ││
│   ↓         ↓              ↓              ↓              ↓              ││
│  A-08      A-04           A-16(Galerie)  A-34(Qte)     A-39(Adresse)  ││
│  A-10      A-05           A-23(Avis)     A-35(Supp.)    A-40(Livr.)    ││
│  A-12      A-06           A-26(Q&A)      A-36(Save)     A-41(Paiem.)   ││
│  A-14      A-07           A-29(Partage)  A-37(Promo)    A-46-50(Pay)   ││
│                                                                         ││
│  RECHERCHE STACK:                                                       ││
│  C-41 → C-42(Résultats) → C-43(Filtres) → A-15(Produit)               ││
│                                                                         ││
│  VENDRE STACK (si vendeur):                                             ││
│  V-28 → V-29(Photo) → V-30(Infos) → V-31(Partage)                     ││
│   ↓                                                                  ││
│  V-09(Dashboard) → V-14(Produits) → V-16(Ajout) → V-22(Photos)        ││
│   ↓              → V-39(Commandes) → V-40(Détail) → V-44(Livreur)      ││
│  V-61(Portef.)   → V-73(Boutique) → V-74(Modif)                        ││
│                                                                         ││
│  MESSAGES STACK:                                                        ││
│  A-43(Chat) → A-32(Négocier)                                           ││
│                                                                         ││
│  PROFIL STACK:                                                          ││
│  C-16 → C-17(Edit) → C-18(Adresses) → C-19(Add) → C-21(Paiements)     ││
│   ↓     → C-24(Settings) → C-25(Notifs) → C-31(Aide) → C-33(Support)  ││
│  A-55(Commandes) → A-56(Détail) → A-57(GPS) → A-61(Réception)         ││
│                                                                         ││
└────────────────────────────────────────────────────────────────────────┘│
                                                                          │
┌─────────────────────────────────────────────────────────────────────────┘
│                      MODAL / BOTTOM SHEET SCREENS                        │
│                                                                          │
│  • A-19: Sélection Variante          • A-20: Quantité                   │
│  • A-21: Détail Livraison            • A-29: Partager                   │
│  • A-37: Code Promo                  • A-39: Choisir Adresse            │
│  • A-40: Mode Livraison              • A-41: Mode Paiement              │
│  • A-53: Partager Commande           • A-58: Contacter Livreur          │
│  • V-20: Gérer Stock                 • V-24: Catégories                 │
│  • V-25: Promotions                  • V-31: Partage Réseaux            │
│  • V-43: Imprimer BL                 • V-47: Contacter Client           │
│  • L-16: Nouvelle Course             • L-30: Chat Client                │
│  • L-38: Demander Retrait            • AD-50: Campagne Push             │
│  • AD-54: Code Promo                 • C-22: Ajouter Carte              │
│  • C-23: Ajouter Mobile Money        • C-34: Signaler Problème          │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────┐
│                        APP LIVREUR (Standalone)                             │
│                                                                             │
│   L-01 → L-02 → L-03 → L-04 → L-05 → L-06 → L-07 → L-08 → L-09         │
│                                                                             │
│   L-09 (Tab Bar)                                                           │
│   ├── L-14 (Disponible) → L-15 (Carte) → L-16 (Nouvelle) → L-17 (Détail) │
│   │                                          → L-18 (Accepter) → L-20-25  │
│   ├── L-09 (Dashboard) → L-10-13 (Stats) → L-36 (Portefeuille)           │
│   │                                          → L-37-41 (Finances)         │
│   └── L-42-48 (Paramètres)                                                 │
│                                                                             │
└────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────────────┐
│                        PANEL ADMIN (Web App)                                │
│                                                                             │
│   AD-01 (Dashboard)                                                        │
│   ├── AD-02-07 (Analytics)                                                 │
│   ├── AD-08-20 (Utilisateurs)                                              │
│   ├── AD-21-29 (Catalogue)                                                 │
│   ├── AD-30-41 (Commandes & Transactions)                                  │
│   ├── AD-42-48 (Livraisons)                                                │
│   ├── AD-49-57 (Marketing)                                                 │
│   ├── AD-58-66 (Support)                                                   │
│   └── AD-67-75 (Paramètres Système)                                        │
│                                                                             │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## **8. LOGIQUE DE NAVIGATION DÉTAILLÉE**

### **8.1 Parcours Acheteur — Découverte → Achat**

```javascript
Écran Initial : A-01 (Home)
    │
    ├── Tap sur Catégorie ────────────────────────→ A-02 (Catégorie)
    │       ├── Tap sur Sous-catégorie ───────────→ A-03 (Sous-Catégorie)
    │       │       └── Tap sur Produit ──────────→ A-15 (Fiche Produit)
    │       └── Tap direct sur Produit ───────────→ A-15 (Fiche Produit)
    │
    ├── Tap sur Story ────────────────────────────→ A-08 (Stories)
    │       └── Swipe up "Acheter" ───────────────→ A-15 (Fiche Produit)
    │
    ├── Tap sur Promo ────────────────────────────→ A-09 (Bannière)
    │       └── Tap sur Produit ──────────────────→ A-15 (Fiche Produit)
    │
    └── Tap Recherche (Tab) ──────────────────────→ C-41 (Recherche)
            ├── Saisie texte + Submit ────────────→ C-42 (Résultats)
            │       ├── Tap Filtres ──────────────→ C-43 (Filtres) [Modal]
            │       │       └── Appliquer ────────→ C-42 (Résultats)
            │       └── Tap Produit ──────────────→ A-15 (Fiche Produit)
            └── Tap suggestion historique ────────→ C-42 (Résultats)

Écran : A-15 (Fiche Produit)
    │
    ├── Swipe photos ─────────────────────────────→ A-16 (Galerie) [Full-Screen]
    │       └── Tap photo ────────────────────────→ A-18 (Zoom) [Modal]
    ├── Tap Vidéo ────────────────────────────────→ A-17 (Lecteur) [Full-Screen]
    ├── Tap Variante ─────────────────────────────→ A-19 (Sélection) [Bottom Sheet]
    ├── Tap Quantité ─────────────────────────────→ A-20 (Quantité) [Bottom Sheet]
    ├── Tap "Ajouter au Panier" ──────────────────→ A-33 (Panier) [Push]
    ├── Tap "Acheter Maintenant" ─────────────────→ A-38 (Validation) [Push]
    ├── Tap "Négocier" ───────────────────────────→ A-32 (Négocier) [Push]
    ├── Tap "Partager" ───────────────────────────→ A-29 (Partager) [Bottom Sheet]
    │       ├── WhatsApp ─────────────────────────→ External
    │       ├── Facebook ─────────────────────────→ External
    │       ├── Copier Lien ──────────────────────→ Clipboard
    │       └── Plus d'options ───────────────────→ Native Share Sheet
    ├── Tap "Avis" ───────────────────────────────→ A-23 (Avis) [Push]
    │       ├── Tap "Écrire un avis" ─────────────→ A-25 (Écrire Avis) [Modal]
    │       └── Tap avis ─────────────────────────→ A-24 (Détail Avis) [Push]
    ├── Tap "Q&A" ────────────────────────────────→ A-26 (Q&A) [Push]
    │       └── Tap "Poser question" ─────────────→ A-27 (Question) [Modal]
    ├── Tap Vendeur ──────────────────────────────→ A-44 (Profil Vendeur) [Push]
    │       └── Tap "Suivre" ─────────────────────→ A-45 (Suivre) [Action]
    └── Tap "Signaler" ───────────────────────────→ A-28 (Signaler) [Modal]

Écran : A-33 (Panier)
    │
    ├── Tap "+" / "-" ────────────────────────────→ A-34 (Modifier Qte) [Bottom Sheet]
    ├── Swipe left "Supprimer" ───────────────────→ A-35 (Supprimer) [Alert]
    ├── Tap "Sauvegarder" ────────────────────────→ A-36 (Sauvegarder) → A-42 (Wishlist)
    ├── Tap "Code Promo" ─────────────────────────→ A-37 (Code Promo) [Bottom Sheet]
    ├── Tap "Continuer" ──────────────────────────→ A-38 (Validation) [Push]
    └── Tap Produit ──────────────────────────────→ A-15 (Fiche Produit) [Push]

Écran : A-38 (Validation Commande)
    │
    ├── Tap "Adresse Livraison" ──────────────────→ A-39 (Choisir Adresse) [Bottom Sheet]
    │       ├── Sélection adresse existante ──────→ A-38 (Retour)
    │       └── "Ajouter nouvelle" ───────────────→ C-19 (Ajouter Adresse) [Push]
    │               └── Sauvegarder ──────────────→ A-39 (Retour)
    ├── Tap "Mode Livraison" ─────────────────────→ A-40 (Mode Livraison) [Bottom Sheet]
    ├── Tap "Mode Paiement" ──────────────────────→ A-41 (Mode Paiement) [Bottom Sheet]
    │       ├── Airtel Money ─────────────────────→ A-46 (Paiement Airtel)
    │       ├── Moov Money ───────────────────────→ A-47 (Paiement Moov)
    │       ├── Carte Bancaire ───────────────────→ A-48 (Paiement Carte)
    │       ├── Cash on Delivery ─────────────────→ A-49 (Paiement Cash)
    │       └── Portefeuille ─────────────────────→ A-50 (Paiement Wallet)
    └── Tap "Payer" ──────────────────────────────→ [Traitement] → A-51 (Confirmation)

Écran : A-51 (Confirmation Paiement)
    │
    ├── Animation succès (3s) ────────────────────→ Auto
    ├── Tap "Voir ma commande" ───────────────────→ A-56 (Détail Commande) [Push]
    ├── Tap "Partager" ───────────────────────────→ A-53 (Partager) [Bottom Sheet]
    ├── Tap "Télécharger reçu" ───────────────────→ A-54 (Reçu) [Modal]
    └── Tap "Continuer mes achats" ───────────────→ A-01 (Home) [Pop to Root]
```

### **8.2 Parcours Acheteur — Suivi de Commande**

```javascript
Écran : A-55 (Mes Commandes)
    │
    ├── Tab "En cours" ───────────────────────────→ Filtrer en cours
    ├── Tab "Livrées" ────────────────────────────→ Filtrer livrées
    ├── Tab "Annulées" ───────────────────────────→ Filtrer annulées
    └── Tap Commande ─────────────────────────────→ A-56 (Détail Commande) [Push]
            │
            ├── Tap "Suivre livraison" ───────────→ A-57 (GPS) [Push]
            │       ├── Tap "Appeler" ────────────→ L-31 (Appel) [External]
            │       └── Tap "Chat" ───────────────→ A-58 (Chat Livreur) [Bottom Sheet]
            │
            ├── Statut "En livraison" + OTP ──────→ A-61 (Confirmer Réception) [Push]
            │       ├── Saisie OTP ───────────────→ Validation
            │       ├── Signature digitale ───────→ Validation
            │       └── Photo preuve ─────────────→ Validation
            │               └── Succès ───────────→ A-62 (Noter) [Modal]
            │                       ├── Noter vendeur
            │                       ├── Noter livreur
            │                       ├── Noter produit
            │                       └── Soumettre ─→ A-55 (Retour)
            │
            ├── Tap "Annuler" ────────────────────→ A-59 (Annuler) [Modal]
            │       └── Confirmation ─────────────→ A-55 (Retour)
            │
            ├── Tap "Remboursement" ──────────────→ A-60 (Remboursement) [Modal]
            └── Tap "Contacter vendeur" ──────────→ A-43 (Chat) [Push]
```

### **8.3 Parcours Vendeur — Première Vente**

```javascript
Écran : C-05 (Choix Profil)
    │
    └── Tap "Je veux vendre" ─────────────────────→ V-01 (Devenir Vendeur) [Push]
            │
            ├── Tap "Continuer" ──────────────────→ V-02 (Type Vendeur) [Push]
            │       ├── Social ───────────────────→ V-03 (KYC)
            │       ├── Commerçant ───────────────→ V-03 (KYC)
            │       ├── Artisan ──────────────────→ V-03 (KYC)
            │       └── Entreprise ───────────────→ V-03 (KYC)
            │
            ├── V-03 (KYC) ───────────────────────→ Upload CNI + Selfie [Full-Screen]
            │       └── Submit ───────────────────→ V-04 (Attente)
            │               └── Notification ─────→ V-05 (Validé) [Auto]
            │                       └── Continuer ─→ V-06 (Créer Boutique)
            │
            ├── V-06 (Créer Boutique) ────────────→ Nom, desc, logo, bannière
            │       └── Continuer ────────────────→ V-07 (Config Livraison)
            │
            ├── V-07 (Config Livraison) ──────────→ Zones, tarifs
            │       └── Continuer ────────────────→ V-08 (Config Paiement)
            │
            ├── V-08 (Config Paiement) ───────────→ Lier Airtel/Moov
            │       └── Terminer ─────────────────→ V-09 (Dashboard) [Tab]
            │
            └── V-09 (Dashboard)
                    │
                    ├── Tap "Ajouter Produit" ────→ V-16 (Ajouter Produit) [Push]
                    │       ├── Photos ───────────→ V-22 (Camera) [Full-Screen]
                    │       ├── Vidéo ────────────→ V-23 (Vidéo) [Full-Screen]
                    │       ├── Catégories ───────→ V-24 (Catégories) [Bottom Sheet]
                    │       └── Submit ───────────→ V-14 (Mes Produits) [Push]
                    │
                    ├── Tap "Vente Rapide" ───────→ V-28 (Vendre Maintenant) [Push]
                    │       ├── Photo ────────────→ V-29 (Camera) [Full-Screen]
                    │       ├── Infos ────────────→ V-30 (Prix + Desc) [Push]
                    │       └── Partage ──────────→ V-31 (Partage) [Bottom Sheet]
                    │               ├── WhatsApp ───→ External
                    │               ├── Facebook ───→ External
                    │               └── Copier ─────→ Clipboard
                    │
                    ├── Tap "Commandes" ──────────→ V-39 (Commandes) [Push]
                    │       ├── En attente ───────→ V-48 (À confirmer)
                    │       ├── En cours ─────────→ V-49 (En préparation)
                    │       └── Livrées ──────────→ V-50 (Livrées)
                    │
                    ├── Tap "Portefeuille" ───────→ V-61 (Portefeuille) [Push]
                    │       └── Retrait ──────────→ V-64 (Retrait) [Modal]
                    │
                    └── Tap "Ma Boutique" ────────→ V-73 (Boutique) [Push]

Écran : V-39 (Commandes Reçues)
    │
    ├── Tab "En attente" ─────────────────────────→ V-48
    ├── Tab "En préparation" ─────────────────────→ V-49
    ├── Tab "Expédiées" ──────────────────────────→ V-49
    ├── Tab "Livrées" ────────────────────────────→ V-50
    ├── Tab "Annulées" ───────────────────────────→ V-51
    └── Tab "Litiges" ────────────────────────────→ V-52
    │
    └── Tap Commande ─────────────────────────────→ V-40 (Détail) [Push]
            │
            ├── Statut "En attente" + "Confirmer" ─→ V-41 (Confirmer) [Action]
            │       └── Succès ───────────────────→ V-49 (En préparation)
            │
            ├── Statut "Confirmée" + "Préparer" ──→ V-42 (Préparer) [Action]
            │       └── Succès ───────────────────→ V-49 (En préparation)
            │
            ├── Tap "Imprimer BL" ────────────────→ V-43 (Bon Livraison) [Modal]
            │
            ├── Statut "Prête" + "Demander livreur" → V-44 (Demander Livreur) [Push]
            │       ├── Livreur trouvé ───────────→ Notification
            │       └── Aucun livreur ────────────→ V-44 (Réessayer)
            │
            ├── Statut "Livreur assigné" + "Expédiée" → V-45 (Expédiée) [Action]
            │
            ├── Tap "Annuler" ────────────────────→ V-46 (Annuler) [Modal]
            │
            ├── Tap "Contacter client" ───────────→ V-47 (Chat) [Bottom Sheet]
            │
            └── Statut "Litige" ──────────────────→ V-53 (Gérer Litige) [Push]
```

### **8.4 Parcours Livreur — Première Course**

```javascript
Écran : L-01 (Devenir Livreur)
    │
    ├── Tap "Continuer" ──────────────────────────→ L-02 (Infos Perso) [Push]
    │       └── Continuer ────────────────────────→ L-03 (Véhicule) [Push]
    │               └── Continuer ────────────────→ L-04 (Documents) [Push]
    │                       ├── Upload CNI ───────→ Gallery / Camera
    │                       ├── Upload Permis ────→ Gallery / Camera
    │                       └── Upload Véhicule ──→ Gallery / Camera
    │                               └── Continuer ─→ L-05 (Selfie) [Full-Screen]
    │                                       └── ──→ L-06 (Quiz) [Push]
    │                                               └── Submit ───→ L-07 (Attente)
    │                                                       └── ──→ L-08 (Validé)
    │                                                               └── ─→ L-09 (Dashboard)
    │
    └── L-09 (Dashboard Livreur — Tab Bar)
            │
            ├── Tab "Disponible" ─────────────────→ L-14 (Mode ON/OFF)
            │       │
            │       ├── Toggle ON ────────────────→ L-15 (Carte Courses)
            │       │       └── Notification ─────→ L-16 (Nouvelle Course) [Modal]
            │       │               ├── Accepter ───→ L-18 → L-20 (Navigation)
            │       │               │       └── ────→ L-21 (Scan QR) [Full-Screen]
            │       │               │               └── Succès ─→ L-22 (Nav Livraison)
            │       │               │                       └── ─→ L-23 (Arrivée)
            │       │               │                               └── ─→ L-24 (Validation)
            │       │               │                                       ├── OTP ────→ L-25 (Terminée)
            │       │               │                                       ├── Photo ──→ L-25 (Terminée)
            │       │               │                                       └── Sign. ──→ L-25 (Terminée)
            │       │               │                                               └── ─→ L-09 (Dashboard)
            │       │               │
            │       │               └── Refuser ──→ L-19 (Refuser) [Alert]
            │       │                       └── ──→ L-14 (Retour carte)
            │       │
            │       └── Tap course sur carte ─────→ L-17 (Détail Course) [Push]
            │               ├── Accepter ─────────→ L-18
            │               └── Refuser ──────────→ L-19
            │
            ├── Tab "Dashboard" ──────────────────→ L-09 (Stats)
            │       ├── Gains Jour ───────────────→ L-10 [Push]
            │       ├── Gains Semaine ────────────→ L-11 [Push]
            │       ├── Gains Mois ───────────────→ L-12 [Push]
            │       ├── Performance ──────────────→ L-13 [Push]
            │       └── Portefeuille ─────────────→ L-36 [Push]
            │               └── Retrait ──────────→ L-38 [Modal]
            │
            └── Tab "Paramètres" ─────────────────→ L-42 (Véhicule) [Push]
                    ├── Modifier Véhicule ────────→ L-43 [Push]
                    ├── Zones Préférées ──────────→ L-44 [Push]
                    │       └── Ajouter ──────────→ L-45 [Push]
                    ├── Horaires ─────────────────→ L-46 [Push]
                    ├── Assurance ────────────────→ L-47 [Push]
                    └── Formation ────────────────→ L-48 [Push]
```

### **8.5 Parcours Admin — Médiation Litige**

```javascript
Écran : AD-01 (Dashboard Admin)
    │
    ├── Sidebar Menu ─────────────────────────────→ Navigation principale
    │       ├── Dashboard ────────────────────────→ AD-01
    │       ├── Utilisateurs ─────────────────────→ AD-08
    │       ├── Catalogue ────────────────────────→ AD-21
    │       ├── Commandes ────────────────────────→ AD-30
    │       ├── Livraisons ───────────────────────→ AD-42
    │       ├── Finances ─────────────────────────→ AD-35
    │       ├── Marketing ────────────────────────→ AD-49
    │       ├── Support ──────────────────────────→ AD-58
    │       └── Paramètres ───────────────────────→ AD-67
    │
    ├── Widget "Alertes" ─────────────────────────→ AD-06 (Alertes) [Push]
    ├── Widget "Commandes Temps Réel" ────────────→ AD-05 (Flux Live) [Push]
    ├── Widget "KYC en Attente" ──────────────────→ AD-10 (Vérification KYC) [Push]
    │       └── Tap utilisateur ──────────────────→ AD-11 (Valider KYC) [Push]
    │               ├── Approuver ────────────────→ AD-10 (Retour)
    │               └── Rejeter ──────────────────→ AD-12 (Rejeter) [Modal]
    │                       └── ────────────────→ AD-10 (Retour)
    │
    └── Widget "Litiges" ─────────────────────────→ AD-32 (Litiges) [Push]
            └── Tap litige ───────────────────────→ AD-33 (Médiation) [Push]
                    ├── Arbitrer pour client ─────→ AD-34 (Remboursement)
                    ├── Arbitrer pour vendeur ────→ AD-34 (Rejet)
                    └── Négocier ─────────────────→ AD-33 (Chat médiation)
```

---

## **9. MATRICE DE CONNEXION DES ÉCRANS**

### **9.1 Matrice Acheteur (Écrans les plus connectés)**

| **Écran** | **Connexions Entrantes** | **Connexions Sortantes** | **Total** |
| --- | --- | --- | --- |
| **A-15 Fiche Produit** | **A-01, A-02, A-03, A-04, A-05, A-06, A-07, A-08, A-09, A-10, A-11, A-12, A-13, A-14, C-42, A-31, A-33** | **A-16, A-17, A-18, A-19, A-20, A-21, A-22, A-23, A-26, A-28, A-29, A-30, A-32, A-33, A-38, A-42, A-43, A-44, A-45** | **22** |
| **A-33 Panier** | **A-15, A-38** | **A-15, A-34, A-35, A-36, A-37, A-38** | **7** |
| **A-38 Validation** | **A-33** | **A-39, A-40, A-41, A-46, A-47, A-48, A-49, A-50** | **9** |
| **A-56 Détail Commande** | **A-55, A-51** | **A-57, A-58, A-59, A-60, A-61, A-43** | **7** |
| **A-01 Home** | **C-12, A-51** | **A-02, A-04, A-05, A-06, A-07, A-08, A-10, A-12, A-13, A-14** | **11** |
| **A-43 Chat** | **A-15, A-32, A-56, A-40** | **A-15, A-32** | **6** |

### **9.2 Matrice Vendeur (Écrans les plus connectés)**

| **Écran** | **Connexions Entrantes** | **Connexions Sortantes** | **Total** |
| --- | --- | --- | --- |
| **V-09 Dashboard** | **V-05, V-08** | **V-10, V-11, V-12, V-13, V-14, V-28, V-39, V-61, V-73** | **10** |
| **V-14 Mes Produits** | **V-09, V-16, V-17, V-18, V-19, V-21, V-26, V-27** | **V-15, V-16, V-17, V-18, V-19, V-20, V-21, V-26, V-27** | **10** |
| **V-15 Fiche Produit Vendeur** | **V-14, V-16, V-17** | **V-16, V-17, V-18, V-19, V-20, V-21, V-25, A-15** | **9** |
| **V-39 Commandes** | **V-09, V-40, V-41, V-42, V-45, V-46** | **V-40, V-41, V-42, V-43, V-44, V-45, V-46, V-47, V-48, V-49, V-50, V-51, V-52** | **13** |
| **V-40 Détail Commande** | **V-39** | **V-41, V-42, V-43, V-44, V-45, V-46, V-47, V-53** | **9** |
| **V-28 Vendre Maintenant** | **V-09, Tab** | **V-29, V-30, V-31, V-32, V-37** | **6** |

### **9.3 Matrice Livreur (Écrans les plus connectés)**

| **Écran** | **Connexions Entrantes** | **Connexions Sortantes** | **Total** |
| --- | --- | --- | --- |
| **L-09 Dashboard** | **L-08, L-25** | **L-10, L-11, L-12, L-13, L-14, L-36, L-42** | **8** |
| **L-14 Mode Disponible** | **L-09, L-19** | **L-15, L-16** | **4** |
| **L-17 Détail Course** | **L-14, L-15, L-16** | **L-18, L-19, L-30, L-31, L-32** | **6** |
| **L-24 Validation** | **L-23** | **L-25** | **2** |
| **L-36 Portefeuille** | **L-09** | **L-37, L-38, L-39, L-40, L-41** | **6** |

### **9.4 Matrice Admin (Écrans les plus connectés)**

| **Écran** | **Connexions Entrantes** | **Connexions Sortantes** | **Total** |
| --- | --- | --- | --- |
| **AD-01 Dashboard** | **Login** | **AD-02, AD-03, AD-04, AD-05, AD-06, AD-07, AD-08, AD-21, AD-30, AD-42, AD-49, AD-58** | **13** |
| **AD-08 Utilisateurs** | **AD-01** | **AD-09, AD-10, AD-15, AD-18** | **5** |
| **AD-10 KYC en Attente** | **AD-08, AD-01** | **AD-11, AD-12** | **3** |
| **AD-30 Commandes** | **AD-01** | **AD-31, AD-32, AD-33, AD-34** | **5** |
| **AD-35 Transactions** | **AD-01** | **AD-36, AD-37, AD-38, AD-40** | **5** |

---

## **10. RÈGLES DE NAVIGATION SPÉCIFIQUES**

### **10.1 Règles Générales**

| **Règle** | **Description** | **Implémentation** |
| --- | --- | --- |
| **R-01** | **Retour arrière depuis Home ferme l'app** | **`SystemNavigator.pop()`** |
| **R-02** | **Double-tap back dans stack → confirmation sortie** | **Snackbar "Appuyez encore pour quitter"** |
| **R-03** | **Navigation profonde préserve l'état** | **Stack navigation avec `keepAlive`** |
| **R-04** | **Modal ne peut pas être swipé si formulaire modifié** | **Alert "Voulez-vous vraiment quitter ?"** |
| **R-05** | **Paiement en cours = blocage retour arrière** | **`WillPopScope` bloquant** |
| **R-06** | **Commande confirmée = reset stack vers Home** | **`Navigator.pushAndRemoveUntil`** |
| **R-07** | **Notification tap = navigation directe** | **Deep linking avec route paramétrée** |
| **R-08** | **Mode hors ligne = navigation limitée** | **Griser écrans nécessitant connexion** |
| **R-09** | **Session expirée = redirect login** | **Intercepteur 401 → C-06** |
| **R-10** | **KYC incomplet = blocage fonctionnalités** | **Redirect V-03 ou L-04** |

### **10.2 Deep Links & Routes Universelles**

| **Route** | **Écran Cible** | **Paramètres** |
| --- | --- | --- |
| **`/product/:id`** | **A-15 (Fiche Produit)** | **`productId`** |
| **`/shop/:id`** | **A-11 (Boutique Vendeur)** | **`shopId`** |
| **`/order/:id`** | **A-56 (Détail Commande)** | **`orderId`** |
| **`/cart`** | **A-33 (Panier)** | **—** |
| **`/search?q=...`** | **C-42 (Résultats Recherche)** | **`query`** |
| **`/promo/:code`** | **A-37 (Code Promo auto-appliqué)** | **`promoCode`** |
| **`/track/:id`** | **A-57 (Suivi GPS)** | **`deliveryId`** |
| **`/sell`** | **V-28 (Vendre Maintenant)** | **—** |
| **`/delivery`** | **L-14 (Mode Disponible)** | **—** |

### **10.3 Transitions d'État (State-Driven Navigation)**

```javascript
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MACHINE À ÉTATS — COMMANDE ACHETEUR                       │
│                                                                              │
│   [Panier] ──valider──→ [Validation] ──payer──→ [Paiement]                 │
│      │                      │                      │                         │
│      │                      │                      ├── Succès ──→ [Confirmée]│
│      │                      │                      └── Échec ───→ [Retry]    │
│      │                      │                                                │
│      └── ajouter article ───┘                                              │
│                                                                              │
│   [Confirmée] ──préparation──→ [En Préparation] ──expédiée──→ [En Route]   │
│                                                                              │
│   [En Route] ──arrivée──→ [Livraison] ──otp valid──→ [Livrée]              │
│                                                                              │
│   [Livrée] ──notation──→ [Terminée]                                        │
│                                                                              │
│   [Confirmée] ──annuler──→ [Annulée]                                       │
│   [En Route] ──litige────→ [Litige] ──médiation──→ [Résolu]                │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    MACHINE À ÉTATS — COURSE LIVREUR                        │
│                                                                              │
│   [Disponible] ──notification──→ [Nouvelle Course] ──accepter──→ [Acceptée]│
│      │                              └── refuser ───→ [Disponible]           │
│      │                                                                       │
│      └── toggle OFF ───→ [Hors Ligne]                                        │
│                                                                              │
│   [Acceptée] ──arrivée vendeur──→ [Prise en Charge] ──scan QR──→ [Chargée] │
│                                                                              │
│   [Chargée] ──arrivée client──→ [Livraison] ──validation──→ [Terminée]     │
│                                                                              │
│   [Acceptée] ──annuler──→ [Annulée] ──pénalité──→ [Disponible]             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## **11. RÉCAPITULATIF PAR MODULE**

| **Module** | **Nombre d'Écrans** | **Écrans Clés** | **Complexité** |
| --- | --- | --- | --- |
| **Communs** | **40** | **Auth, Profil, Paramètres, Recherche, Support** | **⭐⭐⭐** |
| **Acheteur** | **69** | **Home, Produit, Panier, Paiement, Suivi, Chat** | **⭐⭐⭐⭐⭐** |
| **Vendeur** | **80** | **Dashboard, Catalogue, Vente Rapide, Commandes, Finances** | **⭐⭐⭐⭐⭐** |
| **Livreur** | **48** | **Dashboard, Courses, Navigation, Finances** | **⭐⭐⭐⭐** |
| **Admin** | **75** | **Dashboard, Modération, Analytics, Support** | **⭐⭐⭐⭐⭐** |
| **TOTAL** | **~312 écrans** |  |  |

> **Note : Le total inclut les modals, bottom sheets et full-screen modals comme des écrans distincts car ils ont chacun leur propre logique, état et cycle de vie.**

---

## **12. ÉCRANS PRIORITAIRES — MVP (Phase 1)**

**Pour le MVP (4 mois), seuls ces écrans sont développés :**

### **Phase 1 — Écrans Essentiels (60 écrans)**

| **Priorité** | **Écran** | **Justification** |
| --- | --- | --- |
| **P0** | **C-01 à C-12** | **Onboarding + Auth (obligatoire)** |
| **P0** | **C-16, C-18, C-19, C-24** | **Profil basique** |
| **P0** | **C-41, C-42** | **Recherche** |
| **P0** | **A-01, A-02, A-15** | **Home + Catégorie + Produit** |
| **P0** | **A-33, A-38, A-46, A-47, A-51, A-52** | **Panier + Paiement + Confirmation** |
| **P0** | **A-55, A-56** | **Commandes** |
| **P0** | **A-43** | **Chat basique** |
| **P0** | **V-01 à V-09** | **Onboarding vendeur** |
| **P0** | **V-14, V-15, V-16, V-22** | **Catalogue vendeur** |
| **P0** | **V-28, V-29, V-30, V-31** | **Vente rapide** |
| **P0** | **V-39, V-40, V-41, V-42, V-46** | **Gestion commandes** |
| **P0** | **V-61, V-64** | **Finances basiques** |
| **P0** | **L-01 à L-09** | **Onboarding livreur** |
| **P0** | **L-14, L-15, L-16, L-17, L-18, L-24, L-25** | **Gestion courses** |
| **P0** | **L-36, L-38** | **Finances livreur** |
| **P0** | **AD-01, AD-08, AD-09, AD-10, AD-11** | **Admin basique** |
| **P0** | **AD-21, AD-22, AD-23** | **Modération catalogue** |
| **P0** | **AD-30, AD-31, AD-32** | **Gestion commandes** |

---

***Document rédigé en Août 2026 — Version 1.0***
***Architecture Navigation E-Commerce Gabon***  tu utliseras flutter animate lottie flutter rive flutter et hugeicons sans oublié apple design 
