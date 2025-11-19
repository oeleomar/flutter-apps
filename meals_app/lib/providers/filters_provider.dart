import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

final filtersProvider = NotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  () {
    return FiltersNotifier();
  },
);

class FiltersNotifier extends Notifier<Map<Filter, bool>> {
  @override
  Map<Filter, bool> build() {
    return {
      Filter.glutenFree: false,
      Filter.lactoseFree: false,
      Filter.vegan: false,
      Filter.vegetarian: false,
    };
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}
