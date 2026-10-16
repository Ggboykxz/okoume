import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class _Slide {
 const _Slide(this.emoji, this.title, this.text, this.seed);

 final String emoji;
 final String title;
 final String text;
 final int seed;
}

const _slides = <_Slide>[
 _Slide(
 '',
 'Tout le Gabon,\ndans ma poche',
 'Des milliers de produits des vendeurs de Libreville, Port-Gentil, Franceville… livrés près de chez vous.',
 0,
 ),
 _Slide(
 '',
 'Payez comme\nvous vivez',
 'Airtel Money, Moov Money, carte bancaire ou cash à la livraison. Votre argent est bloqué jusqu\'à la réception du colis.',
 1,
 ),
 _Slide(
 '',
 'Livraison suivie,\nen temps réel',
 'Vendeurs vérifiés, livreurs notés, suivi GPS et code OTP à la remise. La confiance, de bout en bout.',
 2,
 ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
 const OnboardingScreen({super.key});

 @override
 ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
 final _controller = PageController();
 int _index = 0;

 void _finish() {
 ref.read(settingsProvider.notifier).seenOnboarding();
 context.go('/auth');
 }

 @override
 void dispose() {
 _controller.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final isLast = _index == _slides.length - 1;
 return Scaffold(
  body: SafeArea(
  child: Column(
   children: [
   Align(
    alignment: Alignment.topRight,
    child: Padding(
    padding: const EdgeInsets.all(12),
    child: TextButton(
     onPressed: _finish,
     child: Text(
     'Passer',
     style: TextStyle(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w700,
     ),
     ),
    ),
    ),
   ),
   Expanded(
    child: PageView.builder(
    controller: _controller,
    itemCount: _slides.length,
    onPageChanged: (i) => setState(() => _index = i),
    itemBuilder: (context, i) {
     final slide = _slides[i];
     return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 32),
     child: LayoutBuilder(
      builder: (context, constraints) {
      final compact = constraints.maxHeight < 480;
      final artSize = compact ? 140.0 : 210.0;
      return SingleChildScrollView(
       child: ConstrainedBox(
       constraints: BoxConstraints(
        minHeight: constraints.maxHeight),
       child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SizedBox(
         width: artSize,
         height: artSize,
         child: Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
          BoxShadow(
           color: ArtPalette.pair(slide.seed)[1]
            .withValues(alpha: 0.5),
           blurRadius: 40,
           offset: const Offset(0, 18),
          ),
          ],
         ),
         child: ProductArt(
          emoji: slide.emoji.isNotEmpty ? slide.emoji : '•',
          seed: slide.seed,
          radius: 48,
          emojiScale: 0.4,
         ),
         ),
        ),
        SizedBox(height: compact ? 22 : 42),
        Text(
         slide.title,
         textAlign: TextAlign.center,
         style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(height: 1.15),
        ),
        const SizedBox(height: 14),
        Text(
         slide.text,
         textAlign: TextAlign.center,
         style: TextStyle(
         fontSize: 14.5,
         height: 1.5,
         color: cs.onSurfaceVariant,
         ),
        ),
        ],
       ),
       ),
      );
      },
     ),
     );
    },
    ),
   ),
   Padding(
    padding: const EdgeInsets.fromLTRB(32, 0, 32, 28),
    child: Column(
    children: [
     Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      for (var i = 0; i < _slides.length; i++)
      AnimatedContainer(
       duration: const Duration(milliseconds: 250),
       margin: const EdgeInsets.symmetric(horizontal: 4),
       width: i == _index ? 22 : 8,
       height: 8,
       decoration: BoxDecoration(
       color: i == _index
        ? cs.primary
        : cs.outlineVariant,
       borderRadius: BorderRadius.circular(99),
       ),
      ),
     ],
     ),
     const SizedBox(height: 22),
     AppButton(
     label: isLast ? 'Créer mon compte' : 'Suivant',
     variant: isLast
      ? AppButtonVariant.primary
      : AppButtonVariant.primary,
     icon: isLast ? AppIcons.rocket_launch_rounded : null,
     onPressed: () {
      if (isLast) {
      _finish();
      } else {
      _controller.nextPage(
       duration: const Duration(milliseconds: 320),
       curve: Curves.easeOutCubic,
      );
      }
     },
     ),
     const SizedBox(height: 10),
     Text(
     'Gratuit Sans engagement Mobile Money ',
     style: TextStyle(
      fontSize: 11.5,
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
     ),
     ),
     const SizedBox(height: 4),
     Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      AppIcon(AppIcons.lock_rounded,
       size: 12, color: AppColors.success),
      const SizedBox(width: 4),
      Text(
      'Paiements sécurisés (escrow)',
      style: TextStyle(
       fontSize: 11.5,
       color: AppColors.success,
       fontWeight: FontWeight.w700,
      ),
      ),
     ],
     ),
    ],
    ),
   ),
   ],
  ),
  ),
 );
 }
}
