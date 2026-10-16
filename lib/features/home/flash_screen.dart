import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// A-12 · Offres Flash — prix cassés du jour avec compte à rebours.
class FlashSalesScreen extends ConsumerWidget {
  const FlashSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flash = ref.watch(flashDealsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offres flash ⚡'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: CountdownText(size: 12.5)),
          ),
        ],
      ),
      body: flash.isEmpty
          ? const EmptyState(
              emoji: '⚡',
              title: 'Pas d\'offre en cours',
              message:
                  'Les offres flash reviennent chaque jour. Revenez demain !',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
              children: [
                MotionEnter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A3D), Color(0xFFFF1744)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 30)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${flash.length} offres du jour',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Prix cassés jusqu\'à minuit — stock limité',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.62,
                  children: [
                    for (var i = 0; i < flash.length; i++)
                      MotionEnter(
                        order: i,
                        child: ProductCard(product: flash[i]),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                const InfoBanner(
                  emoji: '💡',
                  color: AppColors.warning,
                  text:
                      'Les offres flash sont limitées en quantité. Un article épuisé peut disparaître de la liste à tout moment.',
                ),
              ],
            ),
    );
  }
}
