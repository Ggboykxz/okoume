import 'package:flutter/material.dart';
import '../motion.dart';

// ================================================================ Helpers

void showAppSnack(BuildContext context, String message,
    {String? emoji, SnackBarAction? action}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(content: Text(emoji == null ? message : '$emoji $message'), action: action),
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
    // Feuille « matériau » avec ressort Apple (damping 0.8, réponse 0.3 s),
    // neutralisée quand le système demande de réduire les animations.
    sheetAnimationStyle: AppMotion.on(context)
        ? AnimationStyle(
            curve: AppMotion.springBouncy,
            duration: AppMotion.springBouncy.duration,
          )
        : null,
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

/// Skeleton de chargement : bloc pulsé, respecte le mode réduit.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width = 120,
    this.height = 14,
    this.radius = 8,
    this.color,
  });

  final double? width;
  final double height;
  final double radius;
  final Color? color;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void initState() {
    super.initState();
    if (!AppMotion.reduce) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = widget.color ?? cs.surfaceContainerHigh;
    if (AppMotion.reduce || MediaQuery.disableAnimationsOf(context)) {
      // Fallback statique : le contrôleur est figé (aucune frame dépensée).
      if (_controller.isAnimating) _controller.stop();
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final c = Color.lerp(base, cs.surfaceContainerHighest, 0.35 + 0.25 * t)!;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}

/// Lien texte (ex. « Tout voir › », « Réinitialiser ») : role bouton exposé à
/// TalkBack/VoiceOver + cible largement alignée (zone tap opaque).
class AppTextLink extends StatelessWidget {
  const AppTextLink({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: child,
        ),
      ),
    );
  }
}
