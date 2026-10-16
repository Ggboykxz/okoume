import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'ui/app_icons.dart';

/// Identité visuelle : vignettes produit, avatars boutiques, logo.
/// Les visuels produits sont des dégradés + emoji (fonctionne 100% hors ligne).
abstract final class ArtPalette {
 static const palettes = <List<Color>>[
  [Color(0xFFE3F0FF), Color(0xFFB7D6FF)], // bleu
  [Color(0xFFFFF0E0), Color(0xFFFFD6A8)], // orange
  [Color(0xFFE4F8EC), Color(0xFFBEEED4)], // vert
  [Color(0xFFF3EAFE), Color(0xFFDCC6FB)], // violet
  [Color(0xFFFFE9EC), Color(0xFFFBC2CD)], // rose
  [Color(0xFFE5F7FA), Color(0xFFBCE8F1)], // turquoise
  [Color(0xFFF6F1E3), Color(0xFFE8DBB2)], // sable
  [Color(0xFFEDEFF5), Color(0xFFD2D9E8)], // ardoise
 ];

 static List<Color> pair(int seed) =>
   palettes[seed.abs() % palettes.length];

 static Color accent(int seed) {
  const accents = <Color>[
   Color(0xFF2F6FDB),
   Color(0xFFE07A1F),
   Color(0xFF1F9D55),
   Color(0xFF7C4DFF),
   Color(0xFFD84262),
   Color(0xFF12889B),
   Color(0xFF9A7B2D),
   Color(0xFF4A5B7A),
  ];
  return accents[seed.abs() % accents.length];
 }
}

/// Vignette produit : dégradé duotone + emoji + ruban optionnel ("PROMO -20 %").
class ProductArt extends StatelessWidget {
 const ProductArt({
  super.key,
  required this.emoji,
  required this.seed,
  this.ribbon,
  this.radius = 16,
  this.emojiScale = 0.36,
 });

 final String emoji;
 final int seed;
 final String? ribbon;
 final double radius;
 final double emojiScale;

 @override
 Widget build(BuildContext context) {
  final pair = ArtPalette.pair(seed);
  return ClipRRect(
   borderRadius: BorderRadius.circular(radius),
   child: DecoratedBox(
    decoration: BoxDecoration(
     gradient: LinearGradient(
      colors: pair,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
     ),
    ),
    child: LayoutBuilder(
     builder: (context, constraints) {
      final side = math.min(
       constraints.maxWidth.isFinite ? constraints.maxWidth : 120,
       constraints.maxHeight.isFinite ? constraints.maxHeight : 120,
      );
      return Stack(
       fit: StackFit.expand,
       children: [
        Positioned(
         right: -side * 0.18,
         top: -side * 0.18,
         child: Container(
          width: side * 0.62,
          height: side * 0.62,
          decoration: BoxDecoration(
           color: Colors.white.withValues(alpha: 0.38),
           shape: BoxShape.circle,
          ),
         ),
        ),
        Center(
         child: Text(
          emoji,
          style: TextStyle(fontSize: side * emojiScale),
         ),
        ),
        if (ribbon != null)
         Positioned(
          left: 0,
          top: 10,
          child: Container(
           padding: const EdgeInsets.symmetric(
             horizontal: 8, vertical: 4),
           decoration: const BoxDecoration(
            color: Color(0xFFFF6B00),
            borderRadius: BorderRadius.only(
             topRight: Radius.circular(10),
             bottomRight: Radius.circular(10),
            ),
           ),
           child: Text(
            ribbon!,
            style: const TextStyle(
             color: Colors.white,
             fontSize: 10,
             fontWeight: FontWeight.w800,
             letterSpacing: 0.3,
            ),
           ),
          ),
         ),
       ],
      );
     },
    ),
   ),
  );
 }
}

/// Avatar boutique : cercle dégradé + emoji + badge vérifié.
class SellerAvatar extends StatelessWidget {
 const SellerAvatar({
  super.key,
  required this.emoji,
  required this.seed,
  this.size = 44,
  this.verified = false,
 });

 final String emoji;
 final int seed;
 final double size;
 final bool verified;

 @override
 Widget build(BuildContext context) {
  final pair = ArtPalette.pair(seed);
  final badge = size * 0.34;
  return SizedBox(
   width: size,
   height: size,
   child: Stack(
    clipBehavior: Clip.none,
    children: [
     Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
       gradient: LinearGradient(
        colors: pair,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
       ),
       shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: size * 0.46)),
     ),
     if (verified)
      Positioned(
       right: -1,
       bottom: -1,
       child: Container(
        width: badge,
        height: badge,
        decoration: const BoxDecoration(
         color: Color(0xFF0066CC),
         shape: BoxShape.circle,
         border: Border.fromBorderSide(
           BorderSide(color: Colors.white, width: 1.6)),
        ),
        child: AppIcon(AppIcons.check_rounded,
          size: badge * 0.72, color: Colors.white),
       ),
      ),
    ],
   ),
  );
 }
}

/// Logo Okoumé (carré arrondi dégradé bleu, "O" blanc, point orange).
class AppLogo extends StatelessWidget {
 const AppLogo({super.key, this.size = 72});

 final double size;

 @override
 Widget build(BuildContext context) {
  return Container(
   width: size,
   height: size,
   decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(size * 0.3),
    gradient: const LinearGradient(
     colors: [Color(0xFF0066CC), Color(0xFF3399FF)],
     begin: Alignment.topLeft,
     end: Alignment.bottomRight,
    ),
    boxShadow: [
     BoxShadow(
      color: const Color(0xFF0066CC).withValues(alpha: 0.32),
      blurRadius: size * 0.3,
      offset: Offset(0, size * 0.12),
     ),
    ],
   ),
   child: Stack(
    alignment: Alignment.center,
    children: [
     Text(
      'O',
      style: TextStyle(
       fontFamily: AppTheme.poppins,
       fontWeight: FontWeight.w800,
       fontSize: size * 0.52,
       color: Colors.white,
       height: 1,
      ),
     ),
     Positioned(
      right: size * 0.2,
      bottom: size * 0.2,
      child: Container(
       width: size * 0.14,
       height: size * 0.14,
       decoration: const BoxDecoration(
        color: Color(0xFFFF6B00),
        shape: BoxShape.circle,
       ),
      ),
     ),
    ],
   ),
  );
 }
}
