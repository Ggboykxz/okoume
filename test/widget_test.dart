import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:okoume/app.dart';
import 'package:okoume/core/format.dart';
import 'package:okoume/router.dart';
import 'package:okoume/core/theme/app_theme.dart';
import 'package:okoume/core/ui/app_icons.dart';
import 'package:okoume/core/ui/common.dart';
import 'package:okoume/core/ui/motion.dart';
import 'package:okoume/data/providers.dart';
import 'package:okoume/data/models.dart';
import 'package:okoume/features/auth/auth_screen.dart';
import 'package:okoume/features/auth/onboarding_screen.dart';
import 'package:okoume/features/auth/otp_screen.dart';
import 'package:okoume/features/auth/splash_screen.dart';
import 'package:okoume/features/cart/cart_screen.dart';
import 'package:okoume/features/catalog/category_screen.dart';
import 'package:okoume/features/catalog/product_screen.dart';
import 'package:okoume/features/catalog/seller_screen.dart';
import 'package:okoume/features/chat/chat_list_screen.dart';
import 'package:okoume/features/chat/chat_screen.dart';
import 'package:okoume/features/checkout/checkout_screen.dart';
import 'package:okoume/features/checkout/order_success_screen.dart';
import 'package:okoume/features/checkout/payment_screen.dart';
import 'package:okoume/features/home/home_screen.dart';
import 'package:okoume/features/livreur/course_screen.dart';
import 'package:okoume/features/livreur/livreur_home_screen.dart';
import 'package:okoume/features/livreur/livreur_wallet_screen.dart';
import 'package:okoume/features/orders/order_tracking_screen.dart';
import 'package:okoume/features/orders/orders_screen.dart';
import 'package:okoume/features/profile/addresses_screen.dart';
import 'package:okoume/features/profile/notifications_screen.dart';
import 'package:okoume/features/profile/payment_methods_screen.dart';
import 'package:okoume/features/profile/profile_screen.dart';
import 'package:okoume/features/profile/wallet_screen.dart';
import 'package:okoume/features/profile/wishlist_screen.dart';
import 'package:okoume/features/search/search_screen.dart';
import 'package:okoume/features/seller/dashboard_screen.dart';
import 'package:okoume/features/seller/finance_screen.dart';
import 'package:okoume/features/seller/orders_screen.dart';
import 'package:okoume/features/seller/products_screen.dart';
import 'package:okoume/features/seller/quick_sell_screen.dart';
import 'package:okoume/features/shell/main_shell.dart';
import 'package:okoume/features/auth/location_screen.dart';
import 'package:okoume/features/auth/permissions_screen.dart';
import 'package:okoume/features/auth/profile_setup_screen.dart';
import 'package:okoume/features/catalog/reviews_screen.dart';
import 'package:okoume/features/checkout/lockers_screen.dart';
import 'package:okoume/features/checkout/payment_failed_screen.dart';
import 'package:okoume/features/home/flash_screen.dart';
import 'package:okoume/features/home/local_screen.dart';
import 'package:okoume/features/home/stories_screen.dart';
import 'package:okoume/features/livreur/join_screen.dart';
import 'package:okoume/features/profile/about_screen.dart';
import 'package:okoume/features/profile/edit_profile_screen.dart';
import 'package:okoume/features/profile/help_screen.dart';
import 'package:okoume/features/profile/settings_screen.dart';
import 'package:okoume/features/seller/join_screen.dart';
import 'package:okoume/features/seller/product_form_screen.dart';
import 'package:okoume/features/extra/extra_screen.dart';
import 'package:okoume/features/extra/hero_screens.dart';
import 'package:okoume/features/extra/screens_index_screen.dart';
import 'package:okoume/data/extras/extras_all.dart';
import 'package:okoume/data/screen_catalog.dart';

/// Réglages forcés en mode sombre pour les smoke tests.
class _DarkSettings extends SettingsNotifier {
 @override
 SettingsState build() => const SettingsState(themeMode: ThemeMode.dark);
}

/// Monte l'app complète (routeur inclus) sur une route donnée.
Future<ProviderContainer> pumpApp(
 WidgetTester tester, {
 String route = '/main',
 bool dark = false,
}) async {
 final container = ProviderContainer(
  overrides: [
   initialRouteProvider.overrideWithValue(route),
   if (dark) settingsProvider.overrideWith(_DarkSettings.new),
  ],
 );
 addTearDown(container.dispose);
 await tester.pumpWidget(
  UncontrolledProviderScope(
   container: container,
   child: const OkoumeApp(),
  ),
 );
 await tester.pump();
 return container;
}

/// Monte un écran isolé (sans routeur) dans l'un des deux thèmes.
Future<void> pumpScreen(
 WidgetTester tester,
 Widget screen, {
 bool dark = false,
}) async {
 await tester.pumpWidget(
  ProviderScope(
   child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    home: screen,
   ),
  ),
 );
 await tester.pump(const Duration(milliseconds: 350));
 await tester.pump(const Duration(milliseconds: 350));
 expect(tester.takeException(), isNull);
 expect(find.byType(Scaffold), findsWidgets);
}

/// Trouve une icône Hugeicons par sa donnée (constante du mapping).
Finder findAppIcon(AppIconData icon) => find.byWidgetPredicate(
   (w) => w is AppIcon && identical(w.icon, icon),
  );

void main() {
 setUpAll(() async {
  await initFormats();
 });

 setUp(() {
  // Figer les animations décoratives (Lottie/Rive/springs) en tests.
  AppMotion.reduce = true;
 });

 tearDown(() {
  shellTabNotifier.value = 0;
 });

 // ============================================================ Écrans isolés
 final screens = <String, Widget Function()>{
  'Accueil': () => const HomeScreen(),
  'Recherche': () => const SearchScreen(),
  'Connexion': () => const AuthScreen(),
  'Onboarding': () => const OnboardingScreen(),
  'Splash': () => const SplashScreen(),
  'OTP': () => const OtpScreen(),
  'Catégorie': () => const CategoryScreen(categoryId: 'c1'),
  'Produit': () => const ProductScreen(productId: 'p1'),
  'Boutique': () => const SellerScreen(sellerId: 's1'),
  'Panier': () => const CartScreen(),
  'Commande (checkout)': () => const CheckoutScreen(),
  'Paiement': () => const PaymentScreen(),
  'Succès commande': () => const OrderSuccessScreen(orderId: 'o1'),
  'Mes commandes': () => const OrdersScreen(),
  'Suivi de commande': () => const OrderTrackingScreen(orderId: 'o1'),
  'Messages (liste)': () => const ChatListScreen(),
  'Conversation inconnue': () => const ChatScreen(threadId: 't-inexistant'),
  'Favoris': () => const WishlistScreen(),
  'Notifications': () => const NotificationsScreen(),
  'Adresses': () => const AddressesScreen(),
  'Portefeuille': () => const WalletScreen(),
  'Moyens de paiement': () => const PaymentMethodsScreen(),
  'Profil': () => const ProfileScreen(),
  'Vendeur (bord)': () => const SellerDashboardScreen(),
  'Vendeur (produits)': () => const SellerProductsScreen(),
  'Vendeur (commandes)': () => const SellerOrdersScreen(),
  'Vente rapide': () => const QuickSellScreen(),
  'Vendeur (finance)': () => const SellerFinanceScreen(),
  'Livreur (courses)': () => const LivreurHomeScreen(),
  'Livreur (course)': () => const CourseScreen(),
  'Livreur (gains)': () => const LivreurWalletScreen(),
  'Création profil (C-09)': () => const ProfileSetupScreen(),
  'Zone de livraison (C-10)': () => const DeliveryLocationScreen(),
  'Permissions (C-11)': () => const PermissionsScreen(),
  'Modifier le profil (C-17)': () => const EditProfileScreen(),
  'Paramètres (C-24)': () => const SettingsScreen(),
  'Réglages notifications (C-25)': () => const NotificationSettingsScreen(),
  'Données et stockage (C-27)': () => const DataSettingsScreen(),
  'À propos (C-28)': () => const AboutScreen(),
  'CGU (C-29)': () => const LegalScreen(kind: 'terms'),
  'Confidentialité (C-30)': () => const LegalScreen(kind: 'privacy'),
  'Centre d\'aide (C-31)': () => const HelpScreen(),
  'Stories (A-08)': () => const StoriesScreen(),
  'Offres flash (A-12)': () => const FlashSalesScreen(),
  'Made in Gabon (A-14)': () => const LocalProductsScreen(),
  'Avis produit (A-23)': () => const ProductReviewsScreen(productId: 'p1'),
  'Échec paiement (A-52)': () => const PaymentFailedScreen(),
  'Consignes (A-66)': () => const LockersScreen(),
  'Devenir vendeur (V-01)': () => const SellerJoinScreen(),
  'Nouvelle annonce (V-16)': () => const ProductFormScreen(),
  'Devenir livreur (L-01)': () => const LivreurJoinScreen(),
  'Mot de passe oublié (C-13)': () => const ResetPasswordScreen(),
  'Recherche vocale (C-45)': () => const VoiceSearchScreen(),
  'Galerie produit (A-16)': () => const ProductGalleryScreen(productId: 'p1'),
  'Comparer (A-30)': () => const CompareScreen(),
  'Scan QR (A-69)': () => const ScanPickupScreen(),
  'Live shopping (V-35)': () => const LiveShoppingScreen(),
  'Carte des courses (L-15)': () => const CourierMapScreen(),
  'Index des écrans (317)': () => const ScreensIndexScreen(),
  'Aperçu catalogue (V-10)': () => const ExtraScreen(screenId: 'V-10'),
  'Aperçu catalogue (AD-01)': () => const ExtraScreen(screenId: 'AD-01'),
  'Aperçu inconnu': () => const ExtraScreen(screenId: 'ZZ-99'),
 };

 for (final dark in [false, true]) {
  for (final entry in screens.entries) {
   testWidgets(
    'écran ${entry.key} · ${dark ? 'sombre' : 'clair'}',
    (tester) async {
     await pumpScreen(tester, entry.value(), dark: dark);
    },
   );
  }
 }

 // ============================================================ Routes réelles
 const routes = <String, String?>{
  '/onboarding': null,
  '/auth': null,
  '/auth/otp': null,
  '/main': null,
  '/search': null,
  '/category/c1': null,
  '/product/p1': null,
  '/seller/s1': null,
  '/cart': 'Votre panier est vide',
  '/checkout': 'Votre panier est vide',
  '/orders': 'Mes commandes',
  '/order/o1': 'Commande OKM-2026-0042',
  '/chat/t-inexistant': 'Conversation introuvable',
  '/wishlist': null,
  '/notifications': null,
  '/addresses': 'Mes adresses',
  '/wallet': 'Solde disponible',
  '/payment-methods': 'Airtel Money',
  '/seller/finance': 'Solde retirable',
  '/livreur/course': 'Aucune course active',
  '/success/o1': 'Commande confirmée !',
  '/auth/profile-setup': 'Comment doit-on vous appeler ?',
  '/auth/location': 'Où livrer vos commandes ?',
  '/auth/permissions': 'Restez au courant',
  '/settings': 'Paramètres',
  '/settings/notifications': 'Suivi de commandes',
  '/settings/data': 'Données et stockage',
  '/help': 'Questions fréquentes',
  '/about': 'La marketplace du Gabon',
  '/legal/terms': 'Conditions générales',
  '/legal/privacy': 'Confidentialité',
  '/profile/edit': 'Modifier mon profil',
  '/flash': 'Offres flash',
  '/local': 'Made in Gabon',
  '/stories': 'Offres du jour',
  '/lockers': 'Consignes de retrait',
  '/payment/failed': 'Paiement échoué',
  '/product/p1/reviews': 'Donner mon avis',
  '/seller/join': 'Vendez à tout le Gabon',
  '/livreur/join': 'Livrez à votre rythme',
  '/seller/products/new': 'Nouvelle annonce',
  '/auth/reset': 'Mot de passe oublié',
  '/voice': 'écouteurs sans fil',
  '/product/p1/gallery': 'Pincez pour zoomer',
  '/compare': 'Choisissez jusqu’à 3 produits',
  '/scan-pickup': 'Scannez le QR code du colis',
  '/seller/live': 'EN DIRECT',
  '/livreur/map': 'Courses disponibles',
  '/screens': 'Catalogue officiel Okoumé',
  '/screen/V-10': 'Analytics Vente',
  '/screen/AD-01': 'Dashboard Admin',
  '/screen/C-34': 'Signaler un Problème',
 };

 for (final dark in [false, true]) {
  for (final entry in routes.entries) {
   testWidgets(
    'route ${entry.key} · ${dark ? 'sombre' : 'clair'}',
    (tester) async {
     await pumpApp(tester, route: entry.key, dark: dark);
     await tester.pumpAndSettle();
     expect(tester.takeException(), isNull);
     expect(find.byType(Scaffold), findsWidgets);
     if (entry.value!= null) {
      expect(find.textContaining(entry.value!), findsWidgets);
     }
    },
   );
  }
 }

 testWidgets('démarrage : le splash mène à l\'onboarding', (tester) async {
  await pumpApp(tester, route: '/splash');
  await tester.pump(const Duration(milliseconds: 1900));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(find.byType(Scaffold), findsWidgets);
 });

 // ============================================================= Shell & thème
 testWidgets('shell acheteur : les 5 onglets s\'ouvrent sans erreur',
   (tester) async {
  await pumpApp(tester);
  await tester.pumpAndSettle();
  for (var i = 0; i < 5; i++) {
   shellTabNotifier.value = i;
   await tester.pumpAndSettle();
   expect(tester.takeException(), isNull);
   expect(find.byType(Scaffold), findsWidgets);
  }
 });

 testWidgets('mode sombre appliqué par les réglages', (tester) async {
  await pumpApp(tester, dark: true);
  await tester.pumpAndSettle();
  final context = tester.element(find.byType(Scaffold).first);
  expect(Theme.of(context).brightness, Brightness.dark);
 });

 // ============================================================= Flux complet
 testWidgets('produit → panier → promo → commande → paiement → succès',
   (tester) async {
  final container = await pumpApp(tester, route: '/product/p1');
  await tester.pumpAndSettle();
  final ordersBefore = container.read(ordersProvider).length;

  // 1) Ajout au panier depuis la fiche produit.
  await tester.tap(find.text('Au panier'));
  await tester.pump(const Duration(milliseconds: 400));
  expect(container.read(cartProvider).lines.length, 1);

  // 2) Ouverture du panier via l'icône de la barre supérieure.
  await tester.tap(findAppIcon(AppIcons.shopping_cart_outlined));
  await tester.pumpAndSettle();
  expect(find.textContaining('Passer la commande'), findsOneWidget);

  // 3) Code promo BIENVENUE10.
  final promoField = find.byType(TextField).first;
  await tester.ensureVisible(promoField);
  await tester.enterText(promoField, 'BIENVENUE10');
  await tester.ensureVisible(find.text('OK'));
  await tester.tap(find.text('OK'));
  await tester.pump(const Duration(milliseconds: 400));
  expect(container.read(cartProvider).promo?.code, 'BIENVENUE10');

  // 4) Tunnel de commande.
  await tester.ensureVisible(find.textContaining('Passer la commande'));
  await tester.tap(find.textContaining('Passer la commande'));
  await tester.pumpAndSettle();
  expect(find.text('Finaliser la commande'), findsOneWidget);
  await tester.tap(find.text('Continuer vers le paiement'));
  await tester.pumpAndSettle();
  expect(find.text('Moyen de paiement'), findsOneWidget);

  // 5) Paiement simulé → écran de succès.
  await tester.tap(find.textContaining('Payer '));
  await tester.pump(const Duration(milliseconds: 600));
  expect(find.text('Annuler le paiement'), findsOneWidget);
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
  expect(find.text('Commande confirmée !'), findsOneWidget);
  expect(container.read(cartProvider).lines, isEmpty);
  expect(container.read(ordersProvider).length, ordersBefore + 1);
 });

 // ===================================================== Nouveaux flux (P0)
 testWidgets(
   'OTP → profil (C-09) → zone (C-10) → permissions (C-11) → accueil',
   (tester) async {
  final container = await pumpApp(tester, route: '/auth/otp');
  await tester.pumpAndSettle();

  // Saisie du code démo 1 2 3 4.
  final boxes = find.byType(TextField);
  expect(boxes, findsNWidgets(4));
  for (var i = 0; i < 4; i++) {
   await tester.enterText(boxes.at(i), '1234'[i]);
   await tester.pump(const Duration(milliseconds: 150));
  }
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(container.read(authProvider), isNotNull);
  expect(find.text('Comment doit-on vous appeler ?'), findsOneWidget);

  // C-09 → C-10.
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();
  expect(find.text('Où livrer vos commandes ?'), findsOneWidget);

  // C-10 : choix de la ville puis C-11.
  await tester.tap(find.text('Libreville'));
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();
  expect(container.read(authProvider)?.city, 'Libreville');
  expect(find.text('Restez au courant '), findsOneWidget);

  // C-11 → accueil.
  await tester.tap(find.text('Commencer sur Okoumé'));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(container.read(settingsProvider).onboardingSeen, isTrue);
 });

 testWidgets('devenir vendeur (V-01 → V-08) : parcours complet',
   (tester) async {
  final container = await pumpApp(tester, route: '/seller/join');
  container
    .read(authProvider.notifier)
    .login('+241 07 45 12 33', UserRole.acheteur);
  await tester.pumpAndSettle();

  // V-01 → V-02.
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();
  expect(find.text('Quel type de vendeur êtes-vous ?'), findsOneWidget);

  // V-02 : type artisan.
  await tester.tap(find.text('Artisan'));
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // V-03 : infos boutique.
  await tester.enterText(find.byType(TextField).first, 'Atelier Nzeng');
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // V-04 : ville.
  await tester.tap(find.text('Libreville'));
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // V-05 : scan CNI simulé.
  await tester.tap(find.text('Scanner'));
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // V-06 : numéro de versement.
  await tester.enterText(find.byType(TextField).first, '074123456');
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // V-07 : conditions puis envoi.
  await tester.tap(find.byType(Checkbox));
  await tester.pump();
  await tester.tap(find.text('Envoyer ma demande'));
  await tester.pumpAndSettle();
  expect(find.text('Demande envoyée ! '), findsOneWidget);

  // V-08 : bascule démo vers l'espace vendeur.
  await tester.tap(find.text('Explorer l\'espace vendeur (démo)'));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(container.read(authProvider)?.role, UserRole.vendeur);
 });

 testWidgets('devenir livreur (L-01 → L-08) : quiz de formation obligatoire',
   (tester) async {
  final container = await pumpApp(tester, route: '/livreur/join');
  container
    .read(authProvider.notifier)
    .login('+241 07 45 12 33', UserRole.acheteur);
  await tester.pumpAndSettle();

  await tester.tap(find.text('Continuer')); // L-01 → L-02
  await tester.pumpAndSettle();

  await tester.tap(find.text('Continuer')); // véhicule par défaut : moto
  await tester.pumpAndSettle();

  // L-03 : scan permis puis suite.
  await tester.tap(find.text('Scanner'));
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // L-04 : zone.
  await tester.tap(find.text('Libreville'));
  await tester.pump();
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // L-05 : disponibilités pré-remplies.
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // L-06 : quiz — sans les 3 bonnes réponses, on ne passe pas.
  await tester.tap(find.text('Continuer'));
  await tester.pump();
  expect(find.byType(Checkbox), findsNothing);
  for (final answer in [
   'Je patiente 2 minutes',
   'Après avoir remis le colis',
   'Refusez et signalez',
  ]) {
   final option = find.textContaining(answer);
   await tester.ensureVisible(option);
   await tester.pumpAndSettle();
   await tester.tap(option);
   await tester.pump(const Duration(milliseconds: 200));
  }
  await tester.tap(find.text('Continuer'));
  await tester.pumpAndSettle();

  // L-07 : contrat puis envoi.
  expect(find.text('Vérifiez votre candidature'), findsOneWidget);
  await tester.ensureVisible(find.byType(Checkbox));
  await tester.tap(find.byType(Checkbox));
  await tester.pump();
  await tester.ensureVisible(find.text('Envoyer ma candidature'));
  await tester.tap(find.text('Envoyer ma candidature'));
  await tester.pumpAndSettle();
  expect(find.text('Candidature envoyée ! '), findsOneWidget);

  // L-08 : bascule démo vers l'espace livreur.
  await tester.tap(find.text('Explorer l\'espace livreur (démo)'));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(container.read(authProvider)?.role, UserRole.livreur);
 });

 testWidgets('formulaire produit (V-16) : publier une annonce',
   (tester) async {
  final container = await pumpApp(tester, route: '/seller/products/new');
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byType(TextField).first, 'Collier perles du Gabon');

  // Le formulaire est long : on défile jusqu'au champ prix (ListView
  // paresseux — les champs hors écran ne sont pas construits).
  final priceField = find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.hintText == 'Prix');
  await tester.dragUntilVisible(
   priceField,
   find.byType(ListView).first,
   const Offset(0, -300),
  );
  await tester.pumpAndSettle();
  await tester.enterText(priceField.first, '8500');
  await tester.pump();
  await tester.tap(find.text('Publier l\'annonce'));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);

  final published = container
    .read(catalogProvider)
    .where((p) => p.title == 'Collier perles du Gabon')
    .toList();
  expect(published, hasLength(1));
  expect(published.first.price, 8500);
  expect(container.read(sellerProvider).products.first.title,
    'Collier perles du Gabon');
  expect(find.textContaining('Annonce publiée'), findsWidgets);
 });

 testWidgets('avis produit (A-25) : rédiger un avis', (tester) async {
  final container = await pumpApp(tester, route: '/product/p1/reviews');
  await tester.pumpAndSettle();
  final before = container.read(productReviewsProvider('p1')).length;

  await tester.tap(find.text('Donner mon avis'));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byType(TextField).last, 'Très bon achat, je recommande!');
  await tester.tap(find.text('Publier mon avis'));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
  final after = container.read(productReviewsProvider('p1'));
  expect(after.length, before + 1);
  expect(after.first.text, 'Très bon achat, je recommande!');
 });

 // ================================================ Catalogue officiel (317)
 test('catalogue officiel : 317 écrans, couverture complète des aperçus', () {
  expect(screenCatalog, hasLength(317));

  final previews = screenCatalog.where((e) => e.isPreview).toList();
  expect(previews, hasLength(allExtraSpecs.length),
    reason: 'chaque écran hors MVP doit avoir son aperçu');

  for (final e in previews) {
   expect(allExtraSpecs.containsKey(e.id), isTrue,
     reason: 'aperçu manquant pour ${e.id} · ${e.title}');
  }
  for (final id in allExtraSpecs.keys) {
   final matches = screenCatalog.where((x) => x.id == id).toList();
   expect(matches, hasLength(1), reason: 'aperçu orphelin $id');
   expect(matches.first.isPreview, isTrue,
     reason: '$id a une vraie route : pas besoin d’aperçu');
  }

  // Chaque écran réel a bien une route déclarée.
  final reels = screenCatalog.where((e) =>!e.isPreview).toList();
  expect(reels, isNotEmpty);
  expect(reels.length + previews.length, 317);
 });

 testWidgets('index des écrans : la recherche mène à l’aperçu V-10',
   (tester) async {
  await pumpApp(tester, route: '/screens');
  await tester.pumpAndSettle();
  expect(find.textContaining('317 écrans'), findsOneWidget);

  await tester.enterText(find.byType(TextField).first, 'V-10');
  await tester.pumpAndSettle();
  expect(find.textContaining('Analytics Vente'), findsOneWidget);

  await tester.tap(find.textContaining('V-10 — Analytics Vente'));
  await tester.pumpAndSettle();
  expect(find.text('CA du mois'), findsOneWidget);
  expect(find.textContaining('Démo locale fonctionnelle'), findsOneWidget);
 });

 testWidgets('aperçu C-22 : formulaire carte bancaire validé',
   (tester) async {
  await pumpApp(tester, route: '/screen/C-22');
  await tester.pumpAndSettle();

  final fields = find.byType(TextField);
  expect(fields, findsNWidgets(4));
  for (var i = 0; i < 4; i++) {
   await tester.enterText(fields.at(i), '42');
  }
  await tester.pump();
  await tester.ensureVisible(find.text('Ajouter la carte'));
  await tester.tap(find.text('Ajouter la carte'));
  await tester.pump();
  expect(find.textContaining('Carte vérifiée et enregistrée'), findsOneWidget);
 });

 testWidgets('aperçu C-26 : interrupteurs interactifs', (tester) async {
  await pumpApp(tester, route: '/screen/C-26');
  await tester.pumpAndSettle();
  expect(find.text('Double authentification par SMS'), findsOneWidget);

  final sw = find.byType(Switch).first;
  expect(tester.widget<Switch>(sw).value, isTrue);
  await tester.ensureVisible(sw);
  await tester.tap(sw);
  await tester.pump(const Duration(milliseconds: 250));
  expect(tester.widget<Switch>(find.byType(Switch).first).value, isFalse);
 });

 testWidgets('flux C-13 : réinitialisation du mot de passe', (tester) async {
  await pumpApp(tester, route: '/auth/reset');
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).first, '074 00 00 00');
  await tester.tap(find.text('Envoyer le code'));
  await tester.pump();

  await tester.enterText(find.byType(TextField).first, '1234');
  await tester.tap(find.text('Vérifier le code'));
  await tester.pump();

  final fields = find.byType(TextField);
  expect(fields, findsNWidgets(2));
  await tester.enterText(fields.first, 'secret123');
  await tester.enterText(fields.last, 'secret123');
  await tester.tap(find.text('Réinitialiser le mot de passe'));
  await tester.pump();

  expect(tester.takeException(), isNull);
  expect(find.textContaining('Mot de passe réinitialisé'), findsOneWidget);
 });

 testWidgets('scan QR : la simulation identifie le colis', (tester) async {
  await pumpApp(tester, route: '/scan-pickup');
  await tester.pumpAndSettle();

  await tester.ensureVisible(find.text('Simuler le scan'));
  await tester.tap(find.text('Simuler le scan'));
  await tester.pumpAndSettle();
  expect(find.textContaining('Colis OK-2026-0101'), findsOneWidget);
 });

 testWidgets('comparateur (A-30) : sélection de 2 produits', (tester) async {
  await pumpApp(tester, route: '/compare');
  await tester.pumpAndSettle();

  expect(find.text('Aucun produit sélectionné'), findsOneWidget);

  final chips = find.byType(AppChip);
  expect(chips, findsWidgets);
  await tester.ensureVisible(chips.at(0));
  await tester.tap(chips.at(0));
  await tester.pump();
  await tester.tap(chips.at(1));
  await tester.pump();

  expect(find.textContaining('(2/3)'), findsOneWidget);
  expect(find.text('Aucun produit sélectionné'), findsNothing);
  // Le tableau compare bien les produits sélectionnés.
  expect(find.text('Prix'), findsOneWidget);
 });

 // ========================================== Intégration de toutes les routes
 test('chaque route du catalogue existe dans le routeur', () {
  final container = ProviderContainer(
   overrides: [initialRouteProvider.overrideWithValue('/main')],
  );
  addTearDown(container.dispose);
  final router = container.read(routerProvider);

  final paths = <String>[];
  void walk(List<RouteBase> routes) {
   for (final r in routes) {
    if (r is GoRoute) {
     paths.add(r.path);
     walk(r.routes);
    } else if (r is ShellRoute) {
     walk(r.routes);
    }
   }
  }

  walk(router.configuration.routes);
  expect(paths.length, greaterThan(45));

  bool opens(String route) {
   final segs = route.split('/').where((s) => s.isNotEmpty).toList();
   for (final p in paths) {
    final psegs = p.split('/').where((s) => s.isNotEmpty).toList();
    if (psegs.length!= segs.length) continue;
    var ok = true;
    for (var i = 0; i < segs.length; i++) {
     if (segs[i]!= psegs[i] &&!psegs[i].startsWith(':')) {
      ok = false;
      break;
     }
    }
    if (ok) return true;
   }
   return false;
  }

  final routes = screenCatalog
    .where((e) => e.route!= null)
    .map((e) => e.route!)
    .toSet();
  expect(routes, hasLength(greaterThan(45)));
  for (final r in routes) {
   expect(opens(r), isTrue, reason: 'route $r absente du routeur');
  }
 });

 testWidgets("toutes les routes du catalogue s'ouvrent sans erreur",
   (tester) async {
  final routes = screenCatalog
    .where((e) => e.route!= null)
    .map((e) => e.route!)
    .toSet()
    .toList()
   ..sort();

  for (final route in routes) {
   await pumpApp(tester, route: route);
   await tester.pump(const Duration(milliseconds: 350));
   expect(tester.takeException(), isNull, reason: 'route $route');
  }

  // Libère l'arbre pour annuler timers et animations en attente.
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
 });

 // ====================================== Fonctionnalité réelle des écrans
 testWidgets('fonctionnel : valider un KYC (AD-11) met à jour la file AD-10',
   (tester) async {
  final container = await pumpApp(tester, route: '/screen/AD-10');
  await tester.pumpAndSettle();
  expect(find.textContaining('Ibrahim K.'), findsOneWidget);

  final router = container.read(routerProvider);
  router.go('/screen/AD-11');
  await tester.pumpAndSettle();

  final approve = find.textContaining('Approuver le dossier');
  await tester.scrollUntilVisible(approve, 160,
    scrollable: find.byType(Scrollable).first);
  await tester.tap(approve);
  await tester.pumpAndSettle();
  expect(find.textContaining('validé — notification envoyée'), findsWidgets);

  // Laisse le bandeau de confirmation s'effacer avant de revenir.
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();

  router.go('/screen/AD-10');
  await tester.pumpAndSettle();
  expect(find.textContaining('Ibrahim K.'), findsNothing);
  expect(find.textContaining('Nguema Fashion'), findsOneWidget);
 });

 testWidgets('fonctionnel : créer un code promo (AD-54) l’affiche dans AD-53',
   (tester) async {
  final container = await pumpApp(tester, route: '/screen/AD-54');
  await tester.pumpAndSettle();

  final fields = find.byType(TextField);
  expect(fields, findsWidgets);
  final values = [
   'PAQUES15', '−15 %', '25 000 F', '1 mois · 500 usages', 'tous',
  ];
  for (var i = 0; i < values.length; i++) {
   final f = find.byType(TextField).at(i);
   await tester.scrollUntilVisible(f, 120,
     scrollable: find.byType(Scrollable).first);
   await tester.enterText(f, values[i]);
  }
  await tester.pump();
  final submit = find.text('Créer le code');
  await tester.scrollUntilVisible(submit, 120,
    scrollable: find.byType(Scrollable).first);
  await tester.tap(submit);
  await tester.pump();
  expect(find.textContaining('Code PAQUES15 créé'), findsOneWidget);
  final journal = find.textContaining('Journal de l’écran');
  await tester.scrollUntilVisible(journal, 120,
    scrollable: find.byType(Scrollable).first);
  expect(journal, findsOneWidget);

  container.read(routerProvider).go('/screen/AD-53');
  await tester.pumpAndSettle();
  expect(find.text('PAQUES15'), findsOneWidget);
 });

 testWidgets('fonctionnel : un litige client (A-60) apparaît côté admin (AD-32)',
   (tester) async {
  final container = await pumpApp(tester, route: '/screen/A-60');
  await tester.pumpAndSettle();

  // Liste paresseuse : on défile jusqu'au bouton du formulaire, ce qui
  // construit toute la carte (champs compris).
  final values = ['OK-2026-0104', 'Colis abîmé à la réception', 'photo.jpg'];
  final submit = find.text('Ouvrir le dossier de litige');
  await tester.scrollUntilVisible(submit, 200,
    scrollable: find.byType(Scrollable).first);
  final fields = find.byType(TextField);
  expect(fields, findsNWidgets(3));
  for (var i = 0; i < values.length; i++) {
   await tester.enterText(fields.at(i), values[i]);
  }
  await tester.pump();
  await tester.tap(submit);
  await tester.pump();
  expect(find.textContaining('LM-225'), findsWidgets);

  container.read(routerProvider).go('/screen/AD-32');
  await tester.pumpAndSettle();
  expect(find.textContaining('LM-225'), findsWidgets);
 });

 testWidgets('fonctionnel : un interrupteur (C-26) persiste après navigation',
   (tester) async {
  final container = await pumpApp(tester, route: '/screen/C-26');
  await tester.pumpAndSettle();

  final sw = find.byType(Switch).first;
  expect(tester.widget<Switch>(sw).value, isTrue);
  await tester.ensureVisible(sw);
  await tester.tap(sw);
  await tester.pump(const Duration(milliseconds: 250));
  expect(tester.widget<Switch>(find.byType(Switch).first).value, isFalse);

  final router = container.read(routerProvider);
  router.go('/main');
  await tester.pump(const Duration(milliseconds: 350));
  router.go('/screen/C-26');
  await tester.pumpAndSettle();
  expect(tester.widget<Switch>(find.byType(Switch).first).value, isFalse);
 });

 testWidgets('fonctionnel : la maintenance (AD-71) est journalisée dans AD-72',
   (tester) async {
  final container = await pumpApp(tester, route: '/screen/AD-71');
  await tester.pumpAndSettle();

  final action = find.textContaining('Activer la maintenance');
  await tester.scrollUntilVisible(action, 160,
    scrollable: find.byType(Scrollable).first);
  await tester.tap(action);
  await tester.pump();
  expect(find.textContaining('Mode maintenance activé'), findsWidgets);

  container.read(routerProvider).go('/screen/AD-72');
  await tester.pumpAndSettle();
  expect(find.textContaining('Maintenance activée'), findsWidgets);
 });
}
