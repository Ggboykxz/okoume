import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// V-16 / V-17 / V-22 Formulaire produit vendeur — création et édition.
/// Photos (emoji + appareil simulé), prix, stock, catégorie, livraison.
class ProductFormScreen extends ConsumerStatefulWidget {
 const ProductFormScreen({super.key, this.productId});

 final String? productId;

 @override
 ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
 static const _emojiChoices = [
 '', '', '', '', '', '', '', '',
 '', '', '', '', '', '', '', '',
 ];

 late final TextEditingController _title;
 late final TextEditingController _desc;
 late final TextEditingController _price;
 late final TextEditingController _oldPrice;
 late final TextEditingController _stock;
 String _emoji = '';
 String _categoryId = 'c2';
 String _city = 'Libreville';
 bool _express = false;
 bool _isService = false;

 bool get _isEdit => widget.productId != null;

 @override
 void initState() {
 super.initState();
 final product = _isEdit
  ? ref.read(productByIdProvider(widget.productId!))
  : null;
 _title = TextEditingController(text: product?.title ?? '');
 _desc = TextEditingController(text: product?.description ?? '');
 _price =
  TextEditingController(text: product == null ? '' : '${product.price}');
 _oldPrice = TextEditingController(
  text: product?.oldPrice == null ? '' : '${product!.oldPrice}');
 _stock =
  TextEditingController(text: product == null ? '10' : '${product.stock}');
 if (product != null) {
  _emoji = product.emoji.isNotEmpty ? product.emoji : '•';
  _categoryId = product.categoryId;
  _city = product.city;
  _express = product.express;
  _isService = product.isService;
 }
 }

 @override
 void dispose() {
 _title.dispose();
 _desc.dispose();
 _price.dispose();
 _oldPrice.dispose();
 _stock.dispose();
 super.dispose();
 }

 void _save() {
 final title = _title.text.trim();
 final price = int.tryParse(_price.text.replaceAll(' ', ''));
 if (title.length < 4) {
  showAppSnack(context, 'Le titre doit faire au moins 4 caractères',
   emoji: '');
  return;
 }
 if (price == null || price <= 0) {
  showAppSnack(context, 'Entrez un prix valide en FCFA', emoji: '');
  return;
 }
 final oldPrice = int.tryParse(_oldPrice.text.replaceAll(' ', ''));
 if (oldPrice != null && oldPrice <= price) {
  showAppSnack(context, 'Le prix barré doit être supérieur au prix',
   emoji: '');
  return;
 }
 final stock = _isService ? 999 : (int.tryParse(_stock.text) ?? 1);
 final notifier = ref.read(sellerProvider.notifier);

 if (_isEdit) {
  final existing = ref.read(productByIdProvider(widget.productId!));
  if (existing != null) {
  notifier.editProduct(
   Product(
   id: existing.id,
   title: title,
   price: price,
   oldPrice: oldPrice,
   emoji: _emoji,
   seed: existing.seed,
   categoryId: _categoryId,
   sellerId: existing.sellerId,
   rating: existing.rating,
   reviews: existing.reviews,
   sold: existing.sold,
   stock: stock,
   city: _city,
   description: _desc.text.trim(),
   tags: existing.tags,
   variants: existing.variants,
   characteristics: existing.characteristics,
   express: _express,
   isService: _isService,
   condition: existing.condition,
   createdAt: existing.createdAt,
   ),
  );
  AppMotion.success();
  showAppSnack(context, 'Annonce mise à jour ', emoji: '');
  }
 } else {
  notifier.publish(
  title: title,
  price: price,
  oldPrice: oldPrice,
  emoji: _emoji,
  seed: DateTime.now().millisecondsSinceEpoch % 1000,
  categoryId: _categoryId,
  description: _desc.text.trim(),
  stock: stock,
  city: _city,
  tags: const ['Nouveau'],
  express: _express,
  isService: _isService,
  );
  AppMotion.success();
  showAppSnack(context, 'Annonce publiée — visible par les acheteurs ',
   emoji: '');
 }
 if (context.canPop()) context.pop();
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;

 return Scaffold(
  appBar: AppBar(
  title: Text(_isEdit ? 'Modifier l\'annonce' : 'Nouvelle annonce'),
  ),
  body: SafeArea(
  child: Column(
   children: [
   Expanded(
    child: ListView(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
    children: [
     // ---------------------------------------------------- V-17 Photos
     Text('Photos du produit',
      style: Theme.of(context).textTheme.titleSmall),
     const SizedBox(height: 10),
     MotionEnter(
     child: Container(
      height: 130,
      decoration: BoxDecoration(
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Text(_emoji, style: const TextStyle(fontSize: 40)),
       const SizedBox(height: 6),
       Text(
       'Photo de couverture (démo : emoji)',
       style: TextStyle(
        fontSize: 11.5, color: cs.onSurfaceVariant),
       ),
      ],
      ),
     ),
     ),
     const SizedBox(height: 10),
     SizedBox(
     height: 46,
     child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _emojiChoices.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, i) {
      final choice = _emojiChoices[i];
      final selected = choice == _emoji;
      return Pressable(
       scale: 0.9,
       child: GestureDetector(
       onTap: () {
        AppMotion.tap();
        setState(() => _emoji = choice);
       },
       child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
        color: selected
         ? cs.primary.withValues(alpha: 0.14)
         : cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(13),
        border: selected
         ? Border.all(color: cs.primary, width: 2)
         : null,
        ),
        alignment: Alignment.center,
        child: Text(choice,
         style: const TextStyle(fontSize: 21)),
       ),
       ),
      );
      },
     ),
     ),
     const SizedBox(height: 10),
     AppButton(
     label: 'Ajouter une vraie photo',
     variant: AppButtonVariant.outline,
     small: true,
     icon: AppIcons.photo_camera_rounded,
     onPressed: () => showAppSnack(
      context,
      'Appareil photo simulé en démo — jusqu\'à 8 photos en production',
      emoji: '',
     ),
     ),
     const SizedBox(height: 20),

     // ---------------------------------------------------- V-16 Détails
     AppTextField(
     controller: _title,
     hint: 'Titre de l\'annonce (ex. iPhone 13 128 Go)',
     icon: AppIcons.title_rounded,
     textCapitalization: TextCapitalization.sentences,
     ),
     const SizedBox(height: 12),
     AppTextField(
     controller: _desc,
     hint: 'Description : état, taille, garantie, ce qui est inclus…',
     icon: AppIcons.notes_rounded,
     maxLines: 4,
     ),
     const SizedBox(height: 18),
     Text('Catégorie',
      style: Theme.of(context).textTheme.titleSmall),
     const SizedBox(height: 10),
     Wrap(
     spacing: 8,
     runSpacing: 8,
     children: [
      for (final category in Mock.categories)
      AppChip(
       label: '${category.emoji.isNotEmpty ? category.emoji : '•'} ${category.name}',
       selected: _categoryId == category.id,
       onTap: () {
       AppMotion.tap();
       setState(() => _categoryId = category.id);
       },
      ),
     ],
     ),
     const SizedBox(height: 18),
     Text('Prix (FCFA)',
      style: Theme.of(context).textTheme.titleSmall),
     const SizedBox(height: 10),
     Row(
     children: [
      Expanded(
      child: AppTextField(
       controller: _price,
       hint: 'Prix',
       keyboardType: TextInputType.number,
      ),
      ),
      const SizedBox(width: 10),
      Expanded(
      child: AppTextField(
       controller: _oldPrice,
       hint: 'Prix barré (facultatif)',
       keyboardType: TextInputType.number,
      ),
      ),
     ],
     ),
     const SizedBox(height: 18),
     Text('Stock et livraison',
      style: Theme.of(context).textTheme.titleSmall),
     const SizedBox(height: 10),
     if (!_isService)
     AppTextField(
      controller: _stock,
      hint: 'Quantité en stock',
      icon: AppIcons.shopping_bag_rounded,
      keyboardType: TextInputType.number,
     ),
     const SizedBox(height: 10),
     _ToggleRow(
     emoji: '',
     title: 'C\'est un service',
     subtitle: 'Prestation sans stock ni livraison',
     value: _isService,
     onChanged: (v) => setState(() => _isService = v),
     ),
     const SizedBox(height: 10),
     _ToggleRow(
     emoji: '',
     title: 'Livraison express possible',
     subtitle: 'Le produit apparaît dans le filtre Express ',
     value: _express,
     onChanged: (v) => setState(() => _express = v),
     ),
     const SizedBox(height: 18),
     Text('Ville',
      style: Theme.of(context).textTheme.titleSmall),
     const SizedBox(height: 10),
     Wrap(
     spacing: 8,
     runSpacing: 8,
     children: [
      for (final city in ref.watch(citiesProvider))
      AppChip(
       label: city,
       selected: _city == city,
       onTap: () {
       AppMotion.tap();
       setState(() => _city = city);
       },
      ),
     ],
     ),
     const SizedBox(height: 8),
    ],
    ),
   ),
   Padding(
    padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
    child: Column(
    children: [
     AppButton(
     label: _isEdit
      ? 'Enregistrer les modifications'
      : 'Publier l\'annonce',
     icon: _isEdit
      ? AppIcons.check_rounded
      : AppIcons.rocket_launch_rounded,
     onPressed: _save,
     ),
     const SizedBox(height: 4),
     Text(
     _isEdit
      ? 'Les changements sont visibles immédiatement.'
      : 'Vous pourrez modifier ou retirer l\'annonce à tout moment.',
     style:
      TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
     ),
    ],
    ),
   ),
   ],
  ),
  ),
 );
 }
}

class _ToggleRow extends StatelessWidget {
 const _ToggleRow({
 required this.emoji,
 required this.title,
 required this.subtitle,
 required this.value,
 required this.onChanged,
 });

 final String emoji;
 final String title;
 final String subtitle;
 final bool value;
 final ValueChanged<bool> onChanged;

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Container(
  padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
  decoration: BoxDecoration(
  color: cs.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: cs.outlineVariant),
  ),
  child: Row(
  children: [
   Text(emoji, style: const TextStyle(fontSize: 19)),
   const SizedBox(width: 12),
   Expanded(
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(title,
     style: const TextStyle(
      fontSize: 13.5, fontWeight: FontWeight.w700)),
    const SizedBox(height: 2),
    Text(subtitle,
     style: TextStyle(
      fontSize: 11.5, color: cs.onSurfaceVariant)),
    ],
   ),
   ),
   Switch(
   value: value,
   activeThumbColor: cs.primary,
   onChanged: (v) {
    AppMotion.tap();
    onChanged(v);
   },
   ),
  ],
  ),
 );
 }
}
