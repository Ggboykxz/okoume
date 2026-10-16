import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// A-23 · Tous les avis d'un produit (+ A-25 : rédiger un avis).
class ProductReviewsScreen extends ConsumerStatefulWidget {
  const ProductReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductReviewsScreen> createState() =>
      _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends ConsumerState<ProductReviewsScreen> {
  int _filter = 0; // 0 = tous, sinon nombre d'étoiles minimum

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final product = ref.watch(productByIdProvider(widget.productId));
    final reviews = ref.watch(productReviewsProvider(widget.productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          emoji: '🔍',
          title: 'Produit introuvable',
          message: 'Cet article n\'est plus disponible.',
        ),
      );
    }

    final filtered = _filter == 0
        ? reviews
        : _filter == 3
            ? reviews.where((r) => r.rating <= 3).toList()
            : reviews.where((r) => r.rating.round() == _filter).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Avis · ${product.title}')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWriteSheet(product),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        icon: const AppIcon(AppIcons.edit_rounded, size: 20),
        label: const Text('Donner mon avis'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
        children: [
          // ------------------------------------------------------ Résumé note
          MotionEnter(
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        product.rating.toStringAsFixed(1).replaceAll('.', ','),
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          fontSize: 38,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RatingStars(
                          rating: product.rating, size: 14, showValue: false),
                      const SizedBox(height: 4),
                      Text(
                        '${reviews.length} avis',
                        style: TextStyle(
                            fontSize: 11.5, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Column(
                      children: [
                        for (var stars = 5; stars >= 1; stars--) ...[
                          _DistributionBar(
                            stars: stars,
                            count: reviews
                                .where((r) => r.rating.round() == stars)
                                .length,
                            total: reviews.length,
                          ),
                          if (stars > 1) const SizedBox(height: 5),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // ---------------------------------------------------- Filtres
          Row(
            children: [
              AppChip(
                label: 'Tous',
                selected: _filter == 0,
                onTap: () => setState(() => _filter = 0),
              ),
              const SizedBox(width: 8),
              for (final stars in const [5, 4, 3])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AppChip(
                    label: stars == 3 ? '≤ 3 ★' : '$stars ★',
                    selected: _filter == stars,
                    onTap: () => setState(
                        () => _filter = _filter == stars ? 0 : stars),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            const EmptyState(
              emoji: '💬',
              title: 'Aucun avis dans ce filtre',
              message: 'Essayez un autre filtre ou soyez le premier à noter !',
            )
          else
            for (var i = 0; i < filtered.length; i++) ...[
              MotionEnter(order: i, child: _ReviewCard(review: filtered[i])),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }

  void _showWriteSheet(Product product) {
    var stars = 5;
    final tags = <String>{};
    final comment = TextEditingController();
    const availableTags = [
      'Conforme à la description',
      'Bien emballé',
      'Livraison rapide',
      'Vendeur réactif',
      'Bon rapport qualité/prix',
    ];

    showAppSheet(
      context,
      StatefulBuilder(
        builder: (context, setSheetState) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Votre avis sur ce produit',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                product.title,
                style: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        AppMotion.tap();
                        setSheetState(() => stars = i);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          i <= stars
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 38,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in availableTags)
                    AppChip(
                      label: tag,
                      selected: tags.contains(tag),
                      onTap: () {
                        AppMotion.tap();
                        setSheetState(() {
                          if (!tags.add(tag)) tags.remove(tag);
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: comment,
                hint: 'Racontez votre expérience (facultatif)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Publier mon avis',
                icon: AppIcons.send_rounded,
                onPressed: () {
                  final user = ref.read(authProvider);
                  ref.read(reviewsProvider.notifier).add(
                        product.id,
                        Review(
                          author: user?.name ?? 'Utilisateur Okoumé',
                          emoji: user?.emoji ?? '🧑🏾',
                          rating: stars.toDouble(),
                          date: DateTime.now(),
                          text: comment.text.trim().isEmpty
                              ? (tags.isEmpty
                                  ? 'Très bon achat, je recommande !'
                                  : tags.join(' · '))
                              : comment.text.trim(),
                        ),
                      );
                  Navigator.of(context).pop();
                  AppMotion.success();
                  showAppSnack(context, 'Merci, votre avis est publié ✅',
                      emoji: '⭐');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({
    required this.stars,
    required this.count,
    required this.total,
  });

  final int stars;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ratio = total == 0 ? 0.0 : count / total;
    return Row(
      children: [
        Text('$stars ★',
            style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: cs.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation(AppColors.warning),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 22,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(review.emoji,
                    style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.author,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      formatDate(review.date),
                      style: TextStyle(
                          fontSize: 11, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              RatingStars(rating: review.rating, size: 12, showValue: false),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.text,
            style: TextStyle(fontSize: 13, height: 1.5, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
