import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../theme/app_colors.dart';
import '../app_icons.dart';
import '../motion.dart';

// ============================================================== Pastilles

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.icon,
    this.dense = false,
    this.onTap,
  });

  final String text;
  final Color? color;

  /// Couleur du texte/icône sur la pastille teintée. Déduite de [color] si absent.
  final Color? textColor;
  final AppIconData? icon;
  final bool dense;
  final VoidCallback? onTap;

  /// Texte lisible sur la pastille teintée (couleur à 13 %) et adapté au
  /// thème : variante sombre des couleurs vives qui échouent en dark.
  static Color _pillForeground(BuildContext context, Color c, ColorScheme cs) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (c == AppColors.success || c == AppColors.delivered) {
      return AppColors.onTintSuccess;
    }
    if (c == AppColors.pending || c == AppColors.warning) {
      return AppColors.onTintWarning;
    }
    if (c == AppColors.secondary || c == AppColors.preparing) {
      return AppColors.onTintSecondary;
    }
    if (c == AppColors.danger) return AppColors.onTintDanger;
    if (c == AppColors.inDelivery) return const Color(0xFF005FA0); // ≈ 5,6:1
    if (c == AppColors.cancelled) return cs.onSurfaceVariant;
    if (c == AppColors.confirmed) {
      return dark ? const Color(0xFF66AFFF) : c; // 2,96:1 en dark sinon
    }
    if (c == AppColors.shipped) {
      return dark ? const Color(0xFFB39DFF) : const Color(0xFF6A38EE);
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    final fg = textColor ?? _pillForeground(context, c, cs);
    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      child: Pressable(
      enabled: onTap != null,
      scale: 0.94,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: dense ? 8 : 10, vertical: dense ? 3 : 5),
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                AppIcon(icon, size: dense ? 11 : 13, color: fg),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: dense ? 10.5 : 11.5,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.dense = true});

  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Pill(
      text: 'Vendeur vérifié',
      color: AppColors.primary,
      icon: AppIcons.verified_rounded,
      dense: dense,
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Pill(
      text: '${status.emoji.isNotEmpty ? status.emoji : '•'} ${status.label}',
      color: status.color,
    );
  }
}

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.reviews,
    this.showValue = true,
  });

  final double rating;
  final double size;
  final int? reviews;
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Note ${rating.toStringAsFixed(1).replaceAll('.', ',')} sur 5'
          '${reviews != null ? ', $reviews avis' : ''}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        for (var i = 0; i < 5; i++)
          Icon(
            rating >= i + 0.75
                ? Icons.star_rounded
                : rating >= i + 0.25
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: size,
            color: AppColors.warning,
          ),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1).replaceAll('.', ','),
            style: TextStyle(
                fontSize: size * 0.86,
                fontWeight: FontWeight.w700,
                color: cs.onSurface),
          ),
        ],
        if (reviews != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviews)',
            style: TextStyle(fontSize: size * 0.82, color: cs.onSurfaceVariant),
          ),
        ],
      ],
      ),
    );
  }
}
