import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

// Ré-exposé pour les écrans qui pilotent une scène Rive (ex. déclencher
// une entrée de machine à états) sans importer le moteur directement.
export 'package:rive/rive.dart' show RiveWidgetController;

/// Système de motion Apple fluid interfaces pour Okoumé.
///
/// - Retour immédiat au *pointer-down* ([Pressable], [AppButton]).
/// - Ressorts : [SpringCurve] (damping 1.0 par défaut, 0.8 avec élan).
/// - Matériaux translucides : [Frosted].
/// - Haptique : [AppMotion.tap] / [AppMotion.success].
/// - `AppMotion.reduce = true` fige les animations décoratives (tests,
/// accessibilité réduire les animations ).
abstract final class AppMotion {
 /// Active/désactive globalement les animations décoratives (tests).
 static bool reduce = false;

 /// Vrai si les animations décoratives peuvent jouer.
 static bool on(BuildContext context) =>
  !reduce && !MediaQuery.disableAnimationsOf(context);

 // ---------------------------------------------------------------- Haptique
 static void tap() => HapticFeedback.selectionClick();
 static void impact() => HapticFeedback.lightImpact();
 static void success() => HapticFeedback.mediumImpact();
 static void warning() => HapticFeedback.heavyImpact();

 // --------------------------------------------------------------- Durées/UX
 static const fast = Duration(milliseconds: 150);
 static const smooth = Duration(milliseconds: 320);
 static const slow = Duration(milliseconds: 520);

 /// Ressort critique (damping 1.0, réponse 0.35 s) — mouvement standard.
 static final SpringCurve spring = SpringCurve();

 /// Ressort à léger rebond (damping 0.8, réponse 0.3 s) — feuilles, élan.
 static final SpringCurve springBouncy =
  SpringCurve(damping: 0.8, response: 0.3);
}

/// Courbe échantillonnée depuis une simulation ressort
/// (équivalent `damping` + `response` Apple, cf. WWDC 2018).
class SpringCurve extends Curve {
 SpringCurve({this.damping = 1.0, this.response = 0.35}) {
 final stiffness = math.pow(2 * math.pi / response, 2).toDouble();
 _sim = SpringSimulation(
  SpringDescription.withDampingRatio(
  mass: 1,
  stiffness: stiffness,
  ratio: damping,
  ),
  0,
  1,
  0,
 );
 final samples = <double>[0];
 const dt = 1 / 120;
 var t = 0.0;
 while (t < response * 8 && samples.length < 720) {
  t += dt;
  samples.add(_sim.x(t));
  if (_sim.isDone(t)) break;
 }
 _samples = samples;
 duration = Duration(microseconds: (t * 1e6).round());
 }

 final double damping;
 final double response;

 late final SpringSimulation _sim;
 late final List<double> _samples;

 /// Temps d'établissement du ressort (durée conseillée de l'animation).
 late final Duration duration;

 @override
 double transformInternal(double t) {
 if (_samples.length < 2) return t;
 final pos = t * (_samples.length - 1);
 final index = pos.floor().clamp(0, _samples.length - 2);
 final frac = pos - index;
 final a = _samples[index];
 final b = _samples[index + 1];
 return a + (b - a) * frac;
 }
}

/// Retour d'appui immédiat : l'élément s'enfonce au *pointer-down*, pas au
/// relâchement (principe 1 — Response). Sans conflit d'arène gestuelle
/// ([Listener], pas de recognizer).
class Pressable extends StatefulWidget {
 const Pressable({
 super.key,
 required this.child,
 this.scale = 0.97,
 this.enabled = true,
 });

 final Widget child;
 final double scale;
 final bool enabled;

 @override
 State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
 bool _pressed = false;

 @override
 Widget build(BuildContext context) {
 if (!widget.enabled) return widget.child;
 return Listener(
  onPointerDown: (_) => _set(true),
  onPointerUp: (_) => _set(false),
  onPointerCancel: (_) => _set(false),
  child: AnimatedScale(
  scale: _pressed ? widget.scale : 1,
  duration: const Duration(milliseconds: 110),
  curve: Curves.easeOutCubic,
  child: widget.child,
  ),
 );
 }

 void _set(bool value) {
 if (_pressed == value) return;
 setState(() => _pressed = value);
 }
}

/// Entrée en fondu + montée (ordre de stagger optionnel).
/// Figée en mode réduit — évite aussi tout Timer résiduel en tests.
class MotionEnter extends StatelessWidget {
 const MotionEnter({
 super.key,
 required this.child,
 this.order = 0,
 this.slide = 0.06,
 });

 final Widget child;
 final int order;
 final double slide;

 @override
 Widget build(BuildContext context) {
 if (!AppMotion.on(context)) return child;
 return child
  .animate(delay: Duration(milliseconds: 70 * (order > 6 ? 6 : order)))
  .fadeIn(
   duration: const Duration(milliseconds: 320),
   curve: Curves.easeOutCubic,
  )
  .slideY(
   begin: slide,
   end: 0,
   duration: const Duration(milliseconds: 380),
   curve: Curves.easeOutCubic,
  );
 }
}

/// Barre/panneau translucide matériau (blur + fond semi-transparent),
/// le contenu défile dessous.
class Frosted extends StatelessWidget {
 const Frosted({
 super.key,
 required this.child,
 this.blur = 20,
 this.color,
 });

 final Widget child;
 final double blur;
 final Color? color;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return ClipRect(
  child: BackdropFilter(
  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
  child: ColoredBox(
   color: color ?? cs.surface.withValues(alpha: 0.78),
   child: child,
  ),
  ),
 );
 }
}

/// Animation Lottie locale, respectueuse du mode réduit (fallback statique).
class LottieArt extends StatelessWidget {
 const LottieArt(
 this.asset, {
 super.key,
 this.size,
 this.width,
 this.height,
 this.fit = BoxFit.contain,
 this.loop = false,
 this.fallback,
 });

 final String asset;
 final double? size;
 final double? width;
 final double? height;
 final BoxFit fit;
 final bool loop;
 final Widget? fallback;

 @override
 Widget build(BuildContext context) {
 final w = width ?? size;
 final h = height ?? size;
 if (!AppMotion.on(context)) {
  return fallback ?? SizedBox(width: w, height: h);
 }
 return Lottie.asset(
  asset,
  width: w,
  height: h,
  fit: fit,
  repeat: loop,
  frameBuilder: (context, child, composition) {
  if (composition != null) return child;
  return fallback ?? SizedBox(width: w, height: h);
  },
  errorBuilder: (context, error, stackTrace) =>
   fallback ?? SizedBox(width: w, height: h),
 );
 }
}

/// Scène Rive interactive (moteur embarqué `rive` 0.14).
///
/// Chargée paresseusement : en mode réduit ([AppMotion.reduce]), le
/// [fallback] statique est rendu à la place (aucun accès au moteur natif —
/// indispensable en tests).
class RiveStage extends StatefulWidget {
 const RiveStage(
 this.asset, {
 super.key,
 this.stateMachine,
 this.fit = BoxFit.contain,
 this.alignment = Alignment.center,
 this.fallback,
 this.onReady,
 });

 final String asset;

 /// Nom de la machine à états (défaut : machine par défaut du fichier).
 final String? stateMachine;
 final BoxFit fit;
 final Alignment alignment;
 final Widget? fallback;

 /// Expose le contrôleur (permet de déclencher des entrées, ex. `bump`).
 final ValueChanged<RiveWidgetController>? onReady;

 @override
 State<RiveStage> createState() => _RiveStageState();
}

class _RiveStageState extends State<RiveStage> {
 @override
 Widget build(BuildContext context) {
 if (!AppMotion.on(context)) {
  return widget.fallback ?? const SizedBox.shrink();
 }
 return RiveWidgetBuilder(
  fileLoader:
   FileLoader.fromAsset(widget.asset, riveFactory: Factory.rive),
  stateMachineSelector: widget.stateMachine == null
   ? const StateMachineDefault()
   : StateMachineSelector.byName(widget.stateMachine!),
  onLoaded: (loaded) => widget.onReady?.call(loaded.controller),
  onFailed: (error, stackTrace) {},
  builder: (context, state) => switch (state) {
  RiveLoaded(:final controller) => RiveWidget(
   controller: controller,
   fit: _riveFit(widget.fit),
   alignment: widget.alignment,
   ),
  _ => widget.fallback ?? const SizedBox.shrink(),
  },
 );
 }

 static Fit _riveFit(BoxFit fit) => switch (fit) {
  BoxFit.contain => Fit.contain,
  BoxFit.cover => Fit.cover,
  BoxFit.fill => Fit.fill,
  BoxFit.fitWidth => Fit.fitWidth,
  BoxFit.fitHeight => Fit.fitHeight,
  BoxFit.none => Fit.none,
  BoxFit.scaleDown => Fit.scaleDown,
  };
}
