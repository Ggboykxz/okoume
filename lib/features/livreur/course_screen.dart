import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

/// Course active du livreur : retrait livraison validation OTP.
class CourseScreen extends ConsumerStatefulWidget {
 const CourseScreen({super.key});

 @override
 ConsumerState<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
 int _phase = 0; // 0 retrait 1 chargé 2 en route 3 terminé
 int? _lastPayout;
 String? _lastRoute;

 static const _scooterPositions = [-0.75, -0.2, 0.55, 0.85];

 Future<void> _finishWithOtp(int payout, String route) async {
 final controller = TextEditingController();
 final code = await showDialog<String>(
  context: context,
  builder: (context) => AlertDialog(
  title: const Text('Code de remise client'),
  content: Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   const Text(
    'Demandez le code à 4 chiffres au client et saisissez-le pour valider la livraison.',
    style: TextStyle(fontSize: 13.5),
   ),
   const SizedBox(height: 14),
   TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    maxLength: 4,
    textAlign: TextAlign.center,
    style: const TextStyle(
     fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 8),
    decoration:
     const InputDecoration(hintText: '••••', counterText: ''),
   ),
   ],
  ),
  actions: [
   TextButton(
   onPressed: () => Navigator.of(context).pop(),
   child: const Text('Annuler'),
   ),
   TextButton(
   onPressed: () => Navigator.of(context).pop(controller.text.trim()),
   child: const Text('Valider'),
   ),
  ],
  ),
 );
 if (code == null || code.length != 4 || !mounted) return;
 ref.read(livreurProvider.notifier).completeActive();
 setState(() {
  _phase = 3;
  _lastPayout = payout;
  _lastRoute = route;
 });
 showAppSnack(
  context,
  'Livraison validée ! + ${formatXaf(payout)} ajoutés à votre solde',
  emoji: '',
 );
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final state = ref.watch(livreurProvider);
 final course = state.active;

 // --------------------------------------------------- Course terminée
 if (_phase == 3 && _lastPayout != null) {
  return Scaffold(
  body: SafeArea(
   child: ListView(
   padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
   children: [
    Center(
    child: TweenAnimationBuilder<double>(
     tween: AppMotion.on(context) ? Tween(begin: 0, end: 1) : ConstantTween<double>(1.0),
     duration: const Duration(milliseconds: 650),
     curve: Curves.elasticOut,
     builder: (context, value, child) =>
      Transform.scale(scale: value, child: child),
     child: Container(
     width: 96,
     height: 96,
     decoration: const BoxDecoration(
      gradient: LinearGradient(
      colors: [Color(0xFF00E065), Color(0xFF00C853)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      ),
      shape: BoxShape.circle,
     ),
     child: const AppIcon(AppIcons.check_rounded,
      size: 50, color: Colors.white),
     ),
    ),
    ),
    const SizedBox(height: 20),
    Text('Livraison terminée !',
     textAlign: TextAlign.center,
     style: Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height: 8),
    Text(
    _lastRoute ?? '',
    textAlign: TextAlign.center,
    style: TextStyle(
     fontSize: 13, height: 1.5, color: cs.onSurfaceVariant),
    ),
    const SizedBox(height: 20),
    AppCard(
    child: AmountRow(
     label: 'Gain crédité',
     amount: _lastPayout!,
     bold: true,
     color: AppColors.success,
    ),
    ),
    const SizedBox(height: 20),
    AppButton(
    label: 'Retour aux courses',
    icon: AppIcons.delivery_dining_rounded,
    onPressed: () => context.pop(),
    ),
   ],
   ),
  ),
  );
 }

 // ---------------------------------------------------- Aucune course
 if (course == null) {
  return Scaffold(
  appBar: AppBar(title: const Text('Course active')),
  body: EmptyState(
   emoji: '',
   title: 'Aucune course active',
   message:
    'Acceptez une course depuis l\'onglet Courses pour la démarrer ici.',
   actionLabel: 'Voir les courses',
   onAction: () => context.pop(),
  ),
  );
 }

 final positionX =
  _scooterPositions[_phase >= 0 && _phase <= 3 ? _phase : 0];

 return Scaffold(
  appBar: AppBar(
  title: const Text('Course active'),
  actions: [
   IconButton(
   icon: const AppIcon(AppIcons.report_problem_rounded),
   onPressed: () => showAppSnack(
    context, 'Problème signalé — le support vous rappelle',
    emoji: ''),
   ),
  ],
  ),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
  children: [
   // ------------------------------------------------ Carte illustrée
   Container(
   height: 150,
   decoration: BoxDecoration(
    color: cs.surfaceContainerHigh,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: cs.outlineVariant),
   ),
   child: Stack(
    children: [
    Positioned(
     left: 24,
     right: 24,
     top: 80,
     child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
      for (var i = 0; i < 15; i++)
      Container(
       width: 8,
       height: 3,
       decoration: BoxDecoration(
       color: cs.outlineVariant,
       borderRadius: BorderRadius.circular(2),
       ),
      ),
     ],
     ),
    ),
    Align(
     alignment: const Alignment(-0.85, -0.15),
     child: _Marker(emoji: '', color: AppColors.secondary),
    ),
    Align(
     alignment: const Alignment(0.85, -0.15),
     child: _Marker(emoji: '', color: AppColors.primary),
    ),
    Align(
     alignment: Alignment(positionX, 0.55),
     child: _Marker(
      emoji: '', color: AppColors.success, size: 44),
    ),
    ],
   ),
   ),
   const SizedBox(height: 14),

   // ------------------------------------------------------- Étapes
   Padding(
   padding: const EdgeInsets.symmetric(horizontal: 4),
   child: StepBar(
    steps: const ['Retrait', 'Chargé', 'En route', 'Livré'],
    current: _phase,
   ),
   ),
   const SizedBox(height: 18),

   // ------------------------------------------------ Infos course
   AppCard(
   child: Column(
    children: [
    _RouteRow(
     emoji: course.sellerEmoji,
     label: 'Retrait colis',
     value: course.pickup),
    const SizedBox(height: 10),
    _RouteRow(
     emoji: '',
     label: 'Livraison client',
     value: course.dropoff),
    Divider(height: 24, color: cs.outlineVariant),
    Row(
     children: [
     Expanded(
      child: _MiniStat(
       label: 'Distance',
       value: '${course.distanceKm} km'),
     ),
     Expanded(
      child: _MiniStat(
       label: 'Durée estimée',
       value: '≈ ${course.etaMin} min'),
     ),
     Expanded(
      child: _MiniStat(
       label: 'Votre gain',
       value: formatXaf(course.payout),
       highlight: true),
     ),
     ],
    ),
    ],
   ),
   ),
   const SizedBox(height: 14),

   // ----------------------------------------------------- Contacts
   AppCard(
   padding: const EdgeInsets.all(14),
   child: Row(
    children: [
    Expanded(
     child: AppButton(
     label: 'Appeler le vendeur',
     small: true,
     height: 42,
     variant: AppButtonVariant.outline,
     icon: AppIcons.call_rounded,
     onPressed: () => showAppSnack(
      context, 'Appel du vendeur…', emoji: ''),
     ),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: AppButton(
     label: 'Appeler le client',
     small: true,
     height: 42,
     variant: AppButtonVariant.outline,
     icon: AppIcons.call_rounded,
     onPressed: () => showAppSnack(
      context, 'Appel du client…', emoji: ''),
     ),
    ),
    ],
   ),
   ),
   const SizedBox(height: 18),

   // ------------------------------------------------------ Actions
   AppButton(
   label: switch (_phase) {
    0 => 'Je suis arrivé au point de retrait',
    1 => 'Colis récupéré — démarrer la livraison',
    _ => 'Terminer la livraison (code client)',
   },
   icon: switch (_phase) {
    0 => AppIcons.storefront_rounded,
    1 => AppIcons.inventory_2_rounded,
    _ => AppIcons.verified_rounded,
   },
   variant: _phase == 2
    ? AppButtonVariant.success
    : AppButtonVariant.primary,
   onPressed: () {
    if (_phase == 0) {
    setState(() => _phase = 1);
    showAppSnack(
     context, 'Prévenez le vendeur : colis en cours de préparation',
     emoji: '');
    } else if (_phase == 1) {
    setState(() => _phase = 2);
    showAppSnack(
     context, 'En route vers le client — bonne route !',
     emoji: '');
    } else {
    _finishWithOtp(
     course.payout, '${course.pickup} ${course.dropoff}');
    }
   },
   ),
   const SizedBox(height: 12),
   InfoBanner(
   emoji: '',
   color: cs.secondary,
   text:
    'Démo : le code client est fourni par l\'acheteur à la remise. En production, il est vérifié en temps réel.',
   ),
  ],
  ),
 );
 }
}

class _Marker extends StatelessWidget {
 const _Marker({required this.emoji, required this.color, this.size = 40});

 final String emoji;
 final Color color;
 final double size;

 @override
 Widget build(BuildContext context) {
 return Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
  color: Theme.of(context).colorScheme.surface,
  shape: BoxShape.circle,
  border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
  ),
  alignment: Alignment.center,
  child: Text(emoji, style: TextStyle(fontSize: size * 0.45)),
 );
 }
}

class _RouteRow extends StatelessWidget {
 const _RouteRow({
 required this.emoji,
 required this.label,
 required this.value,
 });

 final String emoji;
 final String label;
 final String value;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Row(
  children: [
  Container(
   width: 40,
   height: 40,
   decoration: BoxDecoration(
   color: cs.surfaceContainerHigh,
   borderRadius: BorderRadius.circular(12),
   ),
   alignment: Alignment.center,
   child: Text(emoji, style: const TextStyle(fontSize: 17)),
  ),
  const SizedBox(width: 11),
  Expanded(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(label,
     style: TextStyle(
      fontSize: 11, color: cs.onSurfaceVariant)),
    const SizedBox(height: 1),
    Text(value,
     maxLines: 1,
     overflow: TextOverflow.ellipsis,
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 13.5)),
   ],
   ),
  ),
  ],
 );
 }
}

class _MiniStat extends StatelessWidget {
 const _MiniStat({
 required this.label,
 required this.value,
 this.highlight = false,
 });

 final String label;
 final String value;
 final bool highlight;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(label,
   style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
  const SizedBox(height: 3),
  Text(
   value,
   maxLines: 1,
   overflow: TextOverflow.ellipsis,
   style: TextStyle(
   fontWeight: FontWeight.w800,
   fontSize: 13.5,
   color: highlight ? AppColors.success : cs.onSurface,
   ),
  ),
  ],
 );
 }
}
