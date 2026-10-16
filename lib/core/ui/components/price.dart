import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../format.dart';

// ================================================================= Prix

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.oldPrice,
    this.size = 16,
    this.color,
  });

  final int price;
  final int? oldPrice;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            formatXaf(price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.montserrat,
              fontWeight: FontWeight.w700,
              fontSize: size,
              color: color ?? cs.onSurface,
            ),
          ),
        ),
        if (oldPrice != null && oldPrice! > price) ...[
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              formatXaf(oldPrice!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: size * 0.72,
                color: cs.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
                decorationColor: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Ligne de récapitulatif (sous-total, livraison…).
class AmountRow extends StatelessWidget {
  const AmountRow({
    super.key,
    required this.label,
    required this.amount,
    this.bold = false,
    this.color,
    this.free = false,
  });

  final String label;
  final int amount;
  final bool bold;
  final Color? color;
  final bool free;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: bold ? 14.5 : 13.5,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: bold ? cs.onSurface : cs.onSurfaceVariant),
            ),
          ),
          Text(
            free ? 'Offerte' : formatXaf(amount),
            style: TextStyle(
              fontFamily: bold ? AppTheme.montserrat : null,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              fontSize: bold ? 16 : 13.5,
              color: color ??
                  (free ? AppColors.success : (bold ? cs.onSurface : cs.onSurface)),
            ),
          ),
        ],
      ),
    );
  }
}
