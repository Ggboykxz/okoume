import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class SellerScreen extends ConsumerStatefulWidget {
 const SellerScreen({super.key, required this.sellerId});

 final String sellerId;

 @override
 ConsumerState<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends ConsumerState<SellerScreen> {
 bool _following = false;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final seller = ref.watch(sellerByIdProvider(widget.sellerId));
 final products = ref.watch(productsBySellerProvider(widget.sellerId));
 final totalSold = products.fold<int>(0, (sum, p) => sum + p.sold);

 return Scaffold(
  appBar: AppBar(title: Text(seller.name)),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
  children: [
   // ------------------------------------------------------ Bandeau
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
   child: Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
    gradient: LinearGradient(
     colors: ArtPalette.pair(seller.seed),
     begin: Alignment.topLeft,
     end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
    children: [
     Row(
     children: [
      SellerAvatar(
      emoji: seller.emoji.isNotEmpty ? seller.emoji : '•',
      seed: seller.seed,
      size: 68,
      verified: false,
      ),
      const SizedBox(width: 14),
      Expanded(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       Row(
        children: [
        Flexible(
         child: Text(
         seller.name,
         maxLines: 2,
         overflow: TextOverflow.ellipsis,
         style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16.5,
          color: AppColors.text,
          height: 1.2,
         ),
         ),
        ),
        if (seller.verified) ...[
         const SizedBox(width: 4),
         const AppIcon(AppIcons.verified_rounded,
          size: 17, color: AppColors.primary),
        ],
        ],
       ),
       const SizedBox(height: 4),
       Text(
        '${seller.type.label} ${seller.city}',
        style: const TextStyle(
         fontSize: 12,
         fontWeight: FontWeight.w600,
         color: Color(0xCC1A1A2E)),
       ),
       const SizedBox(height: 6),
       Row(
        children: [
        RatingStars(
         rating: seller.rating,
         size: 13,
         reviews: seller.reviews),
        const SizedBox(width: 10),
        Text(
         '${formatNumber(seller.followers)} abonnés',
         style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: Color(0xCC1A1A2E)),
        ),
        ],
       ),
       ],
      ),
      ),
     ],
     ),
     const SizedBox(height: 16),
     Row(
     children: [
      Expanded(
      child: AppButton(
       label: _following ? ' Suivi' : 'Suivre',
       small: true,
       height: 44,
       variant: _following
        ? AppButtonVariant.outline
        : AppButtonVariant.primary,
       onPressed: () {
       setState(() => _following = !_following);
       showAppSnack(
        context,
        _following
         ? 'Vous suivez ${seller.name}'
         : 'Vous ne suivez plus cette boutique',
        emoji: _following ? '' : '',
       );
       },
      ),
      ),
      const SizedBox(width: 10),
      Expanded(
      child: AppButton(
       label: 'Contacter',
       small: true,
       height: 44,
       icon: AppIcons.chat_bubble_rounded,
       variant: AppButtonVariant.outline,
       onPressed: () {
       final threadId = ref
        .read(chatProvider.notifier)
        .ensureThread(seller.id);
       context.push('/chat/$threadId');
       },
      ),
      ),
      const SizedBox(width: 10),
      AppIconButton(
      label: 'Partager la boutique',
      icon: AppIcons.ios_share_rounded,
      size: 44,
      onTap: () => showAppSnack(
       context, 'Lien de la boutique copié', emoji: ''),
      ),
     ],
     ),
    ],
    ),
   ),
   ),

   // ------------------------------------------------------- Stats
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
   child: Row(
    children: [
    Expanded(
     child: StatCard(
     emoji: '',
     label: 'Produits',
     value: '${products.length}',
     ),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: StatCard(
     emoji: '',
     label: 'Ventes',
     value: formatNumber(totalSold),
     ),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: StatCard(
     emoji: '',
     label: 'Note',
     value: seller.rating.toStringAsFixed(1).replaceAll('.', ','),
     delta: '${seller.reviews} avis',
     ),
    ),
    ],
   ),
   ),

   // --------------------------------------------------- À propos
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
   child: AppCard(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text('À propos',
      style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 8),
     Text(
     seller.description,
     style: const TextStyle(fontSize: 13.5, height: 1.5),
     ),
     const SizedBox(height: 12),
     Row(
     children: [
      Expanded(
      child: _MiniStat(
       emoji: '',
       text: 'Répond en ~${seller.responseMin} min',
      ),
      ),
      Expanded(
      child: _MiniStat(
       emoji: '',
       text: 'Membre depuis ${seller.sinceYear}',
      ),
      ),
     ],
     ),
    ],
    ),
   ),
   ),

   // ----------------------------------------------------- Produits
   SectionHeader(
   title: 'Ses produits (${products.length})',
   ),
   if (products.isEmpty)
   const Padding(
    padding: EdgeInsets.only(top: 30),
    child: EmptyState(
    emoji: '',
    title: 'Aucun produit en ligne',
    message: 'Cette boutique prépare son catalogue.',
    ),
   )
   else
   GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    mainAxisSpacing: 18,
    crossAxisSpacing: 14,
    childAspectRatio: 0.62,
    children: [
    for (final p in products) ProductCard(product: p),
    ],
   ),
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
   child: Text(
    'Boutique ${seller.verified ? 'vérifiée par Okoumé — KYC validé' : 'en cours de vérification'}. Signalez tout comportement suspect depuis la fiche produit.',
    textAlign: TextAlign.center,
    style: TextStyle(
     fontSize: 11, color: cs.onSurfaceVariant, height: 1.5),
   ),
   ),
  ],
  ),
 );
 }
}

class _MiniStat extends StatelessWidget {
 const _MiniStat({required this.emoji, required this.text});

 final String emoji;
 final String text;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Row(
  children: [
  Text(emoji, style: const TextStyle(fontSize: 15)),
  const SizedBox(width: 6),
  Expanded(
   child: Text(
   text,
   style: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: cs.onSurfaceVariant),
   ),
  ),
  ],
 );
 }
}
