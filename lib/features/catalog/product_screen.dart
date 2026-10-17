import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class ProductScreen extends ConsumerStatefulWidget {
 const ProductScreen({super.key, required this.productId});

 final String productId;

 @override
 ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
 final _galleryController = PageController();
 int _galleryIndex = 0;
 final Map<String, String> _selected = {};

 @override
 void dispose() {
 _galleryController.dispose();
 super.dispose();
 }

 Map<String, String> _resolvedVariant(Product product) {
 final map = <String, String>{};
 for (final v in product.variants) {
  map[v.name] = _selected[v.name] ?? v.values.first;
 }
 return map;
 }

 void _addToCart(Product product, {bool buyNow = false}) {
 ref.read(cartProvider.notifier).add(
   product.id,
   variant: _resolvedVariant(product),
  );
 if (buyNow) {
  context.push('/cart');
 } else {
  showAppSnack(context, 'Ajouté au panier', emoji: '');
 }
 }

 void _negotiate(Product product) {
 final seller = Mock.sellerById(product.sellerId);
 final threadId = ref.read(chatProvider.notifier).ensureThread(seller.id);
 showAppSnack(
  context,
  'Discussion ouverte avec ${seller.name} — proposez votre prix !',
  emoji: '',
 );
 context.push('/chat/$threadId');
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final product = ref.watch(productByIdProvider(widget.productId));
 if (product == null) {
  return Scaffold(
  appBar: AppBar(),
  body: const EmptyState(
   emoji: '',
   title: 'Produit introuvable',
   message: 'Cet article n\'est plus disponible.',
  ),
  );
 }
 final seller = ref.watch(sellerByIdProvider(product.sellerId));
 final wished = ref.watch(wishlistProvider).contains(product.id);
 final cartCount = ref.watch(cartCountProvider);
 final similar = ref
  .watch(productsByCategoryProvider(product.categoryId))
  .where((p) => p.id != product.id)
  .take(8)
  .toList();
 final reviews = Mock.reviewsFor(product);
 final qas = Mock.qaFor(product);

 return Scaffold(
  appBar: AppBar(
  title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
  actions: [
   IconButton(
   icon: Icon(wished
    ? Icons.favorite_rounded
    : Icons.favorite_outline_rounded),
   color: wished ? AppColors.danger : null,
   onPressed: () {
    ref.read(wishlistProvider.notifier).toggle(product.id);
    showAppSnack(context,
     wished ? 'Retiré des favoris' : 'Ajouté aux favoris',
     emoji: wished ? '' : '');
   },
   ),
   IconButton(
   icon: const AppIcon(AppIcons.ios_share_rounded),
   onPressed: () => showAppSnack(
    context,
    'Lien okoume.ga/${product.id} copié — partagez sur WhatsApp !',
    emoji: '',
   ),
   ),
   Padding(
   padding: const EdgeInsets.only(right: 8),
   child: AppIconButton(
    label: 'Panier',
    icon: AppIcons.shopping_cart_outlined,
    badgeCount: cartCount,
    size: 38,
    onTap: () => context.push('/cart'),
   ),
   ),
  ],
  ),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
  children: [
   // ------------------------------------------------------- Galerie
   SizedBox(
   height: 320,
   child: Stack(
    children: [
    PageView.builder(
     controller: _galleryController,
     itemCount: 3,
     onPageChanged: (i) => setState(() => _galleryIndex = i),
     itemBuilder: (context, i) => Padding(
     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
     child: ProductArt(
      emoji: product.emoji.isNotEmpty ? product.emoji : '•',
      seed: product.seed + i * 3,
      radius: 22,
      emojiScale: 0.42,
      ribbon: i == 0 && product.discountPercent >= 10
       ? '-${product.discountPercent}%'
       : null,
     ),
     ),
    ),
    Positioned(
     bottom: 12,
     left: 0,
     right: 0,
     child: Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      for (var i = 0; i < 3; i++)
      AnimatedContainer(
       duration: const Duration(milliseconds: 200),
       margin: const EdgeInsets.symmetric(horizontal: 3),
       width: i == _galleryIndex ? 18 : 6,
       height: 6,
       decoration: BoxDecoration(
       color: i == _galleryIndex
        ? cs.primary
        : cs.outlineVariant,
       borderRadius: BorderRadius.circular(99),
       ),
      ),
     ],
     ),
    ),
    ],
   ),
   ),

   Padding(
   padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // ------------------------------------------------- Badges
    Wrap(
     spacing: 8,
     runSpacing: 8,
     children: [
     if (product.condition != null)
      Pill(
      text: product.condition!,
      color: AppColors.warning,
      icon: AppIcons.sell_rounded,
      ),
     if (product.express)
      const Pill(
      text: 'Livraison express < 2 h',
      color: AppColors.success,
      icon: AppIcons.bolt_rounded,
      ),
     if (product.isService)
      const Pill(
      text: 'Prestation à domicile',
      color: Color(0xFF7C4DFF),
      icon: AppIcons.home_repair_service_rounded,
      ),
     for (final tag in product.tags)
      Pill(text: tag, color: cs.onSurfaceVariant, dense: true),
     ],
    ),
    const SizedBox(height: 12),

    // -------------------------------------------------- Titre
    Text(
     product.title,
     style: Theme.of(context)
      .textTheme
      .titleLarge
      ?.copyWith(fontSize: 20, height: 1.25),
    ),
    const SizedBox(height: 8),
    Row(
     children: [
     RatingStars(
      rating: product.rating,
      size: 15,
      reviews: product.reviews),
     const SizedBox(width: 8),
     Text('',
      style: TextStyle(color: cs.onSurfaceVariant)),
     const SizedBox(width: 8),
     Text(
      product.isService
       ? '${product.sold}+ prestations'
       : '${formatNumber(product.sold)} vendus',
      style: TextStyle(
       fontSize: 12.5, color: cs.onSurfaceVariant),
     ),
     ],
    ),
    const SizedBox(height: 14),

    // --------------------------------------------------- Prix
    Row(
     crossAxisAlignment: CrossAxisAlignment.end,
     children: [
     PriceText(
      price: product.price,
      oldPrice: product.oldPrice,
      size: product.price >= 1000000 ? 22 : 26,
     ),
     ],
    ),
    const SizedBox(height: 8),
    Row(
     children: [
     Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
      color: product.stock <= 5
       ? AppColors.warning
       : AppColors.success,
      shape: BoxShape.circle,
      ),
     ),
     const SizedBox(width: 6),
     Text(
      product.isService
       ? 'Disponible sur rendez-vous'
       : product.stock <= 5
        ? 'Plus que ${product.stock} en stock !'
        : 'En stock (${product.stock} disponibles)',
      style: TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      color: product.stock <= 5 && !product.isService
       ? AppColors.warning
       : cs.onSurfaceVariant,
      ),
     ),
     const Spacer(),
     Text(' ${product.city}',
      style: TextStyle(
       fontSize: 12, color: cs.onSurfaceVariant)),
     ],
    ),

    // ------------------------------------------------ Variantes
    if (product.variants.isNotEmpty) ...[
     const SizedBox(height: 20),
     for (final variant in product.variants) ...[
     Text(
      '${variant.name} : ${_selected[variant.name] ?? variant.values.first}',
      style: const TextStyle(
       fontWeight: FontWeight.w700, fontSize: 13.5),
     ),
     const SizedBox(height: 8),
     Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
      for (final value in variant.values)
       AppChip(
       label: value,
       selected: (_selected[variant.name] ??
         variant.values.first) ==
        value,
       onTap: () =>
        setState(() => _selected[variant.name] = value),
       ),
      ],
     ),
     const SizedBox(height: 14),
     ],
    ],

    // -------------------------------------------------- Vendeur
    const SizedBox(height: 6),
    AppCard(
     onTap: () => context.push('/seller/${seller.id}'),
     child: Row(
     children: [
      SellerAvatar(
       emoji: seller.emoji.isNotEmpty ? seller.emoji : '•',
       seed: seller.seed,
       size: 50,
       verified: seller.verified),
      const SizedBox(width: 12),
      Expanded(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       Row(
        children: [
        Flexible(
         child: Text(
         seller.name,
         maxLines: 1,
         overflow: TextOverflow.ellipsis,
         style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14),
         ),
        ),
        if (seller.verified) ...[
         const SizedBox(width: 4),
         const AppIcon(AppIcons.verified_rounded,
          size: 16, color: AppColors.primary),
        ],
        ],
       ),
       const SizedBox(height: 3),
       Text(
        '${seller.type.label} répond en ~${seller.responseMin} min',
        style: TextStyle(
         fontSize: 11.5,
         color: cs.onSurfaceVariant),
       ),
       const SizedBox(height: 3),
       RatingStars(
        rating: seller.rating,
        size: 12,
        reviews: seller.reviews),
       ],
      ),
      ),
      AppIcon(AppIcons.chevron_right_rounded,
       color: cs.onSurfaceVariant),
     ],
     ),
    ),

    // ----------------------------------------------- Livraison
    const SizedBox(height: 12),
    AppCard(
     child: Column(
     children: [
      _InfoRow(
      emoji: '',
      title: 'Livraison à domicile',
      value:
       'dès ${formatXaf(1500)} — offerte dès 25 000',
      ),
      const SizedBox(height: 10),
      _InfoRow(
      emoji: '',
      title: 'Express (moto)',
      value: product.express
       ? 'en moins de 2 h'
       : 'selon disponibilité',
      ),
      const SizedBox(height: 10),
      const _InfoRow(
      emoji: '',
      title: 'Point relais / retrait',
      value: 'lockers & boutiques partenaires',
      ),
      const SizedBox(height: 12),
      const InfoBanner(
      emoji: '',
      text:
       'Paiement protégé : votre argent est libéré au vendeur seulement après réception (escrow).',
      color: AppColors.success,
      ),
     ],
     ),
    ),

    // ---------------------------------------------- Description
    const SizedBox(height: 22),
    Text('Description',
     style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 8),
    Text(
     product.description,
     style: TextStyle(
      fontSize: 14, height: 1.55, color: cs.onSurface),
    ),

    // ------------------------------------------ Caractéristiques
    const SizedBox(height: 20),
    Text('Caractéristiques',
     style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 10),
    _SpecRow(label: 'État', value: product.condition ?? 'Neuf'),
    _SpecRow(label: 'Ville', value: product.city),
    _SpecRow(
     label: 'Publié le',
     value: formatDateShort(product.createdAt)),
    if (product.isService)
     const _SpecRow(label: 'Type', value: 'Prestation de service'),
    for (final entry in product.characteristics.entries)
     _SpecRow(label: entry.key, value: entry.value),
    ],
   ),
   ),

   // --------------------------------------------------- Avis clients
   _SectionTitle(
   title: 'Avis clients (${product.reviews})',
   actionLabel: 'Tout voir',
   onAction: () => context.push('/product/${product.id}/reviews'),
   ),
   Padding(
   padding: const EdgeInsets.symmetric(horizontal: 20),
   child: AppCard(
    child: Row(
    children: [
     Column(
     children: [
      Text(
      product.rating.toStringAsFixed(1).replaceAll('.', ','),
      style: const TextStyle(
       fontFamily: 'Montserrat',
       fontWeight: FontWeight.w800,
       fontSize: 34,
       height: 1,
      ),
      ),
      const SizedBox(height: 4),
      RatingStars(
       rating: product.rating, size: 13, showValue: false),
      const SizedBox(height: 4),
      Text('${product.reviews} avis',
       style: TextStyle(
        fontSize: 11,
        color: Theme.of(context)
         .colorScheme
         .onSurfaceVariant)),
     ],
     ),
     const SizedBox(width: 20),
     Expanded(
     child: Column(
      children: [
      for (var stars = 5; stars >= 3; stars--)
       Padding(
       padding:
        const EdgeInsets.symmetric(vertical: 2.5),
       child: Row(
        children: [
        Text('$stars',
         style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700)),
        const SizedBox(width: 6),
        Expanded(
         child: ClipRRect(
         borderRadius: BorderRadius.circular(4),
         child: LinearProgressIndicator(
          value: stars == 5
           ? 0.72
           : stars == 4
            ? 0.21
            : 0.07,
          minHeight: 6,
          backgroundColor:
           Theme.of(context)
            .colorScheme
            .surfaceContainerHigh,
         ),
         ),
        ),
        ],
       ),
       ),
      ],
     ),
     ),
    ],
    ),
   ),
   ),
   const SizedBox(height: 12),
   for (final review in reviews.take(3))
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
    child: AppCard(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Row(
      children: [
      Container(
       width: 34,
       height: 34,
       decoration: BoxDecoration(
       color: cs.surfaceContainerHigh,
       shape: BoxShape.circle,
       ),
       alignment: Alignment.center,
       child: Text(review.emoji.isNotEmpty ? review.emoji : '•',
        style: const TextStyle(fontSize: 16)),
      ),
      const SizedBox(width: 10),
      Expanded(
       child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(review.author,
         style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13)),
        RatingStars(
         rating: review.rating,
         size: 11,
         showValue: false),
       ],
       ),
      ),
      Text(timeAgo(review.date),
       style: TextStyle(
        fontSize: 11,
        color: cs.onSurfaceVariant)),
      ],
     ),
     const SizedBox(height: 10),
     Text(review.text,
      style: const TextStyle(
       fontSize: 13, height: 1.45)),
     ],
    ),
    ),
   ),

   // ------------------------------------------------------- Q & R
   _SectionTitle(
   title: 'Questions & réponses',
   actionLabel: 'Poser une question',
   onAction: () => _showAskQuestion(product, seller.name),
   ),
   for (final qa in qas)
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
    child: AppCard(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text('', style: TextStyle(fontSize: 15)),
      const SizedBox(width: 8),
      Expanded(
       child: Text(qa.question,
        style: const TextStyle(
         fontWeight: FontWeight.w700,
         fontSize: 13.5)),
      ),
      ],
     ),
     const SizedBox(height: 8),
     Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Text(
      qa.answer,
      style: TextStyle(
       fontSize: 13,
       height: 1.45,
       color: cs.onSurfaceVariant),
      ),
     ),
     const SizedBox(height: 6),
     Padding(
      padding: const EdgeInsets.only(left: 23),
      child: Text('— ${qa.author}',
       style: TextStyle(
        fontSize: 11,
        fontStyle: FontStyle.italic,
        color: cs.onSurfaceVariant)),
     ),
     ],
    ),
    ),
   ),

   // ---------------------------------------------- Produits similaires
   if (similar.isNotEmpty) ...[
   const SizedBox(height: 12),
   Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
    child: Text('Produits similaires',
     style: Theme.of(context).textTheme.titleMedium),
   ),
   SizedBox(
    height: 248,
    child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    itemCount: similar.length,
    separatorBuilder: (_, _) => const SizedBox(width: 14),
    itemBuilder: (context, i) => SizedBox(
     width: 156,
     child: ProductCard(product: similar[i]),
    ),
    ),
   ),
   ],
  ],
  ),

  // ------------------------------------------------------ Barre d'achat
  bottomNavigationBar: Container(
  decoration: BoxDecoration(
   color: cs.surface,
   border: Border(top: BorderSide(color: cs.outlineVariant)),
  ),
  child: SafeArea(
   top: false,
   child: Padding(
   padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
   child: Row(
    children: [
    GestureDetector(
     onTap: () => _negotiate(product),
     child: Column(
     mainAxisSize: MainAxisSize.min,
     children: [
      Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
       color: cs.primary.withValues(alpha: 0.1),
       borderRadius: BorderRadius.circular(14),
      ),
      child: AppIcon(AppIcons.handshake_rounded,
       color: cs.primary, size: 22),
      ),
      const SizedBox(height: 3),
      Text('Négocier',
       style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: cs.primary)),
     ],
     ),
    ),
    const SizedBox(width: 12),
    Expanded(
     child: AppButton(
     label: 'Au panier',
     variant: AppButtonVariant.outline,
     height: 50,
     onPressed: () => _addToCart(product),
     ),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: AppButton(
     label: product.isService ? 'Réserver' : 'Acheter',
     height: 50,
     onPressed: () => _addToCart(product, buyNow: true),
     ),
    ),
    ],
   ),
   ),
  ),
  ),
 );
 }

 void _showAskQuestion(Product product, String sellerName) {
 final controller = TextEditingController();
 showAppSheet(
  context,
  Padding(
  padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
  child: Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   Text('Poser une question',
    style: Theme.of(context).textTheme.titleMedium),
   const SizedBox(height: 6),
   Text('À $sellerName — réponse publique sous 24 h.',
    style: TextStyle(
     fontSize: 12.5,
     color: Theme.of(context).colorScheme.onSurfaceVariant)),
   const SizedBox(height: 14),
   AppTextField(
    controller: controller,
    hint: 'Votre question…',
    maxLines: 3,
    autofocus: true,
   ),
   const SizedBox(height: 14),
   AppButton(
    label: 'Envoyer la question',
    icon: AppIcons.send_rounded,
    onPressed: () {
    Navigator.of(context).pop();
    showAppSnack(
     context, 'Question envoyée à $sellerName', emoji: '');
    },
   ),
   ],
  ),
  ),
 );
 }
}

class _InfoRow extends StatelessWidget {
 const _InfoRow({
 required this.emoji,
 required this.title,
 required this.value,
 });

 final String emoji;
 final String title;
 final String value;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Row(
  children: [
  Text(emoji, style: const TextStyle(fontSize: 17)),
  const SizedBox(width: 10),
  Expanded(
   child: Text(title,
    style: const TextStyle(
     fontWeight: FontWeight.w600, fontSize: 13.5)),
  ),
  Text(value,
   style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: cs.onSurfaceVariant)),
  ],
 );
 }
}

class _SpecRow extends StatelessWidget {
 const _SpecRow({required this.label, required this.value});

 final String label;
 final String value;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Padding(
  padding: const EdgeInsets.symmetric(vertical: 6),
  child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   SizedBox(
   width: 130,
   child: Text(label,
    style: TextStyle(
     fontSize: 13, color: cs.onSurfaceVariant)),
   ),
   Expanded(
   child: Text(value,
    style: const TextStyle(
     fontSize: 13, fontWeight: FontWeight.w600)),
   ),
  ],
  ),
 );
 }
}

class _SectionTitle extends StatelessWidget {
 const _SectionTitle({required this.title, this.actionLabel, this.onAction});

 final String title;
 final String? actionLabel;
 final VoidCallback? onAction;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Padding(
  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
  child: Row(
  children: [
   Expanded(
   child: Text(title,
    style: Theme.of(context).textTheme.titleMedium),
   ),
   if (actionLabel != null)
   GestureDetector(
    onTap: onAction,
    child: Text(actionLabel!,
     style: TextStyle(
      color: cs.primary,
      fontWeight: FontWeight.w700,
      fontSize: 13)),
   ),
  ],
  ),
 );
 }
}
