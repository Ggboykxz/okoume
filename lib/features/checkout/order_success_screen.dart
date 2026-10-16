import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';
import '../orders/receipt_sheet.dart';
import '../shell/main_shell.dart';
import '../../core/ui/app_icons.dart';

class OrderSuccessScreen extends ConsumerWidget {
  const OrderSuccessScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final order = ref.watch(orderByIdProvider(orderId));
    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          emoji: '🧾',
          title: 'Commande introuvable',
          message: 'Cette commande n\'existe pas ou a été supprimée.',
        ),
      );
    }
    final user = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          children: [
            // --------------------------------------- Coche animée (Lottie)
            Center(
              child: _SuccessCheck(
                fallback: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E065), Color(0xFF00C853)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.35),
                        blurRadius: 26,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const AppIcon(AppIcons.check_rounded,
                      size: 56, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            MotionEnter(
              order: 1,
              child: Text(
                'Commande confirmée !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Merci ${user?.name.split(' ').first ?? ''} 🎉 Votre commande ${order.code} est enregistrée. Le vendeur a été notifié.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.5, height: 1.5, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            // ------------------------------------------------------ Récapitulatif
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('N° ${order.code}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13.5)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => showAppSnack(
                            context, 'Numéro de commande copié', emoji: '📋'),
                        child: AppIcon(AppIcons.copy_rounded,
                            size: 17, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                  Divider(height: 22, color: cs.outlineVariant),
                  _InfoRow(
                      emoji: '💰',
                      label: 'Total payé',
                      value: formatXaf(order.total)),
                  const SizedBox(height: 9),
                  _InfoRow(
                      emoji: '🛵',
                      label: 'Livraison',
                      value: order.deliveryLabel),
                  const SizedBox(height: 9),
                  _InfoRow(
                      emoji: '🕐',
                      label: 'Arrivée estimée',
                      value: formatDate(order.eta)),
                  const SizedBox(height: 9),
                  _InfoRow(
                      emoji: '📍',
                      label: 'Adresse',
                      value: order.addressLabel),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      order.escrowHeld
                          ? const Pill(
                              text: '💰 Paiement sous escrow',
                              color: AppColors.success,
                              icon: AppIcons.lock_rounded,
                            )
                          : const Pill(
                              text: '💵 Paiement à la livraison',
                              color: AppColors.warning,
                            ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (order.escrowHeld)
              const InfoBanner(
                emoji: '🔐',
                color: AppColors.success,
                text:
                    'Votre paiement est bloqué en toute sécurité. Il sera versé au vendeur uniquement après votre confirmation de réception.',
              )
            else
              const InfoBanner(
                emoji: '💵',
                color: AppColors.warning,
                text:
                    'Préparez le montant exact en espèces. Le livreur vous remettra un reçu après vérification du colis.',
              ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Suivre ma commande',
              icon: AppIcons.local_shipping_rounded,
              onPressed: () => context.push('/order/${order.id}'),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Voir le reçu',
              variant: AppButtonVariant.outline,
              icon: AppIcons.receipt_long_rounded,
              onPressed: () => showReceiptSheet(context, order),
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Continuer mes achats',
              variant: AppButtonVariant.outline,
              onPressed: () {
                shellTabNotifier.value = 0;
                context.go('/main');
              },
            ),
            const SizedBox(height: 18),
            Text(
              '🧾 Un reçu vous a été envoyé par SMS au ${user?.phone ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Coche de succès : animation Lottie (tracé progressif) avec repli statique,
/// et retour haptique unique à l'ouverture (Apple §13 — célébrer sobrement).
class _SuccessCheck extends StatefulWidget {
  const _SuccessCheck({required this.fallback});

  final Widget fallback;

  @override
  State<_SuccessCheck> createState() => _SuccessCheckState();
}

class _SuccessCheckState extends State<_SuccessCheck> {
  @override
  void initState() {
    super.initState();
    if (!AppMotion.reduce) AppMotion.success();
  }

  @override
  Widget build(BuildContext context) {
    return LottieArt(
      'assets/lottie/success.json',
      size: 148,
      fallback: widget.fallback,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
