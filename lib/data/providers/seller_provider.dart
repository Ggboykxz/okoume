import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';
import 'catalog_provider.dart';

class SellerState {
  const SellerState({required this.products, required this.orders});

  final List<Product> products;
  final List<Order> orders;

  SellerState copyWith({List<Product>? products, List<Order>? orders}) =>
      SellerState(products: products ?? this.products, orders: orders ?? this.orders);
}

class SellerNotifier extends Notifier<SellerState> {
  @override
  SellerState build() => SellerState(
        products: Mock.productsOfSeller('s2'),
        orders: List.of(Mock.sellerOrders),
      );

  Product quickSell({
    required String title,
    required int price,
    required String emoji,
    required int seed,
    required String description,
    required bool delivery,
  }) {
    final now = DateTime.now();
    final product = Product(
      id: 'qs-${now.millisecondsSinceEpoch}',
      title: title,
      price: price,
      emoji: emoji,
      seed: seed,
      categoryId: 'c2',
      sellerId: 's2',
      rating: 5.0,
      reviews: 0,
      sold: 0,
      stock: 10,
      city: 'Libreville',
      description: description,
      tags: const ['Vente rapide'],
      express: delivery,
      createdAt: now,
    );
    state = state.copyWith(products: [product, ...state.products]);
    // Publie aussi dans le catalogue global (visible par les acheteurs).
    ref.read(catalogProvider.notifier).add(product);
    return product;
  }

  /// Publication complète depuis le formulaire produit (V-16).
  Product publish({
    required String title,
    required int price,
    int? oldPrice,
    required String emoji,
    required int seed,
    required String categoryId,
    required String description,
    required int stock,
    required String city,
    required List<String> tags,
    required bool express,
    required bool isService,
  }) {
    final now = DateTime.now();
    final product = Product(
      id: 'pub-${now.millisecondsSinceEpoch}',
      title: title,
      price: price,
      oldPrice: oldPrice,
      emoji: emoji,
      seed: seed,
      categoryId: categoryId,
      sellerId: 's2',
      rating: 5.0,
      reviews: 0,
      sold: 0,
      stock: stock,
      city: city,
      description: description,
      tags: tags,
      express: express,
      isService: isService,
      createdAt: now,
    );
    state = state.copyWith(products: [product, ...state.products]);
    ref.read(catalogProvider.notifier).add(product);
    return product;
  }

  /// Édition d'un produit existant (V-22).
  void editProduct(Product product) {
    state = state.copyWith(
      products: [
        for (final p in state.products)
          if (p.id == product.id) product else p,
      ],
    );
    ref.read(catalogProvider.notifier).update(product);
  }

  void removeProduct(String id) {
    state = state.copyWith(
        products: state.products.where((p) => p.id != id).toList());
    ref.read(catalogProvider.notifier).remove(id);
  }

  void advanceOrder(String id) {
    final index = state.orders.indexWhere((o) => o.id == id);
    if (index < 0) return;
    final order = state.orders[index];
    final next = order.status == OrderStatus.enAttente
        ? OrderStatus.confirmee
        : order.status.next;
    state = state.copyWith(orders: List.of(state.orders)
      ..[index] = order.copyWith(
        status: next,
        events: [...order.events, OrderEvent(status: next, time: DateTime.now())],
      ));
  }
}

final sellerProvider =
    NotifierProvider<SellerNotifier, SellerState>(SellerNotifier.new);

final sellerStatsProvider = Provider<SellerStats>((ref) => Mock.sellerStats);
