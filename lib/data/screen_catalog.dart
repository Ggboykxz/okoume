/// Catalogue officiel des 317 écrans du CDC Okoumé (voir docs/CDC_okoume.md).
///
/// Chaque entrée porte son identifiant officiel, son titre exact, une courte
/// description, et — quand l'écran est réellement implémenté — la route qui
/// l'ouvre. Les entrées sans route sont rendues par l'aperçu de démo
/// (`/screen/:id`) : contenu fidèle, interactions simulées.
class ScreenEntry {
  const ScreenEntry(this.id, this.title, this.desc, {this.route});

  /// Identifiant officiel (ex. « C-13 », « AD-42 »).
  final String id;

  /// Titre exact du CDC.
  final String title;

  /// Description courte du CDC.
  final String desc;

  /// Route réelle de l'écran, `null` si rendu par l'aperçu `/screen/:id`.
  final String? route;

  String get module => id.split('-').first;
  int get number => int.parse(id.split('-').last);
  bool get isPreview => route == null;
}

/// Libellés des modules (préfixes du CDC).
const screenModuleLabels = <String, String>{
  'C': 'Commun',
  'A': 'Acheteur',
  'V': 'Vendeur',
  'L': 'Livreur',
  'AD': 'Admin',
};

const screenModuleEmojis = <String, String>{
  'C': '⚙️',
  'A': '🛒',
  'V': '🏪',
  'L': '🛵',
  'AD': '👑',
};

/// Groupe d'appartenance (sections du CDC §2 à §6).
String screenGroupOf(ScreenEntry e) {
  final n = e.number;
  return switch (e.module) {
    'C' => n <= 15
        ? 'Onboarding & Authentification'
        : n <= 36
            ? 'Profil Utilisateur'
            : n <= 40
                ? 'Notifications & Messages'
                : 'Recherche Globale',
    'A' => n <= 14
        ? 'Home & Découverte'
        : n <= 32
            ? 'Produit & Décision d\u2019Achat'
            : n <= 45
                ? 'Panier, Commande & Chat'
                : n <= 54
                    ? 'Paiement'
                    : n <= 65
                        ? 'Suivi de Commande'
                        : 'Points de Retrait & Lockers',
    'V' => n <= 13
        ? 'Onboarding & Dashboard'
        : n <= 27
            ? 'Gestion Catalogue'
            : n <= 38
                ? 'Vente Rapide & Social Commerce'
                : n <= 54
                    ? 'Gestion Commandes'
                    : n <= 60
                        ? 'Livraison Vendeur'
                        : n <= 72
                            ? 'Finances Vendeur'
                            : 'Boutique & Profil Public',
    'L' => n <= 13
        ? 'Onboarding & Dashboard'
        : n <= 29
            ? 'Gestion des Courses'
            : n <= 35
                ? 'Communication & Support'
                : n <= 41
                    ? 'Finances Livreur'
                    : 'Paramètres Livreur',
    _ => n <= 7
        ? 'Dashboard & Analytics'
        : n <= 20
            ? 'Gestion Utilisateurs'
            : n <= 29
                ? 'Gestion Catalogue'
                : n <= 41
                    ? 'Commandes & Transactions'
                    : n <= 48
                        ? 'Gestion Livraisons'
                        : n <= 57
                            ? 'Marketing & Communication'
                            : n <= 66
                                ? 'Support & Modération'
                                : 'Paramètres Système',
  };
}

const screenCatalog = <ScreenEntry>[
  // ═══════════════════════════ C — COMMUN (45) ═══════════════════════════
  ScreenEntry('C-01', 'Splash Screen', 'Logo animé, chargement initial', route: '/splash'),
  ScreenEntry('C-02', 'Onboarding 1', 'Slide 1 — Découvrez', route: '/onboarding'),
  ScreenEntry('C-03', 'Onboarding 2', 'Slide 2 — Vendez', route: '/onboarding'),
  ScreenEntry('C-04', 'Onboarding 3', 'Slide 3 — Livrez', route: '/onboarding'),
  ScreenEntry('C-05', 'Choix Profil', 'Acheter / vendre / livrer', route: '/auth'),
  ScreenEntry('C-06', 'Connexion', 'Téléphone + mot de passe', route: '/auth'),
  ScreenEntry('C-07', 'Inscription Téléphone', 'Saisie numéro + OTP', route: '/auth'),
  ScreenEntry('C-08', 'Vérification OTP', 'Code SMS 6 chiffres', route: '/auth/otp'),
  ScreenEntry('C-09', 'Création Profil', 'Nom, prénom, email, photo', route: '/auth/profile-setup'),
  ScreenEntry('C-10', 'Choix Localisation', 'Ville, quartier, GPS', route: '/auth/location'),
  ScreenEntry('C-11', 'Notifications Permission', 'Demande push notifs', route: '/auth/permissions'),
  ScreenEntry('C-12', 'Home (Première Connexion)', 'Home personnalisée nouvel utilisateur'),
  ScreenEntry('C-13', 'Mot de Passe Oublié', 'Réinitialisation par SMS', route: '/auth/reset'),
  ScreenEntry('C-14', 'Biométrie Setup', 'Empreinte / Face ID'),
  ScreenEntry('C-15', 'Sélection Langue', 'Français / Anglais'),
  ScreenEntry('C-16', 'Mon Profil', 'Photo, nom, note, stats', route: '/main'),
  ScreenEntry('C-17', 'Modifier Profil', 'Édition infos personnelles', route: '/profile/edit'),
  ScreenEntry('C-18', 'Mes Adresses', 'Liste des adresses enregistrées', route: '/addresses'),
  ScreenEntry('C-19', 'Ajouter Adresse', 'Formulaire nouvelle adresse + carte', route: '/addresses'),
  ScreenEntry('C-20', 'Modifier Adresse', 'Édition adresse existante'),
  ScreenEntry('C-21', 'Mes Moyens de Paiement', 'Cartes, mobile money enregistrés', route: '/payment-methods'),
  ScreenEntry('C-22', 'Ajouter Carte Bancaire', 'Saisie carte + vérification'),
  ScreenEntry('C-23', 'Ajouter Mobile Money', 'Lier Airtel/Moov'),
  ScreenEntry('C-24', 'Paramètres', 'Notifications, langue, sécurité, données', route: '/settings'),
  ScreenEntry('C-25', 'Notifications Settings', 'Granularité push/email/SMS', route: '/settings/notifications'),
  ScreenEntry('C-26', 'Sécurité', '2FA, mot de passe, sessions actives'),
  ScreenEntry('C-27', 'Mode Hors Ligne', 'Gestion cache, données', route: '/settings/data'),
  ScreenEntry('C-28', 'À Propos', 'Version, mentions légales, CGU', route: '/about'),
  ScreenEntry('C-29', 'CGU', 'Conditions générales d\u2019utilisation', route: '/legal/terms'),
  ScreenEntry('C-30', 'Politique Confidentialité', 'RGPD / Protection données', route: '/legal/privacy'),
  ScreenEntry('C-31', 'Centre d\u2019Aide', 'FAQ, tutoriels, contact support', route: '/help'),
  ScreenEntry('C-32', 'FAQ', 'Questions fréquentes par catégorie', route: '/help'),
  ScreenEntry('C-33', 'Contact Support', 'Chat / Email / Téléphone', route: '/help'),
  ScreenEntry('C-34', 'Signaler un Problème', 'Formulaire de bug/abus'),
  ScreenEntry('C-35', 'Déconnexion', 'Confirmation + retour onboarding', route: '/settings'),
  ScreenEntry('C-36', 'Supprimer Compte', 'Confirmation avec raison', route: '/settings'),
  ScreenEntry('C-37', 'Notifications Centre', 'Liste de toutes les notifications', route: '/notifications'),
  ScreenEntry('C-38', 'Détail Notification', 'Contenu complet d\u2019une notif'),
  ScreenEntry('C-39', 'Paramètres Notifications', 'Par type de notification', route: '/settings/notifications'),
  ScreenEntry('C-40', 'Marquer Tout Lu', 'Action rapide', route: '/notifications'),
  ScreenEntry('C-41', 'Recherche', 'Barre + suggestions + historique', route: '/search'),
  ScreenEntry('C-42', 'Résultats Recherche', 'Grille/liste produits + filtres', route: '/search'),
  ScreenEntry('C-43', 'Filtres Avancés', 'Prix, catégorie, localisation, note', route: '/search'),
  ScreenEntry('C-44', 'Détail Produit', 'Fiche complète', route: '/product/p1'),
  ScreenEntry('C-45', 'Recherche Vocale', 'Micro + transcription', route: '/voice'),

  // ═══════════════════════════ A — ACHETEUR (69) ══════════════════════════
  ScreenEntry('A-01', 'Home Acheteur', 'Carrousel, catégories, tendances, promos', route: '/main'),
  ScreenEntry('A-02', 'Catégorie Détail', 'Liste produits d\u2019une catégorie', route: '/category/c1'),
  ScreenEntry('A-03', 'Sous-Catégorie', 'Sous-liste filtrée'),
  ScreenEntry('A-04', 'Tendances Près de Chez Vous', 'Produits populaires géolocalisés'),
  ScreenEntry('A-05', 'Nouveautés', 'Derniers produits ajoutés'),
  ScreenEntry('A-06', 'Promos du Jour', 'Produits en promotion'),
  ScreenEntry('A-07', 'Produits Recommandés', 'Algorithme IA personnalisé'),
  ScreenEntry('A-08', 'Stories Découverte', 'Stories verticales produits (format TikTok)', route: '/stories'),
  ScreenEntry('A-09', 'Bannière Promo', 'Page détail d\u2019une promotion'),
  ScreenEntry('A-10', 'Vendeurs Populaires', 'Liste boutiques tendance'),
  ScreenEntry('A-11', 'Boutique Vendeur', 'Page publique d\u2019une boutique', route: '/seller/s2'),
  ScreenEntry('A-12', 'Flash Sales', 'Ventes flash avec compte à rebours', route: '/flash'),
  ScreenEntry('A-13', 'Événements Spéciaux', 'Black Friday, Noël, Fête du Travail'),
  ScreenEntry('A-14', 'Produits Locaux', '« Made in Gabon » — artisanat local', route: '/local'),
  ScreenEntry('A-15', 'Fiche Produit', 'Photos, prix, description, avis, vendeur', route: '/product/p1'),
  ScreenEntry('A-16', 'Galerie Photos', 'Visionneuse plein écran HD', route: '/product/p1/gallery'),
  ScreenEntry('A-17', 'Lecteur Vidéo', 'Vidéo produit plein écran'),
  ScreenEntry('A-18', 'Zoom Photo', 'Pinch-to-zoom sur image', route: '/product/p1/gallery'),
  ScreenEntry('A-19', 'Sélection Variante', 'Taille, couleur (bottom sheet)', route: '/product/p1'),
  ScreenEntry('A-20', 'Quantité', 'Sélecteur +/-', route: '/cart'),
  ScreenEntry('A-21', 'Détail Livraison', 'Estimation, modes, frais', route: '/checkout'),
  ScreenEntry('A-22', 'Politique Retour', 'Conditions de retour du vendeur'),
  ScreenEntry('A-23', 'Avis Clients', 'Liste des avis avec photos', route: '/product/p1/reviews'),
  ScreenEntry('A-24', 'Détail Avis', 'Avis complet avec photos'),
  ScreenEntry('A-25', 'Écrire un Avis', 'Formulaire note + commentaire + photos', route: '/product/p1/reviews'),
  ScreenEntry('A-26', 'Questions & Réponses', 'Q&A publiques sur le produit', route: '/product/p1'),
  ScreenEntry('A-27', 'Poser une Question', 'Formulaire nouvelle question', route: '/product/p1'),
  ScreenEntry('A-28', 'Signaler Produit', 'Contrefaçon, contenu inapproprié'),
  ScreenEntry('A-29', 'Partager Produit', 'Partage WhatsApp, Facebook…'),
  ScreenEntry('A-30', 'Comparer Produits', 'Comparaison côte à côte (jusqu\u2019à 3)', route: '/compare'),
  ScreenEntry('A-31', 'Produits Similaires', 'Recommandations basées sur le produit'),
  ScreenEntry('A-32', 'Négocier Prix', 'Chat direct avec le vendeur', route: '/product/p1'),
  ScreenEntry('A-33', 'Mon Panier', 'Liste articles, totaux, vendeurs', route: '/cart'),
  ScreenEntry('A-34', 'Modifier Quantité Panier', '+/- dans le panier', route: '/cart'),
  ScreenEntry('A-35', 'Supprimer Article', 'Confirmation suppression', route: '/cart'),
  ScreenEntry('A-36', 'Sauvegarder pour Plus Tard', 'Déplacer vers wishlist'),
  ScreenEntry('A-37', 'Appliquer Code Promo', 'Saisie code + validation', route: '/cart'),
  ScreenEntry('A-38', 'Validation Commande', 'Récapitulatif avant paiement', route: '/checkout'),
  ScreenEntry('A-39', 'Choisir Adresse Livraison', 'Sélection ou ajout adresse', route: '/checkout'),
  ScreenEntry('A-40', 'Choisir Mode Livraison', 'Express, standard, retrait', route: '/checkout'),
  ScreenEntry('A-41', 'Choisir Mode Paiement', 'Airtel, Moov, carte, cash, wallet', route: '/checkout'),
  ScreenEntry('A-42', 'Wishlist', 'Produits sauvegardés', route: '/wishlist'),
  ScreenEntry('A-43', 'Chat avec Vendeur', 'Conversation privée', route: '/chat'),
  ScreenEntry('A-44', 'Profil Vendeur Public', 'Infos boutique, avis, produits', route: '/seller/s2'),
  ScreenEntry('A-45', 'Suivre Vendeur', 'S\u2019abonner aux nouveautés', route: '/seller/s2'),
  ScreenEntry('A-46', 'Paiement Airtel Money', 'Redirection USSD / in-app', route: '/payment'),
  ScreenEntry('A-47', 'Paiement Moov Money', 'Redirection USSD / in-app', route: '/payment'),
  ScreenEntry('A-48', 'Paiement Carte Bancaire', 'Formulaire sécurisé', route: '/payment'),
  ScreenEntry('A-49', 'Paiement Cash on Delivery', 'Confirmation mode cash', route: '/payment'),
  ScreenEntry('A-50', 'Paiement Portefeuille', 'Utilisation crédit interne', route: '/payment'),
  ScreenEntry('A-51', 'Confirmation Paiement', 'Animation succès + détails', route: '/success/o1'),
  ScreenEntry('A-52', 'Échec Paiement', 'Erreur + options retry', route: '/payment/failed'),
  ScreenEntry('A-53', 'Partager Commande', 'Story réseaux sociaux'),
  ScreenEntry('A-54', 'Reçu Électronique', 'PDF de la transaction', route: '/success/o1'),
  ScreenEntry('A-55', 'Mes Commandes', 'Liste toutes les commandes', route: '/orders'),
  ScreenEntry('A-56', 'Détail Commande', 'Infos complètes + timeline', route: '/order/o1'),
  ScreenEntry('A-57', 'Suivi GPS Livraison', 'Carte temps réel + position livreur', route: '/order/o1'),
  ScreenEntry('A-58', 'Contacter Livreur', 'Chat / appel masqué', route: '/order/o1'),
  ScreenEntry('A-59', 'Annuler Commande', 'Formulaire motif + confirmation', route: '/order/o1'),
  ScreenEntry('A-60', 'Demander Remboursement', 'Formulaire litige'),
  ScreenEntry('A-61', 'Confirmer Réception', 'Code OTP + signature + photo', route: '/order/o1'),
  ScreenEntry('A-62', 'Noter Commande', 'Évaluation vendeur + livreur + produit', route: '/order/o1'),
  ScreenEntry('A-63', 'Commande à Réceptionner', 'Alertes commandes en attente'),
  ScreenEntry('A-64', 'Historique Achats', 'Toutes les commandes passées', route: '/orders'),
  ScreenEntry('A-65', 'Achats Récents', 'Commandes des 30 derniers jours', route: '/orders'),
  ScreenEntry('A-66', 'Carte Points Retrait', 'Carte interactive des points relais', route: '/lockers'),
  ScreenEntry('A-67', 'Détail Point Retrait', 'Horaires, infos, itinéraire', route: '/lockers'),
  ScreenEntry('A-68', 'Itinéraire Point Retrait', 'Navigation GPS vers le point'),
  ScreenEntry('A-69', 'Scan QR Retrait', 'Scanner pour récupérer colis', route: '/scan-pickup'),

  // ═══════════════════════════ V — VENDEUR (80) ═══════════════════════════
  ScreenEntry('V-01', 'Devenir Vendeur', 'Présentation + formulaire', route: '/seller/join'),
  ScreenEntry('V-02', 'Type de Vendeur', 'Social / Commerçant / Artisan / Entreprise', route: '/seller/join'),
  ScreenEntry('V-03', 'KYC Vendeur', 'Upload CNI, selfie, NIF', route: '/seller/join'),
  ScreenEntry('V-04', 'Vérification en Cours', 'Écran d\u2019attente + statut'),
  ScreenEntry('V-05', 'KYC Validé', 'Confirmation + création boutique', route: '/seller/join'),
  ScreenEntry('V-06', 'Créer Boutique', 'Nom, description, logo, bannière', route: '/seller/join'),
  ScreenEntry('V-07', 'Configurer Livraison', 'Zones, tarifs, modes'),
  ScreenEntry('V-08', 'Configurer Paiement', 'Lier Airtel/Moov marchand', route: '/seller/join'),
  ScreenEntry('V-09', 'Dashboard Vendeur', 'CA, commandes, stats, alertes', route: '/main'),
  ScreenEntry('V-10', 'Analytics Vente', 'Graphiques CA, évolution'),
  ScreenEntry('V-11', 'Produits Populaires', 'Top produits vendus'),
  ScreenEntry('V-12', 'Clients Fidèles', 'Top acheteurs'),
  ScreenEntry('V-13', 'Performance Boutique', 'Note, taux conversion, retours'),
  ScreenEntry('V-14', 'Mes Produits', 'Liste tous les produits', route: '/main'),
  ScreenEntry('V-15', 'Fiche Produit Vendeur', 'Vue vendeur du produit', route: '/main'),
  ScreenEntry('V-16', 'Ajouter Produit', 'Formulaire complet', route: '/seller/products/new'),
  ScreenEntry('V-17', 'Modifier Produit', 'Édition fiche produit', route: '/seller/products/p1/edit'),
  ScreenEntry('V-18', 'Dupliquer Produit', 'Copie rapide'),
  ScreenEntry('V-19', 'Supprimer Produit', 'Confirmation + motif', route: '/main'),
  ScreenEntry('V-20', 'Gérer Stock', 'Quantité, alertes seuil'),
  ScreenEntry('V-21', 'Importer Produits', 'Upload CSV/Excel'),
  ScreenEntry('V-22', 'Ajouter Photos Produit', 'Caméra / Galerie (jusqu\u2019à 10)', route: '/seller/products/new'),
  ScreenEntry('V-23', 'Ajouter Vidéo Produit', 'Enregistrement / Upload'),
  ScreenEntry('V-24', 'Catégories & Attributs', 'Gestion catégorisation'),
  ScreenEntry('V-25', 'Promotions Produits', 'Réductions, flash sales'),
  ScreenEntry('V-26', 'Produits en Rupture', 'Alertes stock bas'),
  ScreenEntry('V-27', 'Produits en Vedette', 'Mise en avant payante', route: '/main'),
  ScreenEntry('V-28', 'Vendre Maintenant', 'Bouton rapide vente', route: '/main'),
  ScreenEntry('V-29', 'Vente Rapide — Photo', 'Prendre photo produit', route: '/main'),
  ScreenEntry('V-30', 'Vente Rapide — Infos', 'Prix + description courte (3 champs)', route: '/main'),
  ScreenEntry('V-31', 'Vente Rapide — Partage', 'Génération lien + partage réseaux'),
  ScreenEntry('V-32', 'Catalogue WhatsApp', 'Synchronisation statuts produits'),
  ScreenEntry('V-33', 'Générer Visuel', 'Image optimisée pour réseaux sociaux'),
  ScreenEntry('V-34', 'Live Shopping Setup', 'Planifier un live'),
  ScreenEntry('V-35', 'Live Shopping En Direct', 'Diffusion + chat + achat intégré', route: '/seller/live'),
  ScreenEntry('V-36', 'Fin Live Shopping', 'Stats, ventes, replay'),
  ScreenEntry('V-37', 'Stories Boutique', 'Publier story produit'),
  ScreenEntry('V-38', 'Lien Produit Universel', 'Gestion des liens partagés'),
  ScreenEntry('V-39', 'Commandes Reçues', 'Liste toutes les commandes', route: '/main'),
  ScreenEntry('V-40', 'Détail Commande Reçue', 'Infos complètes client + produits', route: '/main'),
  ScreenEntry('V-41', 'Confirmer Commande', 'Accepter la commande', route: '/main'),
  ScreenEntry('V-42', 'Préparer Commande', 'Marquer « en préparation »', route: '/main'),
  ScreenEntry('V-43', 'Imprimer Bon Livraison', 'Génération PDF'),
  ScreenEntry('V-44', 'Demander Livreur', 'Matching livreur disponible'),
  ScreenEntry('V-45', 'Marquer Expédiée', 'Commande prête, livreur assigné', route: '/main'),
  ScreenEntry('V-46', 'Annuler Commande', 'Motif + confirmation'),
  ScreenEntry('V-47', 'Contacter Client', 'Chat / Appel', route: '/main'),
  ScreenEntry('V-48', 'Commandes en Attente', 'À confirmer'),
  ScreenEntry('V-49', 'Commandes en Cours', 'En préparation / expédiées'),
  ScreenEntry('V-50', 'Commandes Livrées', 'Historique livrées'),
  ScreenEntry('V-51', 'Commandes Annulées', 'Historique annulées'),
  ScreenEntry('V-52', 'Commandes en Litige', 'Réclamations clients'),
  ScreenEntry('V-53', 'Gérer Litige', 'Répondre + proposer solution'),
  ScreenEntry('V-54', 'Retours & Remboursements', 'Gestion des retours'),
  ScreenEntry('V-55', 'Mes Livraisons', 'Suivi des livraisons en cours'),
  ScreenEntry('V-56', 'Détail Livraison', 'Infos livreur, client, statut'),
  ScreenEntry('V-57', 'Contacter Livreur', 'Chat / Appel'),
  ScreenEntry('V-58', 'Tarification Livraison', 'Configurer zones et tarifs'),
  ScreenEntry('V-59', 'Zones de Couverture', 'Carte des zones livrables'),
  ScreenEntry('V-60', 'Ajouter Zone', 'Dessiner zone sur carte'),
  ScreenEntry('V-61', 'Portefeuille Vendeur', 'Solde, transactions, gains', route: '/seller/finance'),
  ScreenEntry('V-62', 'Historique Transactions', 'Liste détaillée', route: '/seller/finance'),
  ScreenEntry('V-63', 'Détail Transaction', 'Infos complètes', route: '/seller/finance'),
  ScreenEntry('V-64', 'Demander Retrait', 'Montant + mode (Airtel/Moov/Banque)', route: '/seller/finance'),
  ScreenEntry('V-65', 'Confirmation Retrait', 'Récapitulatif + code OTP'),
  ScreenEntry('V-66', 'Factures', 'Liste factures générées'),
  ScreenEntry('V-67', 'Détail Facture', 'PDF facture'),
  ScreenEntry('V-68', 'Rapports Fiscaux', 'TVA, exports comptables'),
  ScreenEntry('V-69', 'Abonnement Vendeur', 'Formule (Gratuit/Starter/Pro)'),
  ScreenEntry('V-70', 'Choisir Formule', 'Comparaison des formules'),
  ScreenEntry('V-71', 'Paiement Abonnement', 'Renouvellement / Upgrade'),
  ScreenEntry('V-72', 'Avantages Formule', 'Détail des avantages actuels'),
  ScreenEntry('V-73', 'Ma Boutique', 'Vue publique de ma boutique', route: '/seller/s2'),
  ScreenEntry('V-74', 'Modifier Boutique', 'Nom, description, visuels'),
  ScreenEntry('V-75', 'Horaires Ouverture', 'Configurer jours et heures'),
  ScreenEntry('V-76', 'Politique Retour', 'Rédiger politique'),
  ScreenEntry('V-77', 'À Propos Boutique', 'Story, valeurs, équipe'),
  ScreenEntry('V-78', 'Avis Clients', 'Tous les avis reçus'),
  ScreenEntry('V-79', 'Répondre à un Avis', 'Réponse publique'),
  ScreenEntry('V-80', 'Signaler Avis', 'Avis frauduleux'),

  // ═══════════════════════════ L — LIVREUR (48) ═══════════════════════════
  ScreenEntry('L-01', 'Devenir Livreur', 'Présentation + formulaire', route: '/livreur/join'),
  ScreenEntry('L-02', 'Infos Personnelles', 'Nom, téléphone, email', route: '/livreur/join'),
  ScreenEntry('L-03', 'Documents Véhicule', 'Type, photo, permis', route: '/livreur/join'),
  ScreenEntry('L-04', 'Upload Documents', 'CNI, permis, casier judiciaire', route: '/livreur/join'),
  ScreenEntry('L-05', 'Selfie Vérification', 'Photo temps réel'),
  ScreenEntry('L-06', 'Quiz Géographique', 'Test connaissance quartiers', route: '/livreur/join'),
  ScreenEntry('L-07', 'Vérification en Cours', 'Écran attente'),
  ScreenEntry('L-08', 'Validation Livreur', 'Confirmation + activation', route: '/livreur/join'),
  ScreenEntry('L-09', 'Dashboard Livreur', 'Gains, courses, statut, stats', route: '/main'),
  ScreenEntry('L-10', 'Gains du Jour', 'Détails gains journaliers', route: '/main'),
  ScreenEntry('L-11', 'Gains de la Semaine', 'Récap hebdomadaire', route: '/main'),
  ScreenEntry('L-12', 'Gains du Mois', 'Récap mensuel + graphique', route: '/main'),
  ScreenEntry('L-13', 'Performance', 'Note, ponctualité, taux acceptation'),
  ScreenEntry('L-14', 'Mode Disponible', 'Bouton ON/OFF + zone', route: '/main'),
  ScreenEntry('L-15', 'Carte des Courses', 'Carte avec courses disponibles', route: '/livreur/map'),
  ScreenEntry('L-16', 'Nouvelle Course', 'Popup notification course', route: '/main'),
  ScreenEntry('L-17', 'Détail Course', 'Distance, prix, poids, adresses', route: '/livreur/course'),
  ScreenEntry('L-18', 'Accepter Course', 'Confirmation', route: '/livreur/course'),
  ScreenEntry('L-19', 'Refuser Course', 'Motif + confirmation'),
  ScreenEntry('L-20', 'Navigation vers Prise en Charge', 'GPS vers point de retrait'),
  ScreenEntry('L-21', 'Scanner QR Prise en Charge', 'Validation récupération colis', route: '/scan-pickup'),
  ScreenEntry('L-22', 'Navigation vers Livraison', 'GPS vers adresse client'),
  ScreenEntry('L-23', 'Arrivée Chez Client', 'Confirmation géolocalisée'),
  ScreenEntry('L-24', 'Validation Livraison', 'Code OTP + photo + signature'),
  ScreenEntry('L-25', 'Course Terminée', 'Récap + gains + notation'),
  ScreenEntry('L-26', 'Courses en Cours', 'Liste courses actives', route: '/main'),
  ScreenEntry('L-27', 'Historique Courses', 'Toutes les courses passées', route: '/main'),
  ScreenEntry('L-28', 'Détail Course Passée', 'Infos complètes'),
  ScreenEntry('L-29', 'Courses Annulées', 'Historique annulations'),
  ScreenEntry('L-30', 'Chat Client', 'Conversation anonymisée', route: '/chat'),
  ScreenEntry('L-31', 'Appel Client', 'Numéro masqué'),
  ScreenEntry('L-32', 'Signaler Problème', 'Incident, accident, retard'),
  ScreenEntry('L-33', 'Support Livreur', 'Aide dédiée livreurs', route: '/help'),
  ScreenEntry('L-34', 'FAQ Livreur', 'Questions fréquentes', route: '/help'),
  ScreenEntry('L-35', 'Contacter Support', 'Chat / Téléphone', route: '/help'),
  ScreenEntry('L-36', 'Portefeuille Livreur', 'Solde disponible', route: '/main'),
  ScreenEntry('L-37', 'Historique Gains', 'Détail par course', route: '/main'),
  ScreenEntry('L-38', 'Demander Retrait', 'Montant + mode paiement', route: '/main'),
  ScreenEntry('L-39', 'Confirmation Retrait', 'Récap + OTP'),
  ScreenEntry('L-40', 'Primes & Bonus', 'Liste des bonus obtenus'),
  ScreenEntry('L-41', 'Programme Parrainage', 'Inviter un livreur'),
  ScreenEntry('L-42', 'Mon Véhicule', 'Infos et photo véhicule'),
  ScreenEntry('L-43', 'Modifier Véhicule', 'Mise à jour infos'),
  ScreenEntry('L-44', 'Zones Préférées', 'Quartiers où je préfère livrer'),
  ScreenEntry('L-45', 'Ajouter Zone Préférée', 'Sélection sur carte'),
  ScreenEntry('L-46', 'Horaires Disponibilité', 'Quand je suis disponible'),
  ScreenEntry('L-47', 'Assurance', 'Infos assurance livreur'),
  ScreenEntry('L-48', 'Formation', 'Vidéos et guides'),

  // ═══════════════════════════ AD — ADMIN (75) ════════════════════════════
  ScreenEntry('AD-01', 'Dashboard Admin', 'KPIs globaux, alertes, activité'),
  ScreenEntry('AD-02', 'Vue Globale Ventes', 'CA temps réel, évolution'),
  ScreenEntry('AD-03', 'Carte Thermique Ventes', 'Ventes par zone géographique'),
  ScreenEntry('AD-04', 'Utilisateurs Actifs', 'MAU, DAU, retention'),
  ScreenEntry('AD-05', 'Commandes en Temps Réel', 'Flux live des commandes'),
  ScreenEntry('AD-06', 'Alertes Système', 'Fraude, litiges, anomalies'),
  ScreenEntry('AD-07', 'Rapports Automatisés', 'Génération rapports périodiques'),
  ScreenEntry('AD-08', 'Liste Utilisateurs', 'Tous les utilisateurs'),
  ScreenEntry('AD-09', 'Détail Utilisateur', 'Profil complet, historique'),
  ScreenEntry('AD-10', 'Vérification KYC', 'File d\u2019attente KYC à valider'),
  ScreenEntry('AD-11', 'Valider KYC', 'Vérifier documents + approuver'),
  ScreenEntry('AD-12', 'Rejeter KYC', 'Motif + retour utilisateur'),
  ScreenEntry('AD-13', 'Suspendre Utilisateur', 'Bloquer temporairement'),
  ScreenEntry('AD-14', 'Bannir Utilisateur', 'Bannissement définitif'),
  ScreenEntry('AD-15', 'Liste Vendeurs', 'Tous les vendeurs'),
  ScreenEntry('AD-16', 'Détail Vendeur', 'Boutique, stats, alertes'),
  ScreenEntry('AD-17', 'Valider Boutique', 'Approbation nouvelle boutique'),
  ScreenEntry('AD-18', 'Liste Livreurs', 'Tous les livreurs'),
  ScreenEntry('AD-19', 'Détail Livreur', 'Performance, documents, stats'),
  ScreenEntry('AD-20', 'Valider Livreur', 'Approbation inscription livreur'),
  ScreenEntry('AD-21', 'Liste Produits', 'Tous les produits'),
  ScreenEntry('AD-22', 'Détail Produit Admin', 'Vue admin fiche produit'),
  ScreenEntry('AD-23', 'Modérer Produit', 'Approuver / rejeter / modifier'),
  ScreenEntry('AD-24', 'Produits Signalés', 'Signalements contrefaçon, etc.'),
  ScreenEntry('AD-25', 'Gestion Catégories', 'CRUD catégories'),
  ScreenEntry('AD-26', 'Ajouter Catégorie', 'Nouvelle catégorie'),
  ScreenEntry('AD-27', 'Attributs Produits', 'Gestion champs dynamiques'),
  ScreenEntry('AD-28', 'Bannières Home', 'Gestion carrousels promo'),
  ScreenEntry('AD-29', 'Ajouter Bannière', 'Upload + ciblage'),
  ScreenEntry('AD-30', 'Toutes les Commandes', 'Liste globale'),
  ScreenEntry('AD-31', 'Détail Commande Admin', 'Vue complète'),
  ScreenEntry('AD-32', 'Litiges', 'Commandes en conflit'),
  ScreenEntry('AD-33', 'Médiation Litige', 'Arbitrer entre parties'),
  ScreenEntry('AD-34', 'Remboursements', 'Gestion remboursements'),
  ScreenEntry('AD-35', 'Transactions Financières', 'Toutes les transactions'),
  ScreenEntry('AD-36', 'Détail Transaction', 'Infos complètes'),
  ScreenEntry('AD-37', 'Reconciliation', 'Matching avec Airtel/Moov'),
  ScreenEntry('AD-38', 'Retraits Vendeurs', 'Demandes de retrait en attente'),
  ScreenEntry('AD-39', 'Traiter Retrait', 'Valider / rejeter retrait'),
  ScreenEntry('AD-40', 'Retraits Livreurs', 'Demandes livreurs'),
  ScreenEntry('AD-41', 'Traiter Retrait Livreur', 'Valider / rejeter'),
  ScreenEntry('AD-42', 'Suivi Livraisons', 'Carte temps réel toutes les courses'),
  ScreenEntry('AD-43', 'Détail Course Admin', 'Infos livreur, client, statut'),
  ScreenEntry('AD-44', 'Attribuer Course', 'Assigner manuellement un livreur'),
  ScreenEntry('AD-45', 'Zones de Couverture', 'Gestion zones livrables'),
  ScreenEntry('AD-46', 'Configurer Zone', 'Tarifs, livreurs assignés'),
  ScreenEntry('AD-47', 'Tarification Livraison', 'Grille tarifaire'),
  ScreenEntry('AD-48', 'Performance Livreurs', 'Classement, stats'),
  ScreenEntry('AD-49', 'Campagnes Push', 'Créer notifications push'),
  ScreenEntry('AD-50', 'Nouvelle Campagne Push', 'Ciblage + contenu + planning'),
  ScreenEntry('AD-51', 'Campagnes Email/SMS', 'Créer campagnes'),
  ScreenEntry('AD-52', 'Nouvelle Campagne Email', 'Template + liste + envoi'),
  ScreenEntry('AD-53', 'Codes Promo', 'Gestion coupons'),
  ScreenEntry('AD-54', 'Créer Code Promo', 'Règles, limites, ciblage'),
  ScreenEntry('AD-55', 'Programme Fidélité', 'Configuration points'),
  ScreenEntry('AD-56', 'Règles Fidélité', 'Gains de points, récompenses'),
  ScreenEntry('AD-57', 'Analytics Marketing', 'ROI campagnes'),
  ScreenEntry('AD-58', 'Tickets Support', 'Tous les tickets clients'),
  ScreenEntry('AD-59', 'Détail Ticket', 'Conversation + historique'),
  ScreenEntry('AD-60', 'Répondre Ticket', 'Réponse agent'),
  ScreenEntry('AD-61', 'Chat en Direct', 'Support temps réel'),
  ScreenEntry('AD-62', 'Contenu Signalé', 'Avis, messages, produits signalés'),
  ScreenEntry('AD-63', 'Modérer Contenu', 'Approuver / supprimer / avertir'),
  ScreenEntry('AD-64', 'Base de Connaissances', 'Articles aide'),
  ScreenEntry('AD-65', 'Ajouter Article', 'Nouvel article aide'),
  ScreenEntry('AD-66', 'Chatbot Configuration', 'Réponses automatiques'),
  ScreenEntry('AD-67', 'Paramètres Globaux', 'Configuration plateforme'),
  ScreenEntry('AD-68', 'Commission Plateforme', 'Taux par catégorie'),
  ScreenEntry('AD-69', 'Frais Livraison', 'Configuration tarifs de base'),
  ScreenEntry('AD-70', 'Seuils Alertes', 'Configuration notifications système'),
  ScreenEntry('AD-71', 'Maintenance', 'Mode maintenance ON/OFF'),
  ScreenEntry('AD-72', 'Logs Système', 'Logs techniques'),
  ScreenEntry('AD-73', 'Détail Log', 'Log complet'),
  ScreenEntry('AD-74', 'Gestion Rôles', 'Permissions admin'),
  ScreenEntry('AD-75', 'Ajouter Admin', 'Nouvel utilisateur admin'),
];
