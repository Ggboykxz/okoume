import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class SellerOrdersScreen extends ConsumerStatefulWidget {
 const SellerOrdersScreen({super.key});

 @override
 ConsumerState<SellerOrdersScreen> createState() =>
  _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends ConsumerState<SellerOrdersScreen> {
 int _filter = 0;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final orders = ref.watch(sellerProvider).orders;
 final toProcess = orders.where((o) => o.status.isActive).toList();
 final list = _filter == 0 ? toProcess : orders;

 return Scaffold(
  appBar: AppBar(title: const Text('Commandes reçues')),
  body: Column(
  children: [
   SizedBox(
   height: 58,
   child: ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
    children: [
    AppChip(
     label: 'À traiter (${toProcess.length})',
     icon: AppIcons.notifications_active_rounded,
     selected: _filter == 0,
     onTap: () => setState(() => _filter = 0),
    ),
    const SizedBox(width: 8),
    AppChip(
     label: 'Toutes (${orders.length})',
     icon: AppIcons.receipt_long_rounded,
     selected: _filter == 1,
     onTap: () => setState(() => _filter = 1),
    ),
    ],
   ),
   ),
   Expanded(
   child: list.isEmpty
    ? EmptyState(
     emoji: _filter == 0 ? '' : '',
     title: _filter == 0
      ? 'Aucune commande à traiter'
      : 'Aucune commande reçue',
     message: _filter == 0
      ? 'Vous êtes à jour ! Les nouvelles commandes arriveront ici en temps réel.'
      : 'Vos premières ventes apparaîtront ici dès qu\'un acheteur commandera.',
     )
    : ListView.separated(
     padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
     itemCount: list.length,
     separatorBuilder: (_, _) => const SizedBox(height: 12),
     itemBuilder: (context, i) =>
      _SellerOrderCard(order: list[i]),
     ),
   ),
   if (list.isNotEmpty)
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
    child: Text(
    'Les fonds sont libérés automatiquement 24 h après la livraison confirmée.',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
    ),
   ),
  ],
  ),
 );
 }
}

class _SellerOrderCard extends ConsumerWidget {
 const _SellerOrderCard({required this.order});

 final Order order;

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final cs = Theme.of(context).colorScheme;
 final first = order.lines.first;
 final extra = order.lines.length - 1;

 return AppCard(
  padding: const EdgeInsets.all(14),
  child: Column(
  children: [
   Row(
   children: [
    Text('#${order.code}',
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 13)),
    const SizedBox(width: 8),
    Text(timeAgo(order.createdAt),
     style: TextStyle(
      fontSize: 11, color: cs.onSurfaceVariant)),
    const Spacer(),
    StatusChip(status: order.status),
   ],
   ),
   const SizedBox(height: 12),
   Row(
   children: [
    SizedBox(
    width: 44,
    height: 44,
    child: ProductArt(
     emoji: first.emoji.isNotEmpty ? first.emoji : '•', seed: first.seed, radius: 11),
    ),
    const SizedBox(width: 11),
    Expanded(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(
      first.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
       fontWeight: FontWeight.w600, fontSize: 13),
     ),
     const SizedBox(height: 2),
     Text(
      extra > 0
       ? '+ $extra autre${extra > 1 ? 's' : ''} article${extra > 1 ? 's' : ''}'
       : '×${first.qty} ${first.variantLabel.isEmpty ? order.addressLabel : first.variantLabel}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
       fontSize: 11.5, color: cs.onSurfaceVariant),
     ),
     ],
    ),
    ),
    const SizedBox(width: 8),
    PriceText(price: order.total, size: 14),
   ],
   ),
   const SizedBox(height: 10),
   Row(
   children: [
    Expanded(
    child: Text(
     ' ${order.addressLabel}',
     maxLines: 1,
     overflow: TextOverflow.ellipsis,
     style: TextStyle(
      fontSize: 11.5, color: cs.onSurfaceVariant),
    ),
    ),
    if (order.status.isActive) ...[
    AppButton(
     label: 'Avancer',
     small: true,
     height: 36,
     expanded: false,
     icon: AppIcons.fast_forward_rounded,
     onPressed: () {
     ref
      .read(sellerProvider.notifier)
      .advanceOrder(order.id);
     showAppSnack(
      context, 'Commande mise à jour', emoji: '');
     },
    ),
    const SizedBox(width: 8),
    AppButton(
     label: 'Contacter',
     small: true,
     height: 36,
     expanded: false,
     variant: AppButtonVariant.outline,
     onPressed: () => showAppSnack(
      context, 'Client notifié par SMS (démo)', emoji: ''),
    ),
    ] else if (order.status == OrderStatus.livree)
    const Pill(
     text: ' Terminée',
     color: Color(0xFF00C853),
     dense: true,
    ),
   ],
   ),
  ],
  ),
 );
 }
}
