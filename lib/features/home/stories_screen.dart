import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// A-08 · Stories Découverte — offres du jour en plein écran.
///
/// Lecture auto (5 s) avec barre de progression segmentée ; tap à gauche =
/// précédent, à droite = suivant ; balayage vertical = fermer. La lecture
/// automatique est figée en mode réduit (et donc en tests).
class StoriesScreen extends ConsumerStatefulWidget {
 const StoriesScreen({super.key, this.startIndex = 0});

 final int startIndex;

 @override
 ConsumerState<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesScreen>
  with SingleTickerProviderStateMixin {
 late final AnimationController _progress;
 late int _index;

 @override
 void initState() {
  super.initState();
  _progress = AnimationController(
   vsync: this,
   duration: const Duration(seconds: 5),
  );
  _index = widget.startIndex;
  _progress.addStatusListener((status) {
   if (status == AnimationStatus.completed) _next();
  });
  _play();
 }

 @override
 void dispose() {
  _progress.dispose();
  super.dispose();
 }

 List<_Story> _build(List<Product> products) => [
    for (final p in products)
     _Story(
      emoji: p.emoji.isNotEmpty ? p.emoji : '•',
      seed: p.seed,
      title: p.title,
      price: p.price,
      oldPrice: p.oldPrice,
      productId: p.id,
     ),
   ];

 void _play() {
  if (AppMotion.reduce) {
   _progress.value = 1;
   return;
  }
  _progress.forward(from: 0);
 }

 void _next() {
  final total = ref.read(flashDealsProvider).length;
  if (_index >= total - 1) {
   if (mounted && context.canPop()) context.pop();
   return;
  }
  setState(() => _index += 1);
  AppMotion.tap();
  _play();
 }

 void _previous() {
  if (_index == 0) {
   _play();
   return;
  }
  setState(() => _index -= 1);
  AppMotion.tap();
  _play();
 }

 @override
 Widget build(BuildContext context) {
  final stories = _build(ref.watch(flashDealsProvider));
  if (stories.isEmpty) {
   return const Scaffold(
    body: EmptyState(
     emoji: '',
     title: 'Pas de story aujourd\'hui',
     message: 'Revenez plus tard pour découvrir les offres du jour.',
    ),
   );
  }
  final story = stories[_index.clamp(0, stories.length - 1)];
  final pair = ArtPalette.pair(story.seed);

  return Scaffold(
   backgroundColor: pair.first,
   body: GestureDetector(
    onVerticalDragEnd: (details) {
     if ((details.primaryVelocity ?? 0) > 250) context.pop();
    },
    child: Stack(
     fit: StackFit.expand,
     children: [
      // ------------------------------------------------------- Fond
      DecoratedBox(
       decoration: BoxDecoration(
        gradient: LinearGradient(
         colors: pair,
         begin: Alignment.topLeft,
         end: Alignment.bottomRight,
        ),
       ),
      ),
      Positioned(
       right: -40,
       top: 120,
       child: Text(
        story.emoji.isNotEmpty ? story.emoji : '•',
        style: TextStyle(
         fontSize: 220,
         color: Colors.white.withValues(alpha: 0.16),
        ),
       ),
      ),
      SafeArea(
       child: Column(
        children: [
         // ----------------------------------- Progression segmentée
         Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
           children: [
            for (var i = 0; i < stories.length; i++)
             Expanded(
              child: Padding(
               padding:
                 const EdgeInsets.symmetric(horizontal: 2.5),
               child: ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: SizedBox(
                 height: 3.5,
                 child: i < _index
                   ? const ColoredBox(
                     color: Colors.white)
                   : i == _index
                     ? AnimatedBuilder(
                       animation: _progress,
                       builder: (context, _) =>
                         LinearProgressIndicator(
                        value: AppMotion.reduce
                          ? 1
                          : _progress.value,
                        backgroundColor: Colors.white
                          .withValues(alpha: 0.32),
                        valueColor:
                          const AlwaysStoppedAnimation(
                            Colors.white),
                       ),
                      )
                     : ColoredBox(
                       color: Colors.white
                         .withValues(alpha: 0.32)),
                ),
               ),
              ),
             ),
           ],
          ),
         ),
         const SizedBox(height: 12),
         // ------------------------------------------------- En-tête
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
           children: [
            Container(
             width: 34,
             height: 34,
             decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
             ),
             alignment: Alignment.center,
             child: const Text('🇬🇦',
               style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(width: 10),
            const Expanded(
             child: Text(
              'Offres du jour · Libreville',
              style: TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.w700,
               fontSize: 13.5,
              ),
             ),
            ),
            Pressable(
             scale: 0.9,
             child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
               width: 34,
               height: 34,
               decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                shape: BoxShape.circle,
               ),
               child: const AppIcon(AppIcons.close_rounded,
                 size: 18, color: Colors.white),
              ),
             ),
            ),
           ],
          ),
         ),
         // ------------------------------------------------- Contenu
         Expanded(
          child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 26),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text(story.emoji.isNotEmpty ? story.emoji : '•',
               style: const TextStyle(fontSize: 84)),
             const SizedBox(height: 18),
             Text(
              story.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.w800,
               fontSize: 24,
               height: 1.2,
               letterSpacing: -0.4,
              ),
             ),
             const SizedBox(height: 12),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Text(
                formatXaf(story.price),
                style: const TextStyle(
                 fontFamily: 'Montserrat',
                 color: Colors.white,
                 fontWeight: FontWeight.w800,
                 fontSize: 26,
                ),
               ),
               if (story.oldPrice != null) ...[
                const SizedBox(width: 10),
                Text(
                 formatXaf(story.oldPrice!),
                 style: TextStyle(
                  fontFamily: 'Montserrat',
                  color:
                    Colors.white.withValues(alpha: 0.7),
                  fontSize: 15,
                  decoration: TextDecoration.lineThrough,
                 ),
                ),
               ],
              ],
             ),
             const SizedBox(height: 18),
             MotionEnter(
              child: AppButton(
               label: 'Voir le produit',
               expanded: false,
               height: 46,
               icon: AppIcons.arrow_forward_rounded,
               onPressed: () =>
                 context.push('/product/${story.productId}'),
              ),
             ),
            ],
           ),
          ),
         ),
         // ----------------------------------------------- Zones tactiles
         const SizedBox(height: 64),
        ],
       ),
      ),
      // Tap gauche = précédent / tap droite = suivant.
      Row(
       children: [
        Expanded(
         child: GestureDetector(
          onTap: _previous,
          behavior: HitTestBehavior.opaque,
          child: const SizedBox.expand(),
         ),
        ),
        Expanded(
         flex: 2,
         child: GestureDetector(
          onTap: _next,
          behavior: HitTestBehavior.opaque,
          child: const SizedBox.expand(),
         ),
        ),
       ],
      ),
     ],
    ),
   ),
  );
 }
}

class _Story {
 const _Story({
  required this.emoji,
  required this.seed,
  required this.title,
  required this.price,
  required this.oldPrice,
  required this.productId,
 });

 final String emoji;
 final int seed;
 final String title;
 final int price;
 final int? oldPrice;
 final String productId;
}
