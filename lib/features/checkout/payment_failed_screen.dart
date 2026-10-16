import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/models.dart';
import 'checkout_screen.dart';

/// A-52 · Échec de paiement — explication, relance ou changement de méthode.
/// Aucun débit n'est effectué, la commande reste « en panier ».
class PaymentFailedScreen extends ConsumerStatefulWidget {
  const PaymentFailedScreen({super.key, this.payload, this.reason});

  final CheckoutPayload? payload;
  final String? reason;

  @override
  ConsumerState<PaymentFailedScreen> createState() =>
      _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends ConsumerState<PaymentFailedScreen> {
  @override
  void initState() {
    super.initState();
    if (!AppMotion.reduce) AppMotion.warning();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final payload = widget.payload;
    final method = payload?.method ?? PaymentMethod.airtel;
    final total = payload?.total ?? 0;

    final reason = widget.reason ??
        switch (method) {
          PaymentMethod.carte =>
            'Authentification 3-D Secure refusée par votre banque (code erroné ou délai dépassé).',
          PaymentMethod.wallet =>
            'Solde insuffisant sur votre portefeuille Okoumé. Rechargez puis réessayez.',
          PaymentMethod.cash =>
            'La commande n\'a pas pu être enregistrée. Vérifiez vos articles et réessayez.',
          _ =>
            'Transaction refusée ou délai dépassé. Vérifiez votre solde ${method.label} puis réessayez.',
        };

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
          children: [
            Center(
              child: MotionEnter(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('⛔',
                      style: TextStyle(fontSize: 42)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Paiement échoué',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Votre commande n\'a pas été passée et aucun montant n\'a été débité.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 22),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(method.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          method.label,
                          style: const TextStyle(
                              fontSize: 13.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (total > 0)
                        Text(
                          formatXaf(total),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    reason,
                    style: TextStyle(
                        fontSize: 12.5, height: 1.45, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const InfoBanner(
              emoji: '🛡️',
              color: AppColors.primary,
              text:
                  'Vos articles restent dans le panier. Aucun frais n\'est appliqué pour une tentative échouée.',
            ),
            const SizedBox(height: 22),
            AppButton(
              label: 'Réessayer le paiement',
              icon: AppIcons.fast_forward_rounded,
              onPressed: () {
                if (payload == null) {
                  context.go('/checkout');
                  return;
                }
                context.pushReplacement('/payment', extra: payload);
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Changer de méthode de paiement',
              variant: AppButtonVariant.outline,
              icon: AppIcons.credit_card_rounded,
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/checkout');
                }
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Contacter le support',
              variant: AppButtonVariant.ghost,
              icon: AppIcons.support_agent_rounded,
              onPressed: () => context.push('/help'),
            ),
          ],
        ),
      ),
    );
  }
}
