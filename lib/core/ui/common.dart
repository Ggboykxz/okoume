import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../art.dart';
import '../format.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'motion.dart';

// ============================================================== Boutons

enum AppButtonVariant { primary, outline, ghost, danger, success }

class AppButton extends StatelessWidget {
 const AppButton({
  super.key,
  required this.label,
  this.onPressed,
  this.variant = AppButtonVariant.primary,
  this.icon,
  this.loading = false,
  this.expanded = true,
  this.height = 52,
  this.small = false,
 });

 final String label;
 final VoidCallback? onPressed;
 final AppButtonVariant variant;
 final AppIconData? icon;
 final bool loading;
 final bool expanded;
 final double height;
 final bool small;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final enabled = onPressed != null && !loading;

  final (Color bg, Color fg, Border? border) = switch (variant) {
   AppButtonVariant.primary => (cs.primary, Colors.white, null),
   AppButtonVariant.success => (AppColors.success, Colors.white, null),
   AppButtonVariant.danger => (AppColors.danger, Colors.white, null),
   AppButtonVariant.outline => (
     Colors.transparent,
     cs.primary,
     Border.all(color: cs.primary.withValues(alpha: 0.55), width: 1.4)
    ),
   AppButtonVariant.ghost => (Colors.transparent, cs.primary, null),
  };

  final content = Row(
   mainAxisAlignment: MainAxisAlignment.center,
   mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
   children: [
    if (loading)
     SizedBox(
      width: small ? 16 : 19,
      height: small ? 16 : 19,
      child: CircularProgressIndicator(strokeWidth: 2.2, color: fg),
     )
    else if (icon != null) ...[
     AppIcon(icon, size: small ? 18 : 20, color: fg),
     SizedBox(width: small ? 6 : 8),
    ],
    Text(
     label,
     style: TextStyle(
      fontFamily: AppTheme.poppins,
      fontWeight: FontWeight.w600,
      fontSize: small ? 13.5 : 15,
      color: fg,
     ),
    ),
   ],
  );

  final button = Pressable(
   enabled: enabled,
   scale: 0.975,
   child: AnimatedOpacity(
    opacity: enabled || loading ? 1 : 0.45,
    duration: AppMotion.fast,
    child: Material(
     color: bg,
     borderRadius: BorderRadius.circular(small ? 12 : 14),
     child: InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(small ? 12 : 14),
      child: Container(
       height: height,
       constraints:
         expanded ? null : const BoxConstraints(minWidth: 96),
       padding: EdgeInsets.symmetric(horizontal: small ? 14 : 18),
       decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(small ? 12 : 14),
        border: border,
       ),
       child: content,
      ),
     ),
    ),
   ),
  );

  return expanded ? SizedBox(width: double.infinity, child: button) : button;
 }
}

class AppIconButton extends StatelessWidget {
 const AppIconButton({
  super.key,
  required this.icon,
  this.onTap,
  this.badgeCount = 0,
  this.size = 42,
  this.onArt = false,
  this.backgroundColor,
  this.iconColor,
  this.iconSize,
 });

 final AppIconData icon;
 final VoidCallback? onTap;
 final int badgeCount;
 final double size;
 final bool onArt; // posé au-dessus d'une vignette → fond blanc translucide
 final Color? backgroundColor;
 final Color? iconColor;
 final double? iconSize;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final bg = backgroundColor ??
    (onArt
      ? Colors.white.withValues(alpha: 0.92)
      : cs.surfaceContainerHigh);
  final fg = iconColor ?? (onArt ? AppColors.text : cs.onSurface);
  return Pressable(
   enabled: onTap != null,
   scale: 0.92,
   child: GestureDetector(
   onTap: onTap,
   child: Stack(
    clipBehavior: Clip.none,
    children: [
     Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: AppIcon(icon, size: iconSize ?? size * 0.48, color: fg),
     ),
     if (badgeCount > 0)
      Positioned(
       right: -2,
       top: -2,
       child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        constraints: const BoxConstraints(minWidth: 18),
        decoration: BoxDecoration(
         color: AppColors.danger,
         borderRadius: BorderRadius.circular(999),
         border: Border.all(color: Colors.white, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
         badgeCount > 99 ? '99+' : '$badgeCount',
         style: const TextStyle(
           color: Colors.white,
           fontSize: 10,
           fontWeight: FontWeight.w800),
        ),
       ),
      ),
    ],
   ),
   ),
  );
 }
}

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

// ============================================================ Section & entrées

class SectionHeader extends StatelessWidget {
 const SectionHeader({
  super.key,
  required this.title,
  this.subtitle,
  this.actionLabel,
  this.onAction,
 });

 final String title;
 final String? subtitle;
 final String? actionLabel;
 final VoidCallback? onAction;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Padding(
   padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
   child: Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
     Expanded(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (subtitle != null) ...[
         const SizedBox(height: 2),
         Text(subtitle!,
           style: TextStyle(
             fontSize: 12.5, color: cs.onSurfaceVariant)),
        ],
       ],
      ),
     ),
     if (actionLabel != null)
      GestureDetector(
       onTap: onAction,
       child: Row(
        children: [
         Text(actionLabel!,
           style: TextStyle(
             color: cs.primary,
             fontWeight: FontWeight.w700,
             fontSize: 13)),
         AppIcon(AppIcons.chevron_right_rounded,
           size: 18, color: cs.primary),
        ],
       ),
      ),
    ],
   ),
  );
 }
}

class AppTextField extends StatelessWidget {
 const AppTextField({
  super.key,
  this.controller,
  this.hint,
  this.icon,
  this.suffix,
  this.onChanged,
  this.onSubmitted,
  this.keyboardType,
  this.obscure = false,
  this.maxLines = 1,
  this.autofocus = false,
  this.readOnly = false,
  this.onTap,
  this.textCapitalization = TextCapitalization.none,
 });

 final TextEditingController? controller;
 final String? hint;
 final AppIconData? icon;
 final Widget? suffix;
 final ValueChanged<String>? onChanged;
 final ValueChanged<String>? onSubmitted;
 final TextInputType? keyboardType;
 final bool obscure;
 final int maxLines;
 final bool autofocus;
 final bool readOnly;
 final VoidCallback? onTap;
 final TextCapitalization textCapitalization;

 @override
 Widget build(BuildContext context) {
  return TextField(
   controller: controller,
   onChanged: onChanged,
   onSubmitted: onSubmitted,
   keyboardType: keyboardType,
   obscureText: obscure,
   maxLines: maxLines,
   autofocus: autofocus,
   readOnly: readOnly,
   onTap: onTap,
   textCapitalization: textCapitalization,
   style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
   decoration: InputDecoration(
    hintText: hint,
    prefixIcon: icon == null
      ? null
      : AppIcon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
    suffixIcon: suffix,
   ),
  );
 }
}

class QtyStepper extends StatelessWidget {
 const QtyStepper({
  super.key,
  required this.value,
  required this.onChanged,
  this.max = 99,
 });

 final int value;
 final ValueChanged<int> onChanged;
 final int max;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  Widget btn(AppIconData icon, VoidCallback? onTap, {bool enabled = true}) =>
    GestureDetector(
     onTap: enabled ? onTap : null,
     child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
       color: cs.surfaceContainerHigh,
       borderRadius: BorderRadius.circular(10),
      ),
      child: AppIcon(icon,
        size: 17,
        color: enabled ? cs.onSurface : cs.onSurfaceVariant),
     ),
    );
  return Row(
   mainAxisSize: MainAxisSize.min,
   children: [
    btn(AppIcons.remove_rounded, () => onChanged(value - 1)),
    Container(
     constraints: const BoxConstraints(minWidth: 34),
     alignment: Alignment.center,
     child: Text(
      '$value',
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
     ),
    ),
    btn(AppIcons.add_rounded, () => onChanged(value + 1), enabled: value < max),
   ],
  );
 }
}

class AppChip extends StatelessWidget {
 const AppChip({
  super.key,
  required this.label,
  this.selected = false,
  this.onTap,
  this.icon,
  this.color,
 });

 final String label;
 final bool selected;
 final VoidCallback? onTap;
 final AppIconData? icon;
 final Color? color;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final c = color ?? cs.primary;
  final bg = selected ? c : cs.surfaceContainerHigh;
  final fg = selected ? Colors.white : cs.onSurface;
  return Pressable(
   enabled: onTap != null,
   scale: 0.95,
   child: GestureDetector(
   onTap: onTap,
   child: AnimatedContainer(
    duration: const Duration(milliseconds: 160),
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    decoration: BoxDecoration(
     color: bg,
     borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
     mainAxisSize: MainAxisSize.min,
     children: [
      if (icon != null) ...[
       AppIcon(icon, size: 14, color: fg),
       const SizedBox(width: 5),
      ],
      Text(
       label,
       style: TextStyle(
         fontSize: 12.5, fontWeight: FontWeight.w600, color: fg),
      ),
     ],
    ),
   ),
   ),
  );
 }
}

// ============================================================== Conteneurs

class AppCard extends StatelessWidget {
 const AppCard({
  super.key,
  required this.child,
  this.padding = const EdgeInsets.all(16),
  this.onTap,
 });

 final Widget child;
 final EdgeInsetsGeometry padding;
 final VoidCallback? onTap;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Pressable(
   enabled: onTap != null,
   scale: 0.98,
   child: GestureDetector(
   onTap: onTap,
   child: Container(
    padding: padding,
    decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(16),
     boxShadow: [
      BoxShadow(
       color: cs.shadow.withValues(alpha: 0.06),
       blurRadius: 12,
       offset: const Offset(0, 4),
      ),
     ],
     border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
    ),
    child: child,
   ),
   ),
  );
 }
}

class InfoBanner extends StatelessWidget {
 const InfoBanner({
  super.key,
  required this.emoji,
  required this.text,
  this.color,
  this.onTap,
  this.trailing,
 });

 final String emoji;
 final String text;
 final Color? color;
 final VoidCallback? onTap;
 final Widget? trailing;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final c = color ?? cs.primary;
  return Pressable(
   enabled: onTap != null,
   scale: 0.98,
   child: GestureDetector(
   onTap: onTap,
   child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
     color: c.withValues(alpha: 0.09),
     borderRadius: BorderRadius.circular(14),
     border: Border.all(color: c.withValues(alpha: 0.18)),
    ),
    child: Row(
     children: [
      Text(emoji, style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 10),
      Expanded(
       child: Text(
        text,
        style: TextStyle(
          fontSize: 12.8,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: cs.onSurface),
       ),
      ),
      ?trailing,
     ],
    ),
   ),
   ),
  );
 }
}

class AppListTile extends StatelessWidget {
 const AppListTile({
  super.key,
  this.emoji,
  this.icon,
  required this.title,
  this.subtitle,
  this.trailing,
  this.onTap,
  this.danger = false,
  this.iconColor,
 });

 final String? emoji;
 final AppIconData? icon;
 final String title;
 final String? subtitle;
 final Widget? trailing;
 final VoidCallback? onTap;
 final bool danger;
 final Color? iconColor;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final fg = danger ? AppColors.danger : cs.onSurface;
  return Pressable(
   enabled: onTap != null,
   scale: 0.98,
   child: GestureDetector(
   onTap: onTap,
   child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(16),
     border: Border.all(color: cs.outlineVariant),
    ),
    child: Row(
     children: [
      Container(
       width: 38,
       height: 38,
       decoration: BoxDecoration(
        color: (iconColor ?? cs.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
       ),
       alignment: Alignment.center,
       child: emoji != null
         ? Text(emoji!, style: const TextStyle(fontSize: 18))
         : AppIcon(icon, size: 19, color: iconColor ?? cs.primary),
      ),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(title,
           style: TextStyle(
             fontWeight: FontWeight.w600, fontSize: 14, color: fg)),
         if (subtitle != null) ...[
          const SizedBox(height: 1),
          Text(subtitle!,
            style: TextStyle(
              fontSize: 12, color: cs.onSurfaceVariant)),
         ],
        ],
       ),
      ),
      trailing ??
        AppIcon(AppIcons.chevron_right_rounded,
          size: 20, color: cs.onSurfaceVariant),
     ],
    ),
   ),
   ),
  );
 }
}

class EmptyState extends StatelessWidget {
 const EmptyState({
  super.key,
  required this.emoji,
  required this.title,
  this.message,
  this.actionLabel,
  this.onAction,
 });

 final String emoji;
 final String title;
 final String? message;
 final String? actionLabel;
 final VoidCallback? onAction;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Center(
   child: Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
     mainAxisSize: MainAxisSize.min,
     children: [
      Container(
       width: 96,
       height: 96,
       decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        shape: BoxShape.circle,
       ),
       alignment: Alignment.center,
       child: Text(emoji, style: const TextStyle(fontSize: 42)),
      ),
      const SizedBox(height: 18),
      Text(title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium),
      if (message != null) ...[
       const SizedBox(height: 8),
       Text(
        message!,
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.onSurfaceVariant, height: 1.4),
       ),
      ],
      if (actionLabel != null) ...[
       const SizedBox(height: 20),
       AppButton(
        label: actionLabel!,
        onPressed: onAction,
        expanded: false,
       ),
      ],
     ],
    ),
   ),
  );
 }
}

// ========================================================== Vignettes produit

class ProductCard extends ConsumerWidget {
 const ProductCard({super.key, required this.product, this.width});

 final Product product;
 final double? width;

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;
  final wished = ref.watch(wishlistProvider).contains(product.id);

  return Pressable(
   scale: 0.98,
   child: GestureDetector(
   onTap: () => context.push('/product/${product.id}'),
   child: SizedBox(
    width: width,
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      AspectRatio(
       aspectRatio: 1,
       child: Stack(
        children: [
         Positioned.fill(
          child: ProductArt(
           emoji: product.emoji.isNotEmpty ? product.emoji : '•',
           seed: product.seed,
           ribbon: product.discountPercent >= 15
             ? '-${product.discountPercent}%'
             : null,
           radius: 16,
          ),
         ),
         Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
           onTap: () {
            ref.read(wishlistProvider.notifier).toggle(product.id);
            AppMotion.tap();
            final nowWished = ref
              .read(wishlistProvider)
              .contains(product.id);
            showAppSnack(
             context,
             nowWished
               ? 'Ajouté à vos favoris'
               : 'Retiré de vos favoris',
             emoji: nowWished ? '️' : '',
            );
           },
           child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
             color: Colors.white.withValues(alpha: 0.92),
             shape: BoxShape.circle,
            ),
            child: Icon(
             wished
               ? Icons.favorite_rounded
               : Icons.favorite_outline_rounded,
             size: 16,
             color: wished ? AppColors.danger : AppColors.text,
            ),
           ),
          ),
         ),
         if (product.express)
          Positioned(
           left: 8,
           bottom: 8,
           child: Pill(
            text: 'Express',
            color: AppColors.success,
            icon: AppIcons.bolt_rounded,
            dense: true,
           ),
          ),
        ],
       ),
      ),
      const SizedBox(height: 8),
      Text(
       product.title,
       maxLines: 2,
       overflow: TextOverflow.ellipsis,
       style: const TextStyle(
         fontSize: 13, fontWeight: FontWeight.w600, height: 1.25),
      ),
      const SizedBox(height: 3),
      RatingStars(rating: product.rating, size: 12, reviews: product.reviews),
      const SizedBox(height: 4),
      PriceText(
       price: product.price,
       oldPrice: product.oldPrice,
       size: product.price >= 1000000 ? 13 : 14.5,
      ),
      const SizedBox(height: 2),
      Text(
       ' ${product.city}',
       maxLines: 1,
       overflow: TextOverflow.ellipsis,
       style: TextStyle(fontSize: 10.8, color: cs.onSurfaceVariant),
      ),
     ],
    ),
   ),
   ),
  );
 }
}

class ProductTile extends ConsumerWidget {
 const ProductTile({super.key, required this.product, this.onTap});

 final Product product;
 final VoidCallback? onTap;

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;
  final seller = ref.watch(sellerByIdProvider(product.sellerId));
  return Pressable(
   scale: 0.98,
   child: GestureDetector(
   onTap: onTap ?? () => context.push('/product/${product.id}'),
   child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(18),
     border: Border.all(color: cs.outlineVariant),
    ),
    child: Row(
     children: [
      SizedBox(
       width: 84,
       height: 84,
       child: ProductArt(
         emoji: product.emoji.isNotEmpty ? product.emoji : '•', seed: product.seed, radius: 14),
      ),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            height: 1.25),
         ),
         const SizedBox(height: 3),
         Text(
          seller.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.5, color: cs.onSurfaceVariant),
         ),
         const SizedBox(height: 5),
         Row(
          children: [
           Expanded(
            child: PriceText(
             price: product.price,
             oldPrice: product.oldPrice,
             size: 15,
            ),
           ),
           RatingStars(
             rating: product.rating, size: 12, showValue: true),
          ],
         ),
        ],
       ),
      ),
     ],
    ),
   ),
   ),
  );
 }
}

// ================================================================ Divers

class StatCard extends StatelessWidget {
 const StatCard({
  super.key,
  required this.label,
  required this.value,
  this.emoji,
  this.delta,
  this.color,
 });

 final String label;
 final String value;
 final String? emoji;
 final String? delta;
 final Color? color;

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
       if (emoji != null) ...[
        Text(emoji!, style: const TextStyle(fontSize: 15)),
        const SizedBox(width: 6),
       ],
       Expanded(
        child: Text(
         label,
         maxLines: 1,
         overflow: TextOverflow.ellipsis,
         style: TextStyle(
           fontSize: 11.5,
           color: cs.onSurfaceVariant,
           fontWeight: FontWeight.w600),
        ),
       ),
      ],
     ),
     const SizedBox(height: 8),
     Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
       fontFamily: AppTheme.montserrat,
       fontWeight: FontWeight.w700,
       fontSize: 17,
       color: color ?? cs.onSurface,
      ),
     ),
     if (delta != null) ...[
      const SizedBox(height: 4),
      Text(delta!,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.success,
          fontWeight: FontWeight.w700)),
     ],
    ],
   ),
  );
 }
}

class BarChartMini extends StatelessWidget {
 const BarChartMini({super.key, required this.values, this.labels = const []});

 final List<int> values;
 final List<String> labels;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final maxValue = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
  return SizedBox(
   height: 120,
   child: Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
     for (var i = 0; i < values.length; i++)
      Expanded(
       child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: [
          AnimatedContainer(
           duration: const Duration(milliseconds: 500),
           curve: Curves.easeOutCubic,
           height: (values[i] / maxValue) * 82 + 8,
           decoration: BoxDecoration(
            color: i == values.length - 1
              ? cs.primary
              : cs.primary.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(8),
           ),
          ),
          const SizedBox(height: 6),
          if (i < labels.length)
           Text(
            labels[i],
            style: TextStyle(
              fontSize: 10, color: cs.onSurfaceVariant),
           ),
         ],
        ),
       ),
      ),
    ],
   ),
  );
 }
}

class StepBar extends StatelessWidget {
 const StepBar({super.key, required this.steps, required this.current});

 final List<String> steps;
 final int current;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Row(
   children: [
    for (var i = 0; i < steps.length; i++) ...[
     if (i > 0)
      Expanded(
       child: Container(
        height: 2.5,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
         color: i <= current
           ? cs.primary
           : cs.outlineVariant,
         borderRadius: BorderRadius.circular(2),
        ),
       ),
      ),
     Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
         color: i <= current ? cs.primary : cs.surfaceContainerHigh,
         shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: i < current
          ? const AppIcon(AppIcons.check_rounded,
            size: 15, color: Colors.white)
          : Text(
            '${i + 1}',
            style: TextStyle(
             fontSize: 12.5,
             fontWeight: FontWeight.w800,
             color: i <= current ? Colors.white : cs.onSurfaceVariant,
            ),
           ),
       ),
       const SizedBox(height: 5),
       Text(
        steps[i],
        style: TextStyle(
         fontSize: 10.5,
         fontWeight: FontWeight.w600,
         color: i <= current ? cs.onSurface : cs.onSurfaceVariant,
        ),
       ),
      ],
     ),
    ],
   ],
  );
 }
}

/// Compte à rebours des offres flash (fin à minuit).
class CountdownText extends StatefulWidget {
 const CountdownText({super.key, this.size = 12});

 final double size;

 @override
 State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
 Timer? _timer;
 late Duration _remaining;

 @override
 void initState() {
  super.initState();
  _remaining = _computeRemaining();
  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
   if (!mounted) return;
   setState(() => _remaining = _computeRemaining());
  });
 }

 Duration _computeRemaining() {
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day + 1);
  return midnight.difference(now);
 }

 @override
 void dispose() {
  _timer?.cancel();
  super.dispose();
 }

 @override
 Widget build(BuildContext context) {
  return Container(
   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
   decoration: BoxDecoration(
    color: AppColors.danger.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(8),
   ),
   child: Text(
    '⏱ ${durationHms(_remaining)}',
    style: TextStyle(
     fontSize: widget.size,
     fontWeight: FontWeight.w800,
     color: AppColors.danger,
     fontFeatures: const [FontFeature.tabularFigures()],
    ),
   ),
  );
 }
}

// ================================================================ Helpers

void showAppSnack(BuildContext context, String message, {String? emoji}) {
 final messenger = ScaffoldMessenger.of(context);
 messenger.hideCurrentSnackBar();
 messenger.showSnackBar(
  SnackBar(content: Text(emoji == null ? message : '$emoji $message')),
 );
}

Future<T?> showAppSheet<T>(
 BuildContext context,
 Widget child, {
 bool isScrollControlled = true,
 bool showHandle = true,
}) {
 return showModalBottomSheet<T>(
  context: context,
  isScrollControlled: isScrollControlled,
  showDragHandle: showHandle,
  // Feuille « matériau » avec ressort Apple (damping 0.8, réponse 0.3 s).
  sheetAnimationStyle: AnimationStyle(
   curve: AppMotion.springBouncy,
   duration: AppMotion.springBouncy.duration,
  ),
  builder: (context) => SafeArea(
   top: false,
   child: Padding(
    padding: EdgeInsets.only(
     bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: child,
   ),
  ),
 );
}
