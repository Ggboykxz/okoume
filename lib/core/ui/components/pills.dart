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
    this.icon,
    this.dense = false,
    this.onTap,
  });

  final String text;
  final Color? color;
  final AppIconData? icon;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    return Pressable(
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
                AppIcon(icon, size: dense ? 11 : 13, color: c),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: dense ? 10.5 : 11.5,
                  fontWeight: FontWeight.w700,
                  color: c,
                ),
              ),
            ],
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
    return Row(
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
    );
  }
}
