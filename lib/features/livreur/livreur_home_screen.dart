import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class LivreurHomeScreen extends ConsumerWidget {
  const LivreurHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(livreurProvider);
    final notifier = ref.read(livreurProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.support_agent_rounded),
            onPressed: () => showAppSnack(
                context, 'Support livreurs 7j/7 (démo)', emoji: '🎧'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ---------------------------------------------------- Statut en ligne
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: state.online
                  ? AppColors.success.withValues(alpha: 0.08)
                  : cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: state.online
                    ? AppColors.success.withValues(alpha: 0.45)
                    : cs.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: state.online
                        ? AppColors.success
                        : cs.onSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.online ? 'En ligne' : 'Hors ligne',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 14.5),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        state.online
                            ? 'Vous recevez les courses autour de Libreville'
                            : 'Passez en ligne pour recevoir des courses',
                        style: TextStyle(
                            fontSize: 12, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: state.online,
                  onChanged: (_) {
                    notifier.toggleOnline();
                    showAppSnack(
                      context,
                      state.online
                          ? 'Vous êtes maintenant hors ligne'
                          : 'Vous êtes en ligne — bonnes courses ! 🛵',
                      emoji: state.online ? '😴' : '🟢',
                    );
                  },
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
                  emoji: '💵',
                  label: 'Gains du jour',
                  value: formatXafCompact(state.gainsToday),
                  delta: '+18 % vs hier',
                ),
              ),
              const SizedBox(width: 10),
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
                  label: 'Note',
                  value: '4,9',
                ),
              ),
            ],
          ),

          // ------------------------------------------------ Course en cours
          if (state.active != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
                border:
                    Border.all(color: cs.primary.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🛵', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'Course en cours',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: cs.primary,
                        ),
                      ),
                      const Spacer(),
                      Pill(
                        text: formatXaf(state.active!.payout),
                        color: AppColors.success,
                        dense: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${state.active!.pickup}  →  ${state.active!.dropoff}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${state.active!.distanceKm} km · ≈ ${state.active!.etaMin} min · ${state.active!.vehicle.label}',
                    style: TextStyle(
                        fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Reprendre la course',
                    icon: AppIcons.navigation_rounded,
                    height: 46,
                    onPressed: () => context.push('/livreur/course'),
                  ),
                ],
              ),
            ),
          ],

          // --------------------------------------------- Courses disponibles
          const SizedBox(height: 20),
          Text(
            state.online
                ? 'Courses disponibles (${state.available.length})'
                : 'Courses disponibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            state.online
                ? 'Autour de vous, à moins de 5 km'
                : 'Passez en ligne pour les voir',
            style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          if (!state.online)
            AppCard(
              child: Column(
                children: [
                  const Text('😴', style: TextStyle(fontSize: 34)),
                  const SizedBox(height: 8),
                  Text(
                    'Mode repos activé',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Repassez en ligne pour recevoir des courses. Votre solde et vos gains restent disponibles dans l\'onglet Gains.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else if (state.available.isEmpty)
            AppCard(
              child: Row(
                children: [
                  const Text('🎣', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aucune course pour le moment. Restez en ligne, les demandes arrivent vite !',
                      style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: cs.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            )
          else
            for (final course in state.available)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CourseCard(
                  course: course,
                  onAccept: () {
                    notifier.accept(course.id);
                    showAppSnack(
                        context, 'Course acceptée — direction le retrait 🛵',
                        emoji: '✅');
                    context.push('/livreur/course');
                  },
                  onRefuse: () {
                    notifier.refuse(course.id);
                    showAppSnack(context, 'Course refusée', emoji: '👋');
                  },
                ),
              ),

          const SizedBox(height: 6),
          const InfoBanner(
            emoji: '🛡️',
            color: AppColors.success,
            text:
                'Assurance colis incluse. En cas d\'imprévu, signalez depuis la course active — le support vous rappelle sous 10 min.',
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
    required this.onAccept,
    required this.onRefuse,
  });

  final Course course;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SellerAvatar(emoji: course.sellerEmoji, seed: 5, size: 42),
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
                          fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${course.distanceKm} km · ≈ ${course.etaMin} min · ${course.vehicle.emoji} ${course.vehicle.label}',
                      style: TextStyle(
                          fontSize: 11.5, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatXaf(course.payout),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  Text('votre gain',
                      style: TextStyle(
                          fontSize: 10.5, color: cs.onSurfaceVariant)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Accepter',
                  small: true,
                  height: 42,
                  variant: AppButtonVariant.success,
                  onPressed: onAccept,
                ),
              ),
              const SizedBox(width: 10),
              AppButton(
                label: 'Refuser',
                small: true,
                height: 42,
                expanded: false,
                variant: AppButtonVariant.outline,
                onPressed: onRefuse,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
