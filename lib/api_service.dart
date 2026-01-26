import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
const String baseUrl = "https://api-for-app-r444.onrender.com/api/v1"; // Для Android эмулятора
// const String baseUrl = "http://localhost:8000/api/v1"; // Для iOS симулятора
// const String baseUrl = "http://YOUR_IP:8000/api/v1"; // Для реального устройства

class ApiService {
  // Получить все магазины
  static Future<List<Market>> fetchMarkets() async {
    final response = await http.get(Uri.parse('$baseUrl/markets/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Market.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load markets');
    }
  }

  // Получить все категории
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Получить продукты с фильтрами
  static Future<List<Product>> fetchProducts({String? search, int? categoryId}) async {
    var url = '$baseUrl/products/?';
    if (search != null && search.isNotEmpty) url += 'search=$search&';
    if (categoryId != null) url += 'category_id=$categoryId';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
