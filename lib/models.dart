class Market {
  final int id;
  final String name;
  final String logoUrl;

  const Market({required this.id, required this.name, required this.logoUrl});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logo_url'],
    );
  }
}

class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final double? discountPrice;
  final Market market;
  final String imageUrl;
  final Category category;
  final String weight;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.market,
    required this.imageUrl,
    required this.category,
    required this.weight,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      discountPrice: json['discount_price']?.toDouble(),
      market: Market.fromJson(json['market']),
      imageUrl: json['image_url'],
      category: Category.fromJson(json['category']),
      weight: json['weight'],
      description: json['description'],
    );
  }
}
