import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models.dart';
import '../../../data/providers.dart';
import '../../art.dart';
import '../../theme/app_colors.dart';
import '../app_icons.dart';
import '../motion.dart';
import 'pills.dart';
import 'price.dart';
import 'helpers.dart';

// ========================================================== Vignettes produit

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product, this.width});

  final Product product;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final wished = ref.watch(wishlistedProvider(product.id));

    return Semantics(
      button: true,
      child: Pressable(
      scale: 0.98,
      child: GestureDetector(
        onTap: () => context.push('/product/${product.id}'),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ProductArt(
                        emoji: product.emoji.isNotEmpty ? product.emoji : '•',
                        seed: product.seed,
                        ribbon: product.discountPercent >= 15
                            ? '-${product.discountPercent}%'
                            : null,
                        radius: 16,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Semantics(
                        button: true,
                        toggled: wished,
                        label: wished
                            ? 'Retirer des favoris'
                            : 'Ajouter aux favoris',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            ref
                                .read(wishlistProvider.notifier)
                                .toggle(product.id);
                            AppMotion.tap();
                            final nowWished = ref
                                .read(wishlistProvider)
                                .contains(product.id);
                            showAppSnack(
                              context,
                              nowWished
                                  ? 'Ajouté à vos favoris'
                                  : 'Retiré de vos favoris',
                              emoji: nowWished ? '' : '',
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(7),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: AnimatedSwitcher(
                                duration: AppMotion.on(context)
                                    ? const Duration(milliseconds: 220)
                                    : Duration.zero,
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(
                                  scale: CurvedAnimation(
                                    parent: anim,
                                    curve: Curves.easeOutBack,
                                  ),
                                  child: child,
                                ),
                                child: Icon(
                                  wished
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,
                                  key: ValueKey<bool>(wished),
                                  size: 16,
                                  color: wished
                                      ? AppColors.danger
                                      : AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (product.express)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Pill(
                          text: 'Express',
                          color: AppColors.success,
                          icon: AppIcons.bolt_rounded,
                          dense: true,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, height: 1.25),
              ),
              const SizedBox(height: 3),
              RatingStars(rating: product.rating, size: 12, reviews: product.reviews),
              const SizedBox(height: 4),
              PriceText(
                price: product.price,
                oldPrice: product.oldPrice,
                size: product.price >= 1000000 ? 13 : 14.5,
              ),
              const SizedBox(height: 2),
              Text(
                ' ${product.city}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.8, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final seller = ref.watch(sellerByIdProvider(product.sellerId));
    return Semantics(
      button: true,
      child: Pressable(
      scale: 0.98,
      child: GestureDetector(
        onTap: onTap ?? () => context.push('/product/${product.id}'),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: ProductArt(
                  emoji: product.emoji.isNotEmpty ? product.emoji : '•', seed: product.seed, radius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          height: 1.25),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      seller.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 11.5, color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: PriceText(
                            price: product.price,
                            oldPrice: product.oldPrice,
                            size: 15,
                          ),
                        ),
                        RatingStars(
                            rating: product.rating, size: 12, showValue: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
