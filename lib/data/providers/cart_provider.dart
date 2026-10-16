import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';
import 'catalog_provider.dart';

class CartState {
  const CartState({this.lines = const [], this.promo});

  final List<CartLine> lines;
  final PromoCode? promo;

  CartState copyWith({List<CartLine>? lines, PromoCode? promo, bool clearPromo = false}) =>
      CartState(
        lines: lines ?? this.lines,
        promo: clearPromo ? null : (promo ?? this.promo),
      );
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  static bool _sameVariant(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final e in a.entries) {
      if (b[e.key] != e.value) return false;
    }
    return true;
  }

  void add(String productId, {int qty = 1, Map<String, String> variant = const {}}) {
    final lines = List<CartLine>.of(state.lines);
    final index = lines.indexWhere(
        (l) => l.productId == productId && _sameVariant(l.variant, variant));
    if (index >= 0) {
      final product = Mock.productById(productId);
      final maxQty = product.isService ? 99 : product.stock;
      var newQty = lines[index].qty + qty;
      if (newQty < 1) newQty = 1;
      if (newQty > maxQty) newQty = maxQty;
      lines[index] = lines[index].copyWith(qty: newQty);
    } else {
      lines.add(CartLine(productId: productId, qty: qty, variant: variant));
    }
    state = state.copyWith(lines: lines);
  }

  void setQty(String productId, int qty, {Map<String, String> variant = const {}}) {
    if (qty <= 0) {
      remove(productId, variant: variant);
      return;
    }
    final lines = List<CartLine>.of(state.lines);
    final index = lines.indexWhere(
        (l) => l.productId == productId && _sameVariant(l.variant, variant));
    if (index >= 0) {
      lines[index] = lines[index].copyWith(qty: qty);
      state = state.copyWith(lines: lines);
    }
  }

  void remove(String productId, {Map<String, String> variant = const {}}) {
    state = state.copyWith(
      lines: state.lines
          .where((l) =>
              !(l.productId == productId && _sameVariant(l.variant, variant)))
          .toList(),
    );
  }

  void clear() => state = const CartState();

  String? applyPromo(String code) {
    final normalized = code.trim().toUpperCase();
    try {
      final promo = Mock.promoCodes.firstWhere((p) => p.code == normalized);
      state = state.copyWith(promo: promo);
      return null;
    } catch (_) {
      return 'Code promo invalide';
    }
  }

  void removePromo() => state = state.copyWith(clearPromo: true);
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.lines.fold(0, (sum, l) => sum + l.qty);
});

class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.discount,
    required this.delivery,
    required this.total,
  });

  final int subtotal;
  final int discount;
  final int delivery;
  final int total;

  static const empty = CartTotals(subtotal: 0, discount: 0, delivery: 0, total: 0);
}

/// Frais de livraison de base : offerts dès 25 000 FCFA (cf. bannière Livraison offerte ).
final cartTotalsProvider = Provider<CartTotals>((ref) {
  final cart = ref.watch(cartProvider);
  var subtotal = 0;
  for (final line in cart.lines) {
    final product = ref.watch(productByIdProvider(line.productId));
    if (product != null) subtotal += product.price * line.qty;
  }
  final discount = cart.promo?.discountFor(subtotal) ?? 0;
  var delivery = 0;
  if (subtotal > 0 && subtotal < 25000) delivery = 1500;
  if (cart.promo?.freeShipping == true) delivery = 0;
  var total = subtotal + delivery - discount;
  if (total < 0) total = 0;
  return CartTotals(
      subtotal: subtotal, discount: discount, delivery: delivery, total: total);
});
