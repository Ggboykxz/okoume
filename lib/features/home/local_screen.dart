import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// A-14 · Made in Gabon — artisans et producteurs locaux.
class LocalProductsScreen extends ConsumerWidget {
 const LocalProductsScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final catalog = ref.watch(catalogProvider);
  final local = catalog
    .where((p) =>
      p.tags.contains('Made in Gabon') ||
      Mock.sellerById(p.sellerId).type == SellerType.artisan)
    .toList();
  final artisans = Mock.sellers
    .where((s) => s.type == SellerType.artisan)
    .toList();

  return Scaffold(
   appBar: AppBar(title: const Text('Made in Gabon 🇬🇦')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
    children: [
     MotionEnter(
      child: Container(
       padding: const EdgeInsets.all(18),
       decoration: BoxDecoration(
        gradient: const LinearGradient(
         colors: [Color(0xFF00A344), Color(0xFF00C853)],
         begin: Alignment.topLeft,
         end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
       ),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text('', style: TextStyle(fontSize: 30)),
         const SizedBox(height: 10),
         const Text(
          'Le meilleur du terroir gabonais',
          style: TextStyle(
           color: Colors.white,
           fontWeight: FontWeight.w800,
           fontSize: 18,
           height: 1.2,
           letterSpacing: -0.3,
          ),
         ),
         const SizedBox(height: 6),
         Text(
          '${local.length} produits d\'artisans de Libreville, Port-Gentil, Franceville… Chaque achat soutient une famille gabonaise.',
          style: TextStyle(
           color: Colors.white.withValues(alpha: 0.94),
           fontSize: 12.5,
           height: 1.45,
          ),
         ),
        ],
       ),
      ),
     ),
     const SizedBox(height: 18),
     Text('Nos artisans',
       style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 10),
     SizedBox(
      height: 96,
      child: ListView.separated(
       scrollDirection: Axis.horizontal,
       itemCount: artisans.length,
       separatorBuilder: (_, _) => const SizedBox(width: 12),
       itemBuilder: (context, i) {
        final seller = artisans[i];
        return Pressable(
         scale: 0.94,
         child: GestureDetector(
          onTap: () => context.push('/seller/${seller.id}'),
          child: SizedBox(
           width: 84,
           child: Column(
            children: [
             SellerAvatar(
              emoji: seller.emoji.isNotEmpty ? seller.emoji : '•',
              seed: seller.seed,
              size: 56,
              verified: seller.verified,
             ),
             const SizedBox(height: 5),
             Text(
              seller.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5, fontWeight: FontWeight.w600),
             ),
            ],
           ),
          ),
         ),
        );
       },
      ),
     ),
     const SizedBox(height: 16),
     Text('Produits du terroir',
       style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 12),
     if (local.isEmpty)
      const EmptyState(
       emoji: '',
       title: 'Bientôt disponible',
       message: 'Les produits locaux arrivent très vite sur Okoumé.',
      )
     else
      GridView.count(
       crossAxisCount: 2,
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       mainAxisSpacing: 16,
       crossAxisSpacing: 14,
       childAspectRatio: 0.62,
       children: [
        for (var i = 0; i < local.length; i++)
         MotionEnter(order: i, child: ProductCard(product: local[i])),
       ],
      ),
     const SizedBox(height: 16),
     const InfoBanner(
      emoji: '🇬🇦',
      color: AppColors.success,
      text:
        'En achetant local, vous rémunérez directement les producteurs : Okoumé ne prend aucune commission sur les articles « Made in Gabon » pendant leur première année.',
     ),
    ],
   ),
  );
 }
}
