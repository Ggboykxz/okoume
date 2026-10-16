import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../shell/main_shell.dart';
import '../../core/ui/app_icons.dart';

class SellerProductsScreen extends ConsumerWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final products = ref.watch(sellerProvider).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes produits (${products.length})'),
        actions: [
          IconButton(
            icon: const AppIcon(AppIcons.add_rounded),
            onPressed: () => context.push('/seller/products/new'),
          ),
        ],
      ),
      body: products.isEmpty
          ? EmptyState(
              emoji: '📦',
              title: 'Aucun produit en ligne',
              message:
                  'Publiez votre première annonce en moins de 60 secondes avec la vente rapide.',
              actionLabel: 'Vendre maintenant',
              onAction: () => shellTabNotifier.value = 2,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: products.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                if (i == products.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: InfoBanner(
                      emoji: '🌍',
                      text:
                          'Vos produits sont immédiatement visibles par les acheteurs de tout le Gabon.',
                      color: cs.primary,
                    ),
                  );
                }
                final product = products[i];
                return _ProductRow(product: product);
              },
            ),
    );
  }
}

class _ProductRow extends ConsumerWidget {
  const _ProductRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final lowStock = !product.isService && product.stock <= 3;
    final isFresh = product.tags.contains('Vente rapide');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: SizedBox(
              width: 56,
              height: 56,
              child: ProductArt(
                  emoji: product.emoji, seed: product.seed, radius: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    PriceText(price: product.price, size: 13.5),
                    const SizedBox(width: 8),
                    Text(
                      '· ${product.sold} vendus',
                      style: TextStyle(
                          fontSize: 11.5, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (isFresh)
                      const Pill(
                        text: '🆕 Vente rapide',
                        color: AppColors.secondary,
                        dense: true,
                      ),
                    Pill(
                      text: lowStock
                          ? '⚠️ Stock : ${product.stock}'
                          : '✅ En ligne · ${product.stock} en stock',
                      color: lowStock
                          ? AppColors.warning
                          : AppColors.success,
                      dense: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _openActions(context, ref),
            child: AppIcon(AppIcons.more_vert_rounded,
                size: 20, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _openActions(BuildContext context, WidgetRef ref) {
    showAppSheet(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const AppIcon(AppIcons.visibility_rounded),
            title: const Text('Voir la fiche publique'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/product/${product.id}');
            },
          ),
          ListTile(
            leading: const AppIcon(AppIcons.edit_rounded),
            title: const Text('Modifier'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/seller/products/${product.id}/edit');
            },
          ),
          ListTile(
            leading: const AppIcon(AppIcons.bolt_rounded),
            title: const Text('Booster la visibilité'),
            subtitle: const Text('Mise en avant 24 h · 1 000 FCFA'),
            onTap: () {
              Navigator.of(context).pop();
              showAppSnack(context, 'Boost activé pour 24 h (démo)',
                  emoji: '🚀');
            },
          ),
          ListTile(
            leading: const AppIcon(AppIcons.delete_outline_rounded,
                color: AppColors.danger),
            title: const Text('Retirer de la vente',
                style: TextStyle(color: AppColors.danger)),
            onTap: () async {
              Navigator.of(context).pop();
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Retirer ce produit ?'),
                  content: Text(
                      '« ${product.title} » ne sera plus visible par les acheteurs.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Retirer',
                          style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                ref.read(sellerProvider.notifier).removeProduct(product.id);
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
