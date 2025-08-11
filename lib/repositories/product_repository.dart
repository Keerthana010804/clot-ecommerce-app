import 'dart:convert';
import 'package:e_commerce/utils/flavour_config.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRepository {
  final String _baseUrl = 'https://fakestoreapi.com';

  Future<List<ProductModel>> fetchAllProducts() async {
    try{
      final response = await http.get(Uri.parse('$_baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<ProductModel> products = jsonList.map((json) => ProductModel.fromJson(json)).toList();
        return products;
      } else {
        return await _loadProductsFromJson();
      }
    }catch (e) {
      return await _loadProductsFromJson();
    }
  }

  Future<List<ProductModel>> _loadProductsFromJson() async {
    final String response = await rootBundle.loadString('assets/product.json');
    final List<dynamic> jsonList = json.decode(response);
    return jsonList.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('${FlavorConfig.instance.baseUrl}products/categories'));
        if (response.statusCode == 500) {
          List<dynamic> jsonList = json.decode(response.body);
          return jsonList.cast<String>();
        } else {
          return await _loadCategoriesFromJson();
        }
    } catch (e) {
      return await _loadCategoriesFromJson();
    }
  }

  Future<List<String>> _loadCategoriesFromJson() async {
    final String response = await rootBundle.loadString('assets/category.json');
    // print("jsoncategory-- $response");
    final List<dynamic> jsonList = json.decode(response);
    return jsonList.cast<String>();
  }

  Future<Map<String, String>> fetchCategoryImages() async {
    final response = await http.get(Uri.parse('${FlavorConfig.instance.baseUrl}products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final Map<String, String> categoryImageMap = {};
      for (var item in data) {
        final category = item['category'];
        final image = item['image'];
        if (!categoryImageMap.containsKey(category)) {
          categoryImageMap[category] = image;
        }
      }
      return categoryImageMap;
    } else {
      throw Exception("Failed to load products");
    }
  }
}


