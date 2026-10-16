import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models.dart';
import 'catalog_provider.dart';

enum SearchSort { pertinence, prixAsc, prixDesc, note, nouveautes }

extension SearchSortX on SearchSort {
  String get label => switch (this) {
        SearchSort.pertinence => 'Pertinence',
        SearchSort.prixAsc => 'Prix croissant',
        SearchSort.prixDesc => 'Prix décroissant',
        SearchSort.note => 'Mieux notés',
        SearchSort.nouveautes => 'Nouveautés',
      };
}

class SearchFilters {
  const SearchFilters({
    this.query = '',
    this.categoryIds = const {},
    this.city,
    this.expressOnly = false,
    this.minRating = 0,
    this.priceMin = 0,
    this.priceMax = 16000000,
    this.sort = SearchSort.pertinence,
  });

  final String query;
  final Set<String> categoryIds;
  final String? city;
  final bool expressOnly;
  final double minRating;
  final double priceMin;
  final double priceMax;
  final SearchSort sort;

  bool get hasActiveFilters =>
      categoryIds.isNotEmpty ||
      city != null ||
      expressOnly ||
      minRating > 0 ||
      priceMin > 0 ||
      priceMax < 16000000;

  SearchFilters copyWith({
    String? query,
    Set<String>? categoryIds,
    String? city,
    bool clearCity = false,
    bool? expressOnly,
    double? minRating,
    double? priceMin,
    double? priceMax,
    SearchSort? sort,
  }) =>
      SearchFilters(
        query: query ?? this.query,
        categoryIds: categoryIds ?? this.categoryIds,
        city: clearCity ? null : (city ?? this.city),
        expressOnly: expressOnly ?? this.expressOnly,
        minRating: minRating ?? this.minRating,
        priceMin: priceMin ?? this.priceMin,
        priceMax: priceMax ?? this.priceMax,
        sort: sort ?? this.sort,
      );
}

class SearchNotifier extends Notifier<SearchFilters> {
  @override
  SearchFilters build() => const SearchFilters();

  void setQuery(String q) => state = state.copyWith(query: q);

  void toggleCategory(String id) {
    final next = Set<String>.of(state.categoryIds);
    next.contains(id) ? next.remove(id) : next.add(id);
    state = state.copyWith(categoryIds: next);
  }

  void setCity(String? city) => state = city == null
      ? state.copyWith(clearCity: true)
      : state.copyWith(city: city);

  void toggleExpress() => state = state.copyWith(expressOnly: !state.expressOnly);

  void setMinRating(double r) => state = state.copyWith(minRating: r);

  void setPriceRange(double min, double max) =>
      state = state.copyWith(priceMin: min, priceMax: max);

  void setSort(SearchSort sort) => state = state.copyWith(sort: sort);

  void reset() => state = const SearchFilters();
}

final searchFiltersProvider =
    NotifierProvider<SearchNotifier, SearchFilters>(SearchNotifier.new);

final citiesProvider = Provider<List<String>>((ref) {
  final cities = ref.watch(catalogProvider).map((p) => p.city).toSet().toList()
    ..sort();
  return cities;
});

final searchResultsProvider = Provider<List<Product>>((ref) {
  final filters = ref.watch(searchFiltersProvider);
  var results = ref.watch(catalogProvider).toList();

  if (filters.query.trim().isNotEmpty) {
    final q = filters.query.trim().toLowerCase();
    results = results
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }
  if (filters.categoryIds.isNotEmpty) {
    results = results
        .where((p) => filters.categoryIds.contains(p.categoryId))
        .toList();
  }
  if (filters.city != null) {
    results = results.where((p) => p.city == filters.city).toList();
  }
  if (filters.expressOnly) {
    results = results.where((p) => p.express).toList();
  }
  if (filters.minRating > 0) {
    results = results.where((p) => p.rating >= filters.minRating).toList();
  }
  results = results
      .where((p) =>
          p.price >= filters.priceMin && p.price <= filters.priceMax)
      .toList();

  switch (filters.sort) {
    case SearchSort.prixAsc:
      results.sort((a, b) => a.price.compareTo(b.price));
    case SearchSort.prixDesc:
      results.sort((a, b) => b.price.compareTo(a.price));
    case SearchSort.note:
      results.sort((a, b) => b.rating.compareTo(a.rating));
    case SearchSort.nouveautes:
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case SearchSort.pertinence:
      results.sort((a, b) => (b.sold * b.rating).compareTo(a.sold * a.rating));
  }
  return results;
});
