import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/art.dart';
import '../../core/ui/common.dart';
import '../../data/models.dart';
import '../../core/ui/app_icons.dart';

/// Connexion par numéro de téléphone (FR-001.1). En démo, le rôle est choisi ici.
class AuthScreen extends ConsumerStatefulWidget {
 const AuthScreen({super.key});

 @override
 ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
 final _phoneController = TextEditingController(text: '07 45 12 33');
 UserRole _role = UserRole.acheteur;

 @override
 void dispose() {
  _phoneController.dispose();
  super.dispose();
 }

 void _submit() {
  final digits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length < 8) {
   showAppSnack(context, 'Entrez un numéro gabonais valide (07 XX XX XX)',
     emoji: '');
   return;
  }
  context.push(
   '/auth/otp',
   extra: ('+241 ${_phoneController.text.trim()}', _role),
  );
 }

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Scaffold(
   body: SafeArea(
    child: ListView(
     padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
     children: [
      const SizedBox(height: 8),
      Row(
       children: [
        const AppLogo(size: 54),
        const SizedBox(width: 12),
        Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text('Okoumé',
            style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 22)),
          Text(
           'Tout le Gabon, dans ma poche',
           style: TextStyle(
             fontSize: 12,
             color: cs.onSurfaceVariant,
             fontWeight: FontWeight.w500),
          ),
         ],
        ),
       ],
      ),
      const SizedBox(height: 34),
      Text('Connexion rapide',
        style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 6),
      Text(
       'Recevez un code par SMS. Pas de mot de passe à retenir.',
       style: TextStyle(color: cs.onSurfaceVariant, height: 1.45),
      ),
      const SizedBox(height: 22),
      // Numéro de téléphone
      Container(
       padding: const EdgeInsets.symmetric(horizontal: 14),
       decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
       ),
       child: Row(
        children: [
         const Text('', style: TextStyle(fontSize: 20)),
         const SizedBox(width: 8),
         Text('+241',
           style: TextStyle(
             fontWeight: FontWeight.w700,
             fontSize: 14.5,
             color: cs.onSurface)),
         const SizedBox(width: 10),
         Expanded(
          child: TextField(
           controller: _phoneController,
           keyboardType: TextInputType.phone,
           style: const TextStyle(
             fontWeight: FontWeight.w700, fontSize: 15),
           decoration: const InputDecoration(
            hintText: '07 45 12 33',
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
           ),
          ),
         ),
        ],
       ),
      ),
      const SizedBox(height: 26),
      Text('Je suis…',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13.5,
          color: cs.onSurfaceVariant)),
      const SizedBox(height: 10),
      for (final role in UserRole.values) ...[
       _RoleCard(
        role: role,
        selected: _role == role,
        onTap: () => setState(() => _role = role),
       ),
       const SizedBox(height: 10),
      ],
      const SizedBox(height: 8),
      InfoBanner(
       emoji: '',
       text: _role == UserRole.acheteur
         ? 'Achat en toute confiance : paiement bloqué jusqu\'à la réception (escrow) et vendeurs vérifiés.'
         : 'Après connexion, votre vérification KYC (CNI + selfie) prend moins de 2 minutes.',
      ),
      const SizedBox(height: 22),
      AppButton(
       label: 'Recevoir le code SMS',
       icon: AppIcons.sms_rounded,
       onPressed: _submit,
      ),
      const SizedBox(height: 14),
      Text(
       'En continuant, vous acceptez les Conditions générales et la Politique de confidentialité d\'Okoumé.',
       textAlign: TextAlign.center,
       style: TextStyle(
         fontSize: 11,
         height: 1.5,
         color: cs.onSurfaceVariant),
      ),
     ],
    ),
   ),
  );
 }
}

class _RoleCard extends StatelessWidget {
 const _RoleCard({
  required this.role,
  required this.selected,
  required this.onTap,
 });

 final UserRole role;
 final bool selected;
 final VoidCallback onTap;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final subtitle = switch (role) {
   UserRole.acheteur => 'Acheter, suivre mes livraisons',
   UserRole.vendeur => 'Vendre et gérer ma boutique',
   UserRole.livreur => 'Effectuer des livraisons et gagner',
  };
  return GestureDetector(
   onTap: onTap,
   child: AnimatedContainer(
    duration: const Duration(milliseconds: 160),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
     color: selected ? cs.primary.withValues(alpha: 0.07) : cs.surface,
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
        color: selected
          ? cs.primary
          : ArtPalette.pair(role.index)[0],
        borderRadius: BorderRadius.circular(13),
       ),
       alignment: Alignment.center,
       child: Text(role.emoji.isNotEmpty ? role.emoji : '•',
         style: const TextStyle(fontSize: 20)),
      ),
      const SizedBox(width: 12),
      Expanded(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(role.label,
           style: const TextStyle(
             fontWeight: FontWeight.w700, fontSize: 14.5)),
         Text(subtitle,
           style: TextStyle(
             fontSize: 12, color: cs.onSurfaceVariant)),
        ],
       ),
      ),
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
