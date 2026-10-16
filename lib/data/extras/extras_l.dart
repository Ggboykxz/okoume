import '../../features/extra/extra_spec.dart';

/// Aperçus du module L — Livreur (écrans hors MVP).
const extraSpecsL = <String, ExtraSpec>{
 'L-05': ExtraSpec(
  emoji: '',
  title: 'Selfie Vérification',
  tagline: 'Photo de vérification en temps réel pour valider votre identité.',
  sections: [
   BulletSection('Règles de la photo', [
    ' Visage bien éclairé, sans casque ni masque',
    ' Prise en direct (pas d’import depuis la galerie)',
    ' Suivez le cercle guide à l’écran',
    ' Photo chiffrée, visible uniquement par l’équipe KYC',
   ]),
   TextSection('⏱️', 'Durée',
     'La vérification prend moins de 30 secondes. '
       'En cas d’échec, vous pouvez réessayer immédiatement.'),
  ],
  actions: [
   ExtraAction('', 'Prendre le selfie', snack: 'Caméra frontale simulée (démo) '),
  ],
 ),
 'L-07': ExtraSpec(
  emoji: '⏳',
  title: 'Vérification en Cours (Livreur)',
  tagline: 'Votre dossier livreur est en examen — réponse sous 24 h.',
  sections: [
   TimelineSection([
    ('', 'Documents transmis', 'Aujourd’hui 10h05'),
    ('', 'Contrôle CNI + permis', 'En cours…'),
    ('', 'Appel de validation', 'Sous 24 h'),
    ('', 'Activation du compte', 'Immédiat après appel'),
   ], title: 'Étapes'),
   TextSection('', 'Documents en examen',
     'CNI, permis A/B, photo du véhicule et attestation d’assurance. '
       'Vous recevrez une notification à chaque étape.'),
  ],
  actions: [
   ExtraAction('', 'M’alerter à la validation', snack: 'Alerte activée '),
   ExtraAction('', 'Contacter le support livreur',
     snack: 'Support livreur : rappel sous 1 h (démo) '),
  ],
 ),
 'L-13': ExtraSpec(
  emoji: '',
  title: 'Performance Livreur',
  tagline: 'Votre score influence les courses que vous recevez.',
  sections: [
   ProgressSection('Score livreur — 92/100', [
    ('Ponctualité', 0.95, '95 %'),
    ('Taux d’acceptation', 0.88, '88 %'),
    ('Note clients', 0.96, '4,9 '),
    ('Courses terminées sans incident', 0.99, '99 %'),
   ]),
   BulletSection('Pour progresser', [
    ' Acceptez les courses du matin : +8 pts de priorité',
    ' Pointez « arrivé » avant 15 min : +2 pts',
    ' Répondez au téléphone : taux d’annulation réduit',
   ]),
  ],
 ),
 'L-19': ExtraSpec(
  emoji: '',
  title: 'Refuser Course',
  tagline: 'Un refus expliqué vaut mieux qu’une course en retard.',
  sections: [
   ListSection([
    ExtraRow('', 'Trop loin de ma zone', snack: 'Motif « distance » retenu'),
    ExtraRow('', 'Colis trop volumineux', snack: 'Motif « volume » retenu'),
    ExtraRow('', 'Problème véhicule', snack: 'Motif « véhicule » retenu'),
    ExtraRow('⏱️', 'Pas disponible maintenant', snack: 'Motif « indisponible » retenu'),
   ], title: 'Motif du refus'),
   TextSection('', 'Impact',
     'Refuser trop souvent (> 30 %) réduit les courses proposées. '
       'Les pauses sont plus efficaces : passez en mode « occupé ».'),
  ],
 ),
 'L-20': ExtraSpec(
  emoji: '',
  title: 'Navigation vers Prise en Charge',
  tagline: 'Itinéraire GPS vers le vendeur pour récupérer le colis.',
  sections: [
   MapSection([
    ('', 'Vous', 0.22, 0.7),
    ('', 'Mont-Bouët · Boutique', 0.66, 0.32),
   ], title: '1,8 km · ~6 min · ETA 14h08'),
   TimelineSection([
    ('', 'Départ', 'Maintenant'),
    ('️', 'Boulevard Triomphal', '3 min'),
    ('', 'Arrivée — demandez Sœur Nguema', '6 min'),
    ('', 'Scan QR de prise en charge', 'À l’arrivée'),
   ], title: 'Feuille de route'),
  ],
  actions: [
   ExtraAction('▶️', 'Lancer la navigation',
     snack: 'Navigation GPS simulée (démo) '),
   ExtraAction('', 'Scanner le QR de prise en charge', route: '/scan-pickup'),
  ],
 ),
 'L-22': ExtraSpec(
  emoji: '️',
  title: 'Navigation vers Livraison',
  tagline: 'Itinéraire vers le client avec code OTP de validation.',
  sections: [
   MapSection([
    ('', 'Vous', 0.25, 0.45),
    ('', 'Client · Akébé', 0.7, 0.62),
   ], title: '2,4 km · ~8 min · ETA 14h35'),
   BulletSection('Avant d’arriver', [
    ' Prévenez le client (appel masqué)',
    ' Demandez le code OTP à la remise',
    ' Prenez la photo du colis remis',
   ]),
  ],
  actions: [
   ExtraAction('▶️', 'Lancer la navigation', snack: 'Navigation GPS simulée (démo) ️'),
   ExtraAction('', 'Appeler le client', snack: 'Appel masqué simulé '),
  ],
 ),
 'L-23': ExtraSpec(
  emoji: '',
  title: 'Arrivée Chez Client',
  tagline: 'Confirmez votre arrivée : le client est notifié et préparé.',
  sections: [
   TextSection('', 'Vous êtes à destination',
     'La position GPS confirme votre arrivée à Akébé. '
       'Le client a reçu la notification « Le livreur est arrivé ».'),
   BulletSection('Checklist de remise', [
    ' Demandez le code OTP à 4 chiffres',
    ' Photo du colis remis (facultatif)',
    '️ Signature client en cas de litige',
   ]),
  ],
  actions: [
   ExtraAction('', 'Je suis arrivé', snack: 'Statut « arrivé » transmis (démo) '),
   ExtraAction('⏱️', 'J’attends (client absent)',
     snack: 'Minuteur 10 min lancé — support prévenu après '),
  ],
 ),
 'L-24': ExtraSpec(
  emoji: '',
  title: 'Validation Livraison',
  tagline: 'Code OTP + photo : la preuve de livraison qui protège tout le monde.',
  sections: [
   FormSection(
    title: 'Code OTP du client',
    fields: [
     ('', 'Code à 4 chiffres (démo : 1234)'),
    ],
    submitLabel: 'Valider la livraison',
    success: 'Livraison confirmée — fonds débloqués (démo) ',
   ),
   BulletSection('Preuves complémentaires', [
    ' Photo du colis remis (recommandée)',
    '️ Signature du client (litiges uniquement)',
    ' Position GPS horodatée automatiquement',
   ]),
  ],
 ),
 'L-25': ExtraSpec(
  emoji: '',
  title: 'Course Terminée',
  tagline: 'Récapitulatif : distance, gain, note du client.',
  sections: [
   StatSection([
    ('', '+2 500 F', 'Gain course'),
    ('️', '4,2 km', 'Distance'),
    ('⏱️', '23 min', 'Durée totale'),
   ]),
   ProgressSection('Évaluation client', [
    ('Note reçue', 1.0, '5 — « Rapide et poli ! »'),
   ]),
   LinkSection([
    ExtraRow('', 'Voir mon portefeuille', route: '/main'),
    ExtraRow('️', 'Trouver la course suivante', route: '/livreur/map'),
   ]),
  ],
 ),
 'L-28': ExtraSpec(
  emoji: '',
  title: 'Détail Course Passée',
  tagline: 'Toutes les infos d’une course archivée, gain compris.',
  sections: [
   TimelineSection([
    ('', 'Course acceptée', 'Lundi 09h12'),
    ('', 'Colis récupéré', 'Lundi 09h26'),
    ('', 'Livré à Akébé', 'Lundi 09h48'),
    ('', 'Gain crédité', 'Lundi 09h49 · +2 500 F'),
   ], title: 'Course #3398'),
   BulletSection('Détails', [
    ' Vendeur : TechGabon (Mont-Bouët)',
    ' Client : Aline N. (Akébé)',
    ' Colis : petit gabarit, 1,2 kg',
    ' Note : 5/5',
   ]),
  ],
 ),
 'L-29': ExtraSpec(
  emoji: '',
  title: 'Courses Annulées',
  tagline: 'Annulations subies : motifs et gestes commerciaux.',
  sections: [
   ListSection([
    ExtraRow('', 'Course #3391 · client absent', subtitle: 'Mercredi · dédommagement 500 F', trailing: '+500 F'),
    ExtraRow('', 'Course #3384 · vendeur fermé', subtitle: 'Mardi · trajet partiel remboursé', trailing: '+300 F'),
   ], title: 'Annulations de la semaine'),
   TextSection('️', 'Protection livreur',
     'Si l’annulation ne vient pas de vous, vous êtes dédommagé pour '
       'le trajet déjà effectué, même partiellement.'),
  ],
 ),
 'L-31': ExtraSpec(
  emoji: '',
  title: 'Appel Client',
  tagline: 'Numéro masqué : le client ne voit jamais votre vrai numéro.',
  sections: [
   TextSection('', 'Aline N. · 074 00 00 **',
     'L’appel passe par un numéro relais Okoumé. '
       'Il est facturé comme un appel local standard.'),
   BulletSection('Règles d’appel', [
    ' Entre 7h et 21h uniquement',
    '️ Restez courtois — les échanges peuvent être audités en litige',
    ' Le chat est souvent plus pratique (adresse, étage, repère)',
   ]),
  ],
  actions: [
   ExtraAction('', 'Lancer l’appel', snack: 'Appel masqué en cours… '),
   ExtraAction('', 'Basculer en chat', route: '/chat'),
  ],
 ),
 'L-32': ExtraSpec(
  emoji: '',
  title: 'Signaler Problème (Livreur)',
  tagline: 'Incident, accident, client agressif : alertez immédiatement.',
  sections: [
   ListSection([
    ExtraRow('', 'Accident / panne', subtitle: 'Priorité maximale', snack: 'Incident « panne » enregistré'),
    ExtraRow('', 'Client agressif', snack: 'Incident « client » enregistré'),
    ExtraRow('', 'Colis endommagé', snack: 'Incident « colis » enregistré'),
    ExtraRow('', 'Problème au retrait vendeur', snack: 'Incident « retrait » enregistré'),
   ], title: 'Type d’incident'),
   FormSection(
    title: 'Décrire l’incident',
    fields: [
     ('', 'Où êtes-vous ? (position automatique)'),
     ('', 'Que s’est-il passé ?'),
    ],
    submitLabel: 'Alerter le support',
    success: 'Alerte reçue — un agent vous appelle sous 5 min (démo) ',
   ),
  ],
 ),
 'L-39': ExtraSpec(
  emoji: '',
  title: 'Confirmation Retrait (Livreur)',
  tagline: 'Retrait de vos gains vers Mobile Money.',
  sections: [
   TextSection('', 'Retrait de 120 000 F',
     'Vers Moov Money · 074 00 00 00 · sans frais '
       '(2 retraits gratuits par semaine).'),
   TimelineSection([
    ('', 'Demande enregistrée', 'Aujourd’hui 17h02'),
    ('', 'Vérification solde', 'Immédiat'),
    ('', 'Envoi Moov Money', 'Sous 15 min'),
   ], title: 'Traitement'),
   BulletSection('Rappel', [
    ' Référence : RET-L-2026-0333',
    ' Délai max : 30 min en semaine',
   ]),
  ],
 ),
 'L-40': ExtraSpec(
  emoji: '',
  title: 'Primes & Bonus',
  tagline: 'Objectifs hebdomadaires, majorations et bonus pluie.',
  sections: [
   StatSection([
    ('', '35 000 F', 'Primes du mois'),
    ('', '42/50', 'Courses objectif'),
    ('️', '3', 'Bonus pluie'),
   ]),
   ListSection([
    ExtraRow('', 'Objectif 50 courses — 25 000 F', subtitle: '8 courses restantes', trailing: 'En cours'),
    ExtraRow('', 'Heures de pointe (18h–21h)', subtitle: '+200 F par course', trailing: 'Actif'),
    ExtraRow('️', 'Bonus pluie', subtitle: '+500 F quand il pleut', trailing: '3 fois'),
   ], title: 'Objectifs du mois'),
  ],
 ),
 'L-41': ExtraSpec(
  emoji: '',
  title: 'Programme Parrainage',
  tagline: 'Invitez un ami livreur : 10 000 F chacun après sa 10ᵉ course.',
  sections: [
   TextSection('', 'Votre code : MARC-241',
     'Partagez votre code. Quand votre filleul termine 10 courses, '
       'vous recevez chacun 10 000 F — sans limite de parrains.'),
   ProgressSection('Vos parrainages', [
    ('Ibrahim K. — 7/10 courses', 0.7, '7/10'),
    ('Synthia O. — validé ', 1.0, '+10 000 F'),
   ]),
   FormSection(
    title: 'Inviter un ami',
    fields: [
     ('', 'Numéro WhatsApp de votre ami'),
    ],
    submitLabel: 'Envoyer l’invitation',
    success: 'Invitation WhatsApp envoyée (démo) ',
   ),
  ],
 ),
 'L-42': ExtraSpec(
  emoji: '',
  title: 'Mon Véhicule',
  tagline: 'Infos véhicule, documents et état d’assurance.',
  sections: [
   ListSection([
    ExtraRow('', 'Yamaha Crypton — GT-4521', subtitle: 'Moto · 125 cc · 2022'),
    ExtraRow('', 'Assurance valide', subtitle: 'Expire le 31/12/2026', trailing: 'OK'),
    ExtraRow('', 'Permis A — validé', trailing: 'OK'),
   ], title: 'Véhicule actif'),
   BulletSection('À garder à jour', [
    ' Photo du véhicule de moins d’un an',
    ' Assurance repositionnée chaque année',
    ' Contrôle technique si requis',
   ]),
  ],
  actions: [
   ExtraAction('', 'Mettre à jour la photo', snack: 'Caméra simulée '),
  ],
 ),
 'L-43': ExtraSpec(
  emoji: '',
  title: 'Modifier Véhicule',
  tagline: 'Changement de véhicule ou mise à jour des documents.',
  sections: [
   FormSection(
    title: 'Nouveaux éléments',
    fields: [
     ('', 'Type (moto / voiture / camionnette)'),
     ('', 'Immatriculation'),
     ('', 'Référence assurance'),
    ],
    submitLabel: 'Soumettre pour vérification',
    success: 'Mise à jour envoyée — vérification sous 24 h (démo) ',
   ),
   TextSection('️', 'Important',
     'Un véhicule non validé suspend les propositions de course '
       'le temps de la vérification.'),
  ],
 ),
 'L-44': ExtraSpec(
  emoji: '',
  title: 'Zones Préférées',
  tagline: 'Livrez en priorité là où vous êtes le plus efficace.',
  sections: [
   MapSection([
    ('', 'Mont-Bouët', 0.4, 0.4),
    ('', 'Akanda', 0.62, 0.28),
    ('', 'Ntoum', 0.82, 0.75),
   ], title: '2 zones préférées'),
   ListSection([
    ExtraRow('', 'Mont-Bouët', subtitle: 'Zone principale — 60 % de vos courses'),
    ExtraRow('', 'Akanda', subtitle: 'Zone secondaire', trailing: 'Retirer'),
   ], title: 'Priorités'),
   TextSection('', 'Astuce',
     'Les courses des zones préférées vous sont proposées en premier. '
       'Mais vous restez libre d’accepter partout.'),
  ],
 ),
 'L-45': ExtraSpec(
  emoji: '',
  title: 'Ajouter Zone Préférée',
  tagline: 'Sélectionnez un quartier sur la carte pour le prioriser.',
  sections: [
   MapSection([
    ('', 'Quartier sélectionné', 0.5, 0.5),
   ], title: 'Touchez la zone souhaitée'),
   FormSection(
    title: 'Ajouter comme priorité',
    fields: [
     ('️', 'Nom du quartier (ex. Louis)'),
     ('', 'Niveau de priorité (1 = max)'),
    ],
    submitLabel: 'Enregistrer la zone',
    success: 'Zone prioritaire ajoutée (démo) ',
   ),
  ],
 ),
 'L-46': ExtraSpec(
  emoji: '',
  title: 'Horaires Disponibilité',
  tagline: 'Dites quand vous roulez — les notifications respectent vos créneaux.',
  sections: [
   ToggleSection([
    ('', 'Matin · 7h – 12h', true),
    ('️', 'Après-midi · 12h – 18h', true),
    ('', 'Soir · 18h – 22h', true),
    ('', 'Nuit · 22h – 7h', false),
   ], title: 'Créneaux actifs'),
   TextSection('', 'Pause automatique',
     'Hors créneau, vous passez en « indisponible » : aucune '
       'notification de course ne vous sera envoyée.'),
  ],
 ),
 'L-47': ExtraSpec(
  emoji: '️',
  title: 'Assurance',
  tagline: 'Votre couverture pendant les courses Okoumé.',
  sections: [
   TextSection('️', 'Protection en course',
     'Okoumé vous couvre (responsabilité civile et dommages corporels) '
       'pendant chaque course active, en complément de votre assurance '
       'véhicule personnelle.'),
   BulletSection('Couverture', [
    ' Frais médicaux jusqu’à 500 000 F',
    ' Dommages au colis (hors négligence grave)',
    '️ Assistance juridique en cas de litige',
    ' Numéro d’urgence 24/7 : 07 00 11 22 33',
   ]),
  ],
  actions: [
   ExtraAction('', 'Télécharger l’attestation',
     snack: 'Attestation PDF téléchargée (démo) '),
  ],
 ),
 'L-48': ExtraSpec(
  emoji: '',
  title: 'Formation',
  tagline: 'Vidéos courtes pour livrer plus vite et gagner plus.',
  sections: [
   ProgressSection('Votre progression — 60 %', [
    ('Module 1 · Sécurité routière', 1.0, ' Terminé'),
    ('Module 2 · Relation client', 1.0, ' Terminé'),
    ('Module 3 · Optimiser ses trajets', 0.4, 'En cours'),
    ('Module 4 · Gérer un litige', 0.0, 'À venir'),
   ]),
   ListSection([
    ExtraRow('▶️', 'Trouver le bon repère à Akébé', subtitle: 'Vidéo · 4 min'),
    ExtraRow('▶️', 'Porter un colis fragile', subtitle: 'Vidéo · 3 min'),
    ExtraRow('', 'Quiz de formation', subtitle: '10 questions', route: '/livreur/join'),
   ], title: 'Vidéos courtes'),
  ],
  actions: [
   ExtraAction('▶️', 'Reprendre le module 3', snack: 'Lecture vidéo simulée '),
  ],
 ),
};
