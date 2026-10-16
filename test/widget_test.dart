import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okoume/app.dart';
import 'package:okoume/data/models.dart';
import 'package:okoume/data/mock_data.dart';
import 'package:okoume/data/providers.dart';

void main() {
  group('App', () {
    testWidgets(' démarre sur le splash', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: OkoumeApp()),
      );
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('SettingsNotifier', () {
    test('toggleDark change le thème', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(settingsProvider.notifier);
      expect(container.read(settingsProvider).themeMode, ThemeMode.light);

      notifier.toggleDark(true);
      expect(container.read(settingsProvider).themeMode, ThemeMode.dark);

      notifier.toggleDark(false);
      expect(container.read(settingsProvider).themeMode, ThemeMode.light);
    });

    test('seenOnboarding marque onboarding vu', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(settingsProvider).onboardingSeen, false);
      container.read(settingsProvider.notifier).seenOnboarding();
      expect(container.read(settingsProvider).onboardingSeen, true);
    });
  });

  group('AuthNotifier', () {
    test('login crée un acheteur', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(authProvider), isNull);
      container.read(authProvider.notifier).login('060123456', UserRole.acheteur);
      final user = container.read(authProvider);
      expect(user, isNotNull);
      expect(user!.role, UserRole.acheteur);
      expect(user.name, isNotEmpty);
    });

    test('logout déconnecte', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authProvider.notifier).login('060123456', UserRole.acheteur);
      expect(container.read(authProvider), isNotNull);
      container.read(authProvider.notifier).logout();
      expect(container.read(authProvider), isNull);
    });

    test('switchRole change de rôle', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(authProvider.notifier).login('060123456', UserRole.acheteur);
      expect(container.read(authProvider)!.role, UserRole.acheteur);
      container.read(authProvider.notifier).switchRole(UserRole.vendeur);
      expect(container.read(authProvider)!.role, UserRole.vendeur);
    });
  });

  group('CartNotifier', () {
    test('add ajoute un produit au panier', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(cartProvider).lines, isEmpty);
      container.read(cartProvider.notifier).add('p1');
      expect(container.read(cartProvider).lines.length, 1);
      expect(container.read(cartProvider).lines.first.productId, 'p1');
    });

    test('setQty modifie la quantité', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cartProvider.notifier).add('p1', qty: 1);
      container.read(cartProvider.notifier).setQty('p1', 3);
      expect(container.read(cartProvider).lines.first.qty, 3);
    });

    test('remove retire un produit', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cartProvider.notifier).add('p1');
      container.read(cartProvider.notifier).remove('p1');
      expect(container.read(cartProvider).lines, isEmpty);
    });

    test('clear vide le panier', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cartProvider.notifier).add('p1');
      container.read(cartProvider.notifier).add('p2');
      container.read(cartProvider.notifier).clear();
      expect(container.read(cartProvider).lines, isEmpty);
    });

    test('cartCountProvider compte les articles', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(cartCountProvider), 0);
      container.read(cartProvider.notifier).add('p1', qty: 2);
      container.read(cartProvider.notifier).add('p2', qty: 1);
      expect(container.read(cartCountProvider), 3);
    });
  });

  group('WishlistNotifier', () {
    test('toggle ajoute/retire un favori', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(wishlistProvider), contains('p9'));
      container.read(wishlistProvider.notifier).toggle('p9');
      expect(container.read(wishlistProvider), isNot(contains('p9')));
      container.read(wishlistProvider.notifier).toggle('p9');
      expect(container.read(wishlistProvider), contains('p9'));
    });
  });

  group('OrdersNotifier', () {
    test('place crée une commande', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialCount = container.read(ordersProvider).length;
      final order = container.read(ordersProvider.notifier).place(
        lines: [CartLine(productId: 'p1', qty: 1)],
        totals: CartTotals(subtotal: 10000, discount: 0, delivery: 1500, total: 11500),
        address: Mock.addresses.first,
        payment: PaymentMethod.airtel,
        mode: DeliveryMode.domicile,
        speed: DeliverySpeed.standard,
      );
      expect(container.read(ordersProvider).length, initialCount + 1);
      expect(order.status, OrderStatus.confirmee);
    });

    test('advance fait avancer une commande', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final activeOrder = container.read(ordersProvider).firstWhere((o) => o.status.isActive);
      final initialStatus = activeOrder.status;
      final updated = container.read(ordersProvider.notifier).advance(activeOrder.id);
      expect(updated, isNotNull);
      expect(updated!.status, isNot(initialStatus));
    });
  });

  group('SearchNotifier', () {
    test('setQuery modifie la recherche', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchFiltersProvider.notifier).setQuery('téléphone');
      expect(container.read(searchFiltersProvider).query, 'téléphone');
    });

    test('toggleCategory ajoute/retire une catégorie', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchFiltersProvider.notifier).toggleCategory('c1');
      expect(container.read(searchFiltersProvider).categoryIds, contains('c1'));
      container.read(searchFiltersProvider.notifier).toggleCategory('c1');
      expect(container.read(searchFiltersProvider).categoryIds, isNot(contains('c1')));
    });

    test('reset remet à zéro', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchFiltersProvider.notifier).setQuery('test');
      container.read(searchFiltersProvider.notifier).toggleCategory('c1');
      container.read(searchFiltersProvider.notifier).reset();
      expect(container.read(searchFiltersProvider).query, '');
      expect(container.read(searchFiltersProvider).categoryIds, isEmpty);
    });
  });

  group('ChatNotifier', () {
    test('send envoie un message', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final thread = container.read(chatProvider).first;
      final initialMessages = thread.messages.length;
      container.read(chatProvider.notifier).send(thread.id, text: 'Bonjour');
      final updated = container.read(chatProvider).firstWhere((t) => t.id == thread.id);
      expect(updated.messages.length, initialMessages + 1);
    });

    test('markRead remet les non-lus à zéro', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final thread = container.read(chatProvider).first;
      container.read(chatProvider.notifier).markRead(thread.id);
      final updated = container.read(chatProvider).firstWhere((t) => t.id == thread.id);
      expect(updated.unread, 0);
    });
  });

  group('NotificationsNotifier', () {
    test('markAllRead tout marque lu', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(notificationsProvider.notifier).markAllRead();
      expect(container.read(unreadNotificationsProvider), 0);
    });
  });

  group('AddressesNotifier', () {
    test('add ajoute une adresse', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialCount = container.read(addressesProvider).length;
      container.read(addressesProvider.notifier).add(Address(
        id: 'addr-test',
        label: 'Bureau',
        details: 'Libreville, Centre-ville',
        city: 'Libreville',
      ));
      expect(container.read(addressesProvider).length, initialCount + 1);
    });
  });
}
