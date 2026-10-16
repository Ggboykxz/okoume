import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

/// Choix du client transmis de la commande vers l'écran de paiement.
class CheckoutPayload {
 const CheckoutPayload({
 required this.method,
 required this.mode,
 required this.speed,
 required this.address,
 required this.deliveryFee,
 required this.total,
 });

 final PaymentMethod method;
 final DeliveryMode mode;
 final DeliverySpeed speed;
 final Address address;
 final int deliveryFee;
 final int total;
}

class CheckoutScreen extends ConsumerStatefulWidget {
 const CheckoutScreen({super.key});

 @override
 ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
 int _step = 0;
 DeliveryMode _mode = DeliveryMode.domicile;
 DeliverySpeed _speed = DeliverySpeed.standard;
 PaymentMethod _method = PaymentMethod.airtel;
 String? _addressId;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final cart = ref.watch(cartProvider);
 final totals = ref.watch(cartTotalsProvider);
 final addresses = ref.watch(addressesProvider);
 final user = ref.watch(authProvider);

 if (cart.lines.isEmpty) {
  return Scaffold(
  appBar: AppBar(title: const Text('Commande')),
  body: EmptyState(
   emoji: '',
   title: 'Votre panier est vide',
   message: 'Ajoutez des articles avant de passer commande.',
   actionLabel: 'Découvrir les produits',
   onAction: () => context.go('/main'),
  ),
  );
 }

 final address = addresses.firstWhere(
  (a) => a.id == _addressId,
  orElse: () => addresses.firstWhere(
  (a) => a.isDefault,
  orElse: () => addresses.first,
  ),
 );
 final freeBase =
  totals.subtotal >= 25000 || cart.promo?.freeShipping == true;
 final modeFee =
  _mode == DeliveryMode.retraitVendeur ? 0 : (freeBase ? 0 : _mode.fee);
 final speedFee =
  _speed == DeliverySpeed.express ? DeliverySpeed.express.extraFee : 0;
 final deliveryFee = modeFee + speedFee;
 final grandTotal = totals.subtotal + deliveryFee - totals.discount;
 final sellerCount =
  cart.lines.map((l) => Mock.productById(l.productId).sellerId).toSet().length;

 return Scaffold(
  appBar: AppBar(
  title: const Text('Finaliser la commande'),
  leading: IconButton(
   icon: const AppIcon(AppIcons.arrow_back_rounded),
   onPressed: () {
   if (_step == 1) {
    setState(() => _step = 0);
   } else {
    context.pop();
   }
   },
  ),
  ),
  body: ListView(
  padding: const EdgeInsets.only(bottom: 24),
  children: [
   Padding(
   padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
   child: StepBar(
    steps: const ['Livraison', 'Paiement', 'Confirmation'],
    current: _step,
   ),
   ),
   ...(_step == 0
    ? _deliveryStep(cs, address, freeBase, sellerCount)
    : _paymentStep(cs, cart, totals, address, user, deliveryFee,
     grandTotal)),
  ],
  ),
  bottomNavigationBar: Container(
  decoration: BoxDecoration(
   color: cs.surface,
   border: Border(top: BorderSide(color: cs.outlineVariant)),
  ),
  child: SafeArea(
   top: false,
   child: Padding(
   padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
   child: _step == 0
    ? AppButton(
     label: 'Continuer vers le paiement',
     icon: AppIcons.arrow_forward_rounded,
     onPressed: () => setState(() => _step = 1),
     )
    : AppButton(
     label: 'Payer ${formatXaf(grandTotal)}',
     icon: AppIcons.lock_rounded,
     onPressed: () {
      if (_method == PaymentMethod.wallet &&
       (user?.balance ?? 0) < grandTotal) {
      showAppSnack(
       context,
       'Solde portefeuille insuffisant — choisissez un autre moyen de paiement.',
       emoji: '',
      );
      return;
      }
      context.push(
      '/payment',
      extra: CheckoutPayload(
       method: _method,
       mode: _mode,
       speed: _speed,
       address: address,
       deliveryFee: deliveryFee,
       total: grandTotal,
      ),
      );
     },
     ),
   ),
  ),
  ),
 );
 }

 // ============================================================== Livraison

 List<Widget> _deliveryStep(
 ColorScheme cs,
 Address address,
 bool freeBase,
 int sellerCount,
 ) {
 return [
  Padding(
  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
  child: Row(
   children: [
   Expanded(
    child: Text('Adresse de livraison',
     style: Theme.of(context).textTheme.titleMedium),
   ),
   GestureDetector(
    onTap: () => _pickAddress(),
    child: Text(
    'Changer',
    style: TextStyle(
     color: cs.primary,
     fontWeight: FontWeight.w700,
     fontSize: 13),
    ),
   ),
   ],
  ),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: AppCard(
   onTap: () => _pickAddress(),
   child: Row(
   children: [
    Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
     color: cs.primary.withValues(alpha: 0.1),
     borderRadius: BorderRadius.circular(13),
    ),
    alignment: Alignment.center,
    child: const Text('', style: TextStyle(fontSize: 19)),
    ),
    const SizedBox(width: 12),
    Expanded(
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Row(
      children: [
      Text(address.label,
       style: const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 14)),
      const SizedBox(width: 8),
      if (address.isDefault)
       const Pill(
       text: 'Par défaut',
       color: AppColors.success,
       dense: true,
       ),
      ],
     ),
     const SizedBox(height: 3),
     Text(
      address.full,
      style: TextStyle(
       fontSize: 12.5, color: cs.onSurfaceVariant),
     ),
     ],
    ),
    ),
    AppIcon(AppIcons.edit_rounded, size: 18, color: cs.onSurfaceVariant),
   ],
   ),
  ),
  ),
  Padding(
  padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
  child: Text('Mode de livraison',
   style: Theme.of(context).textTheme.titleMedium),
  ),
  for (final mode in DeliveryMode.values)
  Padding(
   padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
   child: _OptionCard(
   emoji: mode.emoji.isNotEmpty ? mode.emoji : '•',
   title: mode.label,
   subtitle: mode.hint,
   feeLabel: mode == DeliveryMode.retraitVendeur
    ? 'Gratuit'
    : freeBase || mode.fee == 0
     ? 'Gratuit'
     : formatXaf(mode.fee),
   feeColor: (freeBase || mode == DeliveryMode.retraitVendeur)
    ? AppColors.success
    : null,
   selected: _mode == mode,
   onTap: () {
    setState(() {
    _mode = mode;
    if (mode == DeliveryMode.retraitVendeur) {
     _speed = DeliverySpeed.standard;
    }
    });
   },
   ),
  ),
  if (_mode != DeliveryMode.retraitVendeur) ...[
  Padding(
   padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
   child: Text('Vitesse de livraison',
    style: Theme.of(context).textTheme.titleMedium),
  ),
  Padding(
   padding: const EdgeInsets.symmetric(horizontal: 20),
   child: Wrap(
   spacing: 8,
   runSpacing: 8,
   children: [
    for (final speed in DeliverySpeed.values)
    AppChip(
     label: speed.extraFee > 0
      ? '${speed.label} (+${formatNumber(speed.extraFee)})'
      : speed.label,
     icon: speed == DeliverySpeed.express
      ? AppIcons.bolt_rounded
      : speed == DeliverySpeed.programme
       ? AppIcons.event_rounded
       : AppIcons.schedule_rounded,
     selected: _speed == speed,
     onTap: () => setState(() => _speed = speed),
    ),
   ],
   ),
  ),
  ],
  if (_mode == DeliveryMode.pointRelais) ...[
  Padding(
   padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
   child: AppButton(
   label: 'Choisir une consigne de retrait',
   variant: AppButtonVariant.outline,
   small: true,
   icon: AppIcons.lock_rounded,
   onPressed: () => context.push('/lockers'),
   ),
  ),
  ],
  const SizedBox(height: 18),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: InfoBanner(
   emoji: sellerCount > 1 ? '' : '',
   text: sellerCount > 1
    ? 'Commande multi-vendeurs : $sellerCount colis préparés séparément, un livreur Okoumé les regroupe à votre adresse.'
    : 'Un livreur Okoumé prend en charge votre colis et vous notifiera à chaque étape.',
  ),
  ),
 ];
 }

 void _pickAddress() {
 showAppSheet(
  context,
  Consumer(builder: (context, ref, _) {
  final addresses = ref.watch(addressesProvider);
  final current = _addressId ??
   (addresses.isEmpty
    ? ''
    : addresses
     .firstWhere((a) => a.isDefault,
      orElse: () => addresses.first)
     .id);
  return Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   Padding(
    padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
    child: Text('Choisir une adresse',
     style: Theme.of(context).textTheme.titleMedium),
   ),
   Flexible(
    child: ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
    children: [
     for (final a in addresses)
     Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppListTile(
      emoji: '',
      title:
       a.isDefault ? '${a.label} par défaut' : a.label,
      subtitle: a.full,
      trailing: a.id == current
       ? AppIcon(AppIcons.check_circle_rounded,
        color: Theme.of(context).colorScheme.primary)
       : null,
      onTap: () {
       setState(() => _addressId = a.id);
       Navigator.of(context).pop();
      },
      ),
     ),
    ],
    ),
   ),
   Padding(
    padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
    child: AppButton(
    label: 'Ajouter une adresse',
    icon: AppIcons.add_location_alt_rounded,
    variant: AppButtonVariant.outline,
    height: 48,
    onPressed: () {
     Navigator.of(context).pop();
     _addAddress();
    },
    ),
   ),
   ],
  );
  }),
 );
 }

 void _addAddress() {
 final labelController = TextEditingController(text: 'Maison');
 final detailsController = TextEditingController();
 final cityController = TextEditingController(text: 'Libreville');
 showAppSheet(
  context,
  Padding(
  padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
  child: Column(
   mainAxisSize: MainAxisSize.min,
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   Text('Nouvelle adresse',
    style: Theme.of(context).textTheme.titleMedium),
   const SizedBox(height: 14),
   AppTextField(
    controller: labelController,
    hint: 'Libellé (Maison, Bureau…)',
    icon: AppIcons.label_rounded),
   const SizedBox(height: 10),
   AppTextField(
    controller: detailsController,
    hint: 'Détails (rue, quartier, point de repère…)',
    icon: AppIcons.signpost_rounded,
    maxLines: 2),
   const SizedBox(height: 10),
   AppTextField(
    controller: cityController,
    hint: 'Ville',
    icon: AppIcons.location_city_rounded),
   const SizedBox(height: 16),
   AppButton(
    label: 'Enregistrer l\'adresse',
    icon: AppIcons.check_rounded,
    onPressed: () {
    final details = detailsController.text.trim();
    if (details.length < 5) {
     showAppSnack(context,
      'Précisez la rue ou le quartier de livraison.',
      emoji: '');
     return;
    }
    final address = Address(
     id: 'a-${DateTime.now().millisecondsSinceEpoch}',
     label: labelController.text.trim().isEmpty
      ? 'Adresse'
      : labelController.text.trim(),
     details: details,
     city: cityController.text.trim().isEmpty
      ? 'Libreville'
      : cityController.text.trim(),
    );
    ref.read(addressesProvider.notifier).add(address);
    setState(() => _addressId = address.id);
    Navigator.of(context).pop();
    showAppSnack(context, 'Adresse ajoutée', emoji: '');
    },
   ),
   ],
  ),
  ),
 );
 }

 // =============================================================== Paiement

 List<Widget> _paymentStep(
 ColorScheme cs,
 CartState cart,
 CartTotals totals,
 Address address,
 AppUser? user,
 int deliveryFee,
 int grandTotal,
 ) {
 final walletBalance = user?.balance ?? 0;
 return [
  Padding(
  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
  child: Text('Moyen de paiement',
   style: Theme.of(context).textTheme.titleMedium),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: _method == PaymentMethod.cash
   ? InfoBanner(
    emoji: '',
    color: AppColors.warning,
    text:
     'Paiement à la livraison : préparez ${formatXaf(grandTotal)} en espèces. Vérifiez le colis avant de payer.',
    )
   : const InfoBanner(
    emoji: '',
    color: AppColors.success,
    text:
     'Paiement protégé par escrow : votre argent est bloqué par Okoumé et versé au vendeur seulement après votre confirmation de réception.',
    ),
  ),
  const SizedBox(height: 12),
  for (final method in PaymentMethod.values)
  Padding(
   padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
   child: _MethodCard(
   method: method,
   selected: _method == method,
   subtitle: method == PaymentMethod.wallet
    ? 'Solde : ${formatXaf(walletBalance)}'
    : method.tagline,
   warn: method == PaymentMethod.wallet &&
    walletBalance < grandTotal &&
    _method == PaymentMethod.wallet,
   onTap: () => setState(() => _method = method),
   ),
  ),
  Padding(
  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
  child: Text('Récapitulatif',
   style: Theme.of(context).textTheme.titleMedium),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: AppCard(
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
    label: _speed == DeliverySpeed.express
     ? 'Livraison (${_mode.label.toLowerCase()} express)'
     : 'Livraison (${_mode.label.toLowerCase()})',
    amount: deliveryFee,
    free: deliveryFee == 0,
    ),
    Divider(height: 22, color: cs.outlineVariant),
    AmountRow(
     label: 'Total à payer', amount: grandTotal, bold: true),
   ],
   ),
  ),
  ),
  const SizedBox(height: 12),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: AppCard(
   padding: const EdgeInsets.all(14),
   child: Column(
   children: [
    Row(
    children: [
     AppIcon(AppIcons.location_on_rounded, size: 16, color: cs.primary),
     const SizedBox(width: 6),
     Expanded(
     child: Text(
      address.full,
      style: const TextStyle(
       fontSize: 12.5, fontWeight: FontWeight.w600),
     ),
     ),
    ],
    ),
    const SizedBox(height: 8),
    Row(
    children: [
     AppIcon(AppIcons.delivery_dining_rounded,
      size: 16, color: cs.primary),
     const SizedBox(width: 6),
     Expanded(
     child: Text(
      '${_mode.label} ${_speed.label}',
      style: const TextStyle(
       fontSize: 12.5, fontWeight: FontWeight.w600),
     ),
     ),
    ],
    ),
   ],
   ),
  ),
  ),
  const SizedBox(height: 16),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Text(
   'En payant, vous acceptez les Conditions générales d\'Okoumé. Les prix sont en francs CFA (XAF), taxes incluses.',
   textAlign: TextAlign.center,
   style: TextStyle(
    fontSize: 11, color: cs.onSurfaceVariant, height: 1.5),
  ),
  ),
 ];
 }
}

class _OptionCard extends StatelessWidget {
 const _OptionCard({
 required this.emoji,
 required this.title,
 required this.subtitle,
 required this.feeLabel,
 required this.selected,
 required this.onTap,
 this.feeColor,
 });

 final String emoji;
 final String title;
 final String subtitle;
 final String feeLabel;
 final bool selected;
 final VoidCallback onTap;
 final Color? feeColor;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return GestureDetector(
  onTap: onTap,
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 160),
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
  decoration: BoxDecoration(
   color: selected ? cs.primary.withValues(alpha: 0.06) : cs.surface,
   borderRadius: BorderRadius.circular(16),
   border: Border.all(
   color: selected ? cs.primary : cs.outlineVariant,
   width: selected ? 1.6 : 1,
   ),
  ),
  child: Row(
   children: [
   Text(emoji, style: const TextStyle(fontSize: 22)),
   const SizedBox(width: 12),
   Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(title,
      style: const TextStyle(
       fontWeight: FontWeight.w700, fontSize: 14)),
     const SizedBox(height: 2),
     Text(subtitle,
      style: TextStyle(
       fontSize: 12, color: cs.onSurfaceVariant)),
    ],
    ),
   ),
   Text(
    feeLabel,
    style: TextStyle(
    fontWeight: FontWeight.w800,
    fontSize: 13,
    color: feeColor ?? cs.onSurface,
    ),
   ),
   const SizedBox(width: 10),
   AppIcon(
    selected
     ? AppIcons.check_circle_rounded
     : AppIcons.radio_button_unchecked_rounded,
    size: 22,
    color: selected ? cs.primary : cs.outlineVariant,
   ),
   ],
  ),
  ),
 );
 }
}

class _MethodCard extends StatelessWidget {
 const _MethodCard({
 required this.method,
 required this.selected,
 required this.subtitle,
 required this.onTap,
 this.warn = false,
 });

 final PaymentMethod method;
 final bool selected;
 final String subtitle;
 final VoidCallback onTap;
 final bool warn;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return GestureDetector(
  onTap: onTap,
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 160),
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  decoration: BoxDecoration(
   color: selected ? cs.primary.withValues(alpha: 0.06) : cs.surface,
   borderRadius: BorderRadius.circular(16),
   border: Border.all(
   color: selected ? cs.primary : cs.outlineVariant,
   width: selected ? 1.6 : 1,
   ),
  ),
  child: Row(
   children: [
   Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
    color: method.color.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(13),
    ),
    alignment: Alignment.center,
    child:
     Text(method.emoji.isNotEmpty ? method.emoji : '•', style: const TextStyle(fontSize: 16)),
   ),
   const SizedBox(width: 12),
   Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Text(method.label,
      style: const TextStyle(
       fontWeight: FontWeight.w700, fontSize: 14)),
     const SizedBox(height: 2),
     Text(
     subtitle,
     style: TextStyle(
      fontSize: 12,
      color: warn ? AppColors.danger : cs.onSurfaceVariant,
      fontWeight: warn ? FontWeight.w700 : FontWeight.w500,
     ),
     ),
    ],
    ),
   ),
   if (method.isMobileMoney)
    Pill(text: 'Instantané', color: method.color, dense: true),
   const SizedBox(width: 8),
   AppIcon(
    selected
     ? AppIcons.check_circle_rounded
     : AppIcons.radio_button_unchecked_rounded,
    size: 22,
    color: selected ? cs.primary : cs.outlineVariant,
   ),
   ],
  ),
  ),
 );
 }
}
