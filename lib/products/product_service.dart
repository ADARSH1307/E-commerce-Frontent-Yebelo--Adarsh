import 'dart:convert';
import 'package:flutter/services.dart';

class ProductService {
  static Future<List<Map<String, dynamic>>> getProducts() async {
    String jsonString = await rootBundle.loadString('assets/products.json');
    List<dynamic> jsonList = json.decode(jsonString);
    List<Map<String, dynamic>> products = jsonList.cast<Map<String, dynamic>>();
    return products;
  }

  static List<Map<String, dynamic>> filterProductsByCategory(String category, List<Map<String, dynamic>> products) {
    if (category.isEmpty) {
      return products;
    }
    return products.where((product) => product['p_category'] == category).toList();
  }
}
