import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

final favoriteMealsProvider =
    NotifierProvider<FavoritesMealsProvider, List<Meal>>(
      () {
        return FavoritesMealsProvider();
      },
    );

class FavoritesMealsProvider extends Notifier<List<Meal>> {
  @override
  List<Meal> build() {
    return [];
  }

  void toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}
