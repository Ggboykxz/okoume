import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';

/// C-28 · À propos d'Okoumé — identité, chiffres clés, mentions et légal.
class AboutScreen extends StatelessWidget {
 const AboutScreen({super.key});

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Scaffold(
   appBar: AppBar(title: const Text('À propos')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
    children: [
     MotionEnter(
      child: Column(
       children: [
        const AppLogo(size: 84),
        const SizedBox(height: 14),
        Text('Okoumé',
          style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
         'La marketplace du Gabon 🇬🇦 — version 1.0.0 (build 2026.05)',
         style: TextStyle(
           fontSize: 12.5, color: cs.onSurfaceVariant),
        ),
       ],
      ),
     ),
     const SizedBox(height: 20),
     AppCard(
      child: Text(
       'Okoumé connecte les acheteurs du Gabon aux vendeurs et livreurs de leur quartier : '
       'paiement mobile Airtel et Moov, séquestre sécurisé, livraison suivie en temps réel '
       'et « Made in Gabon » mis en avant. Notre mission : rendre le commerce local aussi '
       'simple qu\'un message .',
       style: TextStyle(
         fontSize: 13, height: 1.55, color: cs.onSurface),
      ),
     ),
     const SizedBox(height: 16),
     Row(
      children: const [
       Expanded(
        child: _StatCard(
          emoji: '', value: '1 240+', label: 'vendeurs actifs'),
       ),
       SizedBox(width: 10),
       Expanded(
        child: _StatCard(
          emoji: '', value: '86', label: 'livreurs vérifiés'),
       ),
       SizedBox(width: 10),
       Expanded(
        child: _StatCard(
          emoji: '', value: '52 k', label: 'commandes livrées'),
       ),
      ],
     ),
     const SizedBox(height: 18),
     AppListTile(
      emoji: '',
      title: 'Noter Okoumé',
      subtitle: 'Votre avis nous aide à grandir',
      onTap: () => showAppSnack(
       context,
       'Merci ! Notez-nous 5 étoiles sur le Play Store (démo)',
       emoji: '',
      ),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Conditions générales d\'utilisation',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/legal/terms'),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Politique de confidentialité',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/legal/privacy'),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Licences open source',
      subtitle: 'Flutter, Riverpod, Hugeicons, Lottie, Rive…',
      onTap: () => showLicensePage(
       context: context,
       applicationName: 'Okoumé',
       applicationVersion: '1.0.0',
      ),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '️',
      title: 'Nous écrire',
      subtitle: 'bonjour@okoume.ga',
      onTap: () => showAppSnack(
       context,
       'Adresse copiée : bonjour@okoume.ga (démo)',
       emoji: '️',
      ),
     ),
     const SizedBox(height: 20),
     Center(
      child: Column(
       children: [
        Text(
         'Fait à Libreville avec ️',
         style: TextStyle(
           fontSize: 12.5,
           fontWeight: FontWeight.w700,
           color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
         '© 2026 Okoumé SA — Owendo, Gabon',
         style:
           TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant),
        ),
       ],
      ),
     ),
    ],
   ),
  );
 }
}

class _StatCard extends StatelessWidget {
 const _StatCard({
  required this.emoji,
  required this.value,
  required this.label,
 });

 final String emoji;
 final String value;
 final String label;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Container(
   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
   decoration: BoxDecoration(
    color: cs.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: cs.outlineVariant),
   ),
   child: Column(
    children: [
     Text(emoji, style: const TextStyle(fontSize: 20)),
     const SizedBox(height: 6),
     Text(value,
       style: const TextStyle(
         fontFamily: 'Montserrat',
         fontWeight: FontWeight.w800,
         fontSize: 15)),
     const SizedBox(height: 2),
     Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 10.5, color: cs.onSurfaceVariant),
     ),
    ],
   ),
  );
 }
}

/// C-29 · CGU et C-30 · Confidentialité — textes défilables (démo).
class LegalScreen extends StatelessWidget {
 const LegalScreen({super.key, required this.kind});

 final String kind; // 'terms' | 'privacy'

 bool get _isTerms => kind == 'terms';

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final sections = _isTerms ? _terms : _privacy;

  return Scaffold(
   appBar: AppBar(
    title: Text(_isTerms ? 'Conditions générales' : 'Confidentialité'),
   ),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(22, 10, 22, 32),
    children: [
     Text(
      _isTerms
        ? 'Conditions générales d\'utilisation — v1.0, mai 2026'
        : 'Politique de confidentialité — v1.0, mai 2026',
      style: Theme.of(context).textTheme.titleMedium,
     ),
     const SizedBox(height: 6),
     Text(
      _isTerms
        ? 'En utilisant Okoumé, vous acceptez les règles ci-dessous. Ce texte est une version de démonstration.'
        : 'Okoumé protège vos données personnelles conformément à la loi gabonaise n° 001/2011 sur la protection des données.',
      style: TextStyle(
        fontSize: 12.5, height: 1.5, color: cs.onSurfaceVariant),
     ),
     const SizedBox(height: 18),
     for (final section in sections) ...[
      MotionEnter(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          section.$1,
          style: const TextStyle(
            fontSize: 14.5, fontWeight: FontWeight.w800),
         ),
         const SizedBox(height: 6),
         Text(
          section.$2,
          style: TextStyle(
            fontSize: 13, height: 1.6, color: cs.onSurface),
         ),
        ],
       ),
      ),
      const SizedBox(height: 18),
     ],
     const InfoBanner(
      emoji: '️',
      color: AppColors.primary,
      text:
        'Version de démonstration à but pédagogique — les textes complets seront publiés sur okoume.ga.',
     ),
    ],
   ),
  );
 }

 static const _terms = <(String, String)>[
  (
   '1. Objet',
   'Okoumé est une place de marché qui met en relation des vendeurs, des acheteurs et des livreurs indépendants au Gabon. Okoumé n\'est pas le vendeur des articles : chaque boutique est responsable de ses annonces.'
  ),
  (
   '2. Compte et vérification',
   'Vous confirmez votre numéro par SMS. Les vendeurs et livreurs complètent un KYC (pièce d\'identité, registre de commerce ou permis). Un compte peut être suspendu en cas de fraude, de contrefaçon ou d\'annonces trompeuses.'
  ),
  (
   '3. Paiements et séquestre',
   'Les paiements mobiles (Airtel, Moov) et carte sont encaissés par notre partenaire PSP puis conservés en séquestre. Les fonds sont libérés au vendeur après confirmation de réception, ou automatiquement 48 h après livraison sans litige. Le paiement à la livraison est réglé en espèces au livreur.'
  ),
  (
   '4. Livraison et réception',
   'Les délais affichés sont indicatifs. À la remise, vous confirmez avec un code à 4 chiffres. Un livreur ne peut pas exiger de paiement supplémentaire au-delà des frais affichés.'
  ),
  (
   '5. Retours et remboursements',
   'Un litige peut être ouvert dans les 48 h suivant la livraison depuis la commande. Après arbitrage, le remboursement est effectué sur le moyen de paiement d\'origine (48 h pour Mobile Money) ou sur le portefeuille Okoumé (instantané).'
  ),
  (
   '6. Interdictions',
   'Sont interdits : produits illégaux, contrefaçons, espèces protégées, armes, médicaments non autorisés et toute tentative de contournement du paiement dans l\'application.'
  ),
  (
   '7. Responsabilité',
   'Okoumé met en œuvre les moyens raisonnables pour assurer la disponibilité du service. La responsabilité d\'Okoumé est limitée au montant de la transaction concernée.'
  ),
  (
   '8. Droit applicable',
   'Les présentes conditions sont régies par le droit gabonais. Tout litige relève des tribunaux compétents de Libreville.'
  ),
 ];

 static const _privacy = <(String, String)>[
  (
   '1. Données collectées',
   'Numéro de téléphone (obligatoire pour le compte), nom, e-mail facultatif, ville, historique de commandes, messages vendeurs, et — avec votre accord — position approximative pour la livraison.'
  ),
  (
   '2. Utilisation',
   'Vos données servent uniquement à exécuter vos commandes (livraison, paiement, support), personnaliser les recommandations et prévenir la fraude. Nous ne vendons jamais vos données.'
  ),
  (
   '3. Partage limité',
   'Le livreur voit votre prénom, votre quartier et votre téléphone pendant une livraison active. Le vendeur voit votre prénom et le contenu de la commande. Notre partenaire PSP traite les paiements (PCI-DSS).'
  ),
  (
   '4. Conservation',
   'Les données de compte sont conservées tant que le compte est actif, puis 90 jours. Les factures sont conservées 10 ans conformément aux obligations comptables.'
  ),
  (
   '5. Vos droits',
   'Vous pouvez consulter, corriger et exporter vos données depuis Paramètres, ou demander la suppression du compte (délai de 30 jours). Écrivez à privacy@okoume.ga.'
  ),
  (
   '6. Sécurité',
   'Chiffrement des échanges (TLS), accès internes restreints, journalisation des accès sensibles et tests d\'intrusion réguliers.'
  ),
 ];
}
