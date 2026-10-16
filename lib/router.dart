import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/ui/common.dart';
import 'data/models.dart';
import 'data/providers.dart';
import 'features/auth/auth_screen.dart';
import 'features/auth/location_screen.dart';
import 'features/auth/onboarding_screen.dart';
import 'features/auth/otp_screen.dart';
import 'features/auth/permissions_screen.dart';
import 'features/auth/profile_setup_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/catalog/category_screen.dart';
import 'features/catalog/product_screen.dart';
import 'features/catalog/reviews_screen.dart';
import 'features/catalog/seller_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/checkout/checkout_screen.dart';
import 'features/extra/extra_screen.dart';
import 'features/extra/hero_screens.dart';
import 'features/extra/screens_index_screen.dart';
import 'features/checkout/lockers_screen.dart';
import 'features/checkout/order_success_screen.dart';
import 'features/checkout/payment_failed_screen.dart';
import 'features/checkout/payment_screen.dart';
import 'features/home/flash_screen.dart';
import 'features/home/local_screen.dart';
import 'features/home/stories_screen.dart';
import 'features/livreur/course_screen.dart';
import 'features/livreur/join_screen.dart';
import 'features/orders/order_tracking_screen.dart';
import 'features/orders/orders_screen.dart';
import 'features/profile/about_screen.dart';
import 'features/profile/addresses_screen.dart';
import 'features/profile/edit_profile_screen.dart';
import 'features/profile/help_screen.dart';
import 'features/profile/notifications_screen.dart';
import 'features/profile/payment_methods_screen.dart';
import 'features/profile/settings_screen.dart';
import 'features/profile/wallet_screen.dart';
import 'features/profile/wishlist_screen.dart';
import 'features/seller/finance_screen.dart';
import 'features/seller/join_screen.dart';
import 'features/seller/product_form_screen.dart';
import 'features/search/search_screen.dart';
import 'features/shell/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
 final initial = ref.read(initialRouteProvider);
 return GoRouter(
  initialLocation: initial,
  routes: [
   // ------------------------------------------------------------- Entrée
   GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
   GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
   GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
   GoRoute(
    path: '/auth/otp',
    builder: (context, state) {
     final extra = state.extra;
     if (extra is (String, UserRole)) {
      return OtpScreen(phone: extra.$1, role: extra.$2);
     }
     return const OtpScreen();
    },
   ),
   GoRoute(path: '/main', builder: (_, _) => const MainShell()),
   // Première connexion : profil (C-09) → zone (C-10) → permissions (C-11).
   GoRoute(
     path: '/auth/profile-setup',
     builder: (_, _) => const ProfileSetupScreen()),
   GoRoute(
     path: '/auth/location',
     builder: (_, _) => const DeliveryLocationScreen()),
   GoRoute(
     path: '/auth/permissions',
     builder: (_, _) => const PermissionsScreen()),
   // C-13 · Mot de passe oublié (réinitialisation par SMS).
   GoRoute(
     path: '/auth/reset', builder: (_, _) => const ResetPasswordScreen()),

   // ---------------------------------------------------------- Recherche
   GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
   // C-45 · Recherche vocale.
   GoRoute(path: '/voice', builder: (_, _) => const VoiceSearchScreen()),

   // ---------------------------------------------------------- Catalogue
   GoRoute(
    path: '/category/:id',
    builder: (context, state) =>
      CategoryScreen(categoryId: state.pathParameters['id']!),
   ),
   GoRoute(
    path: '/product/:id',
    builder: (context, state) =>
      ProductScreen(productId: state.pathParameters['id']!),
   ),
   // A-23 · Tous les avis d'un produit (+ A-25 : écrire un avis).
   GoRoute(
    path: '/product/:id/reviews',
    builder: (context, state) =>
      ProductReviewsScreen(productId: state.pathParameters['id']!),
   ),
   // A-16/A-18 · Galerie photos plein écran (+ zoom).
   GoRoute(
    path: '/product/:id/gallery',
    builder: (context, state) =>
      ProductGalleryScreen(productId: state.pathParameters['id']!),
   ),
   // A-30 · Comparateur de produits.
   GoRoute(path: '/compare', builder: (_, _) => const CompareScreen()),
   // A-69 / L-21 · Scan QR (retrait colis / prise en charge).
   GoRoute(
     path: '/scan-pickup', builder: (_, _) => const ScanPickupScreen()),
   // A-08 · Stories Découverte en plein écran.
   GoRoute(
    path: '/stories',
    builder: (context, state) => StoriesScreen(
     startIndex: state.extra is int ? state.extra as int : 0,
    ),
   ),
   // A-12 · Offres flash.
   GoRoute(path: '/flash', builder: (_, _) => const FlashSalesScreen()),
   // A-14 · Made in Gabon.
   GoRoute(path: '/local', builder: (_, _) => const LocalProductsScreen()),
   // Routes littérales AVANT « /seller/:id » pour ne pas être captées.
   GoRoute(
    path: '/seller/finance',
    builder: (_, _) => const SellerFinanceScreen(),
   ),
   // V-01 → V-08 · Devenir vendeur.
   GoRoute(
     path: '/seller/join', builder: (_, _) => const SellerJoinScreen()),
   // V-35 · Live shopping (avant « /seller/:id »).
   GoRoute(
     path: '/seller/live', builder: (_, _) => const LiveShoppingScreen()),
   // V-16/V-17/V-22 · Formulaire produit (création / édition).
   GoRoute(
    path: '/seller/products/new',
    builder: (_, _) => const ProductFormScreen(),
   ),
   GoRoute(
    path: '/seller/products/:id/edit',
    builder: (context, state) =>
      ProductFormScreen(productId: state.pathParameters['id']),
   ),
   GoRoute(
    path: '/seller/:id',
    builder: (context, state) =>
      SellerScreen(sellerId: state.pathParameters['id']!),
   ),

   // --------------------------------------------------------- Achat
   GoRoute(path: '/cart', builder: (_, _) => const CartScreen()),
   GoRoute(path: '/checkout', builder: (_, _) => const CheckoutScreen()),
   GoRoute(
    path: '/payment',
    builder: (context, state) => PaymentScreen(
     payload: state.extra is CheckoutPayload
       ? state.extra as CheckoutPayload
       : null,
    ),
   ),
   GoRoute(
    path: '/success/:id',
    builder: (context, state) =>
      OrderSuccessScreen(orderId: state.pathParameters['id']!),
   ),
   // A-52 · Échec de paiement (payload conservé pour « Réessayer »).
   GoRoute(
    path: '/payment/failed',
    builder: (context, state) => PaymentFailedScreen(
     payload: state.extra is CheckoutPayload
       ? state.extra as CheckoutPayload
       : null,
    ),
   ),
   // A-66/A-67 · Consignes de retrait.
   GoRoute(path: '/lockers', builder: (_, _) => const LockersScreen()),
   GoRoute(path: '/orders', builder: (_, _) => const OrdersScreen()),
   GoRoute(
    path: '/order/:id',
    builder: (context, state) =>
      OrderTrackingScreen(orderId: state.pathParameters['id']!),
   ),

   // --------------------------------------------------------- Messagerie
   // « /chat » sans identifiant ouvre la première conversation.
   GoRoute(path: '/chat', redirect: (_, _) => '/chat/t1'),
   GoRoute(
    path: '/chat/:id',
    builder: (context, state) =>
      ChatScreen(threadId: state.pathParameters['id']!),
   ),

   // ------------------------------------------------------------ Profil
   GoRoute(path: '/wishlist', builder: (_, _) => const WishlistScreen()),
   GoRoute(
     path: '/notifications',
     builder: (_, _) => const NotificationsScreen()),
   GoRoute(path: '/addresses', builder: (_, _) => const AddressesScreen()),
   GoRoute(path: '/wallet', builder: (_, _) => const WalletScreen()),
   GoRoute(
     path: '/payment-methods',
     builder: (_, _) => const PaymentMethodsScreen()),
   // C-17 · Modifier le profil.
   GoRoute(
     path: '/profile/edit',
     builder: (_, _) => const EditProfileScreen()),
   // C-24 · Paramètres (+ C-25 notifications, C-27 données).
   GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
   GoRoute(
     path: '/settings/notifications',
     builder: (_, _) => const NotificationSettingsScreen()),
   GoRoute(
     path: '/settings/data',
     builder: (_, _) => const DataSettingsScreen()),
   // C-31/32/33 · Aide, FAQ, contact.
   GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
   // C-28 · À propos (+ C-29/C-30 légal).
   GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
   GoRoute(
    path: '/legal/:kind',
    builder: (context, state) =>
      LegalScreen(kind: state.pathParameters['kind'] ?? 'terms'),
   ),

   // ------------------------------------------------------------ Livreur
   GoRoute(
     path: '/livreur/course',
     builder: (_, _) => const CourseScreen()),
   // L-15 · Carte des courses disponibles.
   GoRoute(
     path: '/livreur/map', builder: (_, _) => const CourierMapScreen()),
   // L-01 → L-08 · Devenir livreur (avec quiz de formation).
   GoRoute(
     path: '/livreur/join', builder: (_, _) => const LivreurJoinScreen()),

   // ------------------------------------------- Index des 317 écrans
   // Démo : catalogue officiel complet, aperçus hors MVP inclus.
   GoRoute(
     path: '/screens', builder: (_, _) => const ScreensIndexScreen()),
   GoRoute(
    path: '/screen/:id',
    builder: (context, state) =>
      ExtraScreen(screenId: state.pathParameters['id']!),
   ),
  ],
  errorBuilder: (context, state) => Scaffold(
   appBar: AppBar(title: const Text('Oups')),
   body: EmptyState(
    emoji: '',
    title: 'Page introuvable',
    message: state.uri.toString(),
    actionLabel: "Retour à l'accueil",
    onAction: () => context.go('/main'),
   ),
  ),
 );
});
