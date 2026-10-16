import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/app_icons.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/screen_catalog.dart';

/// Index interactif des 317 écrans officiels du CDC (§2 → §6).
///
/// Chaque écran porte son identifiant officiel :
/// - « Réel » : l'écran est implémenté, l'appui ouvre sa vraie route ;
/// - « Démo » : écran hors MVP rendu par `/screen/:id` — contenu fidèle au
///  CDC et **fonctionnel** (formulaires, files d'attente, créations et
///  réglages réels, conservés pendant la session).
class ScreensIndexScreen extends ConsumerStatefulWidget {
 const ScreensIndexScreen({super.key});

 @override
 ConsumerState<ScreensIndexScreen> createState() => _ScreensIndexScreenState();
}

class _ScreensIndexScreenState extends ConsumerState<ScreensIndexScreen> {
 static const _modules = ['Tout', 'C', 'A', 'V', 'L', 'AD'];

 String _module = 'Tout';
 final _query = TextEditingController();

 @override
 void dispose() {
  _query.dispose();
  super.dispose();
 }

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final q = _query.text.trim().toLowerCase();

  final realCount = screenCatalog.where((e) => !e.isPreview).length;
  final total = screenCatalog.length;

  final filtered = [
   for (final e in screenCatalog)
    if ((_module == 'Tout' || e.module == _module) &&
      (q.isEmpty ||
        e.id.toLowerCase().contains(q) ||
        e.title.toLowerCase().contains(q) ||
        e.desc.toLowerCase().contains(q)))
     e,
  ];

  // Liste aplatie : en-têtes de section (String) + entrées.
  final items = <Object>[];
  String? lastGroup;
  for (final e in filtered) {
   final g = '${screenModuleEmojis[e.module]} '
     '${screenModuleLabels[e.module]} · ${screenGroupOf(e)}';
   if (g != lastGroup) {
    items.add(g);
    lastGroup = g;
   }
   items.add(e);
  }

  return Scaffold(
   appBar: AppBar(title: const Text('Index des écrans')),
   body: Column(
    children: [
     Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: AppCard(
       padding: const EdgeInsets.all(14),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
          children: [
           const Text('️', style: TextStyle(fontSize: 20)),
           const SizedBox(width: 10),
           Expanded(
            child: Text(
             'Catalogue officiel Okoumé — $total écrans',
             style: const TextStyle(
               fontWeight: FontWeight.w700, fontSize: 13.5),
            ),
           ),
          ],
         ),
         const SizedBox(height: 10),
         ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
           value: realCount / total,
           minHeight: 8,
           backgroundColor: cs.surfaceContainerHigh,
          ),
         ),
         const SizedBox(height: 8),
         Text(
          '$realCount écrans réels · ${total - realCount} aperçus de démo. '
          'L’admin (AD) est un panel web : aperçu intégré pour la démo.',
          style: TextStyle(
           fontSize: 11.5,
           height: 1.4,
           color: cs.onSurfaceVariant,
          ),
         ),
        ],
       ),
      ),
     ),
     SizedBox(
      height: 54,
      child: ListView.separated(
       scrollDirection: Axis.horizontal,
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
       itemCount: _modules.length,
       separatorBuilder: (_, _) => const SizedBox(width: 8),
       itemBuilder: (context, i) {
        final m = _modules[i];
        final count = m == 'Tout'
          ? total
          : screenCatalog.where((e) => e.module == m).length;
        return AppChip(
         label: m == 'Tout'
           ? 'Tout · $count'
           : '${screenModuleEmojis[m]} $m · $count',
         selected: _module == m,
         onTap: () {
          AppMotion.tap();
          setState(() => _module = m);
         },
        );
       },
      ),
     ),
     Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AppTextField(
       controller: _query,
       hint: 'Rechercher (ex. AD-42, avis, KYC…)',
       icon: AppIcons.search_rounded,
       onChanged: (_) => setState(() {}),
      ),
     ),
     Expanded(
      child: items.isEmpty
        ? const EmptyState(
          emoji: '',
          title: 'Aucun écran trouvé',
          message: 'Essayez un autre identifiant ou mot-clé.',
         )
        : ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
          itemCount: items.length,
          itemBuilder: (context, i) {
           final item = items[i];
           if (item is String) {
            return Padding(
             padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
             child: Text(
              item,
              style: TextStyle(
               fontSize: 12.5,
               fontWeight: FontWeight.w800,
               color: cs.primary,
              ),
             ),
            );
           }
           return _row(context, item as ScreenEntry);
          },
         ),
     ),
    ],
   ),
  );
 }

 Widget _row(BuildContext context, ScreenEntry e) {
  final route = e.route ?? '/screen/${e.id}';
  return Padding(
   padding: const EdgeInsets.only(bottom: 8),
   child: AppListTile(
    icon: e.isPreview
      ? AppIcons.visibility_rounded
      : AppIcons.check_circle_rounded,
    iconColor: e.isPreview ? AppColors.warning : AppColors.success,
    title: '${e.id} · ${e.title}',
    subtitle: e.desc,
    trailing: Pill(
     text: e.isPreview ? 'Démo' : 'Réel',
     dense: true,
     color: e.isPreview ? AppColors.warning : AppColors.success,
    ),
    onTap: () {
     AppMotion.tap();
     context.push(route);
    },
   ),
  );
 }
}
