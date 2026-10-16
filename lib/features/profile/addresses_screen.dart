import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class AddressesScreen extends ConsumerWidget {
 const AddressesScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final addresses = ref.watch(addressesProvider);

  return Scaffold(
   appBar: AppBar(
    title: const Text('Mes adresses'),
    actions: [
     IconButton(
      icon: const AppIcon(AppIcons.add_rounded),
      onPressed: () => _addAddress(context, ref),
     ),
    ],
   ),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
    children: [
     for (final a in addresses)
      Padding(
       padding: const EdgeInsets.only(bottom: 10),
       child: AppListTile(
        emoji: '',
        title: a.label,
        subtitle: a.full,
        trailing: a.isDefault
          ? const Pill(
            text: 'Par défaut',
            color: AppColors.success,
            dense: true,
           )
          : null,
        onTap: () => showAppSnack(
         context,
         a.isDefault
           ? 'Adresse utilisée par défaut'
           : 'Utilisée lors du prochain paiement',
         emoji: '',
        ),
       ),
      ),
     const SizedBox(height: 10),
     AppButton(
      label: 'Ajouter une adresse',
      icon: AppIcons.add_location_alt_rounded,
      variant: AppButtonVariant.outline,
      onPressed: () => _addAddress(context, ref),
     ),
     const SizedBox(height: 18),
     InfoBanner(
      emoji: '',
      text:
        'Astuce : ajoutez un point de repère connu (pharmacie, carrefour…) pour aider le livreur à vous trouver rapidement.',
      color: Theme.of(context).colorScheme.secondary,
     ),
    ],
   ),
  );
 }

 void _addAddress(BuildContext context, WidgetRef ref) {
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
        ref.read(addressesProvider.notifier).add(
           Address(
            id: 'a-${DateTime.now().millisecondsSinceEpoch}',
            label: labelController.text.trim().isEmpty
              ? 'Adresse'
              : labelController.text.trim(),
            details: details,
            city: cityController.text.trim().isEmpty
              ? 'Libreville'
              : cityController.text.trim(),
           ),
          );
        Navigator.of(context).pop();
        showAppSnack(context, 'Adresse ajoutée', emoji: '');
       },
      ),
     ],
    ),
   ),
  );
 }
}
