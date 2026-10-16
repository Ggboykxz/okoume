import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class CategoryScreen extends ConsumerStatefulWidget {
 const CategoryScreen({super.key, required this.categoryId});

 final String categoryId;

 @override
 ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
 int _quickFilter = 0;

 static const _quickLabels = ['Tout', 'Promos', 'Express', 'Mieux notés'];
 static const _quickIcons = [
 null,
 AppIcons.local_fire_department_rounded,
 AppIcons.bolt_rounded,
 AppIcons.star_rounded,
 ];

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final category = ref.watch(categoryByIdProvider(widget.categoryId));
 final all = ref.watch(productsByCategoryProvider(widget.categoryId));

 var products = List<Product>.of(all);
 switch (_quickFilter) {
  case 1:
  products = products
   .where((p) => p.discountPercent >= 15)
   .toList();
  case 2:
  products = products.where((p) => p.express).toList();
  case 3:
  products.sort((a, b) => b.rating.compareTo(a.rating));
 }

 return Scaffold(
  appBar: AppBar(title: Text(category.name)),
  body: ListView(
  padding: const EdgeInsets.only(bottom: 24),
  children: [
   // ----------------------------------------------------- Bandeau
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
   child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    gradient: LinearGradient(
     colors: [
     category.color,
     category.color.withValues(alpha: 0.75),
     ],
     begin: Alignment.topLeft,
     end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
    children: [
     Container(
     width: 56,
     height: 56,
     decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(18),
     ),
     alignment: Alignment.center,
     child: Text(category.emoji.isNotEmpty ? category.emoji : '•',
      style: const TextStyle(fontSize: 28)),
     ),
     const SizedBox(width: 14),
     Expanded(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
       category.name,
       style: const TextStyle(
       color: Colors.white,
       fontWeight: FontWeight.w800,
       fontSize: 18,
       ),
      ),
      const SizedBox(height: 3),
      Text(
       '${category.count} produits Livraison partout au Gabon',
       style: TextStyle(
       color: Colors.white.withValues(alpha: 0.9),
       fontSize: 12,
       fontWeight: FontWeight.w600,
       ),
      ),
      ],
     ),
     ),
    ],
    ),
   ),
   ),
   // ------------------------------------------------- Filtres rapides
   SizedBox(
   height: 58,
   child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
    itemCount: _quickLabels.length,
    separatorBuilder: (_, _) => const SizedBox(width: 8),
    itemBuilder: (context, i) => AppChip(
    label: _quickLabels[i],
    icon: _quickIcons[i],
    selected: _quickFilter == i,
    color: i == 1 ? AppColors.secondary : null,
    onTap: () => setState(() => _quickFilter = i),
    ),
   ),
   ),
   // ------------------------------------------------------- Produits
   if (products.isEmpty)
   const Padding(
    padding: EdgeInsets.only(top: 60),
    child: EmptyState(
    emoji: '',
    title: 'Rien par ici pour le moment',
    message:
     'Aucun produit ne correspond à ce filtre dans cette catégorie.',
    ),
   )
   else
   GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
    mainAxisSpacing: 18,
    crossAxisSpacing: 14,
    childAspectRatio: 0.62,
    children: [
    for (final p in products) ProductCard(product: p),
    ],
   ),
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
   child: Text(
    'Prix en FCFA, taxes incluses. Les vendeurs vérifiés garantissent l\'état des articles.',
    textAlign: TextAlign.center,
    style: TextStyle(
     fontSize: 11, color: cs.onSurfaceVariant, height: 1.5),
   ),
   ),
  ],
  ),
 );
 }
}
