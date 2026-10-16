import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';

/// Reçu de commande (A-54) — feuille ascendante avec le détail complet.
Future<void> showReceiptSheet(BuildContext context, Order order) {
 final cs = Theme.of(context).colorScheme;
 return showAppSheet(
 context,
 Padding(
  padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
  child: Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   Row(
    children: [
    const AppIcon(AppIcons.receipt_long_rounded, size: 22),
    const SizedBox(width: 8),
    Expanded(
     child: Text(
     'Reçu ${order.code}',
     style: Theme.of(context).textTheme.titleMedium,
     ),
    ),
    Pill(
     text: order.status.label,
     color: order.status == OrderStatus.annulee
      ? AppColors.danger
      : AppColors.success,
    ),
    ],
   ),
   const SizedBox(height: 6),
   Text(
    'Émis le ${formatDate(order.createdAt)} ${order.lines.length} article${order.lines.length > 1 ? 's' : ''}',
    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
   ),
   Divider(height: 24, color: cs.outlineVariant),
   // --------------------------------------------------- Lignes d'articles
   for (final line in order.lines) ...[
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(line.emoji.isNotEmpty ? line.emoji : '•', style: const TextStyle(fontSize: 16)),
     const SizedBox(width: 9),
     Expanded(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(line.title,
       style: const TextStyle(
        fontSize: 13, fontWeight: FontWeight.w600)),
      Text(
       [
       if (line.variantLabel.isNotEmpty) line.variantLabel,
       '× ${line.qty}',
       'vendu par ${line.sellerName}',
       ].join(' '),
       style: TextStyle(
        fontSize: 11, color: cs.onSurfaceVariant),
      ),
      ],
     ),
     ),
     const SizedBox(width: 8),
     Text(
     formatXaf(line.price * line.qty),
     style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      fontFamily: 'Montserrat'),
     ),
    ],
    ),
    const SizedBox(height: 10),
   ],
   Divider(height: 22, color: cs.outlineVariant),
   _ReceiptRow(label: 'Sous-total', value: formatXaf(order.subtotal)),
   const SizedBox(height: 7),
   _ReceiptRow(label: 'Livraison', value: formatXaf(order.deliveryFee)),
   if (order.discount > 0) ...[
    const SizedBox(height: 7),
    _ReceiptRow(
    label: 'Réduction',
    value: '− ${formatXaf(order.discount)}',
    color: AppColors.success,
    ),
   ],
   const SizedBox(height: 7),
   _ReceiptRow(label: 'Mode de paiement', value: order.payment.label),
   if (order.escrowHeld)
    const Padding(
    padding: EdgeInsets.only(top: 7),
    child: _ReceiptRow(
     label: 'Séquestre',
     value: 'Fonds bloqués jusqu\'à réception',
     color: AppColors.primary,
    ),
    ),
   Divider(height: 24, color: cs.outlineVariant),
   Row(
    children: [
    Text('Total payé',
     style: Theme.of(context).textTheme.titleSmall),
    const Spacer(),
    PriceText(price: order.total, size: 18),
    ],
   ),
   const SizedBox(height: 14),
   Row(
    children: [
    Expanded(
     child: AppButton(
     label: 'Copier le reçu',
     variant: AppButtonVariant.outline,
     small: true,
     height: 44,
     icon: AppIcons.copy_rounded,
     onPressed: () => showAppSnack(
      context,
      'Reçu ${order.code} copié dans le presse-papiers',
      emoji: '',
     ),
     ),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: AppButton(
     label: 'Fermer',
     small: true,
     height: 44,
     onPressed: () => Navigator.of(context).pop(),
     ),
    ),
    ],
   ),
   ],
  ),
  ),
 );
}

class _ReceiptRow extends StatelessWidget {
 const _ReceiptRow({required this.label, required this.value, this.color});

 final String label;
 final String value;
 final Color? color;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Row(
  children: [
  Expanded(
   child: Text(label,
    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
  ),
  Text(
   value,
   style: TextStyle(
   fontSize: 13,
   fontWeight: FontWeight.w700,
   color: color,
   ),
  ),
  ],
 );
 }
}
