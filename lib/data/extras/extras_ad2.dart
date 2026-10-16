import '../../features/extra/extra_spec.dart';

/// Aperçus du module AD — Admin, partie 2 (AD-39 AD-75).
const extraSpecsAd2 = <String, ExtraSpec>{
 'AD-39': ExtraSpec(
 emoji: '',
 title: 'Traiter Retrait (Vendeur)',
 tagline: 'Valider ou rejeter une demande de retrait vendeur.',
 sections: [
  TextSection('', 'TechGabon — 850 000 F',
   'Vers Airtel Money 074 00 00 00\n'
    'Solde disponible : 1 120 000 F aucune anomalie de compte.'),
  BulletSection('Contrôles automatiques', [
  ' Solde suffisant',
  ' Aucun litige bloquant',
  ' Compte KYC vérifié',
  ' Pas de retrait en doublon (< 24 h)',
  ]),
 ],
 actions: [
  ExtraAction('', 'Approuver et envoyer',
   op: ExtraOp.withdrawalApprove,
   target: 'vendeur',
   snack: 'Retrait exécuté — vendeur notifié '),
  ExtraAction('', 'Rejeter avec motif',
   snack: 'Rejet motivé préparé (démo) '),
 ],
 ),
 'AD-40': ExtraSpec(
 emoji: '',
 title: 'Retraits Livreurs',
 tagline: 'Demandes de retrait des livreurs en attente.',
 sections: [
  ListSection([
  ExtraRow('', 'Marc O. — 120 000 F', subtitle: 'Vers Moov Money demandé il y a 20 min', trailing: 'À traiter'),
  ExtraRow('', 'Synthia O. — 85 000 F', subtitle: 'Vers Airtel Money demandé il y a 1 h', trailing: 'À traiter'),
  ], title: 'Demandes en attente'),
  TextSection('', 'Fonds éligibles',
   'Seuls les gains de courses terminées (hors litige) sont retirables. '
    'Les primes du mois sont créditées le 1er.'),
 ],
 actions: [
  ExtraAction('', 'Traiter le premier retrait',
   route: '/screen/AD-41'),
 ],
 ),
 'AD-41': ExtraSpec(
 emoji: '',
 title: 'Traiter Retrait (Livreur)',
 tagline: 'Valider un retrait livreur — paiement sous 15 min.',
 sections: [
  TextSection('', 'Marc O. — 120 000 F',
   'Vers Moov Money 074 00 00 00\n'
    'Gains disponibles : 148 500 F score 92/100.'),
  FormSection(
  title: 'Décision',
  fields: [
   ('', 'Commentaire (optionnel)'),
  ],
  submitLabel: 'Approuver le retrait',
  success: 'Retrait approuvé — virement opérateur en cours ',
  op: ExtraOp.withdrawalApprove,
  target: 'livreur',
  ),
 ],
 ),
 'AD-42': ExtraSpec(
 emoji: '',
 title: 'Suivi Livraisons',
 tagline: 'Carte temps réel de toutes les courses actives.',
 sections: [
  MapSection([
  ('', '#3412 Owendo', 0.5, 0.4),
  ('', '#3413 Akanda', 0.68, 0.25),
  ('', '#3415 Bikele', 0.35, 0.66),
  ('', '#3417 Mont-Bouët', 0.55, 0.55),
  ], title: '4 courses actives'),
  StatSection([
  ('', '4', 'En cours'),
  ('', '18 min', 'ETA moyen'),
  ('', '312', 'Livrées aujourd’hui'),
  ]),
 ],
 ),
 'AD-43': ExtraSpec(
 emoji: '',
 title: 'Détail Course Admin',
 tagline: 'Tous les acteurs et événements d’une course.',
 sections: [
  TimelineSection([
  ('', 'Course proposée à Marc O.', '13h40'),
  ('', 'Acceptée', '13h41'),
  ('', 'Colis récupéré chez TechGabon', '13h58'),
  ('', 'En route vers Akébé', '14h02'),
  ], title: 'Course #3412'),
  BulletSection('Parties', [
  ' Vendeur : TechGabon (Mont-Bouët)',
  ' Cliente : Aline N. (Akébé)',
  ' Livreur : Marc O. GT-4521',
  ]),
 ],
 actions: [
  ExtraAction('', 'Appeler le livreur', snack: 'Appel admin vers livreur (démo) '),
 ],
 ),
 'AD-44': ExtraSpec(
 emoji: '',
 title: 'Attribuer Course',
 tagline: 'Assigner manuellement une course sans réponse automatique.',
 sections: [
  MapSection([
  ('', 'Retrait — Mont-Bouët', 0.35, 0.4),
  ('', 'Livraison — Akébé', 0.65, 0.6),
  ], title: 'Course en souffrance depuis 4 min'),
  ListSection([
  ExtraRow('', 'Marc O. 1,1 km du retrait', subtitle: 'Disponible 4,9 ', trailing: 'Assigner'),
  ExtraRow('', 'Ibrahim K. 1,7 km', subtitle: 'Disponible 4,8 ', trailing: 'Assigner'),
  ExtraRow('', 'Synthia O. 2,3 km', subtitle: 'Voiture — petit colis', trailing: 'Assigner'),
  ], title: 'Livreurs disponibles'),
 ],
 actions: [
  ExtraAction('', 'Attribuer au plus proche',
   snack: 'Course attribuée à Marc O. (démo) '),
 ],
 ),
 'AD-45': ExtraSpec(
 emoji: '',
 title: 'Zones de Couverture (Admin)',
 tagline: 'Toutes les zones livrées, par ville et par densité.',
 sections: [
  MapSection([
  ('', 'Libreville', 0.45, 0.4),
  ('', 'Akanda', 0.66, 0.22),
  ('', 'Owendo', 0.55, 0.7),
  ('', 'Ntoum — en déploiement', 0.82, 0.78),
  ], title: 'Zones actives : 6 villes'),
  ListSection([
  ExtraRow('', 'Libreville', subtitle: '38 quartiers 214 livreurs'),
  ExtraRow('', 'Ntoum', subtitle: 'Ouverture prévue : avril 2026'),
  ], title: 'Détail'),
 ],
 ),
 'AD-46': ExtraSpec(
 emoji: '',
 title: 'Configurer Zone (Admin)',
 tagline: 'Tarifs, livreurs assignés et règles d’une zone.',
 sections: [
  FormSection(
  title: 'Zone',
  fields: [
   ('', 'Nom de la zone'),
   ('', 'Frais de base'),
   ('', 'Nombre de livreurs cible'),
  ],
  submitLabel: 'Enregistrer la zone',
  success: 'Zone mise à jour — tarifs appliqués (démo) ',
  ),
  ToggleSection([
  ('', 'Express disponible dans la zone', true),
  ('', 'Points relais actifs', true),
  ], title: 'Options'),
 ],
 ),
 'AD-47': ExtraSpec(
 emoji: '',
 title: 'Tarification Livraison (Admin)',
 tagline: 'Grille nationale : base, distance, express, pluie.',
 sections: [
  ListSection([
  ExtraRow('', 'Base intra-ville', subtitle: '0–5 km', trailing: '1 500 F'),
  ExtraRow('', 'Au-delà de 5 km', subtitle: '+150 F / km', trailing: '+900 F max'),
  ExtraRow('', 'Express', subtitle: 'Majoration', trailing: '+1 000 F'),
  ExtraRow('', 'Bonus pluie livreur', subtitle: 'Payé par la plateforme', trailing: '500 F'),
  ], title: 'Grille en vigueur'),
 ],
 actions: [
  ExtraAction('', 'Modifier la grille', snack: 'Édition de la grille simulée (démo) '),
 ],
 ),
 'AD-48': ExtraSpec(
 emoji: '',
 title: 'Performance Livreurs',
 tagline: 'Classement mensuel et indicateurs de qualité.',
 sections: [
  ListSection([
  ExtraRow('', 'Marc O.', subtitle: '4,9 121 courses 98 % ponctualité', trailing: '1ᵉʳ'),
  ExtraRow('', 'Synthia O.', subtitle: '4,9 114 courses 96 % ponctualité', trailing: '2ᵉ'),
  ExtraRow('', 'Ibrahim K.', subtitle: '4,8 108 courses 95 % ponctualité', trailing: '3ᵉ'),
  ], title: 'Top livreurs — mars'),
  ProgressSection('Qualité réseau', [
  ('Ponctualité globale', 0.93, '93 %'),
  ('Courses sans incident', 0.98, '98 %'),
  ('Satisfaction clients', 0.95, '4,8 '),
  ]),
 ],
 ),
 'AD-49': ExtraSpec(
 emoji: '',
 title: 'Campagnes Push',
 tagline: 'Notifications push : historique, performances, programmation.',
 sections: [
  ListSection([
  ExtraRow('', ' Black Friday : −60 % ', subtitle: 'Envoyée à 86 210 utilisateurs', trailing: 'CTR 6,8 %'),
  ExtraRow('', ' Vos favoris sont en promo ', subtitle: 'Ciblage paniers abandonnés', trailing: 'CTR 9,2 %'),
  ExtraRow('', ' Nouveau : paiement Moov ', subtitle: 'Programmée demain 10h', trailing: 'Prévue'),
  ], title: 'Dernières campagnes'),
 ],
 actions: [
  ExtraAction('', 'Nouvelle campagne', route: '/screen/AD-50'),
 ],
 ),
 'AD-50': ExtraSpec(
 emoji: '',
 title: 'Nouvelle Campagne Push',
 tagline: 'Ciblage, contenu, test et envoi.',
 sections: [
  FormSection(
  title: 'Composer',
  fields: [
   ('', 'Titre (max 40 caractères)'),
   ('', 'Message (max 120 caractères)'),
   ('', 'Cible (tous, acheteurs actifs, panier abandonné, vendeurs…)'),
   ('', 'Envoi (maintenant ou programmé)'),
  ],
  submitLabel: 'Programmer l’envoi',
  success: 'Campagne programmée — test interne envoyé ',
  op: ExtraOp.createCampaign,
  ),
  TextSection('', 'Bonnes pratiques',
   'Un emoji par message suffit ; les titres courts (< 30 caractères) '
    'ont 38 % de taux d’ouverture en plus.'),
 ],
 ),
 'AD-51': ExtraSpec(
 emoji: '',
 title: 'Campagnes Email / SMS',
 tagline: 'Canaux email et SMS : campagnes et résultats.',
 sections: [
  ListSection([
  ExtraRow('', 'Newsletter Nouveautés mars ', subtitle: 'Email 41 200 envoyés', trailing: 'Ouverture 32 %'),
  ExtraRow('', 'Rappel codes promo (SMS)', subtitle: 'SMS 12 400 envoyés', trailing: 'Clic 11 %'),
  ExtraRow('', 'Réactivation panier J+3', subtitle: 'Email automatique', trailing: 'Rachat 8,4 %'),
  ], title: 'Campagnes récentes'),
 ],
 actions: [
  ExtraAction('', 'Nouvelle campagne email',
   snack: 'Éditeur email ouvert (démo) '),
 ],
 ),
 'AD-52': ExtraSpec(
 emoji: '',
 title: 'Nouvelle Campagne Email',
 tagline: 'Template, liste de destinataires et test A/B.',
 sections: [
  FormSection(
  title: 'Composer l’email',
  fields: [
   ('', 'Objet'),
   ('', 'Template (promo, nouveautés, réactivation)'),
   ('', 'Liste de destinataires'),
  ],
  submitLabel: 'Prévisualiser et envoyer',
  success: 'Email prévisualisé — test A/B lancé (démo) ',
  ),
  BulletSection('Segmentation disponible', [
  ' Acheteurs actifs 30 jours — 22 400',
  ' Paniers abandonnés — 6 120',
  ' Vendeurs actifs — 1 244',
  ]),
 ],
 ),
 'AD-53': ExtraSpec(
 emoji: '',
 title: 'Codes Promo',
 tagline: 'Tous les coupons : usages, limites, performances.',
 sections: [
  ListSection([
  ExtraRow('', 'BIENVENUE10', subtitle: '−10 % première commande', trailing: '4 128 usages'),
  ExtraRow('', 'LIVRAISON0', subtitle: 'Livraison offerte min. 25 000 F', trailing: '2 011 usages'),
  ExtraRow('', 'OKOUME5000', subtitle: '−5 000 F min. 50 000 F', trailing: '1 402 usages'),
  ExtraRow('', 'FIDELE-10', subtitle: 'Clients fidèles uniquement', trailing: '312 usages'),
  ], title: 'Codes actifs'),
 ],
 actions: [
  ExtraAction('', 'Créer un code', route: '/screen/AD-54'),
 ],
 ),
 'AD-54': ExtraSpec(
 emoji: '',
 title: 'Créer Code Promo',
 tagline: 'Règles, limites et ciblage d’un nouveau coupon.',
 sections: [
  FormSection(
  title: 'Nouveau code',
  fields: [
   ('', 'Code (ex. PAQUES15)'),
   ('', 'Type (− %, − FCFA, livraison offerte)'),
   ('', 'Montant minimum'),
   ('', 'Validité et limite d’usages'),
   ('', 'Ciblage (tous, nouveaux, fidèles)'),
  ],
  submitLabel: 'Créer le code',
  success: 'Code créé et actif immédiatement ',
  op: ExtraOp.createPromo,
  ),
 ],
 ),
 'AD-55': ExtraSpec(
 emoji: '',
 title: 'Programme Fidélité',
 tagline: 'Vue d’ensemble des points distribués et utilisés.',
 sections: [
  StatSection([
  ('', '42,1 M', 'Points en circulation'),
  ('', '3,2 M', 'Gagnés ce mois'),
  ('', '1,1 M', 'Utilisés ce mois'),
  ]),
  ProgressSection('Points par action', [
  ('Commande (1 pt / 1 000 F)', 0.62, '62 %'),
  ('Avis avec photos', 0.21, '21 %'),
  ('Parrainage', 0.12, '12 %'),
  ('Stories / partages', 0.05, '5 %'),
  ]),
 ],
 ),
 'AD-56': ExtraSpec(
 emoji: '',
 title: 'Règles Fidélité',
 tagline: 'Gains de points et catalogue de récompenses.',
 sections: [
  FormSection(
  title: 'Nouvelle règle',
  fields: [
   ('', 'Action (commande, avis, parrainage…)'),
   ('', 'Points attribués'),
   ('', 'Récompense associée (coupon, livraison offerte…)'),
  ],
  submitLabel: 'Ajouter la règle',
  success: 'Règle fidélité ajoutée (démo) ',
  ),
  ListSection([
  ExtraRow('', '500 pts −5 000 F', subtitle: 'Récompense la plus utilisée'),
  ExtraRow('', '1 000 pts livraison offerte'),
  ExtraRow('', '5 000 pts bon d’achat 50 000 F'),
  ], title: 'Récompenses actives'),
 ],
 ),
 'AD-57': ExtraSpec(
 emoji: '',
 title: 'Analytics Marketing',
 tagline: 'ROI des campagnes, coût d’acquisition et conversions.',
 sections: [
  StatSection([
  ('', 'x4,2', 'ROI push'),
  ('', '1 850 F', 'Coût / acquisition'),
  ('', '6,8 %', 'Conversion campagnes'),
  ]),
  ChartSection('Conversions par canal (k)', [
  ('Push', 84), ('SMS', 32), ('Email', 27), ('Social', 51),
  ]),
 ],
 actions: [
  ExtraAction('', 'Rapport marketing complet',
   op: ExtraOp.generateReport),
 ],
 ),
 'AD-58': ExtraSpec(
 emoji: '',
 title: 'Tickets Support',
 tagline: 'Tous les tickets clients : priorités et SLA.',
 sections: [
  StatSection([
  ('', '127', 'Ouverts'),
  ('', '2,1 h', 'Première réponse'),
  ('', '4,8/5', 'Satisfaction'),
  ]),
  ListSection([
  ExtraRow('', 'TK-4412 commande jamais reçue', subtitle: 'Aline N. ouvert il y a 3 h', trailing: 'Prioritaire'),
  ExtraRow('', 'TK-4409 remboursement lent', subtitle: 'Jean-P. M. hier', trailing: 'En cours'),
  ExtraRow('', 'TK-4401 question facture', subtitle: 'TechGabon lundi', trailing: 'Standby'),
  ], title: 'File'),
 ],
 ),
 'AD-59': ExtraSpec(
 emoji: '',
 title: 'Détail Ticket',
 tagline: 'Conversation complète et historique du ticket.',
 sections: [
  TimelineSection([
  ('', 'Ouverture — colis non reçu ', 'Il y a 3 h'),
  ('', 'Réponse auto + n de suivi', 'Il y a 3 h'),
  ('', 'Prise en charge agent Sarah', 'Il y a 1 h'),
  ('', 'Enquête transporteur', 'En cours'),
  ], title: 'TK-4412'),
  TextSection('', 'Contexte',
   'Commande OK-2026-0107 séquestre actif '
    'le livreur indique une livraison, la cliente nie. Boîte à preuves ouverte.'),
 ],
 actions: [
  ExtraAction('', 'Répondre', snack: 'Composeur de réponse ouvert (démo) '),
  ExtraAction('', 'Créer un litige', snack: 'Litige créé et lié au ticket (démo) '),
 ],
 ),
 'AD-60': ExtraSpec(
 emoji: '',
 title: 'Répondre Ticket',
 tagline: 'Réponse agent avec modèles et pièces jointes.',
 sections: [
  FormSection(
  title: 'Votre réponse',
  fields: [
   ('', 'Message au client'),
  ],
  submitLabel: 'Envoyer la réponse',
  success: 'Réponse envoyée — ticket en attente client ',
  op: ExtraOp.replyTicket,
  ),
  ListSection([
  ExtraRow('', 'Modèle enquête transporteur en cours ', snack: 'Modèle inséré'),
  ExtraRow('', 'Modèle remboursement sous 72 h ', snack: 'Modèle inséré'),
  ], title: 'Réponses rapides'),
 ],
 ),
 'AD-61': ExtraSpec(
 emoji: '',
 title: 'Chat en Direct',
 tagline: 'Support temps réel : conversations actives.',
 sections: [
  ListSection([
  ExtraRow('', 'Aline N.', subtitle: ' Bonjour, ma commande… ', trailing: '2 min'),
  ExtraRow('', 'Jean-P. M.', subtitle: ' Le remboursement est… ', trailing: '6 min'),
  ExtraRow('', 'Marc O. (livreur)', subtitle: ' Client injoignable… ', trailing: '11 min'),
  ], title: '3 conversations actives'),
  TextSection('', 'Objectif de réponse',
   'Première réponse en moins de 3 minutes aux heures ouvrées. '
    'Les conversations inactives 15 min repassent en file.'),
 ],
 actions: [
  ExtraAction('', 'Prendre la plus ancienne',
   snack: 'Conversation de Marc O. ouverte (démo) '),
 ],
 ),
 'AD-62': ExtraSpec(
 emoji: '',
 title: 'Contenu Signalé',
 tagline: 'Avis, messages et photos signalés en attente de revue.',
 sections: [
  ListSection([
  ExtraRow('', 'Avis arnaqueurs !!! ', subtitle: 'Signé d’un compte suspendu', trailing: 'Avis'),
  ExtraRow('', 'Photo non conforme (fiche produit)', subtitle: 'Signalée 4 fois', trailing: 'Photo'),
  ExtraRow('', 'Message privé publicitaire', subtitle: 'Spam répété — vendeur s9', trailing: 'Message'),
  ], title: 'File de modération (9)'),
 ],
 actions: [
  ExtraAction('', 'Modérer le premier signalement',
   route: '/screen/AD-63'),
 ],
 ),
 'AD-63': ExtraSpec(
 emoji: '',
 title: 'Modérer Contenu',
 tagline: 'Décision : approuver, masquer, avertir ou sanctionner.',
 sections: [
  ListSection([
  ExtraRow('', 'Approuver', subtitle: 'Le contenu reste visible', snack: 'Contenu approuvé '),
  ExtraRow('', 'Masquer', subtitle: 'Invisible mais conservé', snack: 'Contenu masqué '),
  ExtraRow('', 'Avertir l’auteur', subtitle: 'Sanction progressive', snack: 'Avertissement envoyé '),
  ExtraRow('', 'Supprimer + sanction', subtitle: 'Selon la charte', snack: 'Suppression journalisée (démo)'),
  ], title: 'Actions'),
  FormSection(
  title: 'Justification',
  fields: [
   ('', 'Référence à la charte (article)'),
  ],
  submitLabel: 'Valider la décision',
  success: 'Décision enregistrée — contenu traité ',
  op: ExtraOp.moderateContent,
  ),
 ],
 ),
 'AD-64': ExtraSpec(
 emoji: '',
 title: 'Base de Connaissances',
 tagline: 'Articles d’aide publiés et brouillons.',
 sections: [
  ListSection([
  ExtraRow('', 'Comment suivre ma commande ?', subtitle: 'Vu 12 840 fois à jour', trailing: 'Publié'),
  ExtraRow('', 'Payer avec Airtel Money', subtitle: 'Vu 8 210 fois', trailing: 'Publié'),
  ExtraRow('', 'Devenir vendeur — guide', subtitle: 'En révision', trailing: 'Brouillon'),
  ], title: 'Articles'),
 ],
 actions: [
  ExtraAction('', 'Nouvel article', route: '/screen/AD-65'),
 ],
 ),
 'AD-65': ExtraSpec(
 emoji: '',
 title: 'Ajouter Article',
 tagline: 'Rédiger un article d’aide au format simple.',
 sections: [
  FormSection(
  title: 'Nouvel article',
  fields: [
   ('', 'Titre'),
   ('', 'Catégorie (livraison, paiement, vendeur…)'),
   ('', 'Contenu'),
   ('', 'Liens internes (optionnel)'),
  ],
  submitLabel: 'Publier l’article',
  success: 'Article publié dans le centre d’aide ',
  op: ExtraOp.createFaq,
  ),
 ],
 ),
 'AD-66': ExtraSpec(
 emoji: '',
 title: 'Chatbot Configuration',
 tagline: 'Réponses automatiques de première ligne.',
 sections: [
  ToggleSection([
  ('', 'Chatbot actif sur le support', true),
  ('', 'Hors heures ouvrées uniquement', false),
  ('', 'Réponses multilingues (FR/EN)', true),
  ], title: 'Activation'),
  FormSection(
  title: 'Réponse rapide',
  fields: [
   ('', 'Question type (ex. où est ma commande ? )'),
   ('', 'Réponse automatique'),
  ],
  submitLabel: 'Ajouter la réponse',
  success: 'Réponse chatbot ajoutée (démo) ',
  ),
 ],
 ),
 'AD-67': ExtraSpec(
 emoji: '',
 title: 'Paramètres Globaux',
 tagline: 'Configuration générale de la plateforme.',
 sections: [
  ToggleSection([
  ('', 'Nouvelles commandes ouvertes', true),
  ('', 'Nouvelles inscriptions vendeurs', true),
  ('', 'Nouvelles inscriptions livreurs', true),
  ('', 'Programme fidélité actif', true),
  ('', 'Fonctionnalités expérimentales', false),
  ], title: 'Interrupteurs plateforme'),
  FormSection(
  title: 'Informations plateforme',
  fields: [
   ('', 'Numéro support affiché'),
   ('', 'Email de contact'),
  ],
  submitLabel: 'Enregistrer',
  success: 'Paramètres enregistrés (démo) ',
  ),
 ],
 ),
 'AD-68': ExtraSpec(
 emoji: '',
 title: 'Commission Plateforme',
 tagline: 'Taux de commission par catégorie et par formule vendeur.',
 sections: [
  ListSection([
  ExtraRow('', 'Électronique', subtitle: 'Formule Gratuit / Starter / Pro', trailing: '5 / 3 / 2 %'),
  ExtraRow('', 'Mode', trailing: '5 / 3 / 2 %'),
  ExtraRow('', 'Made in Gabon', subtitle: 'Catégorie encouragée', trailing: '3 / 2 / 1 %'),
  ], title: 'Taux actuels'),
  FormSection(
  title: 'Ajuster',
  fields: [
   ('', 'Catégorie'),
   ('%', 'Nouveau taux'),
  ],
  submitLabel: 'Appliquer',
  success: 'Commission mise à jour (démo) ',
  ),
 ],
 ),
 'AD-69': ExtraSpec(
 emoji: '',
 title: 'Frais Livraison (Admin)',
 tagline: 'Configuration des frais de base et subventions plateforme.',
 sections: [
  ListSection([
  ExtraRow('', 'Livraison à domicile', trailing: '1 500 F'),
  ExtraRow('', 'Point relais', trailing: '700 F'),
  ExtraRow('', 'Retrait vendeur', trailing: '0 F'),
  ExtraRow('', 'Subvention 1ʳᵉ commande ', subtitle: 'Plateforme paie 50 %', trailing: 'Active'),
  ], title: 'Tarifs'),
 ],
 actions: [
  ExtraAction('', 'Modifier', snack: 'Édition des frais simulée (démo) '),
 ],
 ),
 'AD-70': ExtraSpec(
 emoji: '',
 title: 'Seuils Alertes',
 tagline: 'Quand déclencher une alerte interne automatiquement.',
 sections: [
  FormSection(
  title: 'Nouveau seuil',
  fields: [
   ('', 'Indicateur (litiges, signalements, retards…)'),
   ('', 'Valeur seuil'),
   ('', 'Destinataires de l’alerte'),
  ],
  submitLabel: 'Créer le seuil',
  success: 'Seuil d’alerte créé (démo) ',
  ),
  ListSection([
  ExtraRow('', 'Litiges ouverts > 20', trailing: 'Actif'),
  ExtraRow('', 'Signalements contrefaçon > 5 / 24 h', trailing: 'Actif'),
  ExtraRow('', 'Retards de livraison > 15 %', trailing: 'Actif'),
  ], title: 'Seuils configurés'),
 ],
 ),
 'AD-71': ExtraSpec(
 emoji: '',
 title: 'Maintenance',
 tagline: 'Mode maintenance : fermer temporairement la plateforme proprement.',
 sections: [
  ToggleSection([
  ('', 'Mode maintenance actif', false),
  ], title: 'État actuel'),
  TextSection('', 'Message affiché pendant la maintenance',
   ' Okoumé revient dans quelques minutes ! Nos équipes mettent à jour '
    'la plateforme. Merci de votre patience. '),
  BulletSection('Comportement', [
  ' Commandes bloquées — messages clairs aux clients',
  ' Transactions en cours terminées, rien n’est perdu',
  ' Notification push envoyée 15 min avant si programmé',
  ]),
 ],
 actions: [
  ExtraAction('', 'Activer la maintenance',
   op: ExtraOp.toggleMaintenance),
 ],
 ),
 'AD-72': ExtraSpec(
 emoji: '',
 title: 'Logs Système',
 tagline: 'Journal technique : erreurs, actions admin, incidents.',
 sections: [
  ListSection([
  ExtraRow('', 'ERROR API paiement Airtel timeout', subtitle: 'Aujourd’hui 14h02 2 retries OK', trailing: 'Erreur'),
  ExtraRow('', 'WARN latence matching livreur 48 s', subtitle: 'Aujourd’hui 12h40', trailing: 'Warn'),
  ExtraRow('', 'INFO bannissement OK-88121 par admin', subtitle: 'Aujourd’hui 11h15', trailing: 'Info'),
  ], title: 'Derniers événements'),
 ],
 actions: [
  ExtraAction('', 'Filtrer par sévérité', snack: 'Filtre appliqué (démo) '),
 ],
 ),
 'AD-73': ExtraSpec(
 emoji: '',
 title: 'Détail Log',
 tagline: 'Contenu complet d’une entrée de journal.',
 sections: [
  TextSection('', 'ERROR 2026-03-14 14:02:17',
   'Service : api-paiement\n'
    'Message : Timeout opérateur Airtel (> 30 s)\n'
    'Contexte : transaction TXN-88412, commande OK-2026-0110\n'
    'Résolution : retry automatique — succès au 2ᵉ essai (14:02:48)'),
  BulletSection('Trace', [
  ' trace_id : 7f2a-88c1-0b90',
  ' instance : api-03 (Libreville)',
  ' aucun utilisateur impacté',
  ]),
 ],
 ),
 'AD-74': ExtraSpec(
 emoji: '',
 title: 'Gestion Rôles',
 tagline: 'Permissions des comptes admin (RBAC).',
 sections: [
  ListSection([
  ExtraRow('', 'Super Admin — 2 personnes', subtitle: 'Tous les droits'),
  ExtraRow('', 'Opérations — 5 personnes', subtitle: 'Commandes, livraisons, litiges'),
  ExtraRow('', 'Support — 8 personnes', subtitle: 'Tickets, chat, remboursements < 50 kF'),
  ExtraRow('', 'Analyste — 3 personnes', subtitle: 'Lecture seule des rapports'),
  ], title: 'Rôles'),
  ToggleSection([
  ('', 'Les opérateurs peuvent trancher un litige', true),
  ('', 'Le support peut rembourser > 50 000 F', false),
  ], title: 'Permissions sensibles'),
 ],
 actions: [
  ExtraAction('', 'Ajouter un administrateur',
   route: '/screen/AD-75'),
 ],
 ),
 'AD-75': ExtraSpec(
 emoji: '',
 title: 'Ajouter Admin',
 tagline: 'Créer un nouveau compte administrateur avec rôle défini.',
 sections: [
  FormSection(
  title: 'Nouvel administrateur',
  fields: [
   ('', 'Nom complet'),
   ('', 'Téléphone (2FA obligatoire)'),
   ('', 'Email professionnel'),
   ('', 'Rôle (Super Admin, Opérations, Support, Analyste)'),
  ],
  submitLabel: 'Créer le compte admin',
  success: 'Compte créé — invitation 2FA envoyée ',
  op: ExtraOp.createAdmin,
  ),
  BulletSection('Sécurité', [
  ' 2FA obligatoire pour tous les admins',
  ' Chaque action admin est journalisée',
  ' Session expirée après 30 min d’inactivité',
  ]),
 ],
 ),
};
