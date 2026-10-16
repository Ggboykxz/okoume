import '../../features/extra/extra_spec.dart';

/// Aperçus du module C — Commun (écrans hors MVP).
const extraSpecsC = <String, ExtraSpec>{
 'C-12': ExtraSpec(
  emoji: '',
  title: 'Home (Première Connexion)',
  tagline:
    'Accueil personnalisé du nouvel utilisateur : bienvenue, suggestions et premières découvertes.',
  sections: [
   TextSection('', 'Bienvenue sur Okoumé !',
     'Votre accueil est personnalisé selon votre ville et vos centres d’intérêt. '
       'Les catégories populaires de Libreville vous sont présentées en premier, '
       'avec nos vendeurs vérifiés près de chez vous.'),
   BulletSection('Ce que vous verrez en premier', [
    ' Suggestions basées sur votre profil (acheteur)',
    ' Boutiques proches de votre quartier',
    ' Promotions de bienvenue BIENVENUE10',
    ' Guide rapide : commander, payer, suivre',
   ]),
   LinkSection(
    [
     ExtraRow('️', 'Ouvrir l’accueil du MVP',
       subtitle: 'A-01 · Home Acheteur', route: '/main'),
    ],
    title: 'Écran réel équivalent',
   ),
  ],
  actions: [
   ExtraAction('', 'Revoir le guide de démarrage',
     snack: 'Guide de démarrage relancé '),
  ],
 ),
 'C-14': ExtraSpec(
  emoji: '',
  title: 'Biométrie Setup',
  tagline: 'Activez l’empreinte digitale ou Face ID pour sécuriser vos accès.',
  sections: [
   TextSection('', 'Connexion sans mot de passe',
     'La biométrie permet d’ouvrir l’app et de valider vos paiements sans ressaisir '
       'de code. Vos données biométriques restent sur votre téléphone — elles ne '
       'sont jamais transmises aux serveurs Okoumé.'),
   ToggleSection([
    ('', 'Déverrouillage de l’app', true),
    ('', 'Validation des paiements > 50 000 F', true),
    ('', 'Confirmation des retraits', false),
   ], title: 'Utiliser la biométrie pour'),
  ],
  actions: [
   ExtraAction('', 'Activer maintenant',
     snack: 'Biométrie activée (simulation) '),
   ExtraAction('⏭️', 'Plus tard', snack: 'Rappel affiché à la prochaine connexion'),
  ],
 ),
 'C-15': ExtraSpec(
  emoji: '',
  title: 'Sélection Langue',
  tagline: 'Français (par défaut) ou English — appliqué instantanément à toute l’app.',
  sections: [
   ListSection([
    ExtraRow('🇫🇷', 'Français',
      subtitle: 'Langue officielle — recommandée',
      trailing: 'Sélectionné',
      snack: 'Déjà en français 🇫🇷'),
    ExtraRow('🇬🇧', 'English',
      subtitle: 'Interface et emails en anglais (en préparation)',
      snack: 'L’anglais arrive dans une prochaine version '),
   ], title: 'Langues disponibles'),
   TextSection('', 'Documents légaux',
     'Les CGU et la politique de confidentialité seront automatiquement '
       'traduites dans la langue choisie. Les montants restent en FCFA.'),
  ],
 ),
 'C-20': ExtraSpec(
  emoji: '️',
  title: 'Modifier Adresse',
  tagline: 'Éditer une adresse enregistrée : libellé, détails, ville et point GPS.',
  sections: [
   FormSection(
    title: 'Nouvelle version de l’adresse',
    fields: [
     ('️', 'Libellé (ex. Maison, Bureau)'),
     ('', 'Détails (rue, immeuble, repère)'),
     ('️', 'Ville / quartier'),
    ],
    submitLabel: 'Enregistrer les modifications',
    success: 'Adresse mise à jour (démo) ',
   ),
   LinkSection([
    ExtraRow('', 'Voir mes adresses', route: '/addresses'),
   ]),
  ],
  actions: [
   ExtraAction('️', 'Supprimer cette adresse',
     snack: 'Suppression simulée — confirmation demandée ️'),
  ],
 ),
 'C-22': ExtraSpec(
  emoji: '',
  title: 'Ajouter Carte Bancaire',
  tagline: 'Visa / Mastercard — paiement sécurisé 3-D Secure.',
  sections: [
   FormSection(
    title: 'Informations de la carte',
    fields: [
     ('', 'Numéro de carte'),
     ('', 'Titulaire (comme sur la carte)'),
     ('', 'Expiration MM/AA'),
     ('', 'CVC'),
    ],
    submitLabel: 'Ajouter la carte',
    success: 'Carte vérifiée et enregistrée (démo) ',
   ),
   BulletSection('Sécurité', [
    ' Vérification 3-D Secure par SMS',
    ' Aucune donnée complète stockée sur l’appareil',
    '️ Numéro masqué après enregistrement (•••• 4242)',
   ]),
   LinkSection([
    ExtraRow('️', 'Mes moyens de paiement', route: '/payment-methods'),
   ]),
  ],
 ),
 'C-23': ExtraSpec(
  emoji: '',
  title: 'Ajouter Mobile Money',
  tagline: 'Lier votre compte Airtel Money ou Moov Money en quelques secondes.',
  sections: [
   ListSection([
    ExtraRow('', 'Airtel Money',
      subtitle: 'Frais opérateur : 1 % · instantané', snack: 'Airtel sélectionné '),
    ExtraRow('', 'Moov Money',
      subtitle: 'Frais opérateur : 1 % · instantané', snack: 'Moov sélectionné '),
   ], title: 'Choisir l’opérateur'),
   FormSection(
    title: 'Numéro à lier',
    fields: [
     ('', 'Numéro Mobile Money (ex. 074 00 00 00)'),
     ('️', 'Nom du bénéficiaire'),
    ],
    submitLabel: 'Recevoir la demande de validation',
    success: 'Demande envoyée — validez sur votre téléphone (démo) ',
   ),
   LinkSection([
    ExtraRow('️', 'Mes moyens de paiement', route: '/payment-methods'),
   ]),
  ],
 ),
 'C-26': ExtraSpec(
  emoji: '️',
  title: 'Sécurité',
  tagline: '2FA, mot de passe, sessions actives et alertes de connexion.',
  sections: [
   ToggleSection([
    ('', 'Double authentification par SMS', true),
    ('', 'Biométrie à la connexion', false),
    ('', 'Alertes de connexion inhabituelle', true),
   ], title: 'Protections'),
   ListSection([
    ExtraRow('', 'Libreville · cet appareil',
      subtitle: 'Active maintenant', trailing: 'Actuelle'),
    ExtraRow('', 'Tablette — Libreville',
      subtitle: 'Dernière activité il y a 3 jours', trailing: '⏻'),
   ], title: 'Sessions actives'),
   TextSection('', 'Mot de passe',
     'Votre dernier changement date de 4 mois. Un mot de passe fort '
       '(12 caractères, chiffres et symboles) protège votre compte et '
       'vos paiements en séquestre.'),
  ],
  actions: [
   ExtraAction('', 'Changer le mot de passe',
     snack: 'Lien de changement envoyé par SMS '),
   ExtraAction('', 'Déconnecter les autres sessions',
     snack: '2 autres sessions ont été fermées (démo) '),
  ],
 ),
 'C-34': ExtraSpec(
  emoji: '',
  title: 'Signaler un Problème',
  tagline: 'Bug, contenu inapproprié, problème de paiement : dites-nous tout.',
  sections: [
   ListSection([
    ExtraRow('', 'Bug technique', snack: 'Catégorie « bug » sélectionnée'),
    ExtraRow('', 'Problème de paiement', snack: 'Catégorie « paiement » sélectionnée'),
    ExtraRow('', 'Contenu inapproprié', snack: 'Catégorie « contenu » sélectionnée'),
    ExtraRow('', 'Problème de livraison', snack: 'Catégorie « livraison » sélectionnée'),
   ], title: 'Type de problème'),
   FormSection(
    title: 'Décrivez le problème',
    fields: [
     ('', 'Description du problème'),
     ('', 'Écran concerné (ex. checkout, produit…)'),
     ('', 'Lien ou référence (optionnel)'),
    ],
    submitLabel: 'Envoyer le signalement',
    success: 'Signalement transmis au support — réponse < 24 h (démo) ',
   ),
   TextSection('', 'Suivi',
     'Chaque signalement reçoit un numéro de ticket consultable dans '
       'le centre d’aide. Les bugs bloquants sont traités en priorité.'),
  ],
 ),
 'C-38': ExtraSpec(
  emoji: '',
  title: 'Détail Notification',
  tagline: 'Contenu complet d’une notification + action associée.',
  sections: [
   TextSection('', 'Votre commande OK-2024-118 est expédiée !',
     'Le vendeur TechGabon a remis votre colis au livreur Marc O. '
       'Livraison estimée : aujourd’hui avant 18h00 à Akébé. '
       'Suivez la position du livreur en temps réel.'),
   TimelineSection([
    ('', 'Notification reçue', 'Il y a 12 min'),
    ('', 'Ouverture du suivi', 'Il y a 8 min'),
    ('', 'Livreur en route', 'Maintenant'),
   ], title: 'Activité liée'),
  ],
  actions: [
   ExtraAction('', 'Ouvrir le suivi', route: '/order/o1'),
   ExtraAction('️', 'Supprimer la notification',
     snack: 'Notification supprimée ️'),
  ],
 ),
};
