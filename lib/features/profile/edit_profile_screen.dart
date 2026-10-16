import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// C-17 Modifier mon profil — nom, e-mail, ville, avatar emoji.
class EditProfileScreen extends ConsumerStatefulWidget {
 const EditProfileScreen({super.key});

 @override
 ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
 static const _emojiChoices = [
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 ];

 late final TextEditingController _name;
 late final TextEditingController _email;
 late String _emoji;
 String? _city;

 @override
 void initState() {
 super.initState();
 final user = ref.read(authProvider);
 _name = TextEditingController(text: user?.name ?? '');
 _email = TextEditingController(text: user?.email ?? '');
 _emoji = user?.emoji ?? '';
 _city = user?.city;
 }

 @override
 void dispose() {
 _name.dispose();
 _email.dispose();
 super.dispose();
 }

 void _save() {
 final name = _name.text.trim();
 if (name.length < 3) {
  showAppSnack(context, 'Le nom doit contenir au moins 3 caractères',
   emoji: '');
  return;
 }
 final email = _email.text.trim();
 ref.read(authProvider.notifier).updateProfile(
   name: name,
   email: email.isEmpty ? null : email,
   city: _city,
  );
 AppMotion.success();
 showAppSnack(context, 'Profil mis à jour ', emoji: '');
 if (context.canPop()) context.pop();
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final user = ref.watch(authProvider);
 final cities = ref.watch(citiesProvider);

 return Scaffold(
  appBar: AppBar(title: const Text('Modifier mon profil')),
  body: SafeArea(
  child: ListView(
   padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
   children: [
   Center(
    child: Column(
    children: [
     Container(
     width: 90,
     height: 90,
     decoration: BoxDecoration(
      color: cs.primary.withValues(alpha: 0.1),
      shape: BoxShape.circle,
      border: Border.all(
       color: cs.primary.withValues(alpha: 0.35),
       width: 2),
     ),
     alignment: Alignment.center,
     child:
      Text(_emoji, style: const TextStyle(fontSize: 42)),
     ),
     const SizedBox(height: 10),
     SizedBox(
     height: 44,
     child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
        width: 44,
        height: 44,
        decoration: BoxDecoration(
        color: selected
         ? cs.primary.withValues(alpha: 0.14)
         : cs.surfaceContainerHigh,
        shape: BoxShape.circle,
        border: selected
         ? Border.all(color: cs.primary, width: 2)
         : null,
        ),
        alignment: Alignment.center,
        child: Text(choice,
         style: const TextStyle(fontSize: 20)),
       ),
       ),
      );
      },
     ),
     ),
    ],
    ),
   ),
   const SizedBox(height: 18),
   AppTextField(
    controller: _name,
    hint: 'Nom complet',
    icon: AppIcons.person_rounded,
    textCapitalization: TextCapitalization.words,
   ),
   const SizedBox(height: 12),
   AppTextField(
    controller: _email,
    hint: 'E-mail (facultatif)',
    icon: AppIcons.mail_rounded,
    keyboardType: TextInputType.emailAddress,
   ),
   const SizedBox(height: 12),
   AppTextField(
    controller: TextEditingController(text: user?.phone ?? ''),
    hint: 'Téléphone',
    icon: AppIcons.phone_rounded,
    readOnly: true,
    onTap: () => showAppSnack(
    context,
    'Le numéro se modifie via le support (sécurité)',
    emoji: '',
    ),
   ),
   const SizedBox(height: 18),
   Text('Ville de livraison',
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
      AppMotion.tap();
      setState(() => _city = city);
     },
     ),
    ],
   ),
   const SizedBox(height: 24),
   AppButton(
    label: 'Enregistrer',
    icon: AppIcons.check_rounded,
    onPressed: _save,
   ),
   ],
  ),
  ),
 );
 }
}
