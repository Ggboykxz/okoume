import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../core/ui/app_icons.dart';

class PaymentMethodsScreen extends ConsumerWidget {
 const PaymentMethodsScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 const subtitles = {
  PaymentMethod.airtel: 'Par défaut +241 •• 12 33',
  PaymentMethod.moov: '+241 •• 45 67',
  PaymentMethod.carte: 'Visa •••• 4821 expire 09/27',
  PaymentMethod.cash: 'Vous payez à la réception du colis',
  PaymentMethod.wallet: 'Solde prépayé recharge instantanée',
 };

 return Scaffold(
  appBar: AppBar(title: const Text('Moyens de paiement')),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
  children: [
   for (final method in PaymentMethod.values)
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
    child: AppListTile(
    emoji: method.emoji.isNotEmpty ? method.emoji : '•',
    iconColor: method.color,
    title: method.label,
    subtitle: subtitles[method],
    trailing: method == PaymentMethod.airtel
     ? const Pill(
      text: 'Par défaut',
      color: AppColors.success,
      dense: true,
      )
     : null,
    onTap: () => showAppSnack(
     context,
     method == PaymentMethod.airtel
      ? '${method.label} est votre moyen par défaut'
      : '${method.label} sélectionnable au paiement',
     emoji: '',
    ),
    ),
   ),
   const SizedBox(height: 10),
   AppButton(
   label: 'Ajouter une carte bancaire',
   icon: AppIcons.add_card_rounded,
   variant: AppButtonVariant.outline,
   onPressed: () => _addCard(context),
   ),
   const SizedBox(height: 18),
   const InfoBanner(
   emoji: '',
   color: AppColors.success,
   text:
    'Tous les paiements passent par l\'escrow Okoumé : vos fonds ne sont versés au vendeur qu\'après confirmation de réception.',
   ),
  ],
  ),
 );
 }

 void _addCard(BuildContext context) {
 final numberController = TextEditingController();
 final expiryController = TextEditingController();
 showAppSheet(
  context,
  Padding(
  padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
  child: Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   Text('Nouvelle carte',
    style: Theme.of(context).textTheme.titleMedium),
   const SizedBox(height: 14),
   AppTextField(
    controller: numberController,
    hint: 'Numéro de carte (Visa / Mastercard)',
    icon: AppIcons.credit_card_rounded,
    keyboardType: TextInputType.number,
   ),
   const SizedBox(height: 10),
   AppTextField(
    controller: expiryController,
    hint: 'Expiration (MM/AA)',
    icon: AppIcons.event_rounded,
   ),
   const SizedBox(height: 16),
   AppButton(
    label: 'Enregistrer la carte',
    icon: AppIcons.lock_rounded,
    onPressed: () {
    if (numberController.text.trim().length < 12) {
     showAppSnack(
      context, 'Numéro de carte incomplet', emoji: '');
     return;
    }
    Navigator.of(context).pop();
    showAppSnack(
     context, 'Carte ajoutée et vérifiée (démo)', emoji: '');
    },
   ),
   ],
  ),
  ),
 );
 }
}
