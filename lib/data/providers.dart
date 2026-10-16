import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_data.dart';
import 'models.dart';

// ============================================================= Écran initial
/// Surchargé dans les tests pour démarrer directement sur une route donnée.
final initialRouteProvider = Provider<String>((ref) => '/splash');

// ================================================================ Réglages
class SettingsState {
 const SettingsState({
 this.themeMode = ThemeMode.light,
 this.lowData = false,
 this.online = true,
 this.onboardingSeen = false,
 });

 final ThemeMode themeMode;
 final bool lowData; // mode bas débit (FR-008.5)
 final bool online; // faux = simulation hors-ligne (démo)
 final bool onboardingSeen;

 SettingsState copyWith({
 ThemeMode? themeMode,
 bool? lowData,
 bool? online,
 bool? onboardingSeen,
 }) =>
  SettingsState(
  themeMode: themeMode ?? this.themeMode,
  lowData: lowData ?? this.lowData,
  online: online ?? this.online,
  onboardingSeen: onboardingSeen ?? this.onboardingSeen,
  );
}

class SettingsNotifier extends Notifier<SettingsState> {
 @override
 SettingsState build() => const SettingsState();

 void toggleDark(bool value) => state = state.copyWith(
  themeMode: value ? ThemeMode.dark : ThemeMode.light);
 void setThemeMode(ThemeMode mode) => state = state.copyWith(themeMode: mode);
 void toggleLowData(bool value) => state = state.copyWith(lowData: value);
 void setOnline(bool value) => state = state.copyWith(online: value);
 void seenOnboarding() => state = state.copyWith(onboardingSeen: true);
}

final settingsProvider =
 NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

// ============================================================ Authentification
class AuthNotifier extends Notifier<AppUser?> {
 @override
 AppUser? build() => null;

 void login(String phone, UserRole role) {
 state = switch (role) {
  UserRole.acheteur => AppUser(
   name: 'Kévin Mbadinga',
   phone: phone,
   role: role,
   emoji: '',
   points: 320,
   balance: 12500,
   kycVerified: true,
   referralCode: 'OKOUME-KEVIN241',
  ),
  UserRole.vendeur => AppUser(
   name: 'TechLibre 241',
   phone: phone,
   role: role,
   emoji: '',
   kycVerified: true,
   referralCode: 'OKOUME-TECH241',
  ),
  UserRole.livreur => AppUser(
   name: 'Marc Ondo',
   phone: phone,
   role: role,
   emoji: '',
   kycVerified: true,
   referralCode: 'OKOUME-MARC241',
  ),
 };
 }

 void logout() => state = null;

 void switchRole(UserRole role) {
 final user = state;
 if (user == null) return;
 login(user.phone, role);
 }

 void credit(int amount) {
 final user = state;
 if (user == null) return;
 state = user.copyWith(balance: user.balance + amount);
 }

 /// Met à jour le profil (C-09 création / C-17 modification).
 void updateProfile({String? name, String? email, String? city}) {
 final user = state;
 if (user == null) return;
 state = user.copyWith(name: name, email: email, city: city);
 }
}

final authProvider = NotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);

// ================================================================ Catalogue
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

// ================================================================ Recherche
enum SearchSort { pertinence, prixAsc, prixDesc, note, nouveautes }

extension SearchSortX on SearchSort {
 String get label => switch (this) {
  SearchSort.pertinence => 'Pertinence',
  SearchSort.prixAsc => 'Prix croissant',
  SearchSort.prixDesc => 'Prix décroissant',
  SearchSort.note => 'Mieux notés',
  SearchSort.nouveautes => 'Nouveautés',
  };
}

class SearchFilters {
 const SearchFilters({
 this.query = '',
 this.categoryIds = const {},
 this.city,
 this.expressOnly = false,
 this.minRating = 0,
 this.priceMin = 0,
 this.priceMax = 16000000,
 this.sort = SearchSort.pertinence,
 });

 final String query;
 final Set<String> categoryIds;
 final String? city;
 final bool expressOnly;
 final double minRating;
 final double priceMin;
 final double priceMax;
 final SearchSort sort;

 bool get hasActiveFilters =>
  categoryIds.isNotEmpty ||
  city != null ||
  expressOnly ||
  minRating > 0 ||
  priceMin > 0 ||
  priceMax < 16000000;

 SearchFilters copyWith({
 String? query,
 Set<String>? categoryIds,
 String? city,
 bool clearCity = false,
 bool? expressOnly,
 double? minRating,
 double? priceMin,
 double? priceMax,
 SearchSort? sort,
 }) =>
  SearchFilters(
  query: query ?? this.query,
  categoryIds: categoryIds ?? this.categoryIds,
  city: clearCity ? null : (city ?? this.city),
  expressOnly: expressOnly ?? this.expressOnly,
  minRating: minRating ?? this.minRating,
  priceMin: priceMin ?? this.priceMin,
  priceMax: priceMax ?? this.priceMax,
  sort: sort ?? this.sort,
  );
}

class SearchNotifier extends Notifier<SearchFilters> {
 @override
 SearchFilters build() => const SearchFilters();

 void setQuery(String q) => state = state.copyWith(query: q);

 void toggleCategory(String id) {
 final next = Set<String>.of(state.categoryIds);
 next.contains(id) ? next.remove(id) : next.add(id);
 state = state.copyWith(categoryIds: next);
 }

 void setCity(String? city) => state = city == null
  ? state.copyWith(clearCity: true)
  : state.copyWith(city: city);

 void toggleExpress() => state = state.copyWith(expressOnly: !state.expressOnly);

 void setMinRating(double r) => state = state.copyWith(minRating: r);

 void setPriceRange(double min, double max) =>
  state = state.copyWith(priceMin: min, priceMax: max);

 void setSort(SearchSort sort) => state = state.copyWith(sort: sort);

 void reset() => state = const SearchFilters();
}

final searchFiltersProvider =
 NotifierProvider<SearchNotifier, SearchFilters>(SearchNotifier.new);

final citiesProvider = Provider<List<String>>((ref) {
 final cities = ref.watch(catalogProvider).map((p) => p.city).toSet().toList()
 ..sort();
 return cities;
});

final searchResultsProvider = Provider<List<Product>>((ref) {
 final filters = ref.watch(searchFiltersProvider);
 var results = ref.watch(catalogProvider).toList();

 if (filters.query.trim().isNotEmpty) {
 final q = filters.query.trim().toLowerCase();
 results = results
  .where((p) =>
   p.title.toLowerCase().contains(q) ||
   p.description.toLowerCase().contains(q) ||
   p.tags.any((t) => t.toLowerCase().contains(q)))
  .toList();
 }
 if (filters.categoryIds.isNotEmpty) {
 results = results
  .where((p) => filters.categoryIds.contains(p.categoryId))
  .toList();
 }
 if (filters.city != null) {
 results = results.where((p) => p.city == filters.city).toList();
 }
 if (filters.expressOnly) {
 results = results.where((p) => p.express).toList();
 }
 if (filters.minRating > 0) {
 results = results.where((p) => p.rating >= filters.minRating).toList();
 }
 results = results
  .where((p) =>
   p.price >= filters.priceMin && p.price <= filters.priceMax)
  .toList();

 switch (filters.sort) {
 case SearchSort.prixAsc:
  results.sort((a, b) => a.price.compareTo(b.price));
 case SearchSort.prixDesc:
  results.sort((a, b) => b.price.compareTo(a.price));
 case SearchSort.note:
  results.sort((a, b) => b.rating.compareTo(a.rating));
 case SearchSort.nouveautes:
  results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
 case SearchSort.pertinence:
  results.sort((a, b) => (b.sold * b.rating).compareTo(a.sold * a.rating));
 }
 return results;
});

// ==================================================================== Panier
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

// ================================================================== Favoris
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

// ================================================================= Commandes
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

// ====================================================================== Chat
class ChatNotifier extends Notifier<List<ChatThread>> {
 @override
 List<ChatThread> build() => List.of(Mock.threads);

 static const _replies = [
 'Je vous envoie les photos tout de suite ',
 'Oui, c\'est disponible Vous voulez réserver ?',
 'Je peux vous faire -5% si vous prenez 2 pièces ',
 'Livraison possible dès demain matin ',
 'Merci pour votre confiance ',
 ];

 int _replyIndex = 0;

 ChatNotifier() {
 // Alias explicite pour la lisibilité.
 }

 void _append(String threadId, ChatMessage message) {
 try {
  final index = state.indexWhere((t) => t.id == threadId);
  if (index < 0) return;
  final thread = state[index];
  state = List.of(state)
  ..[index] = thread.copyWith(
   unread: message.fromMe ? 0 : thread.unread + 1,
   messages: [...thread.messages, message],
  );
 } catch (_) {
  // Conteneur dispose — ignore.
 }
 }

 void send(String threadId, {String text = '', MessageKind kind = MessageKind.text}) {
 _append(
  threadId, ChatMessage(text: text, fromMe: true, time: DateTime.now(), kind: kind));
 final reply = _replies[_replyIndex++ % _replies.length];
 Timer(const Duration(milliseconds: 1400), () {
  _append(threadId,
   ChatMessage(text: reply, fromMe: false, time: DateTime.now()));
 });
 }

 void markRead(String threadId) {
 final index = state.indexWhere((t) => t.id == threadId);
 if (index < 0) return;
 state = List.of(state)..[index] = state[index].copyWith(unread: 0);
 }

 /// Retourne l'id du fil existant avec ce vendeur, ou en crée un nouveau.
 String ensureThread(String sellerId) {
 for (final t in state) {
  if (t.sellerId == sellerId) return t.id;
 }
 final id = 't-${DateTime.now().millisecondsSinceEpoch}';
 state = [
  ChatThread(
  id: id,
  sellerId: sellerId,
  messages: [
   ChatMessage(
   text: 'Bonjour Je suis disponible pour répondre à vos questions.',
   fromMe: false,
   time: DateTime.now(),
   ),
  ],
  ),
  ...state,
 ];
 return id;
 }
}

final chatProvider = NotifierProvider<ChatNotifier, List<ChatThread>>(ChatNotifier.new);

final threadByIdProvider = Provider.family<ChatThread?, String>((ref, id) {
 for (final t in ref.watch(chatProvider)) {
 if (t.id == id) return t;
 }
 return null;
});

final unreadMessagesProvider = Provider<int>((ref) {
 return ref.watch(chatProvider).fold(0, (sum, t) => sum + t.unread);
});

// ================================================================== Livreur
class LivreurState {
 const LivreurState({
 this.online = true,
 this.available = const [],
 this.active,
 this.gainsToday = 0,
 this.wallet = 0,
 this.history = const [],
 });

 final bool online;
 final List<Course> available;
 final Course? active;
 final int gainsToday;
 final int wallet;
 final List<Course> history;

 LivreurState copyWith({
 bool? online,
 List<Course>? available,
 Course? active,
 bool clearActive = false,
 int? gainsToday,
 int? wallet,
 List<Course>? history,
 }) =>
  LivreurState(
  online: online ?? this.online,
  available: available ?? this.available,
  active: clearActive ? null : (active ?? this.active),
  gainsToday: gainsToday ?? this.gainsToday,
  wallet: wallet ?? this.wallet,
  history: history ?? this.history,
  );
}

class LivreurNotifier extends Notifier<LivreurState> {
 @override
 LivreurState build() => LivreurState(
  available: List.of(Mock.availableCourses),
  gainsToday: 8500,
  wallet: 32000,
  history: const [
   Course(id: 'h1', pickup: 'AgroPêche — Akanda', dropoff: 'Glass', distanceKm: 4.1, payout: 2200, etaMin: 35, vehicle: VehicleType.moto, sellerEmoji: ''),
   Course(id: 'h2', pickup: 'LibreStyle — Centre', dropoff: 'Louis', distanceKm: 2.7, payout: 1600, etaMin: 25, vehicle: VehicleType.moto, sellerEmoji: ''),
  ],
  );

 void toggleOnline() => state = state.copyWith(online: !state.online);

 void accept(String courseId) {
 final index = state.available.indexWhere((c) => c.id == courseId);
 if (index < 0) return;
 final course = state.available[index];
 state = state.copyWith(
  available: List.of(state.available)..removeAt(index),
  active: course,
 );
 }

 void refuse(String courseId) {
 state = state.copyWith(
  available: state.available.where((c) => c.id != courseId).toList(),
 );
 }

 void completeActive() {
 final course = state.active;
 if (course == null) return;
 state = state.copyWith(
  clearActive: true,
  wallet: state.wallet + course.payout,
  gainsToday: state.gainsToday + course.payout,
  history: [course, ...state.history],
 );
 }
}

final livreurProvider =
 NotifierProvider<LivreurNotifier, LivreurState>(LivreurNotifier.new);

// ================================================================== Vendeur
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
 }) { final now = DateTime.now();
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

// ============================================================ Notifications
class NotificationsNotifier extends Notifier<List<AppNotification>> {
 @override
 List<AppNotification> build() => List.of(Mock.notifications);

 void markAllRead() =>
  state = state.map((n) => n.copyWith(read: true)).toList();
}

final notificationsProvider =
 NotifierProvider<NotificationsNotifier, List<AppNotification>>(
  NotificationsNotifier.new);

final unreadNotificationsProvider = Provider<int>((ref) {
 return ref.watch(notificationsProvider).where((n) => !n.read).length;
});

// =============================================================== Adresses
class AddressesNotifier extends Notifier<List<Address>> {
 @override
 List<Address> build() => List.of(Mock.addresses);

 void add(Address address) => state = [...state, address];
}

final addressesProvider =
 NotifierProvider<AddressesNotifier, List<Address>>(AddressesNotifier.new);

// ================================================================= Portefeuille
final walletTxnsProvider = Provider<List<WalletTxn>>((ref) => Mock.walletTxns);
