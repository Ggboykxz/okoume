import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../shell/main_shell.dart';
import '../../core/ui/app_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _bannerController = PageController();
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerController.hasClients) return;
      final next = (_bannerIndex + 1) % Mock.banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final catalog = ref.watch(catalogProvider);
    final cartCount = ref.watch(cartCountProvider);
    final unreadNotifs = ref.watch(unreadNotificationsProvider);

    final flash = ref.watch(flashDealsProvider);
    final trending = List<Product>.of(catalog)
      ..sort((a, b) => b.sold.compareTo(a.sold));
    final madeInGabon = catalog
        .where((p) =>
            p.tags.contains('Made in Gabon') ||
            Mock.sellerById(p.sellerId).type == SellerType.artisan)
        .toList();
    final newest = List<Product>.of(catalog)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: cs.primary,
          onRefresh: () => Future.delayed(const Duration(milliseconds: 700)),
          child: MotionEnter(
            child: ListView(
            padding: const EdgeInsets.only(bottom: 28),
            children: [
              // ------------------------------------------------------- En-tête
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Livraison à',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              AppIcon(AppIcons.location_on_rounded,
                                  size: 16, color: cs.primary),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  'Libreville — Nzeng-Ayong',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              AppIcon(AppIcons.keyboard_arrow_down_rounded,
                                  size: 18, color: cs.onSurfaceVariant),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppIconButton(
                      icon: AppIcons.notifications_none_rounded,
                      badgeCount: unreadNotifs,
                      onTap: () => context.push('/notifications'),
                    ),
                    const SizedBox(width: 10),
                    AppIconButton(
                      icon: AppIcons.shopping_cart_outlined,
                      badgeCount: cartCount,
                      onTap: () => context.push('/cart'),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------------ Recherche
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: GestureDetector(
                  onTap: () => shellTabNotifier.value = 1,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        AppIcon(AppIcons.search_rounded,
                            size: 21, color: cs.onSurfaceVariant),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Rechercher un produit, une boutique…',
                            style: TextStyle(
                                fontSize: 13.5,
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        AppIcon(AppIcons.tune_rounded,
                            size: 19, color: cs.primary),
                      ],
                    ),
                  ),
                ),
              ),

              // -------------------------------------------------- Stories (A-08)
              const SizedBox(height: 16),
              _StoriesStrip(products: flash),
              const SizedBox(height: 4),

              // ----------------------------------------------------- Bannières
              const SizedBox(height: 14),
              SizedBox(
                height: 140,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: Mock.banners.length,
                  onPageChanged: (i) => setState(() => _bannerIndex = i),
                  itemBuilder: (context, i) =>
                      _BannerCard(banner: Mock.banners[i]),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < Mock.banners.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _bannerIndex ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _bannerIndex
                            ? cs.primary
                            : cs.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                ],
              ),

              // ---------------------------------------------------- Catégories
              SectionHeader(
                title: 'Catégories',
                actionLabel: 'Tout voir',
                onAction: () => shellTabNotifier.value = 1,
              ),
              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                mainAxisSpacing: 12,
                crossAxisSpacing: 6,
                childAspectRatio: 0.78,
                children: [
                  for (final c in Mock.categories) _CategoryTile(category: c),
                ],
              ),

              // -------------------------------------------------- Offres flash
              if (flash.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Offres du jour',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(width: 6),
                                const Text('⚡',
                                    style: TextStyle(fontSize: 15)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('Prix cassés, stock limité',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const CountdownText(),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => context.push('/flash'),
                            child: Text('Tout voir ›',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: cs.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: flash.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (context, i) => SizedBox(
                      width: 158,
                      child: ProductCard(product: flash[i]),
                    ),
                  ),
                ),
              ],

              // --------------------------------------------------- Tendances
              SectionHeader(
                title: 'Tendances près de chez vous',
                subtitle: 'Les plus vendus à Libreville',
                actionLabel: 'Voir plus',
                onAction: () => shellTabNotifier.value = 1,
              ),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: trending.take(8).length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => SizedBox(
                    width: 158,
                    child: ProductCard(product: trending[i]),
                  ),
                ),
              ),

              // ----------------------------------------------- Made in Gabon
              SectionHeader(
                title: 'Made in Gabon 🇬🇦',
                subtitle: 'Artisans et producteurs locaux',
                actionLabel: 'Découvrir',
                onAction: () => context.push('/local'),
              ),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: madeInGabon.take(8).length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => SizedBox(
                    width: 158,
                    child: ProductCard(product: madeInGabon[i]),
                  ),
                ),
              ),

              // -------------------------------------------------- Vente rapide
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
                child: GestureDetector(
                  onTap: () => shellTabNotifier.value = 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A3D), Color(0xFFFF6B00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B00)
                              .withValues(alpha: 0.3),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('📸', style: TextStyle(fontSize: 30)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vendez en 60 secondes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Photo + prix → lien à partager sur WhatsApp',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const AppIcon(AppIcons.arrow_forward_rounded,
                            color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),

              // --------------------------------------------------- Nouveautés
              SectionHeader(
                title: 'Nouveautés',
                subtitle: 'Fraîchement publiées',
                actionLabel: 'Voir plus',
                onAction: () => shellTabNotifier.value = 1,
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                mainAxisSpacing: 18,
                crossAxisSpacing: 14,
                childAspectRatio: 0.62,
                children: [
                  for (final p in newest.take(6)) ProductCard(product: p),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoriesStrip extends StatelessWidget {
  const _StoriesStrip({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: products.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          if (i == 0) {
            // « Votre story » — raccourci vers la vente rapide (V-28).
            return _StoryBubble(
              label: 'Votre story',
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.outlineVariant, width: 1.5),
                ),
                child: AppIcon(AppIcons.add_rounded,
                    size: 24, color: cs.primary),
              ),
              onTap: () => shellTabNotifier.value = 2,
            );
          }
          final p = products[i - 1];
          return _StoryBubble(
            label: p.title.split(' ').take(2).join(' '),
            ring: true,
            onTap: () => context.push('/stories', extra: i - 1),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ArtPalette.pair(p.seed),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(p.emoji, style: const TextStyle(fontSize: 26)),
            ),
          );
        },
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  const _StoryBubble({
    required this.label,
    required this.child,
    required this.onTap,
    this.ring = false,
  });

  final String label;
  final Widget child;
  final VoidCallback onTap;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Pressable(
      scale: 0.9,
      child: GestureDetector(
        onTap: () {
          AppMotion.tap();
          onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ring
                    ? const LinearGradient(
                        colors: [Color(0xFFFF8A3D), Color(0xFF0066CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: child,
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final BannerPromo banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: banner.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: -6,
            child: Text(banner.emoji, style: const TextStyle(fontSize: 62)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    banner.tag.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  banner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 21,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/category/${category.id}'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(category.emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10.5, fontWeight: FontWeight.w600, height: 1.2),
          ),
        ],
      ),
    );
  }
}
