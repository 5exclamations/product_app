import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

const String baseUrl = "https://api-for-app-r444.onrender.com/api/v1";

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

  // Получить продукты с фильтрами и сортировкой
  static Future<List<Product>> fetchProducts({
    String? search,
    int? categoryId,
    int? marketId,
    bool? onDiscount,
    String? sortBy,  // "price", "name", "discount"
    String? sortOrder,  // "asc", "desc"
  }) async {
    var url = '$baseUrl/products/?';

    if (search != null && search.isNotEmpty) url += 'search=$search&';
    if (categoryId != null) url += 'category_id=$categoryId&';
    if (marketId != null) url += 'market_id=$marketId&';
    if (onDiscount != null && onDiscount) url += 'on_discount=true&';
    if (sortBy != null) url += 'sort_by=$sortBy&';
    if (sortOrder != null) url += 'sort_order=$sortOrder&';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
