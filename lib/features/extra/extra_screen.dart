import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/ui/common.dart';
import '../../core/ui/motion.dart';
import '../../data/extras/extra_store.dart';
import '../../data/extras/extras_all.dart';
import '../../data/screen_catalog.dart';
import 'extra_spec.dart';

/// Rendu générique **fonctionnel** d'un écran du catalogue.
///
/// Formulaires, interrupteurs et actions modifient un état applicatif local
/// réel ([extraStoreProvider]) : les validations vident les files d'attente,
/// les créations apparaissent dans les listes vivantes, les réglages
/// persistent et les dossiers circulent entre les écrans
/// acheteur / vendeur / livreur / admin.
class ExtraScreen extends ConsumerStatefulWidget {
 const ExtraScreen({super.key, required this.screenId});

 final String screenId;

 @override
 ConsumerState<ExtraScreen> createState() => _ExtraScreenState();
}

/// Première [ListSection] remplacée par une liste vivante, par écran.
const _dynamicKind = <String, DynamicKind>{
 'AD-07': DynamicKind.reports,
 'AD-10': DynamicKind.kycQueue,
 'AD-24': DynamicKind.moderationProducts,
 'AD-25': DynamicKind.categories,
 'AD-28': DynamicKind.banners,
 'AD-32': DynamicKind.disputes,
 'AD-38': DynamicKind.withdrawalsVendor,
 'AD-40': DynamicKind.withdrawalsLivreur,
 'AD-49': DynamicKind.campaigns,
 'AD-53': DynamicKind.promos,
 'AD-58': DynamicKind.tickets,
 'AD-62': DynamicKind.moderationContent,
 'AD-64': DynamicKind.faqArticles,
 'AD-72': DynamicKind.systemLogs,
 'AD-74': DynamicKind.admins,
 'V-20': DynamicKind.stockAll,
 'V-25': DynamicKind.vendorPromos,
 'V-26': DynamicKind.stockLow,
 'V-52': DynamicKind.disputes,
 'V-59': DynamicKind.zones,
};

class _ExtraScreenState extends ConsumerState<ExtraScreen> {
 final Map<String, TextEditingController> _fields = {};

 @override
 void dispose() {
 for (final c in _fields.values) {
  c.dispose();
 }
 super.dispose();
 }

 ExtraStoreNotifier get _store =>
  ref.read(extraStoreProvider.notifier);

 ScreenEntry? get _entry {
 for (final e in screenCatalog) {
  if (e.id == widget.screenId) return e;
 }
 return null;
 }

 /// Les actions admin alimentent aussi le journal système (visible AD-72).
 void _logSystemIfAdmin(String label) {
 if (widget.screenId.startsWith('AD')) {
  _store.logSystem(' INFO ${widget.screenId} $label (admin)');
 }
 }

 /// Exécute une action : navigation réelle, opération réelle ou journal.
 void _run(ExtraAction action) {
 AppMotion.tap();
 if (action.route != null) {
  context.push(action.route!);
  return;
 }
 if (action.op != null) {
  final msg = _store.applyOp(action.op!, target: action.target);
  _store.logActivity(
   widget.screenId, '${action.emoji.isNotEmpty ? action.emoji : '•'} ${action.label} $msg');
  _logSystemIfAdmin(action.label);
  AppMotion.success();
  showAppSnack(context, msg);
  return;
 }
 _store.logActivity(widget.screenId, '${action.emoji.isNotEmpty ? action.emoji : '•'} ${action.label}');
 _logSystemIfAdmin(action.label);
 showAppSnack(
  context,
  action.snack ??
   '${action.label} — ajouté au journal de l’écran ');
 }

 /// Appui sur une ligne de liste : route réelle ou journal local.
 void _rowTap(String emoji, String title,
  {String? route, String? snack}) {
 AppMotion.tap();
 if (route != null) {
  context.push(route);
  return;
 }
 _store.logActivity(widget.screenId, '$emoji $title');
 showAppSnack(
  context, snack ?? '$title — noté dans le journal de l’écran ');
 }

 @override
 Widget build(BuildContext context) {
 final cs = Theme.of(context).colorScheme;
 final entry = _entry;
 final spec = allExtraSpecs[widget.screenId];

 if (entry == null || spec == null) {
  return Scaffold(
  appBar: AppBar(title: Text(widget.screenId)),
  body: EmptyState(
   emoji: '',
   title: 'Écran indisponible',
   message: "L'écran ${widget.screenId} n'est pas référencé.",
   actionLabel: 'Index des écrans',
   onAction: () => context.push('/screens'),
  ),
  );
 }

 final store = ref.watch(extraStoreProvider);
 final dynKind = _dynamicKind[widget.screenId];
 var firstListIndex = -1;
 for (var i = 0; i < spec.sections.length; i++) {
  if (spec.sections[i] is ListSection) {
  firstListIndex = i;
  break;
  }
 }

 final journal = <(String, String)>[
  for (final a
   in (store.formEntries[widget.screenId] ?? const <String>[]).take(4))
  ('', a),
  for (final a
   in (store.activity[widget.screenId] ?? const <String>[]).take(6))
  ('', a),
 ];

 var order = 0;
 return Scaffold(
  appBar: AppBar(title: Text(spec.title)),
  body: ListView(
  padding: const EdgeInsets.fromLTRB(16, 10, 16, 36),
  children: [
   MotionEnter(order: order++, child: _header(cs, entry, spec)),
   const SizedBox(height: 14),
   MotionEnter(
   order: order++,
   child: InfoBanner(
    emoji: '•',
    text: 'Démo locale fonctionnelle — chaque action modifie '
     "l’état de l’application pendant la session. Réf. CDC — "
     '${entry.id} ${entry.title}.',
   ),
   ),
   const SizedBox(height: 4),
   for (var i = 0; i < spec.sections.length; i++)
   MotionEnter(
    order: order++,
    child: Padding(
    padding: const EdgeInsets.only(top: 14),
    child: (i == firstListIndex && dynKind != null)
     ? _dynamicList(
      dynKind,
      (spec.sections[i] as ListSection).title,
      )
     : _section(spec.sections[i], i),
    ),
   ),
   if (spec.actions.isNotEmpty) ...[
   const SizedBox(height: 22),
   MotionEnter(
    order: order++,
    child: Wrap(
    spacing: 10,
    runSpacing: 10,
    children: [
     for (var i = 0; i < spec.actions.length; i++)
     AppButton(
      label:
       '${spec.actions[i].emoji} ${spec.actions[i].label}',
      small: true,
      expanded: false,
      variant: i == 0
       ? AppButtonVariant.primary
       : AppButtonVariant.outline,
      onPressed: () => _run(spec.actions[i]),
     ),
    ],
    ),
   ),
   ],
   if (journal.isNotEmpty) ...[
   const SizedBox(height: 22),
   MotionEnter(order: order++, child: _journal(journal)),
   ],
  ],
  ),
 );
 }

 Widget _header(ColorScheme cs, ScreenEntry entry, ExtraSpec spec) {
 return Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Container(
   width: 58,
   height: 58,
   decoration: BoxDecoration(
   color: cs.primary.withValues(alpha: 0.10),
   borderRadius: BorderRadius.circular(18),
   ),
   alignment: Alignment.center,
   child: Text(spec.emoji.isNotEmpty ? spec.emoji : '•', style: const TextStyle(fontSize: 16)),
  ),
  const SizedBox(width: 13),
  Expanded(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Wrap(
    spacing: 6,
    runSpacing: 4,
    children: [
     Pill(text: entry.id, dense: true),
     if (entry.isPreview)
     Pill(text: 'Démo', dense: true, color: AppColors.warning)
     else
     Pill(
      text: 'Écran du MVP',
      dense: true,
      color: AppColors.success,
     ),
    ],
    ),
    const SizedBox(height: 7),
    Text(
    '${screenModuleLabels[entry.module]} ${screenGroupOf(entry)}',
    style: TextStyle(
     fontSize: 11,
     fontWeight: FontWeight.w600,
     color: cs.onSurfaceVariant,
    ),
    ),
    const SizedBox(height: 3),
    Text(
    spec.tagline,
    style: TextStyle(
     fontSize: 12.8,
     height: 1.35,
     color: cs.onSurface,
    ),
    ),
   ],
   ),
  ),
  ],
 );
 }

 Widget _section(ExtraSection section, int index) {
 final cs = Theme.of(context).colorScheme;
 return switch (section) {
  TextSection s => AppCard(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text('${s.emoji.isNotEmpty ? s.emoji : '•'} ${s.title}',
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 14)),
    const SizedBox(height: 7),
    Text(s.text,
     style: TextStyle(
      fontSize: 13, height: 1.5, color: cs.onSurface)),
   ],
   ),
  ),
  BulletSection s => AppCard(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(s.title,
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 14)),
    const SizedBox(height: 8),
    for (final b in s.bullets)
    Padding(
     padding: const EdgeInsets.only(bottom: 7),
     child: Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Text(b.split(' ').first,
       style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 8),
      Expanded(
      child: Text(
       b.split(' ').skip(1).join(' '),
       style: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: cs.onSurface),
      ),
      ),
     ],
     ),
    ),
   ],
   ),
  ),
  StatSection s => _stats(s),
  DynamicSection s => _dynamicList(s.kind, s.title),
  ListSection s => Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   if (s.title != null) _sectionTitle(s.title!),
   for (final row in s.items)
    Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: AppListTile(
     emoji: row.emoji.isNotEmpty ? row.emoji : '•',
     title: row.title,
     subtitle: row.subtitle,
     onTap: () => _rowTap(row.emoji.isNotEmpty ? row.emoji : '•', row.title,
      route: row.route, snack: row.snack),
     trailing: row.trailing == null
      ? null
      : Padding(
       padding: const EdgeInsets.only(left: 8),
       child: Text(
       row.trailing!,
       style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: cs.primary,
       ),
       ),
      ),
    ),
    ),
   ],
  ),
  LinkSection s => Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   _sectionTitle(s.title),
   for (final row in s.items)
    Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: AppListTile(
     emoji: row.emoji.isNotEmpty ? row.emoji : '•',
     title: row.title,
     subtitle: row.subtitle,
     iconColor: AppColors.success,
     onTap: () => _rowTap(row.emoji.isNotEmpty ? row.emoji : '•', row.title,
      route: row.route, snack: row.snack),
    ),
    ),
   ],
  ),
  ProgressSection s => AppCard(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(s.title,
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 14)),
    const SizedBox(height: 12),
    for (final item in s.items) ...[
    Row(
     children: [
     Expanded(
      child: Text(item.$1,
       style: const TextStyle(
        fontSize: 12.5, fontWeight: FontWeight.w600)),
     ),
     Text(item.$3,
      style: TextStyle(
       fontSize: 12,
       fontWeight: FontWeight.w800,
       color: cs.primary)),
     ],
    ),
    const SizedBox(height: 5),
    ClipRRect(
     borderRadius: BorderRadius.circular(99),
     child: LinearProgressIndicator(
     value: item.$2.clamp(0, 1),
     minHeight: 7,
     backgroundColor: cs.surfaceContainerHigh,
     ),
    ),
    const SizedBox(height: 12),
    ],
   ],
   ),
  ),
  TimelineSection s => AppCard(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    if (s.title != null) ...[
    Text(s.title!,
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 14)),
    const SizedBox(height: 10),
    ],
    for (var i = 0; i < s.steps.length; i++)
    Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Column(
      children: [
      Container(
       width: 30,
       height: 30,
       decoration: BoxDecoration(
       color: cs.primary.withValues(alpha: 0.10),
       shape: BoxShape.circle,
       ),
       alignment: Alignment.center,
       child: Text(s.steps[i].$1,
        style: const TextStyle(fontSize: 14)),
      ),
      if (i < s.steps.length - 1)
       Container(
       width: 2,
       height: 26,
       color: cs.outlineVariant,
       ),
      ],
     ),
     const SizedBox(width: 11),
     Expanded(
      child: Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       Text(s.steps[i].$2,
        style: const TextStyle(
         fontSize: 13.5,
         fontWeight: FontWeight.w600)),
       const SizedBox(height: 2),
       Text(s.steps[i].$3,
        style: TextStyle(
         fontSize: 11.5,
         color: cs.onSurfaceVariant)),
       ],
      ),
      ),
     ),
     ],
    ),
   ],
   ),
  ),
  ChartSection s => AppCard(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    Text(s.title,
     style: const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 14)),
    const SizedBox(height: 14),
    BarChartMini(
    values: [for (final b in s.bars) b.$2],
    labels: [for (final b in s.bars) b.$1],
    ),
   ],
   ),
  ),
  FormSection s => _form(s, index),
  MapSection s => _map(s),
  ToggleSection s => Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
   if (s.title != null) _sectionTitle(s.title!),
   for (var i = 0; i < s.items.length; i++)
    Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
     padding: const EdgeInsets.symmetric(
      horizontal: 14, vertical: 4),
     decoration: BoxDecoration(
     color: cs.surface,
     borderRadius: BorderRadius.circular(16),
     border: Border.all(color: cs.outlineVariant),
     ),
     child: Row(
     children: [
      Text(s.items[i].$1,
       style: const TextStyle(fontSize: 18)),
      const SizedBox(width: 12),
      Expanded(
      child: Text(s.items[i].$2,
       style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600)),
      ),
      Switch(
      value: ref.read(extraStoreProvider).toggles[
        '${widget.screenId}${s.items[i].$2}'] ??
       s.items[i].$3,
      onChanged: (v) {
       AppMotion.tap();
       ref
        .read(extraStoreProvider.notifier)
        .setToggle(
         '${widget.screenId}${s.items[i].$2}', v);
      },
      ),
     ],
     ),
    ),
    ),
   ],
  ),
 };
 }

 Widget _sectionTitle(String title) => Padding(
  padding: const EdgeInsets.fromLTRB(2, 4, 2, 10),
  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );

 Widget _stats(StatSection s) {
 final rows = <Widget>[];
 for (var i = 0; i < s.stats.length; i += 3) {
  final chunk = s.stats.sublist(
   i, i + 3 > s.stats.length ? s.stats.length : i + 3);
  rows.add(Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: IntrinsicHeight(
   child: Row(
   crossAxisAlignment: CrossAxisAlignment.stretch,
   children: [
    for (var j = 0; j < 3; j++) ...[
    if (j > 0) const SizedBox(width: 8),
    Expanded(
     child: j < chunk.length
      ? StatCard(
       label: chunk[j].$3,
       value: chunk[j].$2,
       emoji: chunk[j].$1,
      )
      : const SizedBox.shrink(),
    ),
    ],
   ],
   ),
  ),
  ));
 }
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  if (s.title != null) _sectionTitle(s.title!),
  ...rows,
  ],
 );
 }

 Widget _form(FormSection s, int index) {
 return AppCard(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Text(s.title,
    style:
     const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
   const SizedBox(height: 12),
   for (var i = 0; i < s.fields.length; i++) ...[
   Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Padding(
     padding: const EdgeInsets.only(top: 14),
     child: Text(s.fields[i].$1,
      style: const TextStyle(fontSize: 16)),
    ),
    const SizedBox(width: 10),
    Expanded(
     child: AppTextField(
     controller: _fields.putIfAbsent(
      '${index}_$i', () => TextEditingController()),
     hint: s.fields[i].$2,
     ),
    ),
    ],
   ),
   const SizedBox(height: 10),
   ],
   const SizedBox(height: 4),
   AppButton(
   label: s.submitLabel,
   onPressed: () {
    final values = [
    for (var i = 0; i < s.fields.length; i++)
     _fields['${index}_$i']?.text.trim() ?? ''
    ];
    if (values.isEmpty || values.any((v) => v.isEmpty)) {
    AppMotion.warning();
    showAppSnack(context, 'Complétez tous les champs ');
    return;
    }
    var message = s.success;
    if (s.op != null) {
    message = ref
     .read(extraStoreProvider.notifier)
     .applyOp(s.op!, values: values, target: s.target);
    _logSystemIfAdmin(s.title);
    }
    ref
     .read(extraStoreProvider.notifier)
     .addFormEntry(
      widget.screenId, '${s.title} ${values.first}');
    AppMotion.success();
    showAppSnack(context, message);
    for (var i = 0; i < s.fields.length; i++) {
    _fields['${index}_$i']?.clear();
    }
    setState(() {});
   },
   ),
  ],
  ),
 );
 }

 /// Liste vivante : reflète l'état applicatif réel (mutations visibles
 /// immédiatement, y compris après navigation).
 Widget _dynamicList(DynamicKind kind, String? title) {
 final cs = Theme.of(context).colorScheme;
 ref.watch(extraStoreProvider);
 final items = ref.read(extraStoreProvider.notifier).itemsFor(kind);
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  if (title != null) _sectionTitle(title),
  if (items.isEmpty)
   AppCard(
   child: Text(
    'Rien pour le moment — vos actions apparaîtront ici.',
    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
   ),
   )
  else
   for (final item in items)
   Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: AppListTile(
    emoji: item.$1,
    title: item.$2,
    subtitle: item.$3,
    onTap: () => _rowTap(item.$1, item.$2),
    trailing: item.$4 == null
     ? null
     : Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
       item.$4!,
       style: TextStyle(
       fontSize: 11.5,
       fontWeight: FontWeight.w800,
       color: cs.primary,
       ),
      ),
      ),
    ),
   ),
  ],
 );
 }

 /// Journal local de l'écran : formulaires enregistrés + actions réalisées.
 Widget _journal(List<(String, String)> items) {
 final cs = Theme.of(context).colorScheme;
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  _sectionTitle('Journal de l’écran (démo locale)'),
  AppCard(
   child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
    for (var i = 0; i < items.length; i++) ...[
    Row(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
     Text(items[i].$1, style: const TextStyle(fontSize: 13)),
     const SizedBox(width: 8),
     Expanded(
      child: Text(
      items[i].$2,
      style: TextStyle(
       fontSize: 12.5,
       height: 1.35,
       color: cs.onSurface,
      ),
      ),
     ),
     ],
    ),
    if (i < items.length - 1) const Divider(height: 14),
    ],
   ],
   ),
  ),
  ],
 );
 }

 Widget _map(MapSection s) {
 final cs = Theme.of(context).colorScheme;
 return AppCard(
  padding: const EdgeInsets.all(12),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Padding(
   padding: const EdgeInsets.only(left: 4, bottom: 10),
   child: Text(s.title,
    style: const TextStyle(
     fontWeight: FontWeight.w700, fontSize: 14)),
   ),
   ClipRRect(
   borderRadius: BorderRadius.circular(14),
   child: Container(
    height: 220,
    decoration: BoxDecoration(
    gradient: LinearGradient(
     colors: [
     cs.primary.withValues(alpha: 0.10),
     AppColors.success.withValues(alpha: 0.10),
     ],
     begin: Alignment.topLeft,
     end: Alignment.bottomRight,
    ),
    ),
    child: LayoutBuilder(
    builder: (context, c) => Stack(
     children: [
     Positioned.fill(
      child: CustomPaint(painter: _GridPainter(cs)),
     ),
     for (final pin in s.pins)
      Positioned(
      left: (c.maxWidth * pin.$3 - 24)
       .clamp(0, c.maxWidth - 76),
      top: (c.maxHeight * pin.$4 - 20)
       .clamp(0, c.maxHeight - 62),
      child: Column(
       children: [
       Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
        color: cs.surface,
        shape: BoxShape.circle,
        border: Border.all(
         color: cs.primary, width: 2),
        boxShadow: [
         BoxShadow(
         color: Colors.black
          .withValues(alpha: 0.12),
         blurRadius: 8,
         offset: const Offset(0, 3),
         ),
        ],
        ),
        alignment: Alignment.center,
        child: Text(pin.$1,
         style: const TextStyle(fontSize: 17)),
       ),
       const SizedBox(height: 3),
       Container(
        padding: const EdgeInsets.symmetric(
         horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(99),
        border:
         Border.all(color: cs.outlineVariant),
        ),
        child: Text(
        pin.$2,
        style: const TextStyle(
         fontSize: 9.5,
         fontWeight: FontWeight.w700),
        ),
       ),
       ],
      ),
      ),
     ],
    ),
    ),
   ),
   ),
  ],
  ),
 );
 }
}

/// Quadrillage discret façon carte.
class _GridPainter extends CustomPainter {
 _GridPainter(this.cs);
 final ColorScheme cs;

 @override
 void paint(Canvas canvas, Size size) {
 final paint = Paint()
  ..color = cs.outlineVariant.withValues(alpha: 0.55)
  ..strokeWidth = 1;
 const step = 44.0;
 for (var x = step; x < size.width; x += step) {
  canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
 }
 for (var y = step; y < size.height; y += step) {
  canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
 }
 }

 @override
 bool shouldRepaint(covariant _GridPainter old) => old.cs != cs;
}
