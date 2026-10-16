import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../app_icons.dart';
import '../motion.dart';
import './buttons.dart';

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
    this.emoji,
    required this.text,
    this.color,
    this.onTap,
    this.trailing,
  });

  final String? emoji;
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
              if (emoji != null)
                Text(emoji!, style: const TextStyle(fontSize: 18)),
              if (emoji != null) const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.8,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
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
    return Semantics(
      label: title,
      button: onTap != null,
      child: Pressable(
        enabled: onTap != null,
        scale: 0.98,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                  child: (emoji != null && emoji!.trim().isNotEmpty)
                      ? Text(emoji!.trim(), style: const TextStyle(fontSize: 16))
                      : AppIcon(
                          icon ?? AppIcons.circle_outlined,
                          size: 19,
                          color: iconColor ?? cs.primary),
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
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.emoji,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final String? emoji;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: title,
      child: Center(
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
                child: (emoji != null && emoji!.trim().isNotEmpty)
                    ? Text(emoji!, style: const TextStyle(fontSize: 30))
                    : AppIcon(AppIcons.circle_outlined, size: 38, color: cs.onSurfaceVariant),
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
      ),
    );
  }
}
