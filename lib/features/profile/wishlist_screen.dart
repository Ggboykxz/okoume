import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class WishlistScreen extends ConsumerWidget {
 const WishlistScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final ids = ref.watch(wishlistProvider);
  final products = ids
    .map((id) => ref.watch(productByIdProvider(id)))
    .whereType<Product>()
    .toList();

  return Scaffold(
   appBar: AppBar(
    title: Text('Favoris (${products.length})'),
   ),
   body: products.isEmpty
     ? EmptyState(
       emoji: '',
       title: 'Aucun favori pour le moment',
       message:
         'Touchez le cœur sur un produit pour le retrouver ici, même hors ligne.',
       actionLabel: 'Explorer le catalogue',
       onAction: () => context.go('/main'),
      )
     : ListView(
       padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
       children: [
        GridView.count(
         crossAxisCount: 2,
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         mainAxisSpacing: 18,
         crossAxisSpacing: 14,
         childAspectRatio: 0.62,
         children: [
          for (final p in products) ProductCard(product: p),
         ],
        ),
        const SizedBox(height: 20),
        AppButton(
         label: 'Tout ajouter au panier',
         icon: AppIcons.add_shopping_cart_rounded,
         onPressed: () {
          for (final p in products) {
           ref.read(cartProvider.notifier).add(p.id);
          }
          showAppSnack(
           context,
           '${products.length} article(s) ajouté(s) au panier',
           emoji: '',
          );
         },
        ),
       ],
      ),
  );
 }
}
