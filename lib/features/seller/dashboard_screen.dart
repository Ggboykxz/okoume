import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../shell/main_shell.dart';
import '../../core/ui/app_icons.dart';

class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final stats = ref.watch(sellerStatsProvider);
    final sellerState = ref.watch(sellerProvider);
    final user = ref.watch(authProvider);
    final toProcess = sellerState.orders
        .where((o) => o.status.isActive)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma boutique'),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.insights_rounded),
            onPressed: () => showAppSnack(
                context, 'Rapport complet envoyé par e-mail (démo)',
                emoji: '📈'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ------------------------------------------------------ Bandeau
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0066CC), Color(0xFF003D7A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏪', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Ma boutique',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tableau de bord vendeur',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Row(
                        children: [
                          AppIcon(AppIcons.verified_rounded,
                              size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'KYC OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  formatXaf(stats.monthRevenue),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Chiffre d\'affaires du mois',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------------- Stats
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  emoji: '🛒',
                  label: 'Commandes',
                  value: '${stats.monthOrders}',
                  delta: '+12 %',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  emoji: '🧺',
                  label: 'Panier moyen',
                  value: formatXafCompact(stats.avgBasket),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  emoji: '👀',
                  label: 'Vues (7 j)',
                  value: formatNumber(stats.views),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  emoji: '🎯',
                  label: 'Conversion',
                  value: '${(stats.conversion * 100).toStringAsFixed(1)} %',
                  delta: 'Objectif 5 %',
                ),
              ),
            ],
          ),

          // ---------------------------------------------------- Graphique
          SectionHeader(
            title: 'Ventes des 7 derniers jours',
            subtitle: 'Montants encaissés (escrow inclus)',
          ),
          AppCard(
            child: BarChartMini(
              values: stats.weekly,
              labels: const ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
            ),
          ),

          // ------------------------------------------------------ Actions
          const SizedBox(height: 18),
          AppButton(
            label: 'Nouvelle vente rapide (< 60 s)',
            icon: AppIcons.bolt_rounded,
            onPressed: () => shellTabNotifier.value = 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Finance & retraits',
                  icon: AppIcons.account_balance_wallet_rounded,
                  variant: AppButtonVariant.outline,
                  small: true,
                  height: 46,
                  onPressed: () => context.push('/seller/finance'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Mes produits',
                  icon: AppIcons.inventory_2_rounded,
                  variant: AppButtonVariant.outline,
                  small: true,
                  height: 46,
                  onPressed: () => shellTabNotifier.value = 1,
                ),
              ),
            ],
          ),

          // ------------------------------------------------ À traiter
          SectionHeader(
            title: 'À traiter (${toProcess.length})',
            subtitle: toProcess.isEmpty
                ? 'Tout est à jour, bravo !'
                : 'Commandes en attente d\'action',
            actionLabel: 'Tout voir',
            onAction: () => shellTabNotifier.value = 3,
          ),
          if (toProcess.isEmpty)
            AppCard(
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aucune commande en attente. Vos ventes du jour sont expédiées.',
                      style: TextStyle(
                          fontSize: 12.5, color: cs.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            )
          else
            for (final order in toProcess.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Text(
                        order.lines.first.emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${order.code}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${order.lines.length} article(s) · ${formatXaf(order.total)}',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      StatusChip(status: order.status),
                    ],
                  ),
                ),
              ),

          // ------------------------------------------------------- Astuce
          const SizedBox(height: 16),
          InfoBanner(
            emoji: '💡',
            color: cs.secondary,
            text:
                'Ajoutez des photos lumineuses sur fond neutre : les annonces avec photo se vendent 3× plus vite sur Okoumé.',
          ),
        ],
      ),
    );
  }
}
