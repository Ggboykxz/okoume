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
 final numberErr = <String?>[null];
 final expiryErr = <String?>[null];
 showAppSheet(
  context,
  StatefulBuilder(
   builder: (sheetContext, setSheetState) {
    return Padding(
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
      errorText: numberErr[0],
      onChanged: (_) {
       if (numberErr[0] != null) setSheetState(() => numberErr[0] = null);
      },
     ),
     const SizedBox(height: 10),
     AppTextField(
      controller: expiryController,
      hint: 'Expiration (MM/AA)',
      icon: AppIcons.event_rounded,
      errorText: expiryErr[0],
      onChanged: (_) {
       if (expiryErr[0] != null) setSheetState(() => expiryErr[0] = null);
      },
     ),
     const SizedBox(height: 16),
     AppButton(
      label: 'Enregistrer la carte',
      icon: AppIcons.lock_rounded,
      onPressed: () {
      final num = numberController.text.trim().replaceAll(RegExp(r'\s'), '');
      if (num.length < 12) {
       setSheetState(() => numberErr[0] = 'Numéro de carte incomplet');
       return;
      }
      final exp = expiryController.text.trim();
      if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(exp)) {
       setSheetState(() => expiryErr[0] = 'Format attendu : MM/AA');
       return;
      }
      final parts = exp.split('/');
      final now = DateTime.now();
      final expDate = DateTime(2000 + int.parse(parts[1]), int.parse(parts[0]));
      if (expDate.isBefore(DateTime(now.year, now.month))) {
       setSheetState(() => expiryErr[0] = 'Carte expirée');
       return;
      }
      Navigator.of(context).pop();
      showAppSnack(context, 'Carte enregistrée (démo)', emoji: '');
      },
     ),
     ],
    ),
    );
   },
  ),
 );
 }
}
