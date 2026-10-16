import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';

/// C-31 / C-32 / C-33 Centre d'aide : FAQ filtrable, litiges, contact.
class HelpScreen extends ConsumerStatefulWidget {
 const HelpScreen({super.key});

 @override
 ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
 final _search = TextEditingController();
 String _query = '';

 static const _faq = <(String, String, String)>[
 (
  '',
  'Où est ma commande ?',
  'Ouvrez Commandes puis touchez la commande pour voir le suivi en direct : position du livreur, étapes et code de remise. Le livreur vous appelle avant d\'arriver.'
 ),
 (
  '',
  'Quels moyens de paiement acceptez-vous ?',
  'Airtel Money, Moov Money, carte bancaire Visa/Mastercard, portefeuille Okoumé et paiement à la livraison. Pour Airtel et Moov, vous recevez une notification USSD à valider.'
 ),
 (
  '',
  'Comment fonctionne le séquestre (escrow) ?',
  'Pour les paiements mobiles et carte, votre argent est bloqué par Okoumé. Il n\'est versé au vendeur qu\'après votre confirmation de réception — ou automatiquement 48 h après la livraison sans litige.'
 ),
 (
  '',
  'Comment demander un remboursement ?',
  'Dans la commande concernée, touchez Annuler ou rembourser . Un vendeur ou un livreur accepte sous 24 h. Les remboursements Airtel/Moov arrivent sous 48 h, le portefeuille est instantané.'
 ),
 (
  '',
  'Les frais de livraison sont-ils fixes ?',
  'Non : ils dépendent de votre zone et du mode choisi (domicile, point relais, retrait vendeur). Les promos LIVRAISON0 rendent la livraison gratuite, et le retrait vendeur est toujours gratuit.'
 ),
 (
  '',
  'Comment vérifier un vendeur ?',
  'Les boutiques vérifiées affichent un badge bleu (KYC validé : CNI + registre de commerce). Vous voyez aussi sa note, ses avis et son délai de réponse moyen.'
 ),
 (
  '',
  'Je n\'arrive pas à me connecter',
  'Le code SMS démo est toujours 1 2 3 4. En production, le code arrive par SMS sous 30 secondes ; sans réception, demandez un nouveau code ou passez par le support.'
 ),
 (
  '',
  'Quelles versions de téléphone sont supportées ?',
  'Android 8.0 ou plus récent, et iPhone avec iOS 14 ou plus récent. L\'application consomme peu de données grâce au mode bas débit.'
 ),
 ];

 static const _articles = <(String, String, String)>[
 ('', 'Ouvrir un litige',
  'Article non conforme, non reçu ou endommagé — nous arbitrons sous 72 h.'),
 ('', 'Facture et reçu',
  'Retrouvez chaque reçu dans le détail de la commande, partageable en PDF (démo).'),
 ('', 'Signaler un vendeur ou un produit',
  'Signalez une annonce suspecte : notre équipe vérifie sous 24 h.'),
 ];

 @override
 void dispose() {
 _search.dispose();
 super.dispose();
 }

 List<(String, String, String)> get _filtered {
 if (_query.trim().isEmpty) return _faq;
 final q = _query.toLowerCase();
 return _faq
  .where((f) =>
   f.$2.toLowerCase().contains(q) || f.$3.toLowerCase().contains(q))
  .toList();
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final faq = _filtered;

 return Scaffold(
  appBar: AppBar(title: const Text('Centre d\'aide')),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
  children: [
   // ---------------------------------------------------- Recherche FAQ
   AppTextField(
   controller: _search,
   hint: 'Rechercher : livraison, remboursement…',
   icon: AppIcons.search_rounded,
   onChanged: (v) => setState(() => _query = v),
   ),
   const SizedBox(height: 18),
   Text('Questions fréquentes',
    style: Theme.of(context).textTheme.titleMedium),
   const SizedBox(height: 10),
   if (faq.isEmpty)
   const EmptyState(
    emoji: '',
    title: 'Aucun résultat',
    message:
     'Essayez livraison , paiement ou contactez le support ci-dessous.',
   )
   else
   for (var i = 0; i < faq.length; i++) ...[
    MotionEnter(
    order: i,
    child: Material(
     color: cs.surface,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.circular(16),
     side: BorderSide(color: cs.outlineVariant),
     ),
     clipBehavior: Clip.antiAlias,
     child: ExpansionTile(
     leading: Text(faq[i].$1,
      style: const TextStyle(fontSize: 19)),
     title: Text(
      faq[i].$2,
      style: const TextStyle(
       fontSize: 13.5, fontWeight: FontWeight.w700),
     ),
     iconColor: cs.primary,
     collapsedIconColor: cs.onSurfaceVariant,
     childrenPadding:
      const EdgeInsets.fromLTRB(16, 0, 16, 14),
     expandedCrossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(
      faq[i].$3,
      style: TextStyle(
       fontSize: 13,
       height: 1.5,
       color: cs.onSurfaceVariant,
      ),
      ),
     ],
     ),
    ),
    ),
    const SizedBox(height: 10),
   ],
   const SizedBox(height: 8),

   // --------------------------------------------------------- Litiges
   Text('Litiges et garanties',
    style: Theme.of(context).textTheme.titleMedium),
   const SizedBox(height: 10),
   for (final article in _articles) ...[
   AppListTile(
    emoji: article.$1,
    title: article.$2,
    subtitle: article.$3,
    onTap: () => showAppSnack(
    context,
    '${article.$2} — un conseiller traite votre demande sous 24 h (démo)',
    emoji: '',
    ),
   ),
   const SizedBox(height: 10),
   ],
   const SizedBox(height: 8),

   // --------------------------------------------------------- Contact
   Text('Nous contacter',
    style: Theme.of(context).textTheme.titleMedium),
   const SizedBox(height: 10),
   for (final contact in const [
   ('', 'Chat en direct', 'Réponse en moins de 5 min, 7j/7',
    'Un conseiller arrive dans le chat (démo)'),
   ('', 'Appeler le support', '+241 01 44 55 66 (gratuit)',
    'Appel simulé — numéro démo'),
   ('', 'Envoyer un e-mail', 'support@okoume.ga',
    'Adresse copiée dans le presse-papiers (démo)'),
   ]) ...[
   AppListTile(
    emoji: contact.$1,
    title: contact.$2,
    subtitle: contact.$3,
    trailing: const AppIcon(AppIcons.chevron_right_rounded),
    onTap: () =>
     showAppSnack(context, contact.$4, emoji: contact.$1),
   ),
   const SizedBox(height: 10),
   ],
   const SizedBox(height: 8),
   const InfoBanner(
   emoji: '',
   color: AppColors.primary,
   text:
    'Support 7 j/7 de 7 h à 22 h (heure de Libreville). Les urgences livraison sont traitées en priorité.',
   ),
  ],
  ),
 );
 }
}
