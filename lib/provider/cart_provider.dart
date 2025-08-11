import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  CartProvider() {
    loadCart(); // Load on initialization
  }

  void addToCart({required ProductModel product, required int quantity, String? selectedSize, String? selectedColor}) {
    _items.add(
      CartItem(
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ),
    );
    saveCart(); // Save after adding
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    saveCart(); // Save after removing
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCart(); // Save after clearing
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = jsonEncode(_items.map((e) => e.toJson()).toList());
    prefs.setString('cart', cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart');

    if (cartString != null) {
      final decoded = jsonDecode(cartString) as List;
      _items = decoded.map((e) => CartItem.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
