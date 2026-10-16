import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/providers.dart';

/// C-24 · Paramètres — apparence, données, notifications, compte.
class SettingsScreen extends ConsumerWidget {
 const SettingsScreen({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;
  final settings = ref.watch(settingsProvider);
  final user = ref.watch(authProvider);

  return Scaffold(
   appBar: AppBar(title: const Text('Paramètres')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
    children: [
     // ----------------------------------------------------- Apparence
     _SectionLabel('Apparence'),
     AppCard(
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        const Text('Thème',
          style:
            TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
         children: [
          for (final mode in const [
           (ThemeMode.light, '️ Clair'),
           (ThemeMode.dark, ' Sombre'),
           (ThemeMode.system, ' Système'),
          ])
           Expanded(
            child: Padding(
             padding: const EdgeInsets.only(right: 8),
             child: AppChip(
              label: mode.$2,
              selected: settings.themeMode == mode.$1,
              onTap: () {
               AppMotion.tap();
               ref
                 .read(settingsProvider.notifier)
                 .setThemeMode(mode.$1);
              },
             ),
            ),
           ),
         ],
        ),
       ],
      ),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Langue',
      subtitle: 'Français (Gabon)',
      onTap: () => showAppSnack(
       context,
       'Seul le français est disponible pour le moment — l\'anglais arrive bientôt',
       emoji: '',
      ),
     ),

     // ---------------------------------------------------- Données réseau
     _SectionLabel('Données et réseau'),
     AppListTile(
      emoji: '',
      title: 'Mode bas débit',
      subtitle:
        'Images allégées, vidéos désactivées — idéal en zone faible connexion',
      trailing: Switch(
       value: settings.lowData,
       activeThumbColor: cs.primary,
       onChanged: (v) {
        AppMotion.tap();
        ref.read(settingsProvider.notifier).toggleLowData(v);
       },
      ),
      onTap: () => ref
        .read(settingsProvider.notifier)
        .toggleLowData(!settings.lowData),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Mode hors ligne',
      subtitle: settings.online
        ? 'Simulez une coupure réseau (contenu mis en cache)'
        : 'Actif — contenu servi depuis le cache local',
      trailing: Switch(
       value: !settings.online,
       activeThumbColor: cs.primary,
       onChanged: (v) {
        AppMotion.tap();
        ref.read(settingsProvider.notifier).setOnline(!v);
       },
      ),
      onTap: () =>
        ref.read(settingsProvider.notifier).setOnline(!settings.online),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '️',
      title: 'Données et stockage',
      subtitle: 'Cache images, téléchargements, Wi-Fi uniquement',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/settings/data'),
     ),

     // -------------------------------------------------- Notifications
     _SectionLabel('Notifications'),
     AppListTile(
      emoji: '',
      title: 'Préférences de notification',
      subtitle: 'Commandes, messages, promos',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/settings/notifications'),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Vibrations (haptique)',
      subtitle: 'Retours tactiles sur les actions importantes',
      trailing: Switch(
       value: true,
       activeThumbColor: cs.primary,
       onChanged: (_) => showAppSnack(
        context,
        'Réglage conservé — les retours tactiles restent actifs en démo',
        emoji: '',
       ),
      ),
     ),

     // -------------------------------------------------------- Aide/légal
     _SectionLabel('Aide et informations'),
     AppListTile(
      emoji: '',
      title: 'Centre d\'aide',
      subtitle: 'FAQ, contact, litiges',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/help'),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: 'ℹ️',
      title: 'À propos d\'Okoumé',
      subtitle: 'Version, équipe, mentions',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/about'),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Conditions générales',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/legal/terms'),
     ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '',
      title: 'Confidentialité',
      trailing: const AppIcon(AppIcons.chevron_right_rounded),
      onTap: () => context.push('/legal/privacy'),
     ),

     // ------------------------------------------------------- Compte
     _SectionLabel('Compte'),
     if (user != null)
      AppListTile(
       emoji: '',
       title: 'Se déconnecter',
       subtitle: user.phone,
       onTap: () => _confirmLogout(context, ref),
      ),
     const SizedBox(height: 10),
     AppListTile(
      emoji: '️',
      title: 'Supprimer mon compte',
      subtitle: 'Action définitive (démo : déconnexion immédiate)',
      onTap: () => _confirmDelete(context, ref),
     ),
     const SizedBox(height: 18),
     const InfoBanner(
      emoji: '🇬🇦',
      color: AppColors.primary,
      text:
        'Okoumé v1.0 · Fait à Libreville avec ️ — données de démonstration, aucun paiement réel.',
     ),
    ],
   ),
  );
 }

 Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text('Se déconnecter ?'),
    content: const Text(
      'Votre panier et vos favoris restent enregistrés sur cet appareil.'),
    actions: [
     TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text('Annuler'),
     ),
     FilledButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text('Déconnecter'),
     ),
    ],
   ),
  );
  if (confirmed != true) return;
  ref.read(authProvider.notifier).logout();
  AppMotion.success();
  if (context.mounted) context.go('/auth');
 }

 Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
   context: context,
   builder: (context) => AlertDialog(
    title: const Text('Supprimer mon compte ?'),
    content: const Text(
      'En démo, la suppression réinitialise votre session immédiatement. '
      'Sur la version réelle, un délai de 30 jours permet de récupérer le compte.'),
    actions: [
     TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Text('Conserver'),
     ),
     FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
      onPressed: () => Navigator.of(context).pop(true),
      child: const Text('Supprimer'),
     ),
    ],
   ),
  );
  if (confirmed != true) return;
  ref.read(authProvider.notifier).logout();
  if (context.mounted) context.go('/auth');
 }
}

/// C-25 · Préférences de notification (démo : état local).
class NotificationSettingsScreen extends StatefulWidget {
 const NotificationSettingsScreen({super.key});

 @override
 State<NotificationSettingsScreen> createState() =>
   _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
  extends State<NotificationSettingsScreen> {
 bool _orders = true;
 bool _chat = true;
 bool _promos = false;
 bool _sound = true;

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Scaffold(
   appBar: AppBar(title: const Text('Notifications')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
    children: [
     for (final entry in [
      ('', 'Suivi de commandes',
        'Confirmation, préparation, arrivée du livreur', _orders,
        (bool v) => setState(() => _orders = v)),
      ('', 'Messages',
        'Réponses des vendeurs et du support', _chat,
        (bool v) => setState(() => _chat = v)),
      ('', 'Promos et nouveautés',
        'Deux par semaine maximum, jamais le dimanche', _promos,
        (bool v) => setState(() => _promos = v)),
      ('', 'Sons',
        'Un son discret à la réception des messages', _sound,
        (bool v) => setState(() => _sound = v)),
     ]) ...[
      _SwitchRow(
       emoji: entry.$1,
       title: entry.$2,
       subtitle: entry.$3,
       value: entry.$4,
       onChanged: entry.$5,
      ),
      const SizedBox(height: 10),
     ],
     const SizedBox(height: 8),
     InfoBanner(
      emoji: '️',
      color: cs.primary,
      text:
        'Les notifications sont simulées en démo — aucun vrai message système ne sera envoyé.',
     ),
    ],
   ),
  );
 }
}

/// C-27 · Données et stockage (mode bas débit, cache, hors-ligne).
class DataSettingsScreen extends ConsumerStatefulWidget {
 const DataSettingsScreen({super.key});

 @override
 ConsumerState<DataSettingsScreen> createState() =>
   _DataSettingsScreenState();
}

class _DataSettingsScreenState extends ConsumerState<DataSettingsScreen> {
 bool _wifiOnly = true;
 bool _autoDownload = false;

 @override
 Widget build(BuildContext context) {
  final settings = ref.watch(settingsProvider);
  final cs = Theme.of(context).colorScheme;

  return Scaffold(
   appBar: AppBar(title: const Text('Données et stockage')),
   body: ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
    children: [
     AppCard(
      child: Row(
       children: [
        const Text('️', style: TextStyle(fontSize: 26)),
        const SizedBox(width: 12),
        Expanded(
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Text('Cache images et données',
             style: TextStyle(
               fontSize: 13.5, fontWeight: FontWeight.w700)),
           const SizedBox(height: 3),
           Text(
            '37,4 Mo utilisés · dernière mise à jour aujourd\'hui',
            style: TextStyle(
              fontSize: 12, color: cs.onSurfaceVariant),
           ),
          ],
         ),
        ),
        TextButton(
         onPressed: () => showAppSnack(
          context,
          'Cache vidé — 37,4 Mo libérés (démo)',
          emoji: '',
         ),
         child: const Text('Vider'),
        ),
       ],
      ),
     ),
     const SizedBox(height: 14),
     _SwitchRow(
      emoji: '',
      title: 'Mode bas débit',
      subtitle: 'Compresse les images à 60 % et désactive l\'autoplay',
      value: settings.lowData,
      onChanged: (v) =>
        ref.read(settingsProvider.notifier).toggleLowData(v),
     ),
     const SizedBox(height: 10),
     _SwitchRow(
      emoji: '',
      title: 'Télécharger en Wi-Fi uniquement',
      subtitle: 'Évite de consommer vos données mobiles',
      value: _wifiOnly,
      onChanged: (v) => setState(() => _wifiOnly = v),
     ),
     const SizedBox(height: 10),
     _SwitchRow(
      emoji: '⬇️',
      title: 'Pré-télécharger mes commandes',
      subtitle: 'Photos et factures disponibles hors connexion',
      value: _autoDownload,
      onChanged: (v) => setState(() => _autoDownload = v),
     ),
     const SizedBox(height: 16),
     InfoBanner(
      emoji: settings.online ? '' : '',
      color: settings.online ? AppColors.success : AppColors.danger,
      text: settings.online
        ? 'Vous êtes en ligne. Le contenu se met à jour automatiquement.'
        : 'Mode hors ligne actif : vous naviguez sur le contenu mis en cache.',
     ),
     const SizedBox(height: 16),
     AppButton(
      label: 'Tout télécharger pour ma zone',
      variant: AppButtonVariant.outline,
      icon: AppIcons.download_rounded,
      onPressed: () => showAppSnack(
       context,
       'Téléchargement simulé : 12 produits et 3 boutiques pour votre zone',
       emoji: '⬇️',
      ),
     ),
    ],
   ),
  );
 }
}

class _SectionLabel extends StatelessWidget {
 const _SectionLabel(this.label);

 final String label;

 @override
 Widget build(BuildContext context) {
  return Padding(
   padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
   child: Text(
    label.toUpperCase(),
    style: TextStyle(
     fontSize: 11,
     fontWeight: FontWeight.w800,
     letterSpacing: 0.8,
     color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
   ),
  );
 }
}

class _SwitchRow extends StatelessWidget {
 const _SwitchRow({
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
