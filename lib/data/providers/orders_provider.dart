import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_data.dart';
import '../models.dart';
import 'cart_provider.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() => List.of(Mock.orders);

  Order place({
    required List<CartLine> lines,
    required CartTotals totals,
    required Address address,
    required PaymentMethod payment,
    required DeliveryMode mode,
    required DeliverySpeed speed,
    int? deliveryFee,
  }) {
    final now = DateTime.now();
    final orderLines = lines.map((line) {
      final p = Mock.productById(line.productId);
      return OrderLine(
        productId: p.id,
        title: p.title,
        emoji: p.emoji.isNotEmpty ? p.emoji : '•',
        seed: p.seed,
        price: p.price,
        qty: line.qty,
        variantLabel: line.variantLabel,
        sellerName: Mock.sellerById(p.sellerId).name,
      );
    }).toList();

    final suffix = (1000 + (now.millisecondsSinceEpoch % 9000)).toString();
    final order = Order(
      id: 'o-$suffix',
      code: 'OKM-2026-$suffix',
      createdAt: now,
      lines: orderLines,
      subtotal: totals.subtotal,
      deliveryFee: deliveryFee ?? (totals.delivery + speed.extraFee),
      discount: totals.discount,
      status: OrderStatus.confirmee,
      payment: payment,
      deliveryLabel: '${mode.label} ${speed.label}',
      eta: now.add(speed == DeliverySpeed.express
          ? const Duration(hours: 2)
          : const Duration(hours: 24)),
      addressLabel: address.full,
      otp: suffix.replaceRange(1, 3, '4').padRight(4, '2').substring(0, 4),
      escrowHeld: payment != PaymentMethod.cash,
      events: [OrderEvent(status: OrderStatus.confirmee, time: now)],
    );
    state = [order, ...state];
    return order;
  }

  /// Avance la commande à l'étape suivante (bouton démo du suivi).
  Order? advance(String id) {
    final index = state.indexWhere((o) => o.id == id);
    if (index < 0) return null;
    final order = state[index];
    if (!order.status.isActive) return order;
    final next = order.status.next;
    final updated = order.copyWith(
      status: next,
      escrowHeld: next == OrderStatus.livree ? false : order.escrowHeld,
      events: [...order.events, OrderEvent(status: next, time: DateTime.now())],
    );
    state = List.of(state)..[index] = updated;
    return updated;
  }

  /// Confirme la réception avec le code OTP du livreur (FR-005.5).
  bool confirmDelivery(String id, String otp) {
    final index = state.indexWhere((o) => o.id == id);
    if (index < 0) return false;
    final order = state[index];
    if (order.status != OrderStatus.enLivraison || otp.trim() != order.otp) {
      return false;
    }
    state = List.of(state)
      ..[index] = order.copyWith(
        status: OrderStatus.livree,
        escrowHeld: false,
        events: [
          ...order.events.where((e) => e.done),
          OrderEvent(status: OrderStatus.livree, time: DateTime.now()),
        ],
      );
    return true;
  }

  void rate(String id, double rating, List<String> tags, String comment) {
    final index = state.indexWhere((o) => o.id == id);
    if (index < 0) return;
    state = List.of(state)..[index] = state[index].copyWith(rated: true);
  }
}

final ordersProvider =
    NotifierProvider<OrdersNotifier, List<Order>>(OrdersNotifier.new);

final orderByIdProvider = Provider.family<Order?, String>((ref, id) {
  for (final o in ref.watch(ordersProvider)) {
    if (o.id == id) return o;
  }
  return null;
});
