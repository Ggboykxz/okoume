import '../../features/extra/extra_spec.dart';

/// Aperçus du module AD — Admin, partie 1 (AD-01 → AD-38).
/// L’admin complet est un panel web ; l’app mobile en propose un aperçu de démo.
const extraSpecsAd1 = <String, ExtraSpec>{
 'AD-01': ExtraSpec(
  emoji: '',
  title: 'Dashboard Admin',
  tagline: 'KPIs globaux de la plateforme, alertes et activité en direct.',
  sections: [
   StatSection([
    ('', '48,2 M', 'GMV du mois'),
    ('', '12 480', 'Commandes'),
    ('', '86 210', 'Utilisateurs'),
   ]),
   StatSection([
    ('', '1 244', 'Vendeurs actifs'),
    ('', '418', 'Livreurs actifs'),
    ('️', '17', 'Litiges ouverts'),
   ]),
   ListSection([
    ExtraRow('', '3 KYC en attente > 24 h', trailing: 'Traiter'),
    ExtraRow('️', 'Litige #LM-221 en escalade', trailing: 'Prioritaire'),
    ExtraRow('', '2 écarts de réconciliation', trailing: 'Vérifier'),
   ], title: 'Alertes'),
  ],
  actions: [
   ExtraAction('', 'Rapport complet', snack: 'Rapport PDF généré (démo) '),
  ],
 ),
 'AD-02': ExtraSpec(
  emoji: '',
  title: 'Vue Globale Ventes',
  tagline: 'CA temps réel, évolution et comparaison des périodes.',
  sections: [
   StatSection([
    ('', '48,2 M', 'Ce mois'),
    ('', '+21 %', 'vs. mois dernier'),
    ('', '92 %', 'de l’objectif'),
   ]),
   ChartSection('GMV des 7 derniers jours (MF)', [
    ('Lun', 5), ('Mar', 7), ('Mer', 4), ('Jeu', 9),
    ('Ven', 8), ('Sam', 11), ('Dim', 6),
   ]),
   ListSection([
    ExtraRow('', 'Électronique — 42 % du GMV'),
    ExtraRow('', 'Made in Gabon — +38 % ce mois'),
   ], title: 'Catégories moteur'),
  ],
 ),
 'AD-03': ExtraSpec(
  emoji: '️',
  title: 'Carte Thermique Ventes',
  tagline: 'Densité des ventes par zone géographique.',
  sections: [
   MapSection([
    ('', 'Libreville centre', 0.42, 0.42),
    ('', 'Akanda', 0.62, 0.25),
    ('', 'Owendo', 0.55, 0.68),
    ('', 'Bikele', 0.3, 0.6),
    ('', 'Ntoum', 0.82, 0.8),
   ], title: 'Heatmap — mars 2026'),
   ListSection([
    ExtraRow('', 'Libreville — 68 % du GMV'),
    ExtraRow('', 'Owendo — 14 %'),
    ExtraRow('', 'Akanda — 11 %'),
   ], title: 'Part par ville'),
  ],
 ),
 'AD-04': ExtraSpec(
  emoji: '',
  title: 'Utilisateurs Actifs',
  tagline: 'MAU, DAU, rétention et nouveaux inscrits.',
  sections: [
   StatSection([
    ('', '41 220', 'MAU'),
    ('️', '9 840', 'DAU'),
    ('🆕', '3 102', 'Nouveaux ce mois'),
   ]),
   ChartSection('Inscriptions (k)', [
    ('S1', 6), ('S2', 8), ('S3', 7), ('S4', 11),
   ]),
   ProgressSection('Rétention', [
    ('J+1', 0.52, '52 %'),
    ('J+7', 0.34, '34 %'),
    ('J+30', 0.21, '21 %'),
   ]),
  ],
 ),
 'AD-05': ExtraSpec(
  emoji: '',
  title: 'Commandes en Temps Réel',
  tagline: 'Flux live des commandes sur toute la plateforme.',
  sections: [
   TimelineSection([
    ('', 'OK-2026-8842 · 45 000 F · Libreville', 'il y a 12 s'),
    ('', 'OK-2026-8841 · expédiée · Owendo', 'il y a 48 s'),
    ('', 'OK-2026-8840 · livrée · Akanda', 'il y a 2 min'),
    ('', 'OK-2026-8839 · 12 500 F · Bikele', 'il y a 3 min'),
   ], title: 'Live feed'),
   StatSection([
    ('⏱️', '38 s', 'Commande / minute'),
    ('', '31 kF', 'Panier moyen'),
   ]),
  ],
 ),
 'AD-06': ExtraSpec(
  emoji: '',
  title: 'Alertes Système',
  tagline: 'Fraude, litiges, anomalies techniques : tout ce qui remonte.',
  sections: [
   ListSection([
    ExtraRow('', 'Fraude suspectée — comptes liés (3)',
      subtitle: 'Même appareil, 12 comptes', trailing: 'Urgent'),
    ExtraRow('', 'Paiement Airtel non réconcilié',
      subtitle: '2 transactions bloquées', trailing: 'À traiter'),
    ExtraRow('', 'Stock synchronisation lente',
      subtitle: 'Vendeur TechGabon', trailing: 'Surveiller'),
    ExtraRow('', 'Pic de trafic géré', subtitle: 'Black Friday — 100 % uptime'),
   ], title: 'Alertes actives (5)'),
  ],
  actions: [
   ExtraAction('', 'Marquer tout comme traité', snack: 'Alertes acquittées (démo) '),
  ],
 ),
 'AD-07': ExtraSpec(
  emoji: '',
  title: 'Rapports Automatisés',
  tagline: 'Génération périodique des rapports (quotidien, hebdo, mensuel).',
  sections: [
   ListSection([
    ExtraRow('', 'Rapport ventes quotidien', subtitle: 'Envoyé à 6h — équipe direction', trailing: 'Actif'),
    ExtraRow('️', 'Rapport litiges hebdomadaire', subtitle: 'Lundi 8h', trailing: 'Actif'),
    ExtraRow('', 'Rapport fiscal mensuel', subtitle: '1er du mois', trailing: 'Actif'),
   ], title: 'Rapports programmés'),
   FormSection(
    title: 'Nouveau rapport programmé',
    fields: [
     ('', 'Type de rapport'),
     ('', 'Fréquence (quotidien / hebdo / mensuel)'),
     ('', 'Destinataires (emails)'),
    ],
    submitLabel: 'Programmer',
    success: 'Rapport programmé ',
    op: ExtraOp.generateReport,
   ),
  ],
 ),
 'AD-08': ExtraSpec(
  emoji: '',
  title: 'Liste Utilisateurs',
  tagline: 'Tous les utilisateurs : recherche, filtres et actions rapides.',
  sections: [
   FormSection(
    title: 'Rechercher',
    fields: [
     ('', 'Nom, téléphone ou email'),
    ],
    submitLabel: 'Filtrer',
    success: 'Filtre appliqué — 86 210 résultats (démo) ',
   ),
   ListSection([
    ExtraRow('', 'Aline N. · OK-24810', subtitle: 'Acheteuse · Libreville · depuis 2025', trailing: 'Active'),
    ExtraRow('', 'TechGabon · OK-11202', subtitle: 'Vendeur vérifié', trailing: 'Vendeur'),
    ExtraRow('', 'Marc O. · OK-30418', subtitle: 'Livreur · 4,9 ', trailing: 'Livreur'),
    ExtraRow('', 'Anonyme · OK-88121', subtitle: 'Compte signalé 2 fois', trailing: '️'),
   ], title: 'Résultats'),
  ],
 ),
 'AD-09': ExtraSpec(
  emoji: '',
  title: 'Détail Utilisateur',
  tagline: 'Profil complet, historique et état du compte.',
  sections: [
   TextSection('', 'Aline N. — OK-24810',
     'Acheteuse · Libreville (Akébé) · inscrite le 12/03/2025\n'
       'Téléphone : 074 00 00 00 · Email : aline.n@mail.ga\n'
       '8 commandes · 412 000 F · 0 litige'),
   TimelineSection([
    ('', 'Dernière commande', 'Il y a 2 jours'),
    ('', 'Avis laissés', '7 avis · moyenne 4,8'),
    ('', 'Notifications ouvertes', '68 %'),
   ], title: 'Activité'),
   ToggleSection([
    ('️', 'Notifications marketing', true),
    ('', 'Compte actif', true),
   ], title: 'État du compte'),
  ],
  actions: [
   ExtraAction('', 'Suspendre', snack: 'Suspension préparée — motif requis (démo) '),
   ExtraAction('️', 'Ouvrir l’historique complet', snack: 'Journal détaillé ouvert (démo)'),
  ],
 ),
 'AD-10': ExtraSpec(
  emoji: '',
  title: 'Vérification KYC',
  tagline: 'File d’attente des dossiers KYC à valider (vendeurs et livreurs).',
  sections: [
   StatSection([
    ('⏳', '7', 'En attente'),
    ('⏱️', '4,2 h', 'Délai moyen'),
    ('', 'SLA', '< 24 h'),
   ]),
   ListSection([
    ExtraRow('', 'Nguema Fashion · vendeur', subtitle: 'CNI + patente reçues', trailing: 'À valider'),
    ExtraRow('', 'Ibrahim K. · livreur', subtitle: 'CNI + permis + assurance', trailing: 'À valider'),
    ExtraRow('', 'Mama Mavoungou · vendeur', subtitle: 'Dossier incomplet (NIF manquant)', trailing: 'Bloqué'),
   ], title: 'Dossiers en attente'),
  ],
  actions: [
   ExtraAction('', 'Prendre le dossier prioritaire',
     route: '/screen/AD-11'),
  ],
 ),
 'AD-11': ExtraSpec(
  emoji: '',
  title: 'Valider KYC',
  tagline: 'Vérifier chaque pièce puis approuver le dossier.',
  sections: [
   BulletSection('Documents du dossier — Ibrahim K.', [
    ' CNI recto/verso — lisible ',
    ' Permis A — valide jusqu’en 2028 ',
    ' Carte grise moto GT-4521 ',
    '️ Attestation d’assurance ',
    ' Selfie correspondant à la CNI ',
   ]),
   ToggleSection([
    ('', 'Contrôle anti-doublon effectué', true),
    ('', 'Numéro non blacklisté', true),
   ], title: 'Vérifications'),
  ],
  actions: [
   ExtraAction('', 'Approuver le dossier',
     op: ExtraOp.kycApprove,
     snack: 'Ibrahim K. validé — notification envoyée '),
   ExtraAction('', 'Rejeter',
     op: ExtraOp.kycReject, snack: 'Rejet enregistré — motif notifié '),
  ],
 ),
 'AD-12': ExtraSpec(
  emoji: '',
  title: 'Rejeter KYC',
  tagline: 'Refuser un dossier avec un motif clair pour l’utilisateur.',
  sections: [
   ListSection([
    ExtraRow('️', 'Documents illisibles', snack: 'Motif « lisibilité » retenu'),
    ExtraRow('', 'Document expiré', snack: 'Motif « expiré » retenu'),
    ExtraRow('', 'Incohérence entre les pièces', snack: 'Motif « incohérence » retenu'),
    ExtraRow('', 'Dossier en doublon', snack: 'Motif « doublon » retenu'),
   ], title: 'Motif du rejet'),
   FormSection(
    title: 'Message à l’utilisateur',
    fields: [
     ('', 'Explication (ex. « reprenez la photo de votre CNI »)'),
    ],
    submitLabel: 'Rejeter et notifier',
    success: 'Dossier rejeté — l’utilisateur peut resoumettre ',
    op: ExtraOp.kycReject,
   ),
  ],
 ),
 'AD-13': ExtraSpec(
  emoji: '⏸️',
  title: 'Suspendre Utilisateur',
  tagline: 'Bloquer temporairement un compte (enquête en cours).',
  sections: [
   FormSection(
    title: 'Suspension',
    fields: [
     ('⏱️', 'Durée (24 h, 7 j, 30 j ou jusqu’à décision)'),
     ('', 'Motif interne'),
    ],
    submitLabel: 'Suspendre le compte',
    success: 'Compte suspendu — connexion bloquée (démo) ⏸️',
   ),
   BulletSection('Effets immédiats', [
    ' Connexion impossible',
    ' Commandes en cours maintenues (les clients ne sont pas pénalisés)',
    ' Retraits gelés pendant la suspension',
   ]),
  ],
 ),
 'AD-14': ExtraSpec(
  emoji: '',
  title: 'Bannir Utilisateur',
  tagline: 'Bannissement définitif — action irréversible et journalisée.',
  sections: [
   ListSection([
    ExtraRow('', 'Fraude avérée', snack: 'Motif « fraude » retenu'),
    ExtraRow('', 'Colis non conformes répétés', snack: 'Motif « conformité » retenu'),
    ExtraRow('', 'Comportement abusif envers livreurs', snack: 'Motif « abus » retenu'),
   ], title: 'Motif du bannissement'),
   TextSection('️', 'Conséquences',
     'Le compte ne peut plus se connecter ni créer de nouveau compte '
       'avec le même numéro. Les fonds en séquestre sont gérés par '
       'l’équipe financière. Action tracée dans les logs.'),
  ],
  actions: [
   ExtraAction('', 'Confirmer le bannissement',
     snack: 'Bannissement exécuté et journalisé (démo) '),
  ],
 ),
 'AD-15': ExtraSpec(
  emoji: '',
  title: 'Liste Vendeurs',
  tagline: 'Tous les vendeurs : statut, note, volume et alertes.',
  sections: [
   ListSection([
    ExtraRow('', 'TechGabon', subtitle: '4,9 · 12,4k ventes · vérifié', trailing: '48,2 M F'),
    ExtraRow('', 'Nguema Fashion', subtitle: '4,8 · 7,1k ventes · vérifié', trailing: '31,4 M F'),
    ExtraRow('', 'Mama Mavoungou', subtitle: '4,9 · 5,8k ventes · vérifié', trailing: '18,9 M F'),
    ExtraRow('️', 'Gadget Express', subtitle: '3,1 · 2 litiges ouverts', trailing: 'Surveiller'),
   ], title: '1 244 vendeurs actifs — top 4'),
  ],
  actions: [
   ExtraAction('', 'Exporter la liste', snack: 'Liste exportée en CSV (démo) '),
  ],
 ),
 'AD-16': ExtraSpec(
  emoji: '',
  title: 'Détail Vendeur',
  tagline: 'Boutique, statistiques, alertes et actions de modération.',
  sections: [
   TextSection('', 'TechGabon — s2',
     'Électronique · Libreville · vérifié depuis 2024\n'
       '4,9 sur 1 208 avis · temps de réponse < 30 min'),
   StatSection([
    ('', '48,2 M F', 'GMV 12 mois'),
    ('', '12 400', 'Commandes'),
    ('️', '0,4 %', 'Taux litige'),
   ]),
   ListSection([
    ExtraRow('', 'Croissance +32 % vs. trimestre -1', trailing: 'OK'),
    ExtraRow('', '2 produits signalés (contrefaçon présumée)', trailing: 'Voir'),
   ], title: 'Alertes'),
  ],
  actions: [
   ExtraAction('', 'Attribuer le label « Élite »', snack: 'Label Élite attribué (démo) '),
   ExtraAction('', 'Suspendre la boutique', snack: 'Suspension préparée (démo)'),
  ],
 ),
 'AD-17': ExtraSpec(
  emoji: '',
  title: 'Valider Boutique',
  tagline: 'Approbation d’une nouvelle boutique avant mise en ligne.',
  sections: [
   BulletSection('Contrôle qualité', [
    '️ Logo et bannière conformes aux règles',
    ' Description claire et honnête',
    ' Au moins 3 produits complets',
    ' Pas de marques interdites ou copies',
   ]),
   FormSection(
    title: 'Décision',
    fields: [
     ('', 'Commentaire interne (optionnel)'),
    ],
    submitLabel: 'Approuver la boutique',
    success: 'Boutique approuvée — visible par les acheteurs (démo) ',
   ),
  ],
  actions: [
   ExtraAction('', 'Demander des modifications',
     snack: 'Retour envoyé au vendeur (démo) '),
  ],
 ),
 'AD-18': ExtraSpec(
  emoji: '',
  title: 'Liste Livreurs',
  tagline: 'Tous les livreurs : note, courses, statut.',
  sections: [
   ListSection([
    ExtraRow('', 'Marc O. · GT-4521', subtitle: '4,9 · 1 248 courses · moto', trailing: 'Disponible'),
    ExtraRow('', 'Ibrahim K. · GT-8830', subtitle: '4,8 · 902 courses · moto', trailing: 'En course'),
    ExtraRow('', 'Synthia O. · GT-2214', subtitle: '4,9 · 815 courses · voiture', trailing: 'Disponible'),
    ExtraRow('️', 'Paul M. · GT-6712', subtitle: '3,4 · 2 incidents signalés', trailing: 'Surveiller'),
   ], title: '418 livreurs actifs — top 4'),
  ],
 ),
 'AD-19': ExtraSpec(
  emoji: '‍️',
  title: 'Détail Livreur',
  tagline: 'Performance, documents et historique d’un livreur.',
  sections: [
   ProgressSection('Marc O. — score 92/100', [
    ('Ponctualité', 0.95, '95 %'),
    ('Acceptation', 0.88, '88 %'),
    ('Satisfaction client', 0.96, '4,9 '),
   ]),
   ListSection([
    ExtraRow('', 'Documents valides', subtitle: 'CNI, permis, assurance', trailing: 'OK'),
    ExtraRow('️', 'Aucun litige', subtitle: 'Dernier incident : jamais'),
   ], title: 'Dossier'),
  ],
  actions: [
   ExtraAction('', 'Bonus performance', snack: 'Bonus 25 000 F attribué (démo) '),
  ],
 ),
 'AD-20': ExtraSpec(
  emoji: '',
  title: 'Valider Livreur',
  tagline: 'Approbation finale d’une inscription livreur.',
  sections: [
   BulletSection('Contrôles', [
    ' Identité vérifiée (selfie ↔ CNI)',
    ' Permis adapté au véhicule',
    '️ Assurance valide',
    ' Quiz géographique réussi (≥ 7/10)',
   ]),
  ],
  actions: [
   ExtraAction('', 'Activer le compte livreur',
     snack: 'Compte activé — le livreur peut recevoir des courses (démo) '),
   ExtraAction('', 'Demander un complément', snack: 'SMS envoyé au livreur (démo) '),
  ],
 ),
 'AD-21': ExtraSpec(
  emoji: '️',
  title: 'Liste Produits',
  tagline: 'Tous les produits de la plateforme avec filtres.',
  sections: [
   StatSection([
    ('', '18 402', 'Produits actifs'),
    ('🆕', '312', 'Ajoutés cette semaine'),
    ('', '23', 'Signalés'),
   ]),
   ListSection([
    ExtraRow('', 'Écouteurs ProSound · s2', subtitle: '4,8 · 1 120 ventes', trailing: '24 500 F'),
    ExtraRow('', 'Robe pagne wax · s5', subtitle: '4,9 · 860 ventes', trailing: '26 000 F'),
    ExtraRow('', '« iPhone 15 » · s9', subtitle: 'Prix anormalement bas — vérif.', trailing: '️'),
   ], title: 'Produits (extrait)'),
  ],
 ),
 'AD-22': ExtraSpec(
  emoji: '',
  title: 'Détail Produit Admin',
  tagline: 'Vue admin d’une fiche : qualité, signalements, historique.',
  sections: [
   TextSection('', 'Écouteurs ProSound — p1',
     'Vendeur : TechGabon (s2) · catégorie : Audio\n'
       'Prix : 24 500 F · stock 34 · 4,8 (212 avis)\n'
       'Mise en ligne : il y a 8 mois'),
   ListSection([
    ExtraRow('', 'Photos conformes (4)', trailing: 'OK'),
    ExtraRow('', 'Description vérifiée', trailing: 'OK'),
    ExtraRow('', '0 signalement', trailing: 'OK'),
   ], title: 'Contrôle fiche'),
  ],
  actions: [
   ExtraAction('', 'Mettre en avant sur la home', snack: 'Produit épinglé 7 jours (démo) '),
  ],
 ),
 'AD-23': ExtraSpec(
  emoji: '️',
  title: 'Modérer Produit',
  tagline: 'Approuver, corriger ou retirer une fiche produit.',
  sections: [
   ListSection([
    ExtraRow('', 'Approuver', subtitle: 'La fiche reste en ligne', snack: 'Produit approuvé '),
    ExtraRow('️', 'Demander une correction', subtitle: 'Photos, prix ou description', snack: 'Demande envoyée au vendeur ️'),
    ExtraRow('⏸️', 'Suspendre la fiche', subtitle: 'Invisible le temps du contrôle', snack: 'Fiche suspendue ⏸️'),
    ExtraRow('️', 'Retirer définitivement', subtitle: 'Contrefaçon avérée', snack: 'Retrait journalisé (démo) ️'),
   ], title: 'Actions de modération'),
   FormSection(
    title: 'Note interne',
    fields: [
     ('', 'Contexte de la décision'),
    ],
    submitLabel: 'Enregistrer la note',
    success: 'Note ajoutée au dossier (démo) ',
   ),
  ],
 ),
 'AD-24': ExtraSpec(
  emoji: '',
  title: 'Produits Signalés',
  tagline: 'File des signalements produits à traiter.',
  sections: [
   ListSection([
    ExtraRow('', '« iPhone 15 Pro » — contrefaçon présumée',
      subtitle: '3 signalements · vendeur s9', trailing: 'Urgent'),
    ExtraRow('️', '« Montre luxe » — photos volées',
      subtitle: '2 signalements', trailing: 'À traiter'),
    ExtraRow('️', '« Complément minceur » — produit interdit',
      subtitle: '1 signalement', trailing: 'Urgent'),
   ], title: 'Signalements actifs (6)'),
   TextSection('⏱️', 'SLA modération',
     'Les signalements « danger » et « contrefaçon » doivent être traités '
       'sous 4 h ; les autres sous 48 h.'),
  ],
 ),
 'AD-25': ExtraSpec(
  emoji: '️',
  title: 'Gestion Catégories',
  tagline: 'Créer, renommer, réordonner les catégories de la plateforme.',
  sections: [
   ListSection([
    ExtraRow('', 'Électronique', subtitle: '4 sous-catégories · 6 218 produits', trailing: 'Éditer'),
    ExtraRow('', 'Mode', subtitle: '6 sous-catégories · 5 402 produits', trailing: 'Éditer'),
    ExtraRow('', 'Maison', subtitle: '5 sous-catégories · 3 110 produits', trailing: 'Éditer'),
    ExtraRow('', 'Made in Gabon', subtitle: '3 sous-catégories · 1 240 produits', trailing: 'Éditer'),
   ], title: 'Catégories principales'),
  ],
  actions: [
   ExtraAction('', 'Ajouter une catégorie', snack: 'Formulaire ouvert (démo) '),
  ],
 ),
 'AD-26': ExtraSpec(
  emoji: '',
  title: 'Ajouter Catégorie',
  tagline: 'Nouvelle catégorie avec emoji, couleur et attributs.',
  sections: [
   FormSection(
    title: 'Nouvelle catégorie',
    fields: [
     ('️', 'Nom (ex. « Sport & Loisirs »)'),
     ('', 'Emoji'),
     ('', 'Couleur'),
     ('', 'Attributs (marque, taille…)'),
    ],
    submitLabel: 'Créer la catégorie',
    success: 'Catégorie créée — visible par les vendeurs ',
    op: ExtraOp.createCategory,
   ),
  ],
 ),
 'AD-27': ExtraSpec(
  emoji: '',
  title: 'Attributs Produits',
  tagline: 'Champs dynamiques par catégorie (taille, garantie, matière…).',
  sections: [
   ToggleSection([
    ('', 'Mode : taille, couleur, matière', true),
    ('️', 'Électronique : garantie, marque', true),
    ('', 'Maison : dimensions, poids', true),
    ('', 'Made in Gabon : producteur, région', true),
   ], title: 'Attributs actifs'),
   FormSection(
    title: 'Nouvel attribut',
    fields: [
     ('️', 'Catégorie'),
     ('', 'Nom de l’attribut'),
     ('', 'Type (texte, nombre, liste)'),
    ],
    submitLabel: 'Ajouter',
    success: 'Attribut ajouté (démo) ',
   ),
  ],
 ),
 'AD-28': ExtraSpec(
  emoji: '️',
  title: 'Bannières Home',
  tagline: 'Gérez les bannières du carrousel d’accueil.',
  sections: [
   ListSection([
    ExtraRow('', 'Black Friday — jusqu’à −60 %', subtitle: 'Du 24/11 au 30/11 · toutes villes', trailing: 'Programmée'),
    ExtraRow('', 'Made in Gabon Days', subtitle: 'Chaque 1er week-end · ciblage local', trailing: 'Active'),
    ExtraRow('', 'Livraison offerte dès 50 000 F', subtitle: 'Bannière permanente', trailing: 'Active'),
   ], title: 'Bannières (3)'),
  ],
  actions: [
   ExtraAction('', 'Nouvelle bannière', route: '/screen/AD-29'),
   ExtraAction('', 'Stats de clic', snack: 'CTR moyen : 4,2 % (démo) '),
  ],
 ),
 'AD-29': ExtraSpec(
  emoji: '',
  title: 'Ajouter Bannière',
  tagline: 'Visuel + ciblage + programmation.',
  sections: [
   FormSection(
    title: 'Nouvelle bannière',
    fields: [
     ('️', 'Titre et sous-titre'),
     ('', 'Dates de diffusion'),
     ('', 'Ciblage (villes, catégories, tous)'),
     ('', 'Lien au clic'),
    ],
    submitLabel: 'Programmer la bannière',
    success: 'Bannière programmée ',
    op: ExtraOp.createBanner,
   ),
   TextSection('', 'Format',
     '1200×500 px · JPG/PNG < 300 Ko · '
       'Le texte doit rester lisible sur mobile.'),
  ],
 ),
 'AD-30': ExtraSpec(
  emoji: '',
  title: 'Toutes les Commandes',
  tagline: 'Vue globale des commandes avec filtres avancés.',
  sections: [
   StatSection([
    ('', '12 480', 'Ce mois'),
    ('', '312', 'En cours'),
    ('️', '17', 'En litige'),
   ]),
   ListSection([
    ExtraRow('', 'OK-2026-0110 · en livraison', subtitle: 'Libreville · Marc O.', trailing: '56 000 F'),
    ExtraRow('️', 'OK-2026-0107 · litige', subtitle: 'Owendo · article manquant', trailing: '45 000 F'),
    ExtraRow('', 'OK-2026-0104 · livrée', subtitle: 'Akanda', trailing: '45 000 F'),
   ], title: 'Dernières commandes'),
  ],
 ),
 'AD-31': ExtraSpec(
  emoji: '',
  title: 'Détail Commande Admin',
  tagline: 'Vue complète : lignes, paiement, acteurs, événements.',
  sections: [
   TimelineSection([
    ('', 'Commande créée', 'Hier 09h12'),
    ('', 'Paiement séquestré (Airtel)', 'Hier 09h13'),
    ('', 'Préparée par le vendeur', 'Hier 11h40'),
    ('', 'En livraison — Marc O.', 'Aujourd’hui 13h02'),
   ], title: 'OK-2026-0110'),
   BulletSection('Détails', [
    ' Cliente : Aline N. · Akébé',
    ' Vendeur : TechGabon',
    ' Paiement : Airtel Money — 56 000 F séquestrés',
    ' OTP de livraison : 4821',
   ]),
  ],
  actions: [
   ExtraAction('', 'Forcer le remboursement',
     snack: 'Remboursement admin préparé (démo) '),
   ExtraAction('', 'Exporter la commande', snack: 'Export PDF généré (démo) '),
  ],
 ),
 'AD-32': ExtraSpec(
  emoji: '️',
  title: 'Litiges',
  tagline: 'Toutes les réclamations en cours, triées par priorité.',
  sections: [
   StatSection([
    ('', '17', 'Ouverts'),
    ('⏱️', '31 h', 'Âge moyen'),
    ('', '94 %', 'Résolus < 72 h'),
   ]),
   ListSection([
    ExtraRow('', 'LM-221 · « article manquant »', subtitle: 'Aline N. ↔ TechGabon', trailing: '24 h'),
    ExtraRow('⏳', 'LM-219 · « délai trop long »', subtitle: 'Jean-P. M. ↔ Nguema Fashion', trailing: '2 j'),
    ExtraRow('️', 'LM-214 · « produit non conforme »', subtitle: 'Escaladé — médiation', trailing: '5 j'),
   ], title: 'File des litiges'),
  ],
  actions: [
   ExtraAction('‍️', 'Médiation du premier litige',
     route: '/screen/AD-33'),
  ],
 ),
 'AD-33': ExtraSpec(
  emoji: '‍️',
  title: 'Médiation Litige',
  tagline: 'Arbitrer : examiner les preuves et rendre une décision.',
  sections: [
   TimelineSection([
    ('', 'Réclamation cliente', 'Hier 14h02'),
    ('', 'Réponse vendeur proposée', 'Hier 16h20'),
    ('', 'Preuves : photos, suivi', 'Ajoutées'),
    ('️', 'Décision du médiateur', 'Attendue'),
   ], title: 'Dossier LM-221'),
   FormSection(
    title: 'Décision',
    fields: [
     ('️', 'Sens (client / vendeur / partage 50-50)'),
     ('', 'Justification'),
    ],
    submitLabel: 'Rendre la décision',
    success: 'Décision exécutée — fonds répartis automatiquement ️',
    op: ExtraOp.disputeDecide,
   ),
  ],
 ),
 'AD-34': ExtraSpec(
  emoji: '',
  title: 'Remboursements',
  tagline: 'Suivi et déclenchement des remboursements.',
  sections: [
   StatSection([
    ('', '142', 'Ce mois'),
    ('', '3,1 M F', 'Montant total'),
    ('', '38 min', 'Délai moyen'),
   ]),
   ListSection([
    ExtraRow('', 'RM-812 · OK-2026-0092', subtitle: 'Rupture vendeur · Airtel', trailing: 'En cours'),
    ExtraRow('', 'RM-811 · OK-2026-0088', subtitle: 'Retour accepté · Moov', trailing: 'Effectué'),
   ], title: 'Derniers remboursements'),
  ],
  actions: [
   ExtraAction('', 'Relancer les en cours', snack: 'Relance envoyée aux opérateurs (démo) '),
  ],
 ),
 'AD-35': ExtraSpec(
  emoji: '',
  title: 'Transactions Financières',
  tagline: 'Toutes les transactions : paiements, séquestres, reversements.',
  sections: [
   ChartSection('Volume quotidien (MF)', [
    ('Lun', 4), ('Mar', 6), ('Mer', 5), ('Jeu', 8),
    ('Ven', 7), ('Sam', 9), ('Dim', 5),
   ]),
   ListSection([
    ExtraRow('', 'Airtel Money — 62 %', subtitle: 'Encaissements du mois'),
    ExtraRow('', 'Moov Money — 24 %', subtitle: 'Encaissements du mois'),
    ExtraRow('', 'Carte bancaire — 11 %'),
    ExtraRow('', 'Cash à la livraison — 3 %'),
   ], title: 'Répartition par moyen'),
  ],
 ),
 'AD-36': ExtraSpec(
  emoji: '',
  title: 'Détail Transaction (Admin)',
  tagline: 'Infos complètes d’une transaction financière.',
  sections: [
   TextSection('', 'TXN-88412 — 56 000 F',
     'Type : paiement client (séquestre)\n'
       'Moyen : Airtel Money · réf. AIR-88F2-1029\n'
       'Commande : OK-2026-0110 (Aline N.)\n'
       'Statut : séquestré · libération : à la livraison'),
   BulletSection('Écritures', [
    ' Commission plateforme : 1 400 F (2,5 %)',
    ' Part vendeur : 54 600 F (après livraison)',
    ' Part livreur : à la course #3412 — 2 500 F',
   ]),
  ],
 ),
 'AD-37': ExtraSpec(
  emoji: '',
  title: 'Réconciliation',
  tagline: 'Matching automatique avec les relevés Airtel / Moov.',
  sections: [
   StatSection([
    ('', '99,7 %', 'Taux de matching'),
    ('️', '2', 'Écarts ouverts'),
    ('', '6h', 'Dernier import'),
   ]),
   ListSection([
    ExtraRow('️', 'Airtel · 2 transactions sans commande',
      subtitle: '28 000 F et 12 500 F · 14/03', trailing: 'Inspecter'),
    ExtraRow('', 'Moov · 412 transactions matchées', subtitle: '0 écart'),
   ], title: 'Écarts du jour'),
  ],
  actions: [
   ExtraAction('', 'Relancer le matching', snack: 'Matching relancé — 0 nouvel écart (démo) '),
  ],
 ),
 'AD-38': ExtraSpec(
  emoji: '',
  title: 'Retraits Vendeurs',
  tagline: 'Demandes de retrait des vendeurs en attente de traitement.',
  sections: [
   ListSection([
    ExtraRow('', 'TechGabon — 850 000 F', subtitle: 'Vers Airtel Money · demandé il y a 1 h', trailing: 'À traiter'),
    ExtraRow('', 'Nguema Fashion — 320 000 F', subtitle: 'Vers Moov Money · demandé il y a 3 h', trailing: 'À traiter'),
    ExtraRow('', 'Mama Mavoungou — 150 000 F', subtitle: 'Vers banque BGFI · vérif. renforcée', trailing: 'Contrôle'),
   ], title: 'Demandes en attente'),
  ],
  actions: [
   ExtraAction('', 'Traiter la première', route: '/screen/AD-39'),
  ],
 ),
};
