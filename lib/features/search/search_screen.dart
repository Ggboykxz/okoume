import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ui/common.dart';
import '../../data/mock_data.dart';
import '../../data/providers.dart';
import '../../core/ui/app_icons.dart';

class SearchScreen extends ConsumerStatefulWidget {
 const SearchScreen({super.key});

 @override
 ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
 final _controller = TextEditingController();

 static const _recentSearches = ['samsung', 'karité', 'robe wax', 'moto'];
 static const _trending = [
  'attieke',
  'pagne',
  'iphone',
  'perles mabe',
  'groupe electrogene',
 ];

 @override
 void initState() {
  super.initState();
  _controller.text = ref.read(searchFiltersProvider).query;
 }

 @override
 void dispose() {
  _controller.dispose();
  super.dispose();
 }

 void _search(String query) {
  _controller.text = query;
  ref.read(searchFiltersProvider.notifier).setQuery(query);
 }

 @override
 Widget build(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  final filters = ref.watch(searchFiltersProvider);
  final results = ref.watch(searchResultsProvider);
  final showLanding = filters.query.trim().isEmpty && !filters.hasActiveFilters;

  return Scaffold(
   body: SafeArea(
    bottom: false,
    child: Column(
     children: [
      // ------------------------------------------------------ En-tête
      Padding(
       padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
       child: Row(
        children: [
         Expanded(
          child: Text('Recherche',
            style: Theme.of(context).textTheme.headlineSmall),
         ),
         if (filters.hasActiveFilters)
          GestureDetector(
           onTap: () {
            ref.read(searchFiltersProvider.notifier).reset();
            _controller.clear();
           },
           child: Text(
            'Réinitialiser',
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.w700,
              fontSize: 13),
           ),
          ),
        ],
       ),
      ),
      // ------------------------------------------------- Barre de saisie
      Padding(
       padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
       child: Row(
        children: [
         Expanded(
          child: AppTextField(
           controller: _controller,
           hint: 'Que cherchez-vous ?',
           icon: AppIcons.search_rounded,
           onChanged: (v) =>
             ref.read(searchFiltersProvider.notifier).setQuery(v),
           onSubmitted: _search,
           suffix: _controller.text.isEmpty
             ? null
             : IconButton(
               icon: const AppIcon(AppIcons.close_rounded, size: 18),
               onPressed: () {
                _controller.clear();
                ref
                  .read(searchFiltersProvider.notifier)
                  .setQuery('');
                setState(() {});
               },
              ),
          ),
         ),
         const SizedBox(width: 10),
         AppIconButton(
          icon: AppIcons.tune_rounded,
          backgroundColor:
            filters.hasActiveFilters ? cs.primary : null,
          iconColor:
            filters.hasActiveFilters ? Colors.white : null,
          onTap: () => _openFilters(context),
         ),
        ],
       ),
      ),
      // --------------------------------------------------- Contenu
      Expanded(
       child: showLanding
         ? _buildLanding(cs)
         : Column(
           children: [
            Padding(
             padding:
               const EdgeInsets.fromLTRB(20, 6, 20, 10),
             child: Row(
              children: [
               Expanded(
                child: Text(
                 '${results.length} résultat${results.length > 1 ? 's' : ''}',
                 style: TextStyle(
                   fontSize: 12.5,
                   fontWeight: FontWeight.w700,
                   color: cs.onSurfaceVariant),
                ),
               ),
               GestureDetector(
                onTap: () => _openSort(context),
                child: Row(
                 children: [
                  AppIcon(AppIcons.sort_rounded,
                    size: 17, color: cs.primary),
                  const SizedBox(width: 5),
                  Text(
                   filters.sort.label,
                   style: TextStyle(
                     color: cs.primary,
                     fontWeight: FontWeight.w700,
                     fontSize: 12.5),
                  ),
                 ],
                ),
               ),
              ],
             ),
            ),
            Expanded(
             child: results.isEmpty
               ? EmptyState(
                 emoji: '',
                 title: 'Aucun résultat',
                 message:
                   'Essayez d\'autres mots-clés ou élargissez vos filtres.',
                 actionLabel: 'Réinitialiser',
                 onAction: () {
                  ref
                    .read(searchFiltersProvider.notifier)
                    .reset();
                  _controller.clear();
                 },
                )
               : ListView.separated(
                 padding: const EdgeInsets.fromLTRB(
                   20, 0, 20, 24),
                 itemCount: results.length,
                 separatorBuilder: (_, _) =>
                   const SizedBox(height: 10),
                 itemBuilder: (context, i) =>
                   ProductTile(product: results[i]),
                ),
            ),
           ],
          ),
      ),
     ],
    ),
   ),
  );
 }

 Widget _buildLanding(ColorScheme cs) {
  return ListView(
   padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
   children: [
    const SizedBox(height: 6),
    Text('Recherches récentes',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: cs.onSurfaceVariant)),
    const SizedBox(height: 10),
    Wrap(
     spacing: 8,
     runSpacing: 8,
     children: [
      for (final term in _recentSearches)
       AppChip(
        label: term,
        icon: AppIcons.history_rounded,
        onTap: () => _search(term),
       ),
     ],
    ),
    const SizedBox(height: 26),
    Row(
     children: [
      Text('Tendances à Libreville',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: cs.onSurfaceVariant)),
      const SizedBox(width: 6),
      const Text('', style: TextStyle(fontSize: 13)),
     ],
    ),
    const SizedBox(height: 10),
    Wrap(
     spacing: 8,
     runSpacing: 8,
     children: [
      for (final term in _trending)
       AppChip(label: term, onTap: () => _search(term)),
     ],
    ),
    const SizedBox(height: 26),
    Text('Explorer par catégorie',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: cs.onSurfaceVariant)),
    const SizedBox(height: 10),
    for (final c in Mock.categories)
     Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppListTile(
       emoji: c.emoji.isNotEmpty ? c.emoji : '•',
       iconColor: c.color,
       title: c.name,
       subtitle:
         '${c.count} produits · livraison dès aujourd\'hui',
       onTap: () {
        ref.read(searchFiltersProvider.notifier).reset();
        _controller.clear();
        context.push('/category/${c.id}');
       },
      ),
     ),
   ],
  );
 }

 void _openSort(BuildContext context) {
  showAppSheet(
   context,
   Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
      child: Text('Trier par',
        style: Theme.of(context).textTheme.titleMedium),
     ),
     for (final sort in SearchSort.values)
      Consumer(builder: (context, ref, _) {
       final selected =
         ref.watch(searchFiltersProvider).sort == sort;
       return ListTile(
        title: Text(sort.label,
          style: TextStyle(
            fontWeight: selected
              ? FontWeight.w800
              : FontWeight.w500,
            fontSize: 14)),
        trailing: selected
          ? AppIcon(AppIcons.check_circle_rounded,
            color: Theme.of(context).colorScheme.primary)
          : null,
        onTap: () {
         ref.read(searchFiltersProvider.notifier).setSort(sort);
         Navigator.of(context).pop();
        },
       );
      }),
     const SizedBox(height: 12),
    ],
   ),
  );
 }

 void _openFilters(BuildContext context) {
  showAppSheet(
   context,
   Consumer(builder: (context, ref, _) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);
    final cities = ref.watch(citiesProvider);
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
     padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text('Filtres',
         style: Theme.of(context).textTheme.titleMedium),
       const SizedBox(height: 18),
       Text('Prix (FCFA)',
         style: TextStyle(
           fontWeight: FontWeight.w700,
           fontSize: 13,
           color: cs.onSurfaceVariant)),
       const SizedBox(height: 4),
       Row(
        children: [
         Text('${filters.priceMin.round()}',
           style: const TextStyle(
             fontWeight: FontWeight.w700, fontSize: 12.5)),
         const Spacer(),
         Text(
          filters.priceMax >= 16000000
            ? '5 000 000+'
            : '${filters.priceMax.round()}',
          style: const TextStyle(
            fontWeight: FontWeight.w700, fontSize: 12.5),
         ),
        ],
       ),
       RangeSlider(
        values: RangeValues(
         filters.priceMin,
         filters.priceMax >= 16000000 ? 5000000 : filters.priceMax,
        ),
        min: 0,
        max: 5000000,
        divisions: 50,
        activeColor: cs.primary,
        onChanged: (values) => notifier.setPriceRange(
         values.start,
         values.end >= 5000000 ? 16000000 : values.end,
        ),
       ),
       const SizedBox(height: 12),
       Text('Catégories',
         style: TextStyle(
           fontWeight: FontWeight.w700,
           fontSize: 13,
           color: cs.onSurfaceVariant)),
       const SizedBox(height: 10),
       Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
         for (final c in Mock.categories)
          AppChip(
           label: '${c.emoji.isNotEmpty ? c.emoji : '•'} $c.name',
           selected: filters.categoryIds.contains(c.id),
           onTap: () => notifier.toggleCategory(c.id),
          ),
        ],
       ),
       const SizedBox(height: 20),
       Text('Zone',
         style: TextStyle(
           fontWeight: FontWeight.w700,
           fontSize: 13,
           color: cs.onSurfaceVariant)),
       const SizedBox(height: 10),
       Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
         AppChip(
          label: 'Toutes',
          selected: filters.city == null,
          onTap: () => notifier.setCity(null),
         ),
         for (final city in cities)
          AppChip(
           label: city,
           selected: filters.city == city,
           onTap: () => notifier.setCity(city),
          ),
        ],
       ),
       const SizedBox(height: 20),
       Text('Note minimale',
         style: TextStyle(
           fontWeight: FontWeight.w700,
           fontSize: 13,
           color: cs.onSurfaceVariant)),
       const SizedBox(height: 10),
       Wrap(
        spacing: 8,
        children: [
         for (final (label, r) in const [
          ('Toutes', 0.0),
          ('4+ ', 4.0),
          ('4,5+ ', 4.5),
         ])
          AppChip(
           label: label,
           selected: filters.minRating == r,
           onTap: () => notifier.setMinRating(r),
          ),
        ],
       ),
       const SizedBox(height: 16),
       SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Livraison express uniquement',
          style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: const Text('Livré en moins de 2 h',
          style: TextStyle(fontSize: 12)),
        value: filters.expressOnly,
        onChanged: (_) => notifier.toggleExpress(),
       ),
       const SizedBox(height: 10),
       AppButton(
        label: 'Afficher les résultats',
        onPressed: () => Navigator.of(context).pop(),
       ),
      ],
     ),
    );
   }),
  );
 }
}
