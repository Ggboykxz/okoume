import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class ChatListScreen extends ConsumerWidget {
 const ChatListScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;
  final threads = ref.watch(chatProvider);
  final sorted = List<ChatThread>.of(threads)
   ..sort((a, b) {
    final ta = a.last?.time ?? DateTime(2000);
    final tb = b.last?.time ?? DateTime(2000);
    return tb.compareTo(ta);
   });

  return Scaffold(
   appBar: AppBar(
    title: const Text('Messages'),
    actions: [
     IconButton(
      icon: const AppIcon(AppIcons.search_rounded),
      onPressed: () =>
        showAppSnack(context, 'Recherche dans les messages (démo)',
          emoji: ''),
     ),
    ],
   ),
   body: sorted.isEmpty
     ? EmptyState(
       emoji: '',
       title: 'Aucune conversation',
       message:
         'Contactez un vendeur depuis une fiche produit pour négocier ou poser une question.',
       actionLabel: 'Explorer le catalogue',
       onAction: () => context.go('/main'),
      )
     : ListView.separated(
       padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
       itemCount: sorted.length,
       separatorBuilder: (_, _) => const SizedBox(height: 10),
       itemBuilder: (context, i) {
        final thread = sorted[i];
        final seller = Mock.sellerById(thread.sellerId);
        final last = thread.last;
        return _ThreadTile(
         thread: thread,
         sellerEmoji: seller.emoji.isNotEmpty ? seller.emoji : '•',
         sellerSeed: seller.seed,
         sellerName: seller.name,
         sellerVerified: seller.verified,
         preview: last == null
           ? 'Démarrez la conversation'
           : last.kind == MessageKind.offer
             ? '${last.fromMe ? 'Vous : ' : ''} Offre — ${last.text}'
             : '${last.fromMe ? 'Vous : ' : ''}${last.text}',
         time: last == null ? '' : timeAgo(last.time),
         onlineHint: seller.verified && cs.brightness == Brightness.light
           ? 'Répond en ~${seller.responseMin} min'
           : 'Répond en ~${seller.responseMin} min',
        );
       },
      ),
  );
 }
}

class _ThreadTile extends StatelessWidget {
 const _ThreadTile({
  required this.thread,
  required this.sellerEmoji,
  required this.sellerSeed,
  required this.sellerName,
  required this.sellerVerified,
  required this.preview,
  required this.time,
  required this.onlineHint,
 });

 final ChatThread thread;
 final String sellerEmoji;
 final int sellerSeed;
 final String sellerName;
 final bool sellerVerified;
 final String preview;
 final String time;
 final String onlineHint;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return GestureDetector(
   onTap: () => context.push('/chat/${thread.id}'),
   child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(18),
     border: Border.all(
      color: thread.unread > 0
        ? cs.primary.withValues(alpha: 0.4)
        : cs.outlineVariant,
     ),
    ),
    child: Row(
     children: [
      SellerAvatar(
        emoji: sellerEmoji,
        seed: sellerSeed,
        size: 50,
        verified: sellerVerified),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
          children: [
           Flexible(
            child: Text(
             sellerName,
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: TextStyle(
              fontWeight: thread.unread > 0
                ? FontWeight.w800
                : FontWeight.w700,
              fontSize: 14,
             ),
            ),
           ),
           if (sellerVerified) ...[
            const SizedBox(width: 4),
            const AppIcon(AppIcons.verified_rounded,
              size: 15, color: AppColors.primary),
           ],
           const Spacer(),
           Text(time,
             style: TextStyle(
               fontSize: 11, color: cs.onSurfaceVariant)),
          ],
         ),
         const SizedBox(height: 3),
         Row(
          children: [
           Expanded(
            child: Text(
             preview,
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: TextStyle(
              fontSize: 12.5,
              color: thread.unread > 0
                ? cs.onSurface
                : cs.onSurfaceVariant,
              fontWeight: thread.unread > 0
                ? FontWeight.w600
                : FontWeight.w500,
             ),
            ),
           ),
           if (thread.unread > 0) ...[
            const SizedBox(width: 8),
            Container(
             padding: const EdgeInsets.symmetric(
               horizontal: 7, vertical: 2.5),
             decoration: BoxDecoration(
              color: AppColors.danger,
              borderRadius: BorderRadius.circular(99),
             ),
             child: Text(
              '${thread.unread}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w800),
             ),
            ),
           ],
          ],
         ),
         const SizedBox(height: 3),
         Text(onlineHint,
           style: TextStyle(
             fontSize: 10.5,
             color: AppColors.success,
             fontWeight: FontWeight.w600)),
        ],
       ),
      ),
     ],
    ),
   ),
  );
 }
}
