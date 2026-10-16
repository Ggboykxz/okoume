import '../../features/extra/extra_spec.dart';

/// Aperçus du module V — Vendeur (écrans hors MVP).
const extraSpecsV = <String, ExtraSpec>{
 'V-04': ExtraSpec(
  emoji: '⏳',
  title: 'Vérification en Cours',
  tagline: 'Votre dossier KYC est en cours d’examen — généralement sous 24 h.',
  sections: [
   TimelineSection([
    ('', 'Dossier transmis', 'Aujourd’hui 09h12'),
    ('', 'Vérification des documents', 'En cours…'),
    ('', 'Validation KYC', 'Sous 24 h ouvrées'),
    ('', 'Ouverture de la boutique', 'Immédiat après validation'),
   ], title: 'Étapes'),
   TextSection('', 'Documents en examen',
     'CNI recto/verso, selfie de vérification et patente commerciale '
       '(si applicable). Vous recevrez une notification dès la décision.'),
  ],
  actions: [
   ExtraAction('', 'M’alerter à la validation', snack: 'Alerte activée '),
   ExtraAction('', 'Contacter le support KYC',
     snack: 'Un conseiller vous rappelle sous 2 h (démo) '),
  ],
 ),
 'V-07': ExtraSpec(
  emoji: '',
  title: 'Configurer Livraison',
  tagline: 'Zones desservies, frais et délais proposés à vos acheteurs.',
  sections: [
   ToggleSection([
    ('', 'Livraison à domicile', true),
    ('', 'Points de retrait (consignes)', true),
    ('', 'Retrait en boutique', true),
   ], title: 'Modes proposés'),
   FormSection(
    title: 'Tarifs par zone',
    fields: [
     ('️', 'Zone (ex. Libreville centre)'),
     ('', 'Frais de livraison (F CFA)'),
     ('⏱️', 'Délai moyen (ex. 2 h)'),
    ],
    submitLabel: 'Enregistrer la zone',
    success: 'Zone de livraison enregistrée (démo) ',
   ),
   BulletSection('Recommandations', [
    ' Proposez l’Express : +37 % de conversion en moyenne',
    ' Le point relais réduit vos frais de 700 F',
    '️ Zones actives : Libreville, Akanda, Owendo',
   ]),
  ],
 ),
 'V-10': ExtraSpec(
  emoji: '',
  title: 'Analytics Vente',
  tagline: 'Chiffre d’affaires, évolution et insights de votre boutique.',
  sections: [
   StatSection([
    ('', '4,2 M F', 'CA du mois'),
    ('', '187', 'Commandes'),
    ('', '+18 %', 'vs. mois dernier'),
   ]),
   ChartSection('CA des 7 derniers jours (kF)', [
    ('Lun', 42), ('Mar', 65), ('Mer', 30), ('Jeu', 80),
    ('Ven', 55), ('Sam', 95), ('Dim', 70),
   ]),
   ListSection([
    ExtraRow('', 'Pics de vente 18h–21h',
      subtitle: 'Planifiez vos publications à 17h30'),
    ExtraRow('️', 'Libreville = 62 % des ventes',
      subtitle: 'Akanda et Owendo progressent de 9 %'),
    ExtraRow('', 'Taux de retour : 1,4 %',
      subtitle: 'Sous la moyenne de la plateforme (2,3 %)'),
   ], title: 'Insights'),
  ],
  actions: [
   ExtraAction('', 'Exporter le rapport (CSV)',
     snack: 'Rapport CSV envoyé par email (démo) '),
  ],
 ),
 'V-11': ExtraSpec(
  emoji: '',
  title: 'Produits Populaires',
  tagline: 'Vos meilleures ventes classées par volume et marge.',
  sections: [
   ProgressSection('Top 4 du mois', [
    (' Écouteurs ProSound — 64 ventes', 0.9, '64'),
    (' Power bank 20 000 — 41 ventes', 0.62, '41'),
    (' Coque renforcée — 33 ventes', 0.48, '33'),
    ('⌚ Montre Fit 3 — 21 ventes', 0.3, '21'),
   ]),
   ListSection([
    ExtraRow('', 'Meilleure marge : coques renforcées', trailing: '46 %'),
    ExtraRow('', 'Plus lent : chargeurs 5 W', trailing: '3 ventes'),
   ], title: 'Marges'),
  ],
  actions: [
   ExtraAction('', 'Booster un produit', snack: 'Boost en vedette proposé '),
  ],
 ),
 'V-12': ExtraSpec(
  emoji: '',
  title: 'Clients Fidèles',
  tagline: 'Vos meilleurs clients — remerciez-les avec un code personnalisé.',
  sections: [
   ListSection([
    ExtraRow('', 'Aline N.', subtitle: '8 commandes · cliente depuis 2025', trailing: '412 kF'),
    ExtraRow('', 'Jean-P. M.', subtitle: '6 commandes · répond vite', trailing: '305 kF'),
    ExtraRow('', 'Synthia O.', subtitle: '5 commandes · paye par Airtel', trailing: '287 kF'),
    ExtraRow('', 'Marc O. (livreur de confiance)', subtitle: 'Zone Akanda', trailing: '—'),
   ], title: 'Top clients'),
   BulletSection('Fidélisation', [
    ' Offrez −10 % aux clients ≥ 5 commandes',
    ' Répondez en < 1 h pour gagner le badge « Réactif »',
    ' Invitez-les à laisser un avis — +12 % de visibilité',
   ]),
  ],
  actions: [
   ExtraAction('', 'Créer un code client fidèle',
     snack: 'Code FIDELE-10 créé (démo) '),
  ],
 ),
 'V-13': ExtraSpec(
  emoji: '️',
  title: 'Performance Boutique',
  tagline: 'Note, conversion, retours : votre score global et ses leviers.',
  sections: [
   ProgressSection('Score boutique — 87/100', [
    ('Note clients', 0.92, '4,8 '),
    ('Taux de réponse < 1 h', 0.88, '88 %'),
    ('Conversion vues → commandes', 0.41, '4,1 %'),
    ('Taux de retour', 0.98, '1,4 % (excellent)'),
   ]),
   BulletSection('Prochain palier : 90/100', [
    ' Ajoutez des photos HD à vos 5 fiches les plus vues',
    ' Activez l’Express sur 3 produits supplémentaires',
    ' Répondez aux 2 questions en attente',
   ]),
  ],
 ),
 'V-18': ExtraSpec(
  emoji: '',
  title: 'Dupliquer Produit',
  tagline: 'Créer une copie d’une fiche pour variante, couleur ou taille.',
  sections: [
   TextSection('', 'Copie intelligente',
     'Titre, description, catégorie et photos sont copiés. '
       'Le stock repart à zéro et le SKU est regénéré automatiquement.'),
   FormSection(
    title: 'Nouvelle fiche',
    fields: [
     ('️', 'Nouveau titre (ex. « — Variante bleue »)'),
     ('', 'Stock initial'),
    ],
    submitLabel: 'Dupliquer',
    success: 'Fiche dupliquée — brouillon créé (démo) ',
   ),
  ],
 ),
 'V-20': ExtraSpec(
  emoji: '',
  title: 'Gérer Stock',
  tagline: 'Quantités, seuils d’alerte et réapprovisionnement rapide.',
  sections: [
   ListSection([
    ExtraRow('', 'Écouteurs ProSound', trailing: '34 unités'),
    ExtraRow('', 'Power bank 20 000', trailing: '8 unités ️'),
    ExtraRow('', 'Coque renforcée', trailing: '52 unités'),
    ExtraRow('⌚', 'Montre Fit 3', trailing: '0 unité '),
   ], title: 'Stock actuel'),
   FormSection(
    title: 'Mise à jour rapide',
    fields: [
     ('', 'Produit'),
     ('', 'Nouvelle quantité'),
     ('', 'Seuil d’alerte'),
    ],
    submitLabel: 'Mettre à jour',
    success: 'Stock mis à jour ',
    op: ExtraOp.updateStock,
   ),
  ],
 ),
 'V-21': ExtraSpec(
  emoji: '',
  title: 'Importer Produits',
  tagline: 'Ajoutez tout un catalogue via fichier CSV / Excel.',
  sections: [
   BulletSection('Format attendu', [
    ' Colonnes : titre, prix, stock, catégorie, description',
    '️ Les photos sont à ajouter après import (ou via liens)',
    ' Maximum 500 lignes par fichier',
   ]),
   TextSection('', 'Aperçu du modèle',
     'Titre, Prix (F), Stock, Catégorie, Description.\n'
       'Exemple : « Coque renforcée, 4500, 50, Accessoires, Coque antichoc »'),
  ],
  actions: [
   ExtraAction('', 'Choisir un fichier',
     snack: 'Sélecteur de fichier ouvert (démo) '),
   ExtraAction('⬇️', 'Télécharger le modèle CSV',
     snack: 'Modèle CSV téléchargé (démo) ⬇️'),
  ],
 ),
 'V-23': ExtraSpec(
  emoji: '',
  title: 'Ajouter Vidéo Produit',
  tagline: 'Filmez ou importez une vidéo : les fiches avec vidéo convertissent +29 %.',
  sections: [
   BulletSection('Conseils de tournage', [
    ' Lumière naturelle, fond simple',
    '⏱️ 20 à 45 secondes suffisent',
    ' Montrez le déballage et les finitions',
    ' Ajoutez une voix off ou du texte',
   ]),
   TextSection('', 'Spécifications',
     'MP4 / MOV · 1080p minimum · 100 Mo maximum · '
       'ratio conseillé 4:5 (vertical) pour les stories.'),
  ],
  actions: [
   ExtraAction('', 'Enregistrer maintenant',
     snack: 'Caméra simulée (démo) '),
   ExtraAction('️', 'Importer depuis la galerie',
     snack: 'Galerie simulée (démo) ️'),
  ],
 ),
 'V-24': ExtraSpec(
  emoji: '️',
  title: 'Catégories & Attributs',
  tagline: 'Classez vos produits et définissez les champs de vos fiches.',
  sections: [
   ListSection([
    ExtraRow('', 'Électronique', subtitle: 'Attributs : marque, garantie, état', trailing: '18 produits'),
    ExtraRow('', 'Mode', subtitle: 'Attributs : taille, couleur, matière', trailing: '24 produits'),
    ExtraRow('', 'Maison', subtitle: 'Attributs : dimensions, matériau', trailing: '9 produits'),
   ], title: 'Catégories utilisées'),
   ToggleSection([
    ('', 'Afficher la grille des tailles (mode)', true),
    ('️', 'Garantie obligatoire (électronique)', false),
   ], title: 'Champs avancés'),
  ],
 ),
 'V-25': ExtraSpec(
  emoji: '️',
  title: 'Promotions Produits',
  tagline: 'Réductions simples, promos flash et prix barrés.',
  sections: [
   FormSection(
    title: 'Nouvelle promotion',
    fields: [
     ('', 'Produit concerné'),
     ('%', 'Réduction (1–70 %)'),
     ('', 'Dates (début → fin)'),
    ],
    submitLabel: 'Programmer la promotion',
    success: 'Promotion programmée ️',
    op: ExtraOp.createVendorPromo,
   ),
   ListSection([
    ExtraRow('', 'Flash « Mercredi Tech »', subtitle: 'Demain 12h–18h · 6 produits', trailing: 'Programmée'),
    ExtraRow('', 'Power bank −20 %', subtitle: 'En cours · fin dans 2 j', trailing: 'Active'),
   ], title: 'Promotions'),
  ],
 ),
 'V-26': ExtraSpec(
  emoji: '',
  title: 'Produits en Rupture',
  tagline: 'Alertes stock bas et produits épuisés — réapprovisionnez vite.',
  sections: [
   StatSection([
    ('', '3', 'Épuisés'),
    ('️', '5', 'Stock bas'),
    ('', '~180 kF', 'Ventes perdues est.'),
   ]),
   ListSection([
    ExtraRow('⌚', 'Montre Fit 3', subtitle: 'Épuisé depuis 2 jours', trailing: 'Réappro.'),
    ExtraRow('', 'Power bank 20 000', subtitle: '8 restants — seuil 10', trailing: 'Urgent'),
    ExtraRow('', 'Coffret karité', subtitle: '5 restants — seuil 8', trailing: 'Bientôt'),
   ], title: 'À traiter'),
  ],
  actions: [
   ExtraAction('', 'M’alerter sous 5 unités',
     snack: 'Alertes stock activées '),
  ],
 ),
 'V-31': ExtraSpec(
  emoji: '',
  title: 'Vente Rapide — Partage',
  tagline: 'Votre produit est en ligne ! Partagez-le partout en un tap.',
  sections: [
   ListSection([
    ExtraRow('', 'WhatsApp', subtitle: 'Vos groupes et contacts', snack: 'Partage WhatsApp simulé '),
    ExtraRow('', 'Facebook Marketplace', snack: 'Publication simulée '),
    ExtraRow('', 'Story Instagram', snack: 'Visuel story généré '),
    ExtraRow('', 'Copier le lien', snack: 'Lien copié : oko.me/p/v-31 '),
   ], title: 'Partager maintenant'),
   TextSection('', 'Le saviez-vous ?',
     'Les vendeurs qui partagent sur 2 réseaux ou plus vendent '
       '3 fois plus vite leur premier article.'),
  ],
  actions: [
   ExtraAction('', 'Générer un QR code boutique',
     snack: 'QR boutique généré (démo) '),
  ],
 ),
 'V-32': ExtraSpec(
  emoji: '',
  title: 'Catalogue WhatsApp',
  tagline: 'Publiez votre catalogue Okoumé en statut WhatsApp automatiquement.',
  sections: [
   ToggleSection([
    ('', 'Synchronisation automatique du catalogue', true),
    ('', 'Statut quotidien à 8h00', true),
    ('', 'Version « nouveautés de la semaine »', false),
   ], title: 'Publication automatique'),
   TextSection('', 'Comment ça marche',
     'Okoumé génère un visuel de votre catalogue (produits, prix, lien) '
       'et le publie en statut WhatsApp Business à l’heure choisie.'),
  ],
 ),
 'V-33': ExtraSpec(
  emoji: '',
  title: 'Générer Visuel',
  tagline: 'Visuels prêts à publier : story, post carré et bannière promo.',
  sections: [
   ListSection([
    ExtraRow('', 'Story verticale (1080×1920)', snack: 'Aperçu story généré '),
    ExtraRow('️', 'Post carré (1080×1080)', snack: 'Aperçu post généré ️'),
    ExtraRow('', 'Bannière promo −20 %', snack: 'Bannière générée '),
   ], title: 'Formats disponibles'),
   TextSection('', 'Personnalisation',
     'Votre logo, votre couleur d’accent et un slogan automatique '
       'sont appliqués. Export PNG haute définition immédiat.'),
  ],
  actions: [
   ExtraAction('', 'Exporter le visuel', snack: 'Visuel exporté (démo) '),
  ],
 ),
 'V-34': ExtraSpec(
  emoji: '',
  title: 'Live Shopping Setup',
  tagline: 'Planifiez votre première vente en direct : titre, heure, produits.',
  sections: [
   FormSection(
    title: 'Nouveau live',
    fields: [
     ('️', 'Titre du live (ex. « Tech à petits prix »)'),
     ('', 'Date et heure'),
     ('', 'Produits à présenter'),
    ],
    submitLabel: 'Planifier le live',
    success: 'Live planifié — rappel envoyé à vos abonnés (démo) ',
   ),
   BulletSection('Conseils pour réussir', [
    ' Prévenez vos abonnés 24 h avant',
    ' Préparez 5 à 8 produits maximum',
    ' Prévoyez une offre réservée au live',
   ]),
   LinkSection([
    ExtraRow('', 'Voir un live en direct (démo)', route: '/seller/live'),
   ]),
  ],
 ),
 'V-36': ExtraSpec(
  emoji: '',
  title: 'Fin Live Shopping',
  tagline: 'Bilan du direct : spectateurs, ventes et replay.',
  sections: [
   StatSection([
    ('', '1 248', 'Spectateurs'),
    ('', '63', 'Commandes'),
    ('', '1,8 M F', 'CA du live'),
   ]),
   TimelineSection([
    ('▶️', 'Début du live', '20h00'),
    ('', 'Pic de spectateurs', '20h26 — 312 simultanés'),
    ('', 'Fin du live', '21h05'),
   ], title: 'Déroulé'),
   TextSection('', 'Replay',
     'Le replay reste disponible 7 jours dans votre boutique et '
       'convertit encore 15 % des vues en commandes.'),
  ],
  actions: [
   ExtraAction('', 'Publier le replay', snack: 'Replay publié (démo) '),
   ExtraAction('', 'Traiter les commandes du live', route: '/main'),
  ],
 ),
 'V-37': ExtraSpec(
  emoji: '',
  title: 'Stories Boutique',
  tagline: 'Publiez des stories produits visibles 24 h par vos abonnés.',
  sections: [
   TextSection('', 'Format story',
     'Photo ou vidéo verticale + prix + badge « nouveauté ». '
       'Vos abonnés peuvent acheter directement depuis la story.'),
   BulletSection('Bonnes pratiques', [
    ' Publiez entre 12h et 14h, et après 19h',
    '️ Ajoutez toujours le prix — +41 % de clics',
    ' Consultez les vues et les sorties de story',
   ]),
  ],
  actions: [
   ExtraAction('', 'Publier une story',
     snack: 'Éditeur de story simulé (démo) '),
  ],
 ),
 'V-38': ExtraSpec(
  emoji: '',
  title: 'Lien Produit Universel',
  tagline: 'Un lien unique qui ouvre le bon écran, app installée ou non.',
  sections: [
   ListSection([
    ExtraRow('', 'oko.me/p/p1', subtitle: 'Écouteurs ProSound', snack: 'Lien copié '),
    ExtraRow('', 'oko.me/s/s2', subtitle: 'Boutique TechGabon', snack: 'Lien copié '),
   ], title: 'Vos liens actifs'),
   TextSection('', 'Comportement adaptatif',
     'App installée → ouverture directe de la fiche. '
       'Sinon → page web avec bouton d’installation et aperçu produit.'),
  ],
 ),
 'V-43': ExtraSpec(
  emoji: '️',
  title: 'Imprimer Bon Livraison',
  tagline: 'Générer le bordereau à coller sur le colis (adresse + code).',
  sections: [
   TextSection('', 'Contenu du bon',
     'Numéro de commande OK-2026-0118\n'
       'Destinataire + adresse complète\n'
       'Liste des articles et code de vérification OTP'),
   BulletSection('Formats', [
    '️ A4 — imprimante classique',
    '️ Étiquette 10×15 cm — imprimante thermique',
    ' PDF envoyé sur WhatsApp si pas d’imprimante',
   ]),
  ],
  actions: [
   ExtraAction('️', 'Imprimer le bon', snack: 'Impression simulée (démo) ️'),
   ExtraAction('', 'Envoyer le PDF', snack: 'PDF envoyé '),
  ],
 ),
 'V-44': ExtraSpec(
  emoji: '',
  title: 'Demander Livreur',
  tagline: 'Trouvez un livreur disponible en moins de 3 minutes.',
  sections: [
   MapSection([
    ('', 'Votre boutique', 0.3, 0.4),
    ('', 'Marc O. — 1,2 km', 0.62, 0.55),
    ('', 'Ibrahim K. — 2,8 km', 0.45, 0.75),
   ], title: 'Livreurs disponibles autour de vous'),
   BulletSection('Matching automatique', [
    ' Le plus proche reçoit la demande en priorité',
    ' Poids du colis vérifié (moto vs camionnette)',
    '⏱️ Escalade automatique si aucune réponse en 90 s',
   ]),
  ],
  actions: [
   ExtraAction('', 'Envoyer la demande',
     snack: 'Demande envoyée à 3 livreurs (démo) '),
   ExtraAction('', 'Programmer un enlèvement',
     snack: 'Enlèvement programmé (démo) '),
  ],
 ),
 'V-46': ExtraSpec(
  emoji: '',
  title: 'Annuler Commande (Vendeur)',
  tagline: 'Annulez proprement : le client est remboursé automatiquement.',
  sections: [
   ListSection([
    ExtraRow('', 'Rupture de stock', snack: 'Motif « rupture » retenu'),
    ExtraRow('', 'Boutique fermée exceptionnellement', snack: 'Motif « fermeture » retenu'),
    ExtraRow('', 'Erreur de prix sur la fiche', snack: 'Motif « prix » retenu'),
    ExtraRow('', 'Client injoignable', snack: 'Motif « injoignable » retenu'),
   ], title: 'Motif d’annulation'),
   TextSection('', 'Remboursement',
     'Le montant placé en séquestre est restitué au client sous 24 h '
       'sur son moyen de paiement d’origine. Votre taux d’annulation '
       'est impacté — restez sous 3 %.'),
  ],
 ),
 'V-48': ExtraSpec(
  emoji: '⏳',
  title: 'Commandes en Attente',
  tagline: 'Commandes à confirmer — répondez sous 2 h pour le badge « Réactif ».',
  sections: [
   ListSection([
    ExtraRow('⏳', 'OK-2026-0121 · Aline N.', subtitle: 'Il y a 25 min · 2 articles', trailing: '45 500 F'),
    ExtraRow('⏳', 'OK-2026-0120 · Jean-P. M.', subtitle: 'Il y a 1 h · 1 article', trailing: '18 000 F'),
    ExtraRow('⏳', 'OK-2026-0119 · Synthia O.', subtitle: 'Il y a 2 h · 3 articles', trailing: '87 000 F'),
   ], title: 'À confirmer (3)'),
   BulletSection('Le bon réflexe', [
    ' Confirmez puis préparez la commande',
    ' Imprimez le bon de livraison',
    ' Demandez un livreur dès que le colis est prêt',
   ]),
  ],
  actions: [
   ExtraAction('', 'Tout confirmer', snack: '3 commandes confirmées (démo) '),
  ],
 ),
 'V-49': ExtraSpec(
  emoji: '',
  title: 'Commandes en Cours',
  tagline: 'En préparation, expédiées ou en livraison — suivez tout en direct.',
  sections: [
   ListSection([
    ExtraRow('', 'OK-2026-0115 · en préparation', subtitle: 'Livraison prévue aujourd’hui', trailing: '32 000 F'),
    ExtraRow('', 'OK-2026-0112 · expédiée', subtitle: 'Livreur : Marc O.', trailing: '21 500 F'),
    ExtraRow('', 'OK-2026-0110 · en livraison', subtitle: 'À 1,4 km du client', trailing: '56 000 F'),
   ], title: 'En cours (3)'),
  ],
  actions: [
   ExtraAction('️', 'Suivre en temps réel', route: '/main'),
  ],
 ),
 'V-50': ExtraSpec(
  emoji: '',
  title: 'Commandes Livrées',
  tagline: 'Historique des livraisons réussies et reversements.',
  sections: [
   StatSection([
    ('', '164', 'Livrées ce mois'),
    ('⏱️', '42 min', 'Délai moyen préparation'),
    ('', '3,8 M F', 'Reversé'),
   ]),
   ListSection([
    ExtraRow('', 'OK-2026-0104 · livrée hier', trailing: '45 000 F'),
    ExtraRow('', 'OK-2026-0101 · livrée lundi', trailing: '28 500 F'),
    ExtraRow('', 'OK-2026-0098 · livrée dimanche', trailing: '112 000 F'),
   ], title: 'Dernières livraisons'),
  ],
  actions: [
   ExtraAction('', 'Demander un avis aux clients',
     snack: 'Relance avis envoyée aux 3 clients (démo) '),
  ],
 ),
 'V-51': ExtraSpec(
  emoji: '',
  title: 'Commandes Annulées',
  tagline: 'Annulations : motifs et impact sur votre score boutique.',
  sections: [
   StatSection([
    ('', '2,1 %', 'Taux d’annulation'),
    ('', 'Objectif', '< 3 %'),
   ]),
   ListSection([
    ExtraRow('', 'OK-2026-0092 · rupture de stock', trailing: 'Remboursée'),
    ExtraRow('', 'OK-2026-0084 · client injoignable', trailing: 'Remboursée'),
   ], title: 'Annulations du mois'),
   TextSection('', 'Levier d’amélioration',
     'Activez l’alerte stock bas (V-26) pour éviter les ruptures : '
       'c’est la 1ʳᵉ cause d’annulation des vendeurs.'),
  ],
 ),
 'V-52': ExtraSpec(
  emoji: '️',
  title: 'Commandes en Litige',
  tagline: 'Réclamations clients en cours — répondez sous 24 h.',
  sections: [
   ListSection([
    ExtraRow('', 'OK-2026-0107 · « article manquant »', subtitle: 'Ouvert hier · Aline N.', trailing: 'Prioritaire'),
    ExtraRow('⏳', 'OK-2026-0102 · « délai trop long »', subtitle: 'Ouvert il y a 2 j · Jean-P. M.', trailing: 'En cours'),
   ], title: 'Litiges actifs (2)'),
   TextSection('️', 'Séquestre',
     'Les fonds des commandes en litige restent bloqués. '
       'Un médiateur Okoumé peut trancher si vous ne trouvez pas d’accord.'),
  ],
  actions: [
   ExtraAction('', 'Ouvrir un dossier', route: '/screen/V-53'),
  ],
 ),
 'V-53': ExtraSpec(
  emoji: '',
  title: 'Gérer Litige',
  tagline: 'Répondre au client et proposer une solution concrète.',
  sections: [
   TimelineSection([
    ('', 'Réclamation client', 'Hier 14h02'),
    ('', 'Lecture vendeur', 'Hier 14h30'),
    ('', 'Votre réponse', 'Attendue — sous 24 h'),
   ], title: 'Dossier OK-2026-0107'),
   FormSection(
    title: 'Proposer une solution',
    fields: [
     ('', 'Message au client'),
     ('', 'Proposition (remboursement partiel, renvoi, geste)'),
    ],
    submitLabel: 'Envoyer la proposition',
    success: 'Proposition envoyée — le client a 48 h pour répondre (démo) ',
   ),
  ],
  actions: [
   ExtraAction('‍️', 'Demander la médiation Okoumé',
     snack: 'Médiation demandée — un agent vous contactera ‍️'),
  ],
 ),
 'V-54': ExtraSpec(
  emoji: '↩️',
  title: 'Retours & Remboursements',
  tagline: 'Gérez les retours : réception, contrôle et remboursement.',
  sections: [
   ProgressSection('Dossiers ce mois', [
    ('Retours reçus et contrôlés', 0.85, '17/20'),
    ('Remboursements traités < 72 h', 0.92, '92 %'),
   ]),
   ListSection([
    ExtraRow('', 'RET-320 · Coque renforcée', subtitle: 'Retour reçu — contrôle OK', trailing: 'Rembourser'),
    ExtraRow('', 'RET-318 · Power bank', subtitle: 'Récupération prévue demain', trailing: 'En route'),
   ], title: 'Dossiers ouverts'),
  ],
  actions: [
   ExtraAction('', 'Rembourser RET-320',
     snack: 'Remboursement lancé (démo) '),
  ],
 ),
 'V-55': ExtraSpec(
  emoji: '️',
  title: 'Mes Livraisons',
  tagline: 'Toutes vos livraisons en cours, sur une seule carte.',
  sections: [
   MapSection([
    ('', 'Boutique', 0.25, 0.5),
    ('', 'Course #3412 — Owendo', 0.55, 0.3),
    ('', 'Course #3413 — Akanda', 0.7, 0.7),
   ], title: '2 livraisons actives'),
   ListSection([
    ExtraRow('', 'Course #3412 · Marc O.', subtitle: 'En route · ETA 12 min', trailing: 'OK-2026-0110'),
    ExtraRow('', 'Course #3413 · Ibrahim K.', subtitle: 'Récupération dans 5 min', trailing: 'OK-2026-0112'),
   ], title: 'En cours'),
  ],
 ),
 'V-56': ExtraSpec(
  emoji: '',
  title: 'Détail Livraison',
  tagline: 'Livreur, client, statut et preuves de livraison.',
  sections: [
   TimelineSection([
    ('', 'Colis remis au livreur', '14h05'),
    ('', 'En route vers le client', '14h12'),
    ('', 'Photo à l’arrivée', 'Attendu'),
    ('', 'Code OTP validé par le client', 'Attendu'),
   ], title: 'Course #3412'),
   ListSection([
    ExtraRow('', 'Marc O. — moto GT-4521', subtitle: '4,9 · 128 courses'),
    ExtraRow('', 'Aline N. — Akébé', subtitle: '074 00 00 00'),
   ], title: 'Intervenants'),
  ],
  actions: [
   ExtraAction('', 'Contacter le livreur', snack: 'Chat avec le livreur ouvert (démo) '),
   ExtraAction('', 'Appeler le client', snack: 'Appel simulé '),
  ],
 ),
 'V-57': ExtraSpec(
  emoji: '',
  title: 'Contacter Livreur',
  tagline: 'Chat ou appel direct avec le livreur assigné à la course.',
  sections: [
   ListSection([
    ExtraRow('', 'Chat sécurisé', subtitle: 'Réponse moyenne : 2 min', snack: 'Chat ouvert (démo) '),
    ExtraRow('', 'Appel masqué', subtitle: 'Votre numéro reste caché', snack: 'Appel en cours… '),
   ], title: 'Marc O. — Course #3412'),
   BulletSection('À savoir', [
    ' Évitez les appels après 21h',
    ' Le suivi GPS est plus rapide que l’appel',
    ' Un problème de comportement ? Signalez-le',
   ]),
  ],
 ),
 'V-58': ExtraSpec(
  emoji: '',
  title: 'Tarification Livraison',
  tagline: 'Grille de frais par zone, poids et mode de livraison.',
  sections: [
   ListSection([
    ExtraRow('️', 'Libreville centre', subtitle: '0–5 kg · moto', trailing: '1 500 F'),
    ExtraRow('', 'Akanda / Owendo', subtitle: '0–5 kg · moto', trailing: '2 000 F'),
    ExtraRow('', 'Point relais', subtitle: 'Toutes zones', trailing: '700 F'),
    ExtraRow('', 'Encombrant (camionnette)', subtitle: '> 30 kg', trailing: '8 000 F'),
   ], title: 'Tarifs actuels'),
   FormSection(
    title: 'Ajuster un tarif',
    fields: [
     ('️', 'Zone'),
     ('', 'Nouveau tarif (F CFA)'),
    ],
    submitLabel: 'Appliquer',
    success: 'Tarif mis à jour (démo) ',
   ),
  ],
 ),
 'V-59': ExtraSpec(
  emoji: '️',
  title: 'Zones de Couverture',
  tagline: 'Cartographiez les quartiers que vous livrez.',
  sections: [
   MapSection([
    ('', 'Boutique — Mont-Bouët', 0.32, 0.45),
    ('', 'Libreville centre', 0.5, 0.35),
    ('', 'Akanda', 0.68, 0.25),
    ('', 'Owendo', 0.55, 0.72),
    ('', 'Ntoum (non desservie)', 0.85, 0.8),
   ], title: 'Zones actives : 3'),
   ListSection([
    ExtraRow('', 'Libreville centre', subtitle: '12 quartiers · Délai moyen 45 min'),
    ExtraRow('', 'Akanda', subtitle: '6 quartiers · Délai moyen 1h10'),
    ExtraRow('', 'Owendo', subtitle: '5 quartiers · Délai moyen 55 min'),
   ], title: 'Détail'),
  ],
  actions: [
   ExtraAction('', 'Ajouter une zone', route: '/screen/V-60'),
  ],
 ),
 'V-60': ExtraSpec(
  emoji: '',
  title: 'Ajouter Zone',
  tagline: 'Dessinez une zone sur la carte et fixez ses conditions.',
  sections: [
   MapSection([
    ('️', 'Zone en cours', 0.5, 0.45),
   ], title: 'Dessiner la zone'),
   FormSection(
    title: 'Conditions de la zone',
    fields: [
     ('️', 'Nom (ex. « PK9 & environs »)'),
     ('', 'Frais de livraison'),
     ('⏱️', 'Délai promis'),
    ],
    submitLabel: 'Créer la zone',
    success: 'Zone créée — active dès maintenant ️',
    op: ExtraOp.createZone,
   ),
  ],
 ),
 'V-65': ExtraSpec(
  emoji: '',
  title: 'Confirmation Retrait',
  tagline: 'Récapitulatif du retrait et code de validation.',
  sections: [
   TextSection('', 'Retrait de 850 000 F',
     'Vers Airtel Money · 074 00 00 00 · demandé aujourd’hui à 15h42. '
       'Frais de retrait : 0 F (formule Pro).'),
   TimelineSection([
    ('', 'Demande reçue', '15h42'),
    ('', 'Vérification', '15h45'),
    ('', 'Envoi au numéro', 'Sous 30 min'),
   ], title: 'Traitement'),
   BulletSection('Code de suivi', [
    ' RET-2026-0715',
    ' Vous recevrez un SMS de confirmation',
   ]),
  ],
  actions: [
   ExtraAction('', 'Télécharger le reçu', snack: 'Reçu PDF téléchargé (démo) '),
  ],
 ),
 'V-66': ExtraSpec(
  emoji: '',
  title: 'Factures',
  tagline: 'Toutes vos factures Okoumé (abonnement, commission).',
  sections: [
   ListSection([
    ExtraRow('', 'FAC-2026-03 · Mars', subtitle: 'Abonnement Pro + commission', trailing: '45 500 F'),
    ExtraRow('', 'FAC-2026-02 · Février', subtitle: 'Abonnement Pro + commission', trailing: '41 200 F'),
    ExtraRow('', 'FAC-2026-01 · Janvier', subtitle: 'Abonnement Starter', trailing: '12 500 F'),
   ], title: 'Dernières factures'),
  ],
  actions: [
   ExtraAction('', 'Envoyer par email', snack: 'Factures envoyées (démo) '),
  ],
 ),
 'V-67': ExtraSpec(
  emoji: '',
  title: 'Détail Facture',
  tagline: 'Détail complet : abonnement, commission, TVA.',
  sections: [
   TextSection('', 'FAC-2026-03 — 45 500 F',
     'Période : 1–31 mars 2026\n'
       'Abonnement Pro : 15 000 F\n'
       'Commission ventes (2,5 % de 1 180 000 F) : 29 500 F\n'
       'TVA (18 %) incluse : 6 940 F'),
   BulletSection('Paiement', [
    ' Réglée par Airtel Money le 02/04/2026',
    ' Référence : AIR-88F2-1029',
   ]),
  ],
  actions: [
   ExtraAction('⬇️', 'Télécharger le PDF', snack: 'PDF téléchargé (démo) ⬇️'),
  ],
 ),
 'V-68': ExtraSpec(
  emoji: '',
  title: 'Rapports Fiscaux',
  tagline: 'Exports comptables : ventes, commissions, TVA par période.',
  sections: [
   ChartSection('Ventes déclarables (kF, T1)', [
    ('Jan', 980), ('Fév', 1120), ('Mar', 1180),
   ]),
   ListSection([
    ExtraRow('', 'Rapport TVA mars 2026', trailing: 'PDF'),
    ExtraRow('', 'Rapport TVA février 2026', trailing: 'PDF'),
    ExtraRow('', 'Export Excel T1 2026', trailing: 'XLS'),
   ], title: 'Documents'),
  ],
  actions: [
   ExtraAction('', 'Générer le rapport du mois',
     snack: 'Rapport fiscal généré (démo) '),
  ],
 ),
 'V-69': ExtraSpec(
  emoji: '',
  title: 'Abonnement Vendeur',
  tagline: 'Votre formule, son coût et sa prochaine échéance.',
  sections: [
   ProgressSection('Formule Pro — 15 000 F/mois', [
    ('Renouvellement le 30/04', 0.63, '19 j restants'),
   ]),
   BulletSection('Inclus dans Pro', [
    '️ 0 % de commission sur les 50 premières ventes du mois',
    ' Mise en vedette offerte : 2 produits',
    ' Analytics avancés et exports fiscaux',
   ]),
   LinkSection([
    ExtraRow('', 'Comparer les formules', route: '/screen/V-70'),
   ]),
  ],
  actions: [
   ExtraAction('', 'Renouveler maintenant',
     snack: 'Renouvellement simulé (démo) '),
  ],
 ),
 'V-70': ExtraSpec(
  emoji: '',
  title: 'Choisir Formule',
  tagline: 'Gratuit, Starter ou Pro : trouvez la formule à votre mesure.',
  sections: [
   ListSection([
    ExtraRow('🆓', 'Gratuit — 0 F', subtitle: '3 produits · commission 5 %', trailing: 'Réduire'),
    ExtraRow('', 'Starter — 7 500 F/mois', subtitle: '20 produits · commission 3 %', trailing: 'Choisir'),
    ExtraRow('', 'Pro — 15 000 F/mois', subtitle: 'Illimité · commission 2 %', trailing: 'Actuelle'),
   ], title: 'Formules'),
   TextSection('', 'Exemple',
     'Avec 500 000 F de ventes : Gratuit = 25 000 F de commission ; '
       'Pro = 15 000 F + 10 000 F = 25 000 F… mais avec les outils de vente '
       'en plus. Le Pro gagne dès 800 000 F de ventes mensuelles.'),
  ],
 ),
 'V-71': ExtraSpec(
  emoji: '',
  title: 'Paiement Abonnement',
  tagline: 'Renouvelez ou changez de formule en un tap.',
  sections: [
   ListSection([
    ExtraRow('', 'Airtel Money', subtitle: 'Prélèvement le 30 de chaque mois', trailing: 'Actif'),
    ExtraRow('', 'Moov Money', snack: 'Moov sélectionné '),
    ExtraRow('', 'Carte bancaire', snack: 'Carte sélectionnée '),
   ], title: 'Moyen de paiement'),
   TextSection('', 'Rappel',
     'Vous serez prévenu 3 jours avant chaque échéance. '
       'Sans paiement, la boutique passe en formule Gratuite — '
       'aucune vente n’est perdue.'),
  ],
  actions: [
   ExtraAction('', 'Payer 15 000 F maintenant',
     snack: 'Paiement d’abonnement simulé (démo) '),
  ],
 ),
 'V-72': ExtraSpec(
  emoji: '',
  title: 'Avantages Formule',
  tagline: 'Ce que votre formule Pro vous apporte concrètement.',
  sections: [
   StatSection([
    ('', '37 000 F', 'Économisés ce mois'),
    ('', '2', 'Boosts offerts'),
    ('', '4', 'Rapports avancés'),
   ]),
   BulletSection('Vos avantages actifs', [
    '️ Commission réduite à 2 % (−3 % vs Gratuit)',
    ' 2 mises en vedette offertes (valeur 10 000 F)',
    ' Support prioritaire < 2 h',
    ' Analytics et exports fiscaux avancés',
   ]),
  ],
 ),
 'V-74': ExtraSpec(
  emoji: '',
  title: 'Modifier Boutique',
  tagline: 'Nom, description, logo, bannière et couleur d’accent.',
  sections: [
   FormSection(
    title: 'Identité de la boutique',
    fields: [
     ('', 'Nom de la boutique'),
     ('', 'Description (2–3 phrases)'),
     ('', 'Couleur d’accent'),
    ],
    submitLabel: 'Enregistrer',
    success: 'Boutique mise à jour (démo) ',
   ),
   BulletSection('Visuels', [
    '️ Logo carré — 512×512 px minimum',
    '️ Bannière — 1200×400 px',
    ' Photos réelles : +38 % de confiance acheteurs',
   ]),
  ],
  actions: [
   ExtraAction('️', 'Changer le logo', snack: 'Sélecteur d’image simulé ️'),
  ],
 ),
 'V-75': ExtraSpec(
  emoji: '',
  title: 'Horaires Ouverture',
  tagline: 'Indiquez quand vos clients peuvent vous joindre et retirer.',
  sections: [
   ToggleSection([
    ('', 'Lundi – Vendredi · 8h – 18h', true),
    ('', 'Samedi · 9h – 14h', true),
    ('', 'Dimanche', false),
   ], title: 'Jours d’ouverture'),
   TextSection('', 'Hors horaires',
     'Les commandes passées hors horaires sont acceptées normalement : '
       'elles s’affichent « à préparer » le lendemain matin. '
       'Le badge « Répond en < 1 h » n’est compté que sur vos horaires.'),
  ],
 ),
 'V-76': ExtraSpec(
  emoji: '↩️',
  title: 'Rédiger Politique Retour',
  tagline: 'Votre politique de retour, affichée sur chaque fiche produit.',
  sections: [
   FormSection(
    title: 'Politique de retour',
    fields: [
     ('⏱️', 'Délai accepté (ex. 7 jours)'),
     ('', 'État exigé (ex. emballage d’origine)'),
     ('', 'Frais de retour (vendeur / client / partagés)'),
    ],
    submitLabel: 'Publier la politique',
    success: 'Politique publiée sur vos fiches (démo) ↩️',
   ),
   BulletSection('Modèles suggérés', [
    ' Flexible : 14 jours, retour offert — +21 % de conversion',
    '️ Standard : 7 jours, frais partagés',
    ' Strict : 3 jours, emballage scellé',
   ]),
  ],
 ),
 'V-77': ExtraSpec(
  emoji: '',
  title: 'À Propos Boutique',
  tagline: 'Racontez votre histoire : origine, valeurs, équipe.',
  sections: [
   FormSection(
    title: 'Votre histoire',
    fields: [
     ('', 'Qui êtes-vous ? (ex. artisan à Bikele depuis 2018)'),
     ('', 'Vos valeurs (qualité, made in Gabon, prix justes…)'),
     ('', 'Votre équipe (optionnel)'),
    ],
    submitLabel: 'Publier la page',
    success: 'Page « À propos » publiée (démo) ',
   ),
   TextSection('', 'Pourquoi ça compte',
     'Les boutiques avec une histoire complète inspirent plus confiance : '
       '+34 % d’ajout au panier constaté sur la plateforme.'),
  ],
 ),
 'V-78': ExtraSpec(
  emoji: '',
  title: 'Avis Clients (Vendeur)',
  tagline: 'Tous les avis reçus, filtrables par note et par produit.',
  sections: [
   ProgressSection('Répartition — 4,8 sur 214 avis', [
    ('5 étoiles', 0.82, '175'),
    ('4 étoiles', 0.12, '26'),
    ('3 étoiles', 0.04, '8'),
    ('≤ 2 étoiles', 0.02, '5'),
   ]),
   ListSection([
    ExtraRow('', '« Emballage soigné »', subtitle: 'Aline N. · hier · commande vérifiée', trailing: 'Répondre'),
    ExtraRow('', '« Rapide mais boîte abîmée »', subtitle: 'Jean-P. M. · il y a 3 j', trailing: 'Répondre'),
    ExtraRow('', '« Taille trop petite »', subtitle: 'Synthia O. · il y a 5 j', trailing: 'Répondre'),
   ], title: 'Derniers avis'),
  ],
  actions: [
   ExtraAction('', 'Remercier les 5 étoiles',
     snack: 'Message de remerciement envoyé (démo) '),
  ],
 ),
 'V-79': ExtraSpec(
  emoji: '',
  title: 'Répondre à un Avis',
  tagline: 'Votre réponse est publique : restez courtois et factuel.',
  sections: [
   TextSection('', 'Avis de Jean-P. M. — 4/5',
     '« Produit conforme et livraison rapide, mais la boîte était '
       'légèrement abîmée à l’arrivée. »'),
   FormSection(
    title: 'Votre réponse publique',
    fields: [
     ('', 'Réponse (ex. « Merci ! Nous renforçons nos emballages… »)'),
    ],
    submitLabel: 'Publier la réponse',
    success: 'Réponse publiée — le client est notifié (démo) ',
   ),
   BulletSection('Bonnes pratiques', [
    ' Remerciez toujours, même pour un avis négatif',
    ' Expliquez l’action corrective concrète',
    ' Jamais de données personnelles dans la réponse',
   ]),
  ],
 ),
 'V-80': ExtraSpec(
  emoji: '',
  title: 'Signaler Avis',
  tagline: 'Signalez un avis frauduleux ou contraire aux règles.',
  sections: [
   ListSection([
    ExtraRow('', 'Faux avis / concurrent', snack: 'Motif « faux avis » retenu'),
    ExtraRow('', 'Propos insultants', snack: 'Motif « insultes » retenu'),
    ExtraRow('', 'Spam ou publicité', snack: 'Motif « spam » retenu'),
    ExtraRow('', 'Données personnelles exposées', snack: 'Motif « données » retenu'),
   ], title: 'Motif'),
   FormSection(
    title: 'Détails',
    fields: [
     ('', 'Expliquez pourquoi cet avis pose problème'),
    ],
    submitLabel: 'Signaler à la modération',
    success: 'Signalement transmis — décision sous 48 h (démo) ',
   ),
  ],
 ),
};
