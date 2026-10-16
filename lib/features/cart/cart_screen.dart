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

class CartScreen extends ConsumerStatefulWidget {
 const CartScreen({super.key});

 @override
 ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
 final _promoController = TextEditingController();

 @override
 void dispose() {
 _promoController.dispose();
 super.dispose();
 }

 void _applyPromo() {
 final error =
  ref.read(cartProvider.notifier).applyPromo(_promoController.text);
 if (error != null) {
  showAppSnack(context, error, emoji: '');
 } else {
  _promoController.clear();
  showAppSnack(context, 'Code promo appliqué !', emoji: '');
 }
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final cart = ref.watch(cartProvider);
 final totals = ref.watch(cartTotalsProvider);
 final count = ref.watch(cartCountProvider);

 // Regroupement par vendeur (panier multi-vendeurs).
 final groups = <String, List<CartLine>>{};
 for (final line in cart.lines) {
  final product = Mock.productById(line.productId);
  groups.putIfAbsent(product.sellerId, () => []).add(line);
 }

 return Scaffold(
  appBar: AppBar(
  title: Text('Panier ($count)'),
  actions: [
   if (cart.lines.isNotEmpty)
   IconButton(
    icon: const AppIcon(AppIcons.delete_sweep_outlined),
    onPressed: () async {
    final confirmed = await showDialog<bool>(
     context: context,
     builder: (context) => AlertDialog(
     title: const Text('Vider le panier ?'),
     content: const Text(
      'Tous les articles seront retirés de votre panier.'),
     actions: [
      TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text('Annuler'),
      ),
      TextButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text('Vider',
       style: TextStyle(color: AppColors.danger)),
      ),
     ],
     ),
    );
    if (confirmed == true) {
     ref.read(cartProvider.notifier).clear();
    }
    },
   ),
  ],
  ),
  body: cart.lines.isEmpty
   ? EmptyState(
    emoji: '',
    title: 'Votre panier est vide',
    message:
     'Parcourez les produits du Gabon et ajoutez vos coups de cœur.',
    actionLabel: 'Découvrir les produits',
    onAction: () => context.go('/main'),
   )
   : ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
    children: [
    // ------------------------------------------ Groupes vendeur
    for (final entry in groups.entries)
     _SellerGroup(
     sellerId: entry.key,
     lines: entry.value,
     ),

    // -------------------------------------------------- Code promo
    const SizedBox(height: 6),
    AppCard(
     padding: const EdgeInsets.all(14),
     child: cart.promo == null
      ? Row(
       children: [
       Expanded(
        child: AppTextField(
        controller: _promoController,
        hint: 'Code promo (ex : BIENVENUE10)',
        icon: AppIcons.confirmation_number_outlined,
        textCapitalization: TextCapitalization.characters,
        ),
       ),
       const SizedBox(width: 10),
       AppButton(
        label: 'OK',
        small: true,
        expanded: false,
        height: 48,
        onPressed: _applyPromo,
       ),
       ],
      )
      : Row(
       children: [
       Pill(
        text: cart.promo!.code,
        color: AppColors.success,
        icon: AppIcons.check_circle_rounded,
       ),
       const SizedBox(width: 10),
       Expanded(
        child: Text(
        cart.promo!.label,
        style: const TextStyle(
         fontSize: 12.5,
         fontWeight: FontWeight.w600),
        ),
       ),
       GestureDetector(
        onTap: () => ref
         .read(cartProvider.notifier)
         .removePromo(),
        child: AppIcon(AppIcons.close_rounded,
         size: 20, color: cs.onSurfaceVariant),
       ),
       ],
      ),
    ),

    // ------------------------------------------- Livraison offerte
    if (totals.subtotal > 0 &&
     totals.subtotal < 25000 &&
     cart.promo?.freeShipping != true) ...[
     const SizedBox(height: 14),
     AppCard(
     padding: const EdgeInsets.all(14),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
       'Plus que ${formatXaf(25000 - totals.subtotal)} pour la livraison offerte ',
       style: const TextStyle(
        fontSize: 12.5, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      ClipRRect(
       borderRadius: BorderRadius.circular(4),
       child: LinearProgressIndicator(
       value: totals.subtotal / 25000,
       minHeight: 7,
       backgroundColor: cs.surfaceContainerHigh,
       ),
      ),
      ],
     ),
     ),
    ],

    // ------------------------------------------------ Récapitulatif
    const SizedBox(height: 14),
    AppCard(
     child: Column(
     children: [
      AmountRow(label: 'Sous-total', amount: totals.subtotal),
      if (totals.discount > 0)
      AmountRow(
       label: 'Réduction (${cart.promo?.code})',
       amount: -totals.discount,
       color: AppColors.success,
      ),
      AmountRow(
      label: 'Livraison',
      amount: totals.delivery,
      free: totals.delivery == 0,
      ),
      Divider(height: 22, color: cs.outlineVariant),
      AmountRow(
      label: 'Total à payer',
      amount: totals.total,
      bold: true,
      ),
     ],
     ),
    ),
    const SizedBox(height: 14),
    const InfoBanner(
     emoji: '',
     color: AppColors.success,
     text:
      'Paiement sécurisé par escrow : l\'argent est bloqué et versé au vendeur uniquement après réception.',
    ),
    const SizedBox(height: 14),
    Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
     AppIcon(AppIcons.verified_user_rounded,
      size: 14, color: cs.onSurfaceVariant),
     const SizedBox(width: 5),
     Text(
      'Airtel Money Moov Money Carte Cash à la livraison',
      style: TextStyle(
       fontSize: 11,
       color: cs.onSurfaceVariant,
       fontWeight: FontWeight.w600),
     ),
     ],
    ),
    ],
   ),
  bottomNavigationBar: cart.lines.isEmpty
   ? null
   : Container(
    decoration: BoxDecoration(
    color: cs.surface,
    border: Border(top: BorderSide(color: cs.outlineVariant)),
    ),
    child: SafeArea(
    top: false,
    child: Padding(
     padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
     child: AppButton(
     label: 'Passer la commande ${formatXaf(totals.total)}',
     icon: AppIcons.lock_rounded,
     onPressed: () => context.push('/checkout'),
     ),
    ),
    ),
   ),
 );
 }
}

class _SellerGroup extends ConsumerWidget {
 const _SellerGroup({required this.sellerId, required this.lines});

 final String sellerId;
 final List<CartLine> lines;

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final cs = Theme.of(context).colorScheme;
 final seller = ref.watch(sellerByIdProvider(sellerId));

 return Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: AppCard(
  padding: const EdgeInsets.all(14),
  child: Column(
   children: [
   GestureDetector(
    onTap: () => context.push('/seller/$sellerId'),
    child: Row(
    children: [
     SellerAvatar(
      emoji: seller.emoji.isNotEmpty ? seller.emoji : '•',
      seed: seller.seed,
      size: 32,
      verified: seller.verified),
     const SizedBox(width: 9),
     Expanded(
     child: Text(
      seller.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
       fontWeight: FontWeight.w700, fontSize: 13.5),
     ),
     ),
     Text('Voir la boutique',
      style: TextStyle(
       fontSize: 11,
       color: cs.primary,
       fontWeight: FontWeight.w700)),
     AppIcon(AppIcons.chevron_right_rounded,
      size: 17, color: cs.primary),
    ],
    ),
   ),
   const SizedBox(height: 12),
   for (var i = 0; i < lines.length; i++) ...[
    if (i > 0) Divider(height: 22, color: cs.outlineVariant),
    _CartLineRow(line: lines[i]),
   ],
   ],
  ),
  ),
 );
 }
}

class _CartLineRow extends ConsumerWidget {
 const _CartLineRow({required this.line});

 final CartLine line;

 @override
 Widget build(BuildContext context, WidgetRef ref) {
 final cs = Theme.of(context).colorScheme;
 final product = ref.watch(productByIdProvider(line.productId));
 if (product == null) return const SizedBox.shrink();
 final notifier = ref.read(cartProvider.notifier);
 final maxQty = product.isService ? 99 : product.stock;

 return Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  SizedBox(
   width: 62,
   height: 62,
   child:
    ProductArt(emoji: product.emoji.isNotEmpty ? product.emoji : '•', seed: product.seed, radius: 14),
  ),
  const SizedBox(width: 12),
  Expanded(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(
    product.title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style:
     const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    if (line.variantLabel.isNotEmpty) ...[
    const SizedBox(height: 2),
    Text(
     line.variantLabel,
     style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant),
    ),
    ],
    const SizedBox(height: 8),
    Row(
    children: [
     Expanded(
     child: PriceText(price: product.price, size: 14),
     ),
     QtyStepper(
     value: line.qty,
     max: maxQty,
     onChanged: (v) => notifier.setQty(
      line.productId,
      v,
      variant: line.variant,
     ),
     ),
    ],
    ),
   ],
   ),
  ),
  const SizedBox(width: 4),
  GestureDetector(
   onTap: () =>
    notifier.remove(line.productId, variant: line.variant),
   child: Padding(
   padding: const EdgeInsets.only(left: 4, top: 2),
   child: AppIcon(AppIcons.close_rounded,
    size: 18, color: cs.onSurfaceVariant),
   ),
  ),
  ],
 );
 }
}
