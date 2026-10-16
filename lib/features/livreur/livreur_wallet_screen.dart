import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class LivreurWalletScreen extends ConsumerWidget {
  const LivreurWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(livreurProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes gains')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // -------------------------------------------------------- Solde
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF4A2FA3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C4DFF).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Solde livreur',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatXaf(state.wallet),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Gains du jour : ${formatXaf(state.gainsToday)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _withdraw(context, state.wallet),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIcon(AppIcons.south_west_rounded,
                                  size: 16, color: Color(0xFF4A2FA3)),
                              SizedBox(width: 6),
                              Text(
                                'Retirer',
                                style: TextStyle(
                                  color: Color(0xFF4A2FA3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => showAppSnack(
                            context,
                            'Primes de la semaine : 5 000 FCFA (démo)',
                            emoji: '🎁'),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIcon(AppIcons.card_giftcard_rounded,
                                  size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Primes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------- Stats
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  emoji: '🛵',
                  label: 'Courses',
                  value: '${state.history.length}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  emoji: '⭐',
                  label: 'Note moyenne',
                  value: '4,9',
                  delta: 'Top 10 %',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  emoji: '⏱',
                  label: 'En ligne',
                  value: '4 h 20',
                ),
              ),
            ],
          ),

          // ---------------------------------------------------- Historique
          const SizedBox(height: 18),
          Text('Courses terminées', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          if (state.history.isEmpty)
            AppCard(
              child: Text(
                'Vos courses terminées apparaîtront ici, avec le détail des gains.',
                style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
              ),
            )
          else
            for (final course in state.history)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      SellerAvatar(
                          emoji: course.sellerEmoji, seed: 5, size: 40),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${course.pickup} → ${course.dropoff}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${course.distanceKm} km · ≈ ${course.etaMin} min · ${course.vehicle.emoji} ${course.vehicle.label}',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+ ${formatXaf(course.payout)}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

          const SizedBox(height: 8),
          const InfoBanner(
            emoji: '⚡',
            color: AppColors.success,
            text:
                'Vos gains sont crédités instantanément après chaque livraison validée par le client (OTP).',
          ),
        ],
      ),
    );
  }

  void _withdraw(BuildContext context, int wallet) {
    var amount = wallet >= 10000 ? 10000 : wallet;
    showAppSheet(
      context,
      StatefulBuilder(
        builder: (context, setSheetState) {
          final cs = Theme.of(context).colorScheme;
          final amounts = [10000, 20000, 30000]
              .where((a) => a <= wallet)
              .toList();
          if (amount > wallet) amount = wallet;
          return Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Retirer mes gains',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Vers Airtel Money ou Moov Money · arrivée sous 2 h',
                  style:
                      TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final a in amounts)
                      AppChip(
                        label: formatXaf(a),
                        selected: amount == a,
                        onTap: () => setSheetState(() => amount = a),
                      ),
                    AppChip(
                      label: 'Tout (${formatXaf(wallet)})',
                      selected: amount == wallet && wallet > 0,
                      onTap: () => setSheetState(() => amount = wallet),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: 'Retirer ${formatXaf(amount)}',
                  icon: AppIcons.south_west_rounded,
                  variant: AppButtonVariant.success,
                  onPressed: amount <= 0
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          showAppSnack(
                            context,
                            'Retrait de ${formatXaf(amount)} initié — réception sous 2 h.',
                            emoji: '🏦',
                          );
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
