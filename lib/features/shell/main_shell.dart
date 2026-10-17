import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../chat/chat_list_screen.dart';
import '../home/home_screen.dart';
import '../livreur/livreur_home_screen.dart';
import '../livreur/livreur_wallet_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import '../seller/dashboard_screen.dart';
import '../seller/orders_screen.dart';
import '../seller/products_screen.dart';
import '../seller/quick_sell_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/motion.dart';

/// Permet aux écrans (accueil, profil…) de changer d'onglet du shell.
final shellTabNotifier = ValueNotifier<int>(0);

class _TabSpec {
 const _TabSpec(this.label, this.icon, this.page, {this.badge = 0});

 final String label;
 final AppIconData icon;
 final Widget page;
 final int badge;
}

class MainShell extends ConsumerStatefulWidget {
 const MainShell({super.key});

 @override
 ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
 int _index = 0;

 @override
 void initState() {
 super.initState();
 _index = shellTabNotifier.value;
 shellTabNotifier.addListener(_onTabRequest);
 }

 void _onTabRequest() {
 if (!mounted) return;
 setState(() => _index = shellTabNotifier.value);
 }

 @override
 void dispose() {
 shellTabNotifier.removeListener(_onTabRequest);
 super.dispose();
 }

 List<_TabSpec> _tabsFor(UserRole role) {
 final unread = ref.watch(unreadMessagesProvider);
 final unreadNotifs = ref.watch(unreadNotificationsProvider);
 return switch (role) {
  UserRole.acheteur => [
   const _TabSpec('Accueil', AppIcons.home_rounded, HomeScreen()),
   const _TabSpec('Recherche', AppIcons.search_rounded, SearchScreen()),
   const _TabSpec('Vendre', AppIcons.add_rounded, QuickSellScreen()),
   _TabSpec('Messages', AppIcons.chat_bubble_rounded, const ChatListScreen(),
    badge: unread),
   const _TabSpec('Profil', AppIcons.person_rounded, ProfileScreen()),
  ],
  UserRole.vendeur => [
   _TabSpec('Boutique', AppIcons.storefront_rounded,
    const SellerDashboardScreen(),
    badge: unreadNotifs),
   const _TabSpec(
    'Produits', AppIcons.inventory_2_rounded, SellerProductsScreen()),
   const _TabSpec('Vendre', AppIcons.add_rounded, QuickSellScreen()),
   const _TabSpec(
    'Commandes', AppIcons.receipt_long_rounded, SellerOrdersScreen()),
   const _TabSpec('Profil', AppIcons.person_rounded, ProfileScreen()),
  ],
  UserRole.livreur => [
   const _TabSpec(
    'Courses', AppIcons.delivery_dining_rounded, LivreurHomeScreen()),
   const _TabSpec(
    'Gains', AppIcons.account_balance_wallet_rounded, LivreurWalletScreen()),
   const _TabSpec('Profil', AppIcons.person_rounded, ProfileScreen()),
  ],
 };
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final dark = Theme.of(context).brightness == Brightness.dark;
 final user = ref.watch(authProvider);
 final role = user?.role ?? UserRole.acheteur;
 final tabs = _tabsFor(role);
 if (_index >= tabs.length) _index = tabs.length - 1;
 if (_index < 0) _index = 0;
 final online = ref.watch(settingsProvider).online;
 final isTablet = MediaQuery.sizeOf(context).width >= 900;

 if (isTablet) {
  return Scaffold(
   body: SafeArea(
   child: Row(
    children: [
     NavigationRail(
      selectedIndex: _index,
      onDestinationSelected: (i) {
       AppMotion.tap();
       shellTabNotifier.value = i;
      },
      leading: Padding(
       padding: const EdgeInsets.only(top: 8.0),
       child: const Text('Okoumé',
        style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      labelType: NavigationRailLabelType.all,
      destinations: [
       for (final t in tabs)
        NavigationRailDestination(
         icon: Badge(
          label: Text('${t.badge}'),
          isLabelVisible: t.badge > 0,
          smallSize: 16,
          child: AppIcon(t.icon, color: cs.onSurfaceVariant),
         ),
         selectedIcon: Badge(
          label: Text('${t.badge}'),
          isLabelVisible: t.badge > 0,
          smallSize: 16,
          child: AppIcon(t.icon, color: cs.primary),
         ),
         label: Text(t.label),
        ),
      ],
     ),
     const VerticalDivider(thickness: 1, width: 1),
     Expanded(child: IndexedStack(index: _index, children: [for (final t in tabs) t.page])),
    ],
   ),
   ),
  );
 }

 return Scaffold(
  body: Column(
  children: [
   if (!online)
   Container(
    width: double.infinity,
    color: dark ? AppColors.darkSurfaceHigh : const Color(0xFFFFF4D6),
    padding:
     const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    child: Text(
    ' Mode hors ligne — catalogue en cache, commandes synchronisées plus tard',
    textAlign: TextAlign.center,
    style: TextStyle(
     fontSize: 11,
     fontWeight: FontWeight.w700,
     color: dark ? AppColors.darkText : const Color(0xFF7A5D00),
    ),
    ),
   ),
   Expanded(
   child: IndexedStack(
    index: _index,
    children: [for (final t in tabs) t.page],
   ),
   ),
  ],
  ),
  // Barre de navigation matériau : translucide + flou (Apple §12).
  bottomNavigationBar: Frosted(
  color: cs.surface.withValues(alpha: 0.86),
  child: Container(
   decoration: BoxDecoration(
   border: Border(top: BorderSide(color: cs.outlineVariant)),
   ),
   child: SafeArea(
   top: false,
   child: SizedBox(
    height: 66,
    child: Row(
    children: [
     for (var i = 0; i < tabs.length; i++)
     Expanded(
      child: Semantics(
       label: '${tabs[i].label}${tabs[i].badge > 0 ? ', ${tabs[i].badge} non lus' : ''}',
       selected: i == _index,
       button: true,
       child: _NavItem(
        spec: tabs[i],
        selected: i == _index,
        special: tabs[i].label == 'Vendre',
        onTap: () {
         AppMotion.tap();
         shellTabNotifier.value = i;
        },
       ),
      ),
     ),
    ],
    ),
   ),
   ),
  ),
  ),
 );
 }
}

class _NavItem extends StatelessWidget {
 const _NavItem({
 required this.spec,
 required this.selected,
 required this.special,
 required this.onTap,
 });

 final _TabSpec spec;
 final bool selected;
 final bool special;
 final VoidCallback onTap;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 if (special) {
  return Pressable(
  scale: 0.92,
  child: GestureDetector(
  onTap: onTap,
  behavior: HitTestBehavior.opaque,
  child: Column(
   mainAxisAlignment: MainAxisAlignment.center,
   children: [
   Transform.translate(
    offset: const Offset(0, -8),
    child: Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
     color: AppColors.secondaryDeep,
     borderRadius: BorderRadius.circular(14),
    ),
    child: AppIcon(spec.icon, color: Colors.white, size: 24),
    ),
   ),
   Transform.translate(
    offset: const Offset(0, -4),
    child: Text(
    spec.label,
    style: TextStyle(
     fontSize: 10.5,
     fontWeight: FontWeight.w700,
     color: AppColors.secondaryDeep,
    ),
    ),
   ),
   ],
  ),
  ),
  );
 }

 final color = selected ? cs.primary : cs.onSurfaceVariant;
 return Pressable(
  scale: 0.9,
  child: GestureDetector(
  onTap: onTap,
  behavior: HitTestBehavior.opaque,
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
   SizedBox(
   height: 30,
   child: Stack(
    clipBehavior: Clip.none,
    children: [
    AnimatedScale(
     scale: selected ? 1.06 : 1,
     duration: AppMotion.on(context)
      ? const Duration(milliseconds: 220)
      : Duration.zero,
     curve: Curves.easeOutCubic,
     child: AppIcon(spec.icon, size: 24, color: color),
    ),
    Positioned(
     right: -10,
     top: -4,
     child: AnimatedOpacity(
     opacity: spec.badge > 0 ? 1 : 0,
     duration: AppMotion.on(context)
      ? const Duration(milliseconds: 120)
      : Duration.zero,
     child: AnimatedScale(
      scale: spec.badge > 0 ? 1 : 0,
      duration: AppMotion.on(context)
       ? const Duration(milliseconds: 180)
       : Duration.zero,
      curve: Curves.easeOutBack,
      child: Container(
      padding: const EdgeInsets.symmetric(
       horizontal: 5, vertical: 1.5),
      constraints: const BoxConstraints(minWidth: 17),
      decoration: BoxDecoration(
      color: AppColors.dangerDeep,
      borderRadius: BorderRadius.circular(99),
      border:
       Border.all(color: Colors.white, width: 1.4),
      ),
      alignment: Alignment.center,
      child: Text(
      '${spec.badge}',
      style: const TextStyle(
       color: Colors.white,
       fontSize: 9.5,
       fontWeight: FontWeight.w800),
      ),
      ),
      ),
      ),
     ),
    ],
   ),
   ),
   const SizedBox(height: 3),
   Text(
   spec.label,
   style: TextStyle(
    fontSize: 10.5,
    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
    color: color,
   ),
   ),
  ],
  ),
  ),
 );
 }
}
