import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{'p9'};

  void toggle(String productId) {
    final next = Set<String>.of(state);
    next.contains(productId) ? next.remove(productId) : next.add(productId);
    state = next;
  }

  bool contains(String productId) => state.contains(productId);
}

final wishlistProvider =
    NotifierProvider<WishlistNotifier, Set<String>>(WishlistNotifier.new);

/// Favori d'un produit précis — limite le rebuild à la seule carte concernée
/// lors d'un toggle (au lieu de toutes les cartes montées).
final wishlistedProvider =
    Provider.family<bool, String>((ref, id) => ref.watch(wishlistProvider).contains(id));
