import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../app_icons.dart';
import '../motion.dart';

// ============================================================== Boutons

enum AppButtonVariant { primary, outline, ghost, danger, success }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expanded = true,
    this.height = 48,
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  /// Garde anti double-tap : ignore les appels dans les 400 ms suivant un tap
  /// (un acte financier/paiement ne doit jamais s'exécuter deux fois).
  bool _locked = false;

  void _handleTap() {
    if (_locked) return;
    final cb = widget.onPressed;
    if (cb == null) return;
    cb();
    _locked = true;
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _locked = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null && !widget.loading;
    final loading = widget.loading;
    final variant = widget.variant;
    final small = widget.small;
    final expanded = widget.expanded;
    final height = widget.height;
    final icon = widget.icon;

    final (Color bg, Color fg, Border? border) = switch (variant) {
      AppButtonVariant.primary => (cs.primary, cs.onPrimary, null),
      AppButtonVariant.success => (AppColors.successDeep, Colors.white, null),
      AppButtonVariant.danger => (AppColors.dangerDeep, Colors.white, null),
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
          widget.label,
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
            onTap: enabled ? _handleTap : null,
            borderRadius: BorderRadius.circular(small ? 12 : 14),
            child: Container(
              // Plancher accessibilité : cible tactile ≥ 44 px même en `small`.
              height: height < 44 ? 44 : height,
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

    final result = expanded ? SizedBox(width: double.infinity, child: button) : button;
    return Semantics(
      button: true,
      label: widget.label,
      enabled: enabled,
      child: result,
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.badgeCount = 0,
    this.size = 48,
    this.onArt = false,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  /// Nom accessible annoncé par TalkBack/VoiceOver (le bouton est remplacé par
  /// « $label, $badgeCount » quand un compteur est présent).
  final String label;
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
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: badgeCount > 0 ? '$label, $badgeCount' : label,
      child: Pressable(
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
                    color: AppColors.dangerDeep,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}
