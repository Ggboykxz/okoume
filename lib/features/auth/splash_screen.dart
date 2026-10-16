import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// Écran d'ouverture — logo animé puis redirection selon l'état.
class SplashScreen extends ConsumerStatefulWidget {
 const SplashScreen({super.key});

 @override
 ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
 Timer? _timer;

 @override
 void initState() {
  super.initState();
  _timer = Timer(const Duration(milliseconds: 1700), () {
   if (!mounted) return;
   final settings = ref.read(settingsProvider);
   final user = ref.read(authProvider);
   if (user != null) {
    context.go('/main');
   } else if (settings.onboardingSeen) {
    context.go('/auth');
   } else {
    context.go('/onboarding');
   }
  });
 }

 @override
 void dispose() {
  _timer?.cancel();
  super.dispose();
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   body: Container(
    decoration: const BoxDecoration(
     gradient: LinearGradient(
      colors: [Color(0xFF0066CC), Color(0xFF003D7A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
     ),
    ),
    child: Stack(
     children: [
      // Cercles décoratifs
      Positioned(
       right: -60,
       top: -60,
       child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
         color: Colors.white.withValues(alpha: 0.06),
         shape: BoxShape.circle,
        ),
       ),
      ),
      Positioned(
       left: -80,
       bottom: -40,
       child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
         color: Colors.white.withValues(alpha: 0.05),
         shape: BoxShape.circle,
        ),
       ),
      ),
      // Halo pulsé Lottie derrière le logo (figé en mode réduit).
      const Center(
       child: LottieArt(
        'assets/lottie/pulse.json',
        size: 290,
        loop: true,
       ),
      ),
      Center(
       child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(
         opacity: value,
         child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
         ),
        ),
        child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
          const AppLogo(size: 96),
          const SizedBox(height: 22),
          const Text(
           'Okoumé',
           style: TextStyle(
            fontFamily: AppTheme.poppins,
            fontWeight: FontWeight.w800,
            fontSize: 36,
            color: Colors.white,
            letterSpacing: 0.5,
           ),
          ),
          const SizedBox(height: 6),
          Text(
           'Tout le Gabon, dans ma poche',
           style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
           ),
          ),
         ],
        ),
       ),
      ),
      Positioned(
       left: 0,
       right: 0,
       bottom: 36,
       child: Text(
        '🇬🇦 Fait au Gabon · Version 1.0',
        textAlign: TextAlign.center,
        style: TextStyle(
         fontSize: 11.5,
         color: Colors.white.withValues(alpha: 0.6),
         fontWeight: FontWeight.w600,
        ),
       ),
      ),
     ],
    ),
   ),
  );
 }
}
