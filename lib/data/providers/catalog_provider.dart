import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';

class CatalogNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() => List.of(Mock.products);

  void add(Product product) => state = [product, ...state];

  /// Remplace un produit existant (édition V-22).
  void update(Product product) => state = [
        for (final p in state)
          if (p.id == product.id) product else p,
      ];

  void remove(String id) =>
      state = state.where((p) => p.id != id).toList();
}

final catalogProvider =
    NotifierProvider<CatalogNotifier, List<Product>>(CatalogNotifier.new);

final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final list = ref.watch(catalogProvider);
  for (final p in list) {
    if (p.id == id) return p;
  }
  return null;
});

// ===================================================================== Avis
/// Avis rédigés par l'utilisateur (A-25), par produit. Les avis de démo
/// proviennent de [Mock.reviewsFor] et sont fusionnés à la lecture.
class ReviewsNotifier extends Notifier<Map<String, List<Review>>> {
  @override
  Map<String, List<Review>> build() => const {};

  void add(String productId, Review review) {
    final current = state[productId] ?? const <Review>[];
    state = {...state, productId: [review, ...current]};
  }
}

final reviewsProvider =
    NotifierProvider<ReviewsNotifier, Map<String, List<Review>>>(
        ReviewsNotifier.new);

/// Tous les avis d'un produit : les avis utilisateur d'abord, puis la démo.
final productReviewsProvider =
    Provider.family<List<Review>, String>((ref, id) {
  final userReviews = ref.watch(reviewsProvider)[id] ?? const <Review>[];
  final product = ref.watch(productByIdProvider(id));
  if (product == null) return userReviews;
  return [...userReviews, ...Mock.reviewsFor(product)];
});

final sellerByIdProvider = Provider.family<Seller, String>((ref, id) {
  return Mock.sellerById(id);
});

final categoryByIdProvider = Provider.family<Category, String>((ref, id) {
  return Mock.categoryById(id);
});

final productsByCategoryProvider =
    Provider.family<List<Product>, String>((ref, categoryId) {
  return ref
      .watch(catalogProvider)
      .where((p) => p.categoryId == categoryId)
      .toList();
});

final productsBySellerProvider =
    Provider.family<List<Product>, String>((ref, sellerId) {
  return ref
      .watch(catalogProvider)
      .where((p) => p.sellerId == sellerId)
      .toList();
});

/// Offres flash (>= 15% de remise).
final flashDealsProvider = Provider<List<Product>>((ref) {
  return ref.watch(catalogProvider).where((p) => p.isFlash).toList();
});
