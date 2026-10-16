import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// C-11 Permissions (dernière étape de la première connexion).
/// Notifications, position et offres — tout est simulé en démo.
class PermissionsScreen extends ConsumerStatefulWidget {
 const PermissionsScreen({super.key});

 @override
 ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
 bool _notifications = true;
 bool _location = true;
 bool _promos = true;

 void _finish() {
 ref.read(settingsProvider.notifier).seenOnboarding();
 AppMotion.success();
 showAppSnack(context, 'Bienvenue sur Okoumé ! ', emoji: '');
 context.go('/main');
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 return Scaffold(
  appBar: AppBar(
  title: const Text('Permissions'),
  bottom: PreferredSize(
   preferredSize: const Size.fromHeight(34),
   child: Padding(
   padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
   child: StepBar(
    steps: const ['Profil', 'Zone', 'Notifs'],
    current: 2,
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
     Text('Restez au courant ',
      style: Theme.of(context).textTheme.titleMedium),
     const SizedBox(height: 6),
     Text(
     'Okoumé utilise ces autorisations uniquement pour vous servir. Vous pouvez tout modifier dans les réglages.',
     style: TextStyle(
      fontSize: 13,
      height: 1.45,
      color: cs.onSurfaceVariant),
     ),
    ],
    ),
   ),
   const SizedBox(height: 16),
   MotionEnter(
    order: 1,
    child: _PermissionTile(
    emoji: '',
    title: 'Notifications',
    subtitle:
     'Commandes, messages vendeurs, arrivée du livreur',
    value: _notifications,
    onChanged: (v) => setState(() => _notifications = v),
    ),
   ),
   const SizedBox(height: 10),
   MotionEnter(
    order: 2,
    child: _PermissionTile(
    emoji: '',
    title: 'Position',
    subtitle: 'Livraison au plus proche, frais exacts',
    value: _location,
    onChanged: (v) => setState(() => _location = v),
    ),
   ),
   const SizedBox(height: 10),
   MotionEnter(
    order: 3,
    child: _PermissionTile(
    emoji: '',
    title: 'Offres et promos',
    subtitle: 'Deux messages par semaine maximum, jamais le dimanche',
    value: _promos,
    onChanged: (v) => setState(() => _promos = v),
    ),
   ),
   const SizedBox(height: 16),
   const InfoBanner(
    emoji: '',
    color: AppColors.primary,
    text:
     'En démo, aucune vraie permission système n\'est demandée : ces réglages pilotent uniquement l\'interface.',
   ),
   const SizedBox(height: 22),
   AppButton(
    label: 'Commencer sur Okoumé',
    icon: AppIcons.rocket_launch_rounded,
    onPressed: _finish,
   ),
   const SizedBox(height: 8),
   Center(
    child: TextButton(
    onPressed: _finish,
    child: Text(
     'Plus tard',
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

class _PermissionTile extends StatelessWidget {
 const _PermissionTile({
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
  padding: const EdgeInsets.fromLTRB(14, 16, 8, 12),
  decoration: BoxDecoration(
  color: cs.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: cs.outlineVariant),
  ),
  child: Row(
  children: [
   Container(
   width: 40,
   height: 40,
   decoration: BoxDecoration(
    color: cs.primary.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
   ),
   alignment: Alignment.center,
   child: Text(emoji, style: const TextStyle(fontSize: 19)),
   ),
   const SizedBox(width: 12),
   Expanded(
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(title,
     style: const TextStyle(
      fontSize: 13.5, fontWeight: FontWeight.w700)),
    const SizedBox(height: 2),
    Text(
     subtitle,
     style: TextStyle(
      fontSize: 11.5,
      height: 1.35,
      color: cs.onSurfaceVariant),
    ),
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
