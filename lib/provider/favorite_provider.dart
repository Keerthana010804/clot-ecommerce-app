import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => _favorites;

  FavoriteProvider() {
    loadFavorites();
  }

  void toggleFavorite(ProductModel product) {
    final existingIndex =
    _favorites.indexWhere((item) => item.id == product.id);

    if (existingIndex != -1) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(product);
    }

    saveFavorites();
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    return _favorites.any((item) => item.id == product.id);
  }

  void saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = _favorites.map((p) => jsonEncode(p.toJson())).toList();
    prefs.setStringList('favorites', favs);
  }

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favs = prefs.getStringList('favorites');

    if (favs != null) {
      _favorites =
          favs.map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
      notifyListeners();
    }
  }
}
