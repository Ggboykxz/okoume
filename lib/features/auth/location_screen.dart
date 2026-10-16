import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// C-10 · Zone de livraison (première connexion).
/// Choix de la ville + quartier ; la position GPS est simulée en démo.
class DeliveryLocationScreen extends ConsumerStatefulWidget {
 const DeliveryLocationScreen({super.key});

 @override
 ConsumerState<DeliveryLocationScreen> createState() =>
   _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState
  extends ConsumerState<DeliveryLocationScreen> {
 String? _city;
 final _quartier = TextEditingController();

 @override
 void initState() {
  super.initState();
  _city = ref.read(authProvider)?.city;
 }

 @override
 void dispose() {
  _quartier.dispose();
  super.dispose();
 }

 void _detect() {
  setState(() => _city = 'Libreville');
  AppMotion.success();
  showAppSnack(context, 'Position GPS simulée : Libreville, Akébé',
    emoji: '');
 }

 void _next() {
  if (_city == null) {
   showAppSnack(context, 'Choisissez votre ville de livraison', emoji: '️');
   return;
  }
  ref.read(authProvider.notifier).updateProfile(city: _city);
  AppMotion.tap();
  context.push('/auth/permissions');
 }

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final cities = ref.watch(citiesProvider);

  return Scaffold(
   appBar: AppBar(
    title: const Text('Zone de livraison'),
    bottom: PreferredSize(
     preferredSize: const Size.fromHeight(34),
     child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: StepBar(
       steps: const ['Profil', 'Zone', 'Notifs'],
       current: 1,
      ),
     ),
    ),
   ),
   body: SafeArea(
    child: ListView(
     padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
     children: [
      MotionEnter(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text('Où livrer vos commandes ?',
           style: Theme.of(context).textTheme.titleMedium),
         const SizedBox(height: 6),
         Text(
          'Nous vous montrerons les vendeurs et livreurs proches de vous, avec des frais de livraison exacts.',
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: cs.onSurfaceVariant),
         ),
        ],
       ),
      ),
      const SizedBox(height: 16),
      // ------------------------------------------------ GPS (simulé)
      AppButton(
       label: 'Me localiser automatiquement',
       variant: AppButtonVariant.outline,
       icon: AppIcons.my_location_rounded,
       onPressed: _detect,
      ),
      const SizedBox(height: 20),
      Text('Ou choisissez votre ville',
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: cs.onSurfaceVariant)),
      const SizedBox(height: 10),
      Wrap(
       spacing: 9,
       runSpacing: 9,
       children: [
        for (final city in cities)
         AppChip(
          label: city,
          selected: _city == city,
          onTap: () {
           setState(() => _city = city);
           AppMotion.tap();
          },
         ),
       ],
      ),
      const SizedBox(height: 18),
      AppTextField(
       controller: _quartier,
       hint: 'Quartier (ex. Akébé, Glass…)',
       icon: AppIcons.signpost_rounded,
       textCapitalization: TextCapitalization.words,
      ),
      const SizedBox(height: 16),
      const InfoBanner(
       emoji: '',
       color: AppColors.secondary,
       text:
         'Le GPS n\'est pas activé dans cette démo : la détection utilise une position simulée.',
      ),
      const SizedBox(height: 22),
      AppButton(
       label: 'Continuer',
       icon: AppIcons.arrow_forward_rounded,
       onPressed: _next,
      ),
      const SizedBox(height: 8),
      Center(
       child: TextButton(
        onPressed: () => context.push('/auth/permissions'),
        child: Text(
         'Passer cette étape',
         style: TextStyle(
           color: cs.onSurfaceVariant,
           fontWeight: FontWeight.w600),
        ),
       ),
      ),
     ],
    ),
   ),
  );
 }
}
