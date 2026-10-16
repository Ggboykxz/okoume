import 'package:flutter/material.dart';
import '../app_icons.dart';
import '../motion.dart';

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
    this.errorText,
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
  final String? errorText;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final h = (hint ?? '').toLowerCase();
    final effectiveType = keyboardType ??
        ((h.contains('tél') || h.contains('telephone') || h.contains('phone'))
            ? TextInputType.phone
            : (h.contains('montant') || h.contains('prix') || h.contains('quantit') || h.contains('stock') || h.contains('frais'))
                ? TextInputType.number
                : null);
    final effectiveObscure = obscure ||
        h.contains('mot de passe') || h.contains('password') || h.contains('code') || h.contains('otp') || h.contains('nip');
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: effectiveType,
      obscureText: effectiveObscure,
      maxLines: maxLines,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
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
