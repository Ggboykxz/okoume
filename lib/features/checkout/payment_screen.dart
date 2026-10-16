import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import 'checkout_screen.dart';
import '../../core/ui/app_icons.dart';

/// Simulation de paiement : Airtel / Moov Money (USSD), carte (3-D Secure),
/// portefeuille ou cash à la livraison. La commande est créée à la réussite.
class PaymentScreen extends ConsumerStatefulWidget {
 const PaymentScreen({super.key, this.payload});

 final CheckoutPayload? payload;

 @override
 ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
 Timer? _timer;

 @override
 void initState() {
  super.initState();
  final method = widget.payload?.method ?? PaymentMethod.airtel;
  final delay = switch (method) {
   PaymentMethod.cash => const Duration(milliseconds: 1500),
   PaymentMethod.wallet => const Duration(milliseconds: 1700),
   PaymentMethod.carte => const Duration(milliseconds: 2500),
   _ => const Duration(milliseconds: 2900),
  };
  _timer = Timer(delay, _complete);
 }

 @override
 void dispose() {
  _timer?.cancel();
  super.dispose();
 }

 void _complete() {
  if (!mounted) return;
  final cart = ref.read(cartProvider);
  final totals = ref.read(cartTotalsProvider);
  if (cart.lines.isEmpty) {
   context.go('/main');
   return;
  }
  final payload = widget.payload ??
    CheckoutPayload(
     method: PaymentMethod.airtel,
     mode: DeliveryMode.domicile,
     speed: DeliverySpeed.standard,
     address: ref.read(addressesProvider).first,
     deliveryFee: totals.delivery,
     total: totals.total,
    );
  final order = ref.read(ordersProvider.notifier).place(
     lines: cart.lines,
     totals: totals,
     address: payload.address,
     payment: payload.method,
     mode: payload.mode,
     speed: payload.speed,
     deliveryFee: payload.deliveryFee,
    );
  ref.read(cartProvider.notifier).clear();
  context.go('/success/${order.id}');
 }

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final method = widget.payload?.method ?? PaymentMethod.airtel;
  final total = widget.payload?.total ??
    ref.watch(cartTotalsProvider).total;
  final titles = switch (method) {
   PaymentMethod.airtel => 'Confirmez sur votre téléphone',
   PaymentMethod.moov => 'Confirmez sur votre téléphone',
   PaymentMethod.carte => 'Paiement sécurisé en cours',
   PaymentMethod.cash => 'Commande sans prépaiement',
   PaymentMethod.wallet => 'Débit de votre portefeuille',
  };
  final subtitles = switch (method) {
   PaymentMethod.airtel =>
    'Une demande de paiement a été envoyée à votre numéro Airtel. Validez avec votre code secret (USSD #150*4#).',
   PaymentMethod.moov =>
    'Une demande de paiement a été envoyée à votre numéro Moov. Validez avec votre code secret (USSD #111#).',
   PaymentMethod.carte =>
    'Authentification 3-D Secure auprès de votre banque… Ne fermez pas cette page.',
   PaymentMethod.cash =>
    'Vous paierez en espèces à la réception. Vérifiez le colis avant de payer.',
   PaymentMethod.wallet =>
    '${formatXaf(total)} vont être débités de votre solde Okoumé.',
  };

  return Scaffold(
   body: SafeArea(
    child: Padding(
     padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
     child: Column(
      children: [
       const Spacer(flex: 2),
       // ------------------------------------------------ Icône méthode
       Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
         color: method.color.withValues(alpha: 0.12),
         shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(method.emoji.isNotEmpty ? method.emoji : '•', style: const TextStyle(fontSize: 16)),
       ),
       const SizedBox(height: 22),
       Text(
        titles,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
       ),
       const SizedBox(height: 10),
       Text(
        subtitles,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
       ),
       const SizedBox(height: 26),
       Text(
        formatXaf(total),
        style: const TextStyle(
         fontFamily: 'Montserrat',
         fontWeight: FontWeight.w800,
         fontSize: 34,
        ),
       ),
       const SizedBox(height: 34),
       SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
         strokeWidth: 3,
         color: method.color,
        ),
       ),
       const SizedBox(height: 14),
       Text(
        method.isMobileMoney
          ? 'En attente de confirmation…'
          : 'Transaction en cours…',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.onSurfaceVariant),
       ),
       const Spacer(flex: 3),
       // ------------------------------------------------ Étapes & annulation
       AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
         children: [
          const _PayStep(
            done: true, text: 'Commande créée et sécurisée'),
          const SizedBox(height: 8),
          _PayStep(
           done: false,
           text: method == PaymentMethod.cash
             ? 'Préparation par le vendeur'
             : 'Paiement via ${method.label}',
          ),
          const SizedBox(height: 8),
          const _PayStep(
            done: false, text: 'Confirmation et suivi en direct'),
         ],
        ),
       ),
       const SizedBox(height: 14),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         TextButton(
          onPressed: () {
           _timer?.cancel();
           context.pop();
          },
          child: Text(
           'Annuler le paiement',
           style: TextStyle(
             color: cs.onSurfaceVariant,
             fontWeight: FontWeight.w600),
          ),
         ),
         Container(width: 1, height: 16, color: cs.outlineVariant),
         TextButton(
          onPressed: () {
           _timer?.cancel();
           if (context.canPop()) {
            context.pushReplacement('/payment/failed',
              extra: widget.payload);
           } else {
            context.go('/payment/failed');
           }
          },
          child: Text(
           'Échec (démo)',
           style: TextStyle(
             color: cs.onSurfaceVariant.withValues(alpha: 0.75),
             fontWeight: FontWeight.w600),
          ),
         ),
        ],
       ),
      ],
     ),
    ),
   ),
  );
 }
}

class _PayStep extends StatelessWidget {
 const _PayStep({required this.done, required this.text});

 final bool done;
 final String text;

 @override
 Widget build(BuildContext context) {
  return Row(
   children: [
    Container(
     width: 20,
     height: 20,
     decoration: BoxDecoration(
      color: done
        ? AppColors.success.withValues(alpha: 0.14)
        : Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: BoxShape.circle,
     ),
     alignment: Alignment.center,
     child: done
       ? const AppIcon(AppIcons.check_rounded,
         size: 13, color: AppColors.success)
       : Container(
         width: 7,
         height: 7,
         decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
         ),
        ),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: Text(
      text,
      style: TextStyle(
       fontSize: 13,
       fontWeight: done ? FontWeight.w700 : FontWeight.w500,
       color: done
         ? Theme.of(context).colorScheme.onSurface
         : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
     ),
    ),
   ],
  );
 }
}
