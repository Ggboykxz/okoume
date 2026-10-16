import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class OrdersScreen extends ConsumerStatefulWidget {
 const OrdersScreen({super.key});

 @override
 ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
 int _tab = 0;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final orders = ref.watch(ordersProvider);
 final active = orders.where((o) => o.status.isActive).toList();
 final delivered =
  orders.where((o) => o.status == OrderStatus.livree).toList();
 final cancelled =
  orders.where((o) => o.status == OrderStatus.annulee).toList();
 final list = switch (_tab) {
  0 => active,
  1 => delivered,
  _ => cancelled,
 };

 return Scaffold(
  appBar: AppBar(title: const Text('Mes commandes')),
  body: Column(
  children: [
   SizedBox(
   height: 58,
   child: ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
    children: [
    AppChip(
     label: 'En cours (${active.length})',
     icon: AppIcons.local_shipping_rounded,
     selected: _tab == 0,
     onTap: () => setState(() => _tab = 0),
    ),
    const SizedBox(width: 8),
    AppChip(
     label: 'Livrées (${delivered.length})',
     icon: AppIcons.check_circle_rounded,
     selected: _tab == 1,
     color: const Color(0xFF00C853),
     onTap: () => setState(() => _tab = 1),
    ),
    const SizedBox(width: 8),
    AppChip(
     label: 'Annulées (${cancelled.length})',
     icon: AppIcons.cancel_rounded,
     selected: _tab == 2,
     color: const Color(0xFFFF1744),
     onTap: () => setState(() => _tab = 2),
    ),
    ],
   ),
   ),
   Expanded(
   child: list.isEmpty
    ? EmptyState(
     emoji: _tab == 0
      ? ''
      : _tab == 1
       ? ''
       : '',
     title: _tab == 0
      ? 'Aucune commande en cours'
      : _tab == 1
       ? 'Aucune commande livrée'
       : 'Aucune commande annulée',
     message: _tab == 0
      ? 'Vos prochaines commandes apparaîtront ici avec leur suivi en direct.'
      : null,
     actionLabel: _tab == 0 ? 'Découvrir les produits' : null,
     onAction: _tab == 0 ? () => context.go('/main') : null,
     )
    : ListView.separated(
     padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
     itemCount: list.length,
     separatorBuilder: (_, _) => const SizedBox(height: 12),
     itemBuilder: (context, i) => _OrderCard(order: list[i]),
     ),
   ),
   if (_tab == 0 && active.isNotEmpty)
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
    child: Text(
    'Astuce : ouvrez une commande pour simuler l\'avancement de la livraison (démo).',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
    ),
   ),
  ],
  ),
 );
 }
}

class _OrderCard extends StatelessWidget {
 const _OrderCard({required this.order});

 final Order order;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final first = order.lines.first;
 final extra = order.lines.length - 1;

 return AppCard(
  onTap: () => context.push('/order/${order.id}'),
  child: Column(
  children: [
   Row(
   children: [
    SizedBox(
    width: 46,
    height: 46,
    child: ProductArt(
     emoji: first.emoji.isNotEmpty ? first.emoji : '•', seed: first.seed, radius: 12),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(
      first.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
       fontWeight: FontWeight.w700, fontSize: 13.5),
     ),
     const SizedBox(height: 2),
     Text(
      extra > 0
       ? '+ $extra autre${extra > 1 ? 's' : ''} article${extra > 1 ? 's' : ''}'
       : first.sellerName,
      style: TextStyle(
       fontSize: 11.5, color: cs.onSurfaceVariant),
     ),
     const SizedBox(height: 3),
     Text(
      '#${order.code} ${timeAgo(order.createdAt)}',
      style: TextStyle(
       fontSize: 11, color: cs.onSurfaceVariant),
     ),
     ],
    ),
    ),
    const SizedBox(width: 8),
    StatusChip(status: order.status),
   ],
   ),
   Divider(height: 24, color: cs.outlineVariant),
   Row(
   children: [
    Text('Total : ',
     style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
    PriceText(price: order.total, size: 14),
    const Spacer(),
    if (order.status.isActive)
    AppButton(
     label: 'Suivre',
     small: true,
     height: 38,
     expanded: false,
     icon: AppIcons.local_shipping_rounded,
     onPressed: () => context.push('/order/${order.id}'),
    )
    else if (order.status == OrderStatus.livree && !order.rated)
    AppButton(
     label: 'Noter',
     small: true,
     height: 38,
     expanded: false,
     icon: AppIcons.star_rounded,
     onPressed: () => context.push('/order/${order.id}'),
    )
    else
    AppButton(
     label: 'Détails',
     small: true,
     height: 38,
     expanded: false,
     variant: AppButtonVariant.outline,
     onPressed: () => context.push('/order/${order.id}'),
    ),
   ],
   ),
  ],
  ),
 );
 }
}
