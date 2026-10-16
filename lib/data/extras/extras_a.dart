import '../../features/extra/extra_spec.dart';

/// Aperçus du module A — Acheteur (écrans hors MVP).
const extraSpecsA = <String, ExtraSpec>{
 'A-03': ExtraSpec(
  emoji: '️',
  title: 'Sous-Catégorie',
  tagline: 'Affinez la catégorie par sous-familles et filtres rapides.',
  sections: [
   ListSection([
    ExtraRow('', 'Smartphones & accessoires', trailing: '38'),
    ExtraRow('', 'Ordinateurs & tablettes', trailing: '21'),
    ExtraRow('', 'Audio & écouteurs', trailing: '27'),
    ExtraRow('', 'Chargeurs & câbles', trailing: '45'),
   ], title: 'Sous-catégories — Électronique'),
   BulletSection('Filtres rapides', [
    ' Express disponible (< 2 h)',
    ' Moins de 50 000 F',
    ' Note ≥ 4,5',
    ' Libreville uniquement',
   ]),
   LinkSection([
    ExtraRow('️', 'Voir la catégorie complète', route: '/category/c1'),
   ]),
  ],
 ),
 'A-04': ExtraSpec(
  emoji: '',
  title: 'Tendances Près de Chez Vous',
  tagline: 'Ce que les acheteurs de votre quartier achètent en ce moment.',
  sections: [
   StatSection([
    ('', '+32 %', 'Ventes 7 jours'),
    ('', '1 240', 'Acheteurs actifs'),
    ('⏱️', '18h–21h', 'Heure de pointe'),
   ]),
   ListSection([
    ExtraRow('', 'Écouteurs sans fil ProSound', subtitle: 'Akanda · 4,7 ', trailing: '24 500 F'),
    ExtraRow('', 'Power bank 20 000 mAh', subtitle: 'Owendo · 4,8 ', trailing: '18 000 F'),
    ExtraRow('', 'Baskets running T42', subtitle: 'Libreville · 4,6 ', trailing: '37 000 F'),
    ExtraRow('', 'Coffret karité bio', subtitle: 'Bikele · 4,9 ', trailing: '12 500 F'),
   ], title: 'Tendances de la semaine'),
  ],
  actions: [
   ExtraAction('', 'Actualiser', snack: 'Tendances actualisées (démo) '),
  ],
 ),
 'A-05': ExtraSpec(
  emoji: '🆕',
  title: 'Nouveautés',
  tagline: 'Derniers produits ajoutés par les vendeurs vérifiés.',
  sections: [
   TimelineSection([
    ('', 'Poco X6 Pro 256 Go', 'Ajouté il y a 2 h · 189 000 F'),
    ('', 'Robe pagne wax premium', 'Ajouté hier · 26 000 F'),
    ('️', 'Canapé 3 places rotin', 'Ajouté hier · 245 000 F'),
    ('', 'Manette sans fil universelle', 'Ajouté il y a 2 j · 22 500 F'),
   ], title: 'Arrivés récemment'),
   BulletSection('Pourquoi y jeter un œil', [
    ' Les nouveautés sont souvent en promo de lancement',
    ' Vendeurs vérifiés uniquement',
    '️ Paiement protégé par le séquestre Okoumé',
   ]),
  ],
 ),
 'A-06': ExtraSpec(
  emoji: '️',
  title: 'Promos du Jour',
  tagline: 'Réductions sélectionnées par l’équipe Okoumé — mises à jour chaque matin.',
  sections: [
   StatSection([
    ('️', '112', 'Produits en promo'),
    ('⏰', '48 h', 'Durée moyenne'),
    ('', '−31 %', 'Remise moyenne'),
   ]),
   ListSection([
    ExtraRow('', 'TV LED 43" Smart', subtitle: 'TechGabon · fin ce soir', trailing: '−25 %'),
    ExtraRow('', 'Set cuisine 12 pièces', subtitle: 'Maison+ · 48 h restantes', trailing: '−30 %'),
    ExtraRow('', 'Chaise ergonomique', subtitle: 'Bureau Center · 12 h restantes', trailing: '−40 %'),
   ], title: 'Top remises du jour'),
   LinkSection([
    ExtraRow('', 'Voir les offres flash chronométrées', route: '/flash'),
   ]),
  ],
 ),
 'A-07': ExtraSpec(
  emoji: '',
  title: 'Produits Recommandés',
  tagline: 'Recommandations personnalisées (moteur local, hors ligne).',
  sections: [
   TextSection('', 'Comment ça marche ?',
     'Le moteur analyse vos favoris, votre panier et votre historique de commandes '
       'pour proposer les produits les plus pertinents. Tout est calculé localement '
       'dans le mode démo — aucune donnée ne quitte votre téléphone.'),
   ProgressSection('Vos affinités', [
    ('Électronique', 0.82, '82 %'),
    ('Mode & beauté', 0.54, '54 %'),
    ('Maison', 0.31, '31 %'),
   ]),
   ListSection([
    ExtraRow('', 'Enceinte Bluetooth Xboom', subtitle: 'Carrefour · 4,7 ', trailing: '32 000 F'),
    ExtraRow('⌚', 'Montre connectée Fit 3', subtitle: 'TechGabon · 4,5 ', trailing: '45 000 F'),
   ], title: 'Sélection pour vous'),
  ],
 ),
 'A-09': ExtraSpec(
  emoji: '',
  title: 'Bannière Promo',
  tagline: 'Page détail d’une campagne : conditions, durée et produits concernés.',
  sections: [
   TextSection('', 'Black Friday Okoumé — jusqu’à −60 %',
     'Du 24 au 30 novembre : les meilleurs vendeurs du Gabon cassent les prix. '
       'Livraison offerte au-delà de 50 000 F d’achat, paiement sécurisé par '
       'Airtel Money, Moov Money ou carte bancaire.'),
   BulletSection('Conditions', [
    ' Cumulable avec un seul code promo',
    ' Livraison offerte dès 50 000 F',
    '⏰ Fin de campagne : 30 novembre à 23h59',
   ]),
   LinkSection([
    ExtraRow('', 'Voir toutes les offres flash', route: '/flash'),
    ExtraRow('', 'Made in Gabon en promotion', route: '/local'),
   ]),
  ],
  actions: [
   ExtraAction('', 'Me rappeler le lancement',
     snack: 'Rappel activé — notification le 24/11 à 8h '),
  ],
 ),
 'A-10': ExtraSpec(
  emoji: '',
  title: 'Vendeurs Populaires',
  tagline: 'Les boutiques les mieux notées et les plus actives du moment.',
  sections: [
   ListSection([
    ExtraRow('', 'TechGabon', subtitle: 'Électronique · 4,9 · Libreville', trailing: '12,4k ventes', route: '/seller/s2'),
    ExtraRow('', 'Nguema Fashion', subtitle: 'Mode · 4,8 · Akanda', trailing: '7,1k ventes'),
    ExtraRow('', 'Mama Mavoungou', subtitle: 'Artisanat · 4,9 · Bikele', trailing: '5,8k ventes'),
    ExtraRow('', 'Maison Étal', subtitle: 'Maison · 4,7 · Owendo', trailing: '4,3k ventes'),
   ], title: 'Classement du mois'),
   BulletSection('Labels de confiance', [
    ' Vendeur vérifié (KYC validé)',
    ' Réponse < 1 h en moyenne',
    '️ Aucun litige non résolu',
   ]),
  ],
  actions: [
   ExtraAction('', 'Trier par ventes', snack: 'Tri par ventes appliqué (démo)'),
  ],
 ),
 'A-13': ExtraSpec(
  emoji: '',
  title: 'Événements Spéciaux',
  tagline: 'Black Friday, Noël, Fête du Travail : les grands rendez-vous Okoumé.',
  sections: [
   TimelineSection([
    ('️', 'Black Friday Okoumé', '24–30 novembre · jusqu’à −60 %'),
    ('', 'Noël à Moitié Prix', '15–25 décembre · promos vendeurs'),
    ('', 'Fête du Travail', '1er mai · hommage aux artisans'),
    ('🇬🇦', 'Made in Gabon Days', 'Chaque premier week-end du mois'),
   ], title: 'Calendrier 2026'),
   TextSection('', 'Le saviez-vous ?',
     'Pendant les événements spéciaux, les points du programme fidélité '
       'sont doublés et les frais de livraison réduits de moitié.'),
  ],
  actions: [
   ExtraAction('', 'Activer les alertes événements',
     snack: 'Vous serez prévenu avant chaque événement '),
  ],
 ),
 'A-17': ExtraSpec(
  emoji: '',
  title: 'Lecteur Vidéo',
  tagline: 'Vidéo produit plein écran : démonstration, qualité, livraison réelle.',
  sections: [
   TextSection('️', 'Démonstration en cours',
     'Le vendeur montre le produit en situation réelle : déballage, qualité '
       'des finitions et test de fonctionnement, filmé depuis sa boutique à Libreville.'),
   ProgressSection('Lecture', [
    ('Durée', 0.35, '00:12 / 00:34'),
   ]),
   BulletSection('Contrôles', [
    '▶️ Lecture / pause au double-tap',
    ' Son activé par défaut (données mobiles limitées)',
    ' Mise en plein écran automatique en mode paysage',
   ]),
  ],
  actions: [
   ExtraAction('▶️', 'Lire la vidéo', snack: 'Lecture simulée (démo) '),
  ],
 ),
 'A-22': ExtraSpec(
  emoji: '↩️',
  title: 'Politique Retour',
  tagline: 'Conditions de retour du vendeur et procédure de remboursement.',
  sections: [
   BulletSection('Conditions du vendeur', [
    '⏱️ Retour accepté sous 7 jours après réception',
    ' Produit non utilisé, dans son emballage d’origine',
    ' Reçu électronique ou numéro de commande requis',
    ' Exclusions : produits hygiéniques, aliments, cartes prépayées',
   ]),
   TimelineSection([
    ('', 'Demande de retour', 'Étape 1 — depuis « Mes commandes »'),
    ('', 'Validation vendeur', 'Étape 2 — sous 48 h'),
    ('', 'Récupération colis', 'Étape 3 — livreur à domicile'),
    ('', 'Remboursement', 'Étape 4 — sous 72 h (wallet ou opérateur)'),
   ], title: 'Procédure'),
  ],
  actions: [
   ExtraAction('', 'Ouvrir une demande de remboursement',
     snack: 'Dossier de remboursement ouvert (démo) '),
  ],
 ),
 'A-24': ExtraSpec(
  emoji: '',
  title: 'Détail Avis',
  tagline: 'Avis complet d’un client : note, photos, achat vérifié.',
  sections: [
   TextSection('', '« Qualité au rendez-vous » — 5/5',
     'Livraison rapide (moins de 2 h), produit conforme aux photos, très bien '
       'emballé. Le vendeur a répondu à ma question en moins de 10 minutes. '
       'Je recommande vivement, je commanderai à nouveau chez ce vendeur !'),
   BulletSection('Cet avis en détail', [
    ' 3 photos jointes par l’acheteur',
    ' Achat vérifié — commande OK-2026-0421',
    ' 12 personnes ont trouvé cet avis utile',
   ]),
   LinkSection([
    ExtraRow('️', 'Tous les avis du produit', route: '/product/p1/reviews'),
   ]),
  ],
  actions: [
   ExtraAction('', 'Utile', snack: 'Merci — votre vote a été pris en compte '),
   ExtraAction('', 'Signaler cet avis',
     snack: 'Avis signalé à la modération (démo) '),
  ],
 ),
 'A-28': ExtraSpec(
  emoji: '',
  title: 'Signaler Produit',
  tagline: 'Contrefaçon, produits dangereux, photos trompeuses : alertez la modération.',
  sections: [
   ListSection([
    ExtraRow('', 'Produit contrefait', snack: 'Motif « contrefaçon » retenu'),
    ExtraRow('️', 'Produit dangereux ou interdit', snack: 'Motif « danger » retenu'),
    ExtraRow('️', 'Photos ou description trompeuses', snack: 'Motif « trompeur » retenu'),
    ExtraRow('', 'Prix abusif', snack: 'Motif « prix » retenu'),
   ], title: 'Motif du signalement'),
   FormSection(
    title: 'Informations complémentaires',
    fields: [
     ('', 'Expliquez le problème (obligatoire)'),
     ('', 'Preuve : lien, photo de référence (optionnel)'),
    ],
    submitLabel: 'Transmettre à la modération',
    success: 'Signalement reçu — examen sous 24 h (démo) ',
   ),
   LinkSection([
    ExtraRow('', 'Revoir le produit concerné', route: '/product/p1'),
   ]),
  ],
 ),
 'A-29': ExtraSpec(
  emoji: '',
  title: 'Partager Produit',
  tagline: 'Faites découvrir le produit sur vos réseaux — le lien suit votre parrainage.',
  sections: [
   ListSection([
    ExtraRow('', 'WhatsApp', subtitle: 'Le plus utilisé au Gabon', snack: 'Ouverture du partage WhatsApp…'),
    ExtraRow('', 'Facebook', snack: 'Ouverture du partage Facebook…'),
    ExtraRow('', 'Instagram', subtitle: 'Via story', snack: 'Visuel story généré '),
    ExtraRow('', 'Copier le lien', snack: 'Lien copié : oko.me/p/p1 '),
   ], title: 'Partager via'),
   TextSection('', 'Gagnez des points',
     'Chaque ami qui commande via votre lien vous rapporte 500 points fidélité '
       'et lui offre 10 % sur sa première commande.'),
  ],
  actions: [
   ExtraAction('', 'Afficher le QR code du produit',
     snack: 'QR code affiché — scan facile en boutique '),
  ],
 ),
 'A-31': ExtraSpec(
  emoji: '',
  title: 'Produits Similaires',
  tagline: 'Alternatives proches : même catégorie, prix et zone, meilleures notes.',
  sections: [
   TextSection('', 'Comment sont-ils choisis ?',
     'Produits de la même catégorie que vous consultez, comparés par prix, '
       'note et disponibilité dans votre ville. Les vendeurs express sont mis en avant.'),
   ListSection([
    ExtraRow('', 'CASQUE BT-500 ProSound', subtitle: 'Autre vendeur · 4,8 ', trailing: '26 000 F'),
    ExtraRow('', 'CASQUE BT-400 Générique', subtitle: 'Meilleur prix · 4,3 ', trailing: '15 500 F'),
    ExtraRow('', 'CASQUE StudioBeat ANC', subtitle: 'Réduction de bruit · 4,9 ', trailing: '45 000 F'),
   ], title: '3 alternatives proches'),
  ],
  actions: [
   ExtraAction('️', 'Revenir à la fiche produit', route: '/product/p1'),
  ],
 ),
 'A-36': ExtraSpec(
  emoji: '',
  title: 'Sauvegarder pour Plus Tard',
  tagline: 'Mettez un article du panier de côté sans le perdre.',
  sections: [
   TextSection('', 'Comment ça marche',
     'L’article quitte le panier pour ne pas bloquer le stock, mais reste '
       'disponible en un tap. Si le prix baisse, une notification vous est envoyée.'),
   ListSection([
    ExtraRow('', 'Écouteurs ProSound — sauvegardés', subtitle: 'Depuis le panier · hier'),
    ExtraRow('', 'Power bank 20 000 mAh', subtitle: 'Prix baissé de 2 000 F depuis !', trailing: 'Revoir'),
   ], title: 'Sauvegardés (2)'),
   LinkSection([
    ExtraRow('', 'Retour au panier', route: '/cart'),
    ExtraRow('️', 'Voir la wishlist', route: '/wishlist'),
   ]),
  ],
 ),
 'A-53': ExtraSpec(
  emoji: '',
  title: 'Partager Commande',
  tagline: 'Partagez votre commande : faites envie et gagnez des points.',
  sections: [
   ListSection([
    ExtraRow('', 'Story « J’ai commandé »', subtitle: 'Visuel généré avec le numéro de commande', snack: 'Story générée '),
    ExtraRow('', 'WhatsApp', snack: 'Partage WhatsApp ouvert…'),
    ExtraRow('', 'Copier le lien de la commande', snack: 'Lien copié '),
   ], title: 'Canaux'),
   TextSection('', 'Bonus parrainage',
     'Vos amis qui découvrent Okoumé via votre partage reçoivent 10 % '
       'sur leur première commande — et vous, 500 points.'),
  ],
  actions: [
   ExtraAction('️', 'Ouvrir la commande', route: '/orders'),
  ],
 ),
 'A-60': ExtraSpec(
  emoji: '',
  title: 'Demander Remboursement',
  tagline: 'Ouvrir un litige : produit non conforme, manquant ou non reçu.',
  sections: [
   ListSection([
    ExtraRow('', 'Produit non reçu', snack: 'Motif « non reçu » retenu'),
    ExtraRow('', 'Produit non conforme', snack: 'Motif « non conforme » retenu'),
    ExtraRow('', 'Article manquant dans le colis', snack: 'Motif « manquant » retenu'),
    ExtraRow('', 'Produit arrivé endommagé', snack: 'Motif « endommagé » retenu'),
   ], title: 'Motif'),
   FormSection(
    title: 'Votre demande',
    fields: [
     ('', 'Numéro de commande (ex. OK-2026-0104)'),
     ('', 'Décrivez le problème'),
     ('', 'Photos du produit / colis (optionnel)'),
    ],
    submitLabel: 'Ouvrir le dossier de litige',
    success: 'Dossier ouvert — l’équipe litiges vous répond sous 24 h ',
    op: ExtraOp.openRefund,
   ),
   TextSection('️', 'Séquestre Okoumé',
     'L’argent de la commande est bloqué en séquestre : tant que le litige '
       'n’est pas résolu, le vendeur ne reçoit rien.'),
  ],
 ),
 'A-63': ExtraSpec(
  emoji: '',
  title: 'Commande à Réceptionner',
  tagline: 'Alertes des commandes arrivées en point relais ou à récupérer.',
  sections: [
   ListSection([
    ExtraRow('', 'OK-2026-0101 · Locker Total Owendo',
      subtitle: 'Arrivée hier · code de retrait disponible',
      trailing: '6 j restants'),
    ExtraRow('', 'OK-2026-0098 · Boutique TechGabon',
      subtitle: 'Arrivée il y a 2 j · Horaires 8h–18h',
      trailing: '4 j restants'),
   ], title: 'À récupérer (2)'),
   BulletSection('Bon à savoir', [
    ' Le retrait se fait par scan de votre QR code',
    '⏳ Passé le délai, le colis est retourné au vendeur',
    ' Rappel automatique 24 h avant expiration',
   ]),
   LinkSection([
    ExtraRow('️', 'Carte des points de retrait', route: '/lockers'),
    ExtraRow('', 'Mes commandes', route: '/orders'),
   ]),
  ],
 ),
 'A-68': ExtraSpec(
  emoji: '',
  title: 'Itinéraire Point Retrait',
  tagline: 'Navigation GPS jusqu’au locker ou à la boutique partenaire.',
  sections: [
   MapSection([
    ('', 'Vous', 0.2, 0.72),
    ('', 'Locker Total Owendo', 0.68, 0.3),
   ], title: 'Owendo · 3,2 km · ~9 min en moto'),
   TimelineSection([
    ('', 'Départ de votre position', 'Maintenant'),
    ('️', 'Boulevard Owendo → PK9', '6 min'),
    ('', 'Arrivée au locker — code 4815', '9 min'),
   ], title: 'Feuille de route'),
  ],
  actions: [
   ExtraAction('▶️', 'Lancer la navigation',
     snack: 'Navigation lancée — mode GPS simulé (démo) '),
   ExtraAction('', 'Appeler le point relais',
     snack: 'Appel simulé vers le locker '),
  ],
 ),
};
