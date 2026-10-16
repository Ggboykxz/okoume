import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.any((n) => !n.read))
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllRead();
                showAppSnack(context, 'Toutes les notifications sont lues',
                    emoji: '✅');
              },
              child: const Text('Tout lire',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyState(
              emoji: '🔔',
              title: 'Aucune notification',
              message:
                  'Suivi de commande, promos et messages : tout arrive ici.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final n = notifications[i];
                return Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: n.read
                        ? cs.surface
                        : cs.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: n.read
                          ? cs.outlineVariant
                          : cs.primary.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        alignment: Alignment.center,
                        child: Text(n.emoji,
                            style: const TextStyle(fontSize: 19)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    n.title,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: n.read
                                          ? FontWeight.w600
                                          : FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  timeAgo(n.time),
                                  style: TextStyle(
                                      fontSize: 10.5,
                                      color: cs.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              n.body,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      if (!n.read) ...[
                        const SizedBox(width: 8),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
