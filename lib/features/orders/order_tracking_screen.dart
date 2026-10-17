import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/art.dart';
import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

/// Suivi de commande : timeline, carte illustrée, code OTP, notation.
class OrderTrackingScreen extends ConsumerStatefulWidget {
 const OrderTrackingScreen({super.key, required this.orderId});

 final String orderId;

 @override
 ConsumerState<OrderTrackingScreen> createState() =>
  _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
 static const _canonical = [
 OrderStatus.confirmee,
 OrderStatus.enPreparation,
 OrderStatus.expediee,
 OrderStatus.enLivraison,
 OrderStatus.livree,
 ];

 DateTime? _timeFor(Order order, OrderStatus status) {
 for (var i = order.events.length - 1; i >= 0; i--) {
  final e = order.events[i];
  if (e.status == status && e.done) return e.time;
 }
 return null;
 }

 void _advance(Order order) {
 final updated =
  ref.read(ordersProvider.notifier).advance(order.id);
 if (updated != null) {
  AppMotion.tap();
  showAppSnack(
  context,
  'Statut mis à jour : ${updated.status.emoji.isNotEmpty ? updated.status.emoji : '•'} ${updated.status.label}',
  emoji: '',
  );
 }
 }

 Future<void> _confirmReception(Order order) async {
 final controller = TextEditingController();
 final otp = await showDialog<String>(
  context: context,
  builder: (context) => AlertDialog(
  title: const Text('Confirmer la réception'),
  content: Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   const Text(
    'Saisissez le code de remise à 4 chiffres communiqué par le livreur.',
    style: TextStyle(fontSize: 13.5),
   ),
   const SizedBox(height: 14),
   TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    maxLength: 4,
    textAlign: TextAlign.center,
    style: const TextStyle(
     fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 8),
    decoration: const InputDecoration(hintText: '••••', counterText: ''),
   ),
   ],
  ),
  actions: [
   TextButton(
   onPressed: () => Navigator.of(context).pop(),
   child: const Text('Annuler'),
   ),
   TextButton(
   onPressed: () => Navigator.of(context).pop(controller.text.trim()),
   child: const Text('Valider'),
   ),
  ],
  ),
 );
 if (otp == null || otp.isEmpty || !mounted) return;
 final ok = ref.read(ordersProvider.notifier).confirmDelivery(order.id, otp);
 if (!mounted) return;
 if (ok) {
  AppMotion.success();
  showAppSnack(
  context,
  'Réception confirmée — paiement libéré au vendeur ',
  emoji: '',
  );
 } else {
  AppMotion.warning();
  showAppSnack(
  context,
  'Code incorrect ou livraison pas encore en cours. Le code se trouve dans la carte Code de remise .',
  emoji: '',
  );
 }
 }

 void _openRating(Order order) {
 var stars = 5;
 final tags = <String>{};
 final commentController = TextEditingController();
 const availableTags = [
  'Conforme à la description',
  'Bien emballé',
  'Livraison rapide',
  'Vendeur réactif',
  'Bon rapport qualité/prix',
 ];
 showAppSheet(
  context,
  StatefulBuilder(
  builder: (context, setSheetState) => SingleChildScrollView(
   padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   mainAxisSize: MainAxisSize.min,
   children: [
    Text('Notez votre commande',
     style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 4),
    Text(
    'Votre avis aide toute la communauté Okoumé ',
    style: TextStyle(
     fontSize: 12.5,
     color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
    const SizedBox(height: 16),
    _RatingPicker(
    rating: stars,
    onChanged: (n) => setSheetState(() => stars = n),
    ),
    const SizedBox(height: 16),
    Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
     for (final tag in availableTags)
     AppChip(
      label: tag,
      selected: tags.contains(tag),
      onTap: () => setSheetState(() {
      tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
      }),
     ),
    ],
    ),
    const SizedBox(height: 14),
    AppTextField(
    controller: commentController,
    hint: 'Un commentaire ? (facultatif)',
    maxLines: 3,
    ),
    const SizedBox(height: 16),
    AppButton(
    label: 'Envoyer mon avis',
    icon: AppIcons.send_rounded,
    onPressed: () {
     ref
      .read(ordersProvider.notifier)
      .rate(order.id, stars.toDouble(), tags.toList(),
       commentController.text);
     Navigator.of(context).pop();
     showAppSnack(
      context, 'Merci pour votre avis !', emoji: '');
    },
    ),
   ],
   ),
  ),
  ),
 );
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final order = ref.watch(orderByIdProvider(widget.orderId));
 if (order == null) {
  return Scaffold(
  appBar: AppBar(),
  body: const EmptyState(
   emoji: '',
   title: 'Commande introuvable',
   message: 'Cette commande n\'existe pas ou a été supprimée.',
  ),
  );
 }
 final coursier = Mock.livreur;
 final showCoursier = order.status == OrderStatus.expediee ||
  order.status == OrderStatus.enLivraison;
 final stepIndex = order.status.step; // -1 si annulée

 return Scaffold(
  appBar: AppBar(
  title: Text('Commande ${order.code}',
   maxLines: 1, overflow: TextOverflow.ellipsis),
  actions: [
   IconButton(
   icon: const AppIcon(AppIcons.ios_share_rounded),
   onPressed: () => showAppSnack(
    context, 'Lien de suivi copié — à partager !', emoji: ''),
   ),
  ],
  ),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
  children: [
   // -------------------------------------------------------- Statut
   Row(
   children: [
    Container(
    width: 54,
    height: 54,
    decoration: BoxDecoration(
     color: order.status.color.withValues(alpha: 0.13),
     shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text(order.status.emoji.isNotEmpty ? order.status.emoji : '•',
     style: const TextStyle(fontSize: 26)),
    ),
    const SizedBox(width: 14),
    Expanded(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(order.status.label,
      style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 3),
     Text(
      order.status == OrderStatus.livree
       ? 'Livrée${_timeFor(order, OrderStatus.livree) != null ? ' le ${formatDate(_timeFor(order, OrderStatus.livree)!)}' : ''}'
       : order.status == OrderStatus.annulee
        ? 'Cette commande a été annulée.'
        : 'Arrivée estimée : ${formatDate(order.eta)}',
      style: TextStyle(
       fontSize: 12.5, color: cs.onSurfaceVariant),
     ),
     ],
    ),
    ),
   ],
   ),
   const SizedBox(height: 16),

   // -------------------------------------------- Carte illustrée (démo)
   if (order.status.isActive) ...[
   Container(
    height: 160,
    decoration: BoxDecoration(
    color: cs.surfaceContainerHigh,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: cs.outlineVariant),
    ),
    child: Stack(
    children: [
     // Route pointillée
     Positioned(
     left: 24,
     right: 24,
     top: 86,
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      for (var i = 0; i < 16; i++)
       Container(
       width: 8,
       height: 3,
       decoration: BoxDecoration(
        color: cs.outlineVariant,
        borderRadius: BorderRadius.circular(2),
       ),
       ),
      ],
     ),
     ),
     // Boutique
     const Align(
     alignment: Alignment(-0.85, -0.15),
     child: _MapMarker(emoji: '', color: AppColors.secondary),
     ),
     // Destination
     const Align(
     alignment: Alignment(0.85, -0.15),
     child: _MapMarker(emoji: '', color: AppColors.primary),
     ),
     // Livreur (position selon l'étape) — sprite Rive embarqué.
     Align(
     alignment: Alignment(
      -0.75 +
       (stepIndex < 0
         ? 0.0
         : stepIndex > 4
          ? 4.0
          : stepIndex.toDouble()) *
        0.42,
      0.55,
     ),
     child: const _CourierSprite(),
     ),
     Positioned(
     left: 12,
     bottom: 10,
     child: Pill(
      text: 'Suivi simulé Libreville',
      color: cs.onSurfaceVariant,
      dense: true,
      icon: AppIcons.map_rounded,
     ),
     ),
    ],
    ),
   ),
   const SizedBox(height: 16),
   ],

   // ------------------------------------------------- Code de remise
   if (order.status == OrderStatus.enLivraison) ...[
   Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: cs.primary.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
    ),
    child: Column(
    children: [
     Row(
     children: [
      AppIcon(AppIcons.lock_rounded, size: 17, color: cs.primary),
      const SizedBox(width: 7),
      Text('Code de remise',
       style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 13.5,
        color: cs.primary)),
     ],
     ),
     const SizedBox(height: 12),
     Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      for (final digit in order.otp.split(''))
      Container(
       width: 52,
       height: 56,
       margin: const EdgeInsets.symmetric(horizontal: 5),
       decoration: BoxDecoration(
       color: cs.surface,
       borderRadius: BorderRadius.circular(14),
       border: Border.all(color: cs.primary, width: 1.5),
       ),
       alignment: Alignment.center,
       child: Text(
       digit,
       style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
       ),
       ),
      ),
     ],
     ),
     const SizedBox(height: 10),
     Text(
     'Communiquez ce code au livreur à la remise du colis.',
     textAlign: TextAlign.center,
     style: TextStyle(
      fontSize: 12, color: cs.onSurfaceVariant, height: 1.4),
     ),
    ],
    ),
   ),
   const SizedBox(height: 16),
   ],

   // -------------------------------------------------------- Escrow
   if (order.escrowHeld)
   InfoBanner(
    emoji: '',
    color: AppColors.success,
    text:
     '${formatXaf(order.total)} bloqués en escrow : le vendeur sera payé après votre confirmation de réception.',
   )
   else if (order.status == OrderStatus.livree)
   const InfoBanner(
    emoji: '',
    color: AppColors.success,
    text:
     'Paiement libéré au vendeur. Merci d\'avoir utilisé Okoumé !',
   ),
   const SizedBox(height: 18),

   // -------------------------------------------------------- Timeline
   if (order.status == OrderStatus.annulee)
   AppCard(
    child: Column(
    children: [
     const Text('', style: TextStyle(fontSize: 28)),
     const SizedBox(height: 8),
     const Text('Commande annulée',
      style:
       TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
     const SizedBox(height: 4),
     Text(
     'L\'argent est restitué sur votre moyen de paiement sous 24 h.',
     textAlign: TextAlign.center,
     style: TextStyle(
      fontSize: 12.5, color: cs.onSurfaceVariant),
     ),
    ],
    ),
   )
   else
   AppCard(
    child: Column(
    children: [
     for (var i = 0; i < _canonical.length; i++)
     _TimelineRow(
      status: _canonical[i],
      time: _timeFor(order, _canonical[i]),
      currentIndex: stepIndex,
      index: i,
      isLast: i == _canonical.length - 1,
     ),
    ],
    ),
   ),
   const SizedBox(height: 18),

   // --------------------------------------------------------- Livreur
   if (showCoursier) ...[
   AppCard(
    child: Row(
    children: [
     SellerAvatar(
      emoji: coursier.emoji.isNotEmpty ? coursier.emoji : '•', seed: 3, size: 50, verified: true),
     const SizedBox(width: 12),
     Expanded(
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(coursier.name,
       style: const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 14)),
      const SizedBox(height: 2),
      Text(
       '${coursier.vehicle.emoji.isNotEmpty ? coursier.vehicle.emoji : '•'} ${coursier.vehicle.label} ${coursier.plate}',
       style: TextStyle(
        fontSize: 11.5, color: cs.onSurfaceVariant),
      ),
      const SizedBox(height: 2),
      RatingStars(
       rating: coursier.rating,
       size: 12,
       reviews: coursier.courses),
      ],
     ),
     ),
     AppIconButton(
     label: 'Appeler le livreur',
     icon: AppIcons.call_rounded,
     size: 40,
     onTap: () => showAppSnack(
      context, 'Appel de ${coursier.name}…', emoji: ''),
     ),
     const SizedBox(width: 8),
     AppIconButton(
     label: 'Écrire au livreur',
     icon: AppIcons.chat_bubble_rounded,
     size: 40,
     onTap: () => showAppSnack(
      context, 'Messagerie livreur (démo)', emoji: ''),
     ),
    ],
    ),
   ),
   const SizedBox(height: 18),
   ],

   // -------------------------------------------------------- Articles
   AppCard(
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('Articles (${order.lines.length})',
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 13.5)),
    const SizedBox(height: 12),
    for (var i = 0; i < order.lines.length; i++) ...[
     if (i > 0) const SizedBox(height: 12),
     Row(
     children: [
      SizedBox(
      width: 44,
      height: 44,
      child: ProductArt(
       emoji: order.lines[i].emoji,
       seed: order.lines[i].seed,
       radius: 11),
      ),
      const SizedBox(width: 11),
      Expanded(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       Text(order.lines[i].title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
         fontSize: 13,
         fontWeight: FontWeight.w600)),
       const SizedBox(height: 2),
       Text(
        '${order.lines[i].sellerName}${order.lines[i].variantLabel.isNotEmpty ? ' ${order.lines[i].variantLabel}' : ''}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
         fontSize: 11.5,
         color: cs.onSurfaceVariant),
       ),
       ],
      ),
      ),
      const SizedBox(width: 8),
      Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
       PriceText(price: order.lines[i].total, size: 13.5),
       Text('×${order.lines[i].qty}',
        style: TextStyle(
         fontSize: 11.5,
         color: cs.onSurfaceVariant)),
      ],
      ),
     ],
     ),
    ],
    ],
   ),
   ),
   const SizedBox(height: 14),

   // --------------------------------------------------- Paiement & adresse
   AppCard(
   child: Column(
    children: [
    AmountRow(label: 'Sous-total', amount: order.subtotal),
    if (order.discount > 0)
     AmountRow(
      label: 'Réduction',
      amount: -order.discount,
      color: AppColors.success),
    AmountRow(
     label: 'Livraison',
     amount: order.deliveryFee,
     free: order.deliveryFee == 0),
    Divider(height: 20, color: cs.outlineVariant),
    AmountRow(label: 'Total', amount: order.total, bold: true),
    const SizedBox(height: 10),
    Row(
     children: [
     Pill(
      text:
       '${order.payment.emoji.isNotEmpty ? order.payment.emoji : '•'} ${order.payment.label}',
      color: order.payment.color,
      dense: true,
     ),
     const SizedBox(width: 8),
     Expanded(
      child: Text(
      order.addressLabel,
      textAlign: TextAlign.right,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
       fontSize: 11.5, color: cs.onSurfaceVariant),
      ),
     ),
     ],
    ),
    ],
   ),
   ),
   const SizedBox(height: 20),

   // --------------------------------------------------------- Actions
   if (order.status.isActive)
   AppButton(
    label: order.status == OrderStatus.enLivraison
     ? 'Confirmer la réception (code OTP)'
     : 'Simuler l\'étape suivante (démo)',
    icon: order.status == OrderStatus.enLivraison
     ? AppIcons.lock_open_rounded
     : AppIcons.fast_forward_rounded,
    variant: order.status == OrderStatus.enLivraison
     ? AppButtonVariant.success
     : AppButtonVariant.outline,
    onPressed: () => order.status == OrderStatus.enLivraison
     ? _confirmReception(order)
     : _advance(order),
   ),
   if (order.status == OrderStatus.livree && !order.rated)
   AppButton(
    label: 'Noter la commande',
    icon: AppIcons.star_rounded,
    onPressed: () => _openRating(order),
   ),
   if (order.status == OrderStatus.livree && order.rated)
   const InfoBanner(
    emoji: '',
    color: AppColors.warning,
    text: 'Merci pour votre avis ! Il est maintenant visible sur la fiche produit.',
   ),
   if (order.status == OrderStatus.annulee)
   AppButton(
    label: 'Contacter le support',
    icon: AppIcons.support_agent_rounded,
    variant: AppButtonVariant.outline,
    onPressed: () => showAppSnack(
     context, 'Le support vous rappelle sous 15 min', emoji: ''),
   ),
  ],
  ),
 );
 }
}

class _MapMarker extends StatelessWidget {
 const _MapMarker({
 required this.emoji,
 required this.color,
 this.size = 40,
 });

 final String emoji;
 final Color color;
 final double size;

 @override
 Widget build(BuildContext context) {
 return Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
  color: Theme.of(context).colorScheme.surface,
  shape: BoxShape.circle,
  border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
  boxShadow: [
   BoxShadow(
   color: Colors.black.withValues(alpha: 0.08),
   blurRadius: 8,
   offset: const Offset(0, 3),
   ),
  ],
  ),
  alignment: Alignment.center,
  child: Text(emoji, style: TextStyle(fontSize: size * 0.45)),
 );
 }
}

class _TimelineRow extends StatelessWidget {
 const _TimelineRow({
 required this.status,
 required this.time,
 required this.currentIndex,
 required this.index,
 required this.isLast,
 });

 final OrderStatus status;
 final DateTime? time;
 final int currentIndex;
 final int index;
 final bool isLast;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final done = time != null;
 final current = index == currentIndex;

 return IntrinsicHeight(
  child: Row(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
   Column(
   children: [
    Container(
    width: 26,
    height: 26,
    decoration: BoxDecoration(
     color: done || current
      ? (current && !done ? cs.primary.withValues(alpha: 0.15) : cs.primary)
      : cs.surfaceContainerHigh,
     shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: done
     ? AppIcon(AppIcons.check_rounded,
      size: 14, color: cs.onPrimary)
     : current
      ? Container(
       width: 9,
       height: 9,
       decoration: BoxDecoration(
        color: cs.primary,
        shape: BoxShape.circle,
       ),
       )
      : AppIcon(AppIcons.circle_outlined,
       size: 15, color: cs.outlineVariant),
    ),
    if (!isLast)
    Expanded(
     child: Container(
     width: 2.5,
     margin: const EdgeInsets.symmetric(vertical: 3),
     decoration: BoxDecoration(
      color: done ? cs.primary : cs.outlineVariant,
      borderRadius: BorderRadius.circular(2),
     ),
     ),
    ),
   ],
   ),
   const SizedBox(width: 12),
   Expanded(
   child: Padding(
    padding:
     EdgeInsets.only(bottom: isLast ? 0 : 18, top: 3),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(
     '${status.emoji.isNotEmpty ? status.emoji : '•'} ${status.label}',
     style: TextStyle(
      fontSize: 13.5,
      fontWeight: done || current
       ? FontWeight.w700
       : FontWeight.w500,
      color: done || current
       ? cs.onSurface
       : cs.onSurfaceVariant,
     ),
     ),
     const SizedBox(height: 2),
     Text(
     done
      ? '${formatDateShort(time!)} ${formatTime(time!)}'
      : current
       ? 'En cours…'
       : 'À venir',
     style: TextStyle(
      fontSize: 11.5, color: cs.onSurfaceVariant),
     ),
    ],
    ),
   ),
   ),
  ],
  ),
 );
 }
}

/// Sprite livreur : camion Rive (`vehicles.riv`, machine bumpy ) que l'on
/// peut tapoter pour déclencher l'entrée bump (rebond de suspension).
/// Repli sur le marqueur emoji en mode réduit ou si le fichier échoue.
class _CourierSprite extends StatefulWidget {
 const _CourierSprite();

 @override
 State<_CourierSprite> createState() => _CourierSpriteState();
}

class _CourierSpriteState extends State<_CourierSprite> {
 RiveWidgetController? _controller;

 void _bump() {
 final controller = _controller;
 if (controller == null) return;
 // ignore: deprecated_member_use
 controller.stateMachine.trigger('bump')?.fire();
 AppMotion.tap();
 }

 @override
 Widget build(BuildContext context) {
 return ExcludeSemantics(
  child: GestureDetector(
  onTap: _bump,
  child: SizedBox(
  width: 76,
  height: 54,
  child: RiveStage(
   'assets/rive/vehicles.riv',
   stateMachine: 'bumpy',
   fit: BoxFit.contain,
   onReady: (controller) => _controller = controller,
   fallback: const _MapMarker(
    emoji: '', color: AppColors.success, size: 44),
  ),
  ),
  ),
 );
 }
}

/// Sélecteur d'étoiles : animation Rive interactive (`rating.riv`) au-dessus
/// de zones tactiles ; repli Material en mode réduit/échec.
class _RatingPicker extends StatefulWidget {
 const _RatingPicker({required this.rating, required this.onChanged});

 final int rating;
 final ValueChanged<int> onChanged;

 @override
 State<_RatingPicker> createState() => _RatingPickerState();
}

class _RatingPickerState extends State<_RatingPicker> {
 RiveWidgetController? _controller;

 void _fire(int n) {
 final controller = _controller;
 if (controller == null) return;
 // Les entrées du fichier s'appellent 1_star … 5_stars :
 // on tente les deux variantes, sans effet si absentes.
 for (final name in ['${n}_stars', '${n}_star']) {
  // ignore: deprecated_member_use
  controller.stateMachine.trigger(name)?.fire();
 }
 }

 void _select(int n) {
 widget.onChanged(n);
 AppMotion.tap();
 _fire(n);
 }

 @override
 Widget build(BuildContext context) {
 final materialRow = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  for (var i = 1; i <= 5; i++)
   GestureDetector(
   behavior: HitTestBehavior.opaque,
   onTap: () => _select(i),
   child: SizedBox(
    width: 44,
    height: 44,
    child: Padding(
     padding: const EdgeInsets.all(3),
     child: Icon(
     i <= widget.rating
      ? Icons.star_rounded
      : Icons.star_outline_rounded,
     size: 38,
     color: AppColors.warning,
     ),
    ),
   ),
   ),
  ],
 );

 if (!AppMotion.on(context)) return materialRow;

 return SizedBox(
  height: 64,
  child: Stack(
  alignment: Alignment.center,
  children: [
   RiveStage(
   'assets/rive/rating.riv',
   stateMachine: 'State Machine 1',
   fit: BoxFit.contain,
   onReady: (controller) {
    _controller = controller;
    _fire(widget.rating);
   },
   fallback: materialRow,
   ),
   Row(
   mainAxisAlignment: MainAxisAlignment.center,
   children: [
    for (var i = 1; i <= 5; i++)
    GestureDetector(
     onTap: () => _select(i),
     behavior: HitTestBehavior.opaque,
     child: const SizedBox(width: 42, height: 64),
    ),
   ],
   ),
  ],
  ),
 );
 }
}
