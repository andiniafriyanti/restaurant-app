import 'package:flutter/widgets.dart';

class FavoriteIconProvider extends ChangeNotifier {
  final Map<String, bool> _favorites = {};

  bool isFavorite(String restaurantId) {
    return _favorites[restaurantId] ?? false;
  }

  void toggleFavorite(String restaurantId) {
    _favorites[restaurantId] = !isFavorite(restaurantId);
    notifyListeners();
  }

  void setFavorite(String restaurantId, bool isFavorite) {
    if (_favorites[restaurantId] == isFavorite) return;
    _favorites[restaurantId] = isFavorite;
    Future.microtask(() => notifyListeners());
  }
}
