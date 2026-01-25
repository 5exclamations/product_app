import 'package:flutter/material.dart';

// ENUMS
enum Market { ravo, araz, oba }
enum Category { dairy, bakery, meat, produce, pantry }
enum DisplayMode { card, list, table }

// DATA MODELS
class Product {
  final String name;
  final double price;
  final double? discountPrice;
  final Market market;
  final String imageUrl;
  final Category category;
  final String weight;
  final String description;

  const Product({
    required this.name,
    required this.price,
    this.discountPrice,
    required this.market,
    required this.imageUrl,
    required this.category,
    required this.weight,
    required this.description,
  });
}

// MOCK DATA
final List<Product> allProducts = [
  // Ravo
  Product(name: 'Milk', price: 1.50, discountPrice: 1.35, market: Market.ravo, category: Category.dairy, weight: '1L', description: 'Fresh cow milk, pasteurized.', imageUrl: 'https://i.ibb.co/g9f2sWv/milk.png'),
  Product(name: 'Bread', price: 0.80, market: Market.ravo, category: Category.bakery, weight: '500g', description: 'Freshly baked white bread.', imageUrl: 'https://i.ibb.co/Jqc34b3/bread.png'),
  Product(name: 'Eggs', price: 2.20, market: Market.ravo, category: Category.pantry, weight: '12 pack', description: 'Organic free-range eggs.', imageUrl: 'https://i.ibb.co/d0SM06z/eggs.png'),

  // Araz
  Product(name: 'Milk', price: 1.60, market: Market.araz, category: Category.dairy, weight: '1L', description: 'High-quality full cream milk.', imageUrl: 'https://i.ibb.co/g9f2sWv/milk.png'),
  Product(name: 'Bread', price: 0.75, market: Market.araz, category: Category.bakery, weight: '450g', description: 'Traditional local bread.', imageUrl: 'https://i.ibb.co/Jqc34b3/bread.png'),
  Product(name: 'Cheese', price: 5.50, discountPrice: 4.99, market: Market.araz, category: Category.dairy, weight: '200g', description: 'Aged cheddar cheese.', imageUrl: 'https://i.ibb.co/F8C00Sj/cheese.png'),

  // Oba
  Product(name: 'Milk', price: 1.55, market: Market.oba, category: Category.dairy, weight: '1L', description: 'Farm-fresh milk.', imageUrl: 'https://i.ibb.co/g9f2sWv/milk.png'),
  Product(name: 'Chicken', price: 7.00, discountPrice: 6.50, market: Market.oba, category: Category.meat, weight: '1kg', description: 'Whole chicken, ready to cook.', imageUrl: 'https://i.ibb.co/bFzD2zN/chicken.png'),
  Product(name: 'Eggs', price: 2.30, market: Market.oba, category: Category.pantry, weight: '12 pack', description: 'Large white eggs.', imageUrl: 'https://i.ibb.co/d0SM06z/eggs.png'),
  Product(name: 'Bread', price: 0.85, market: Market.oba, category: Category.bakery, weight: '550g', description: 'Whole wheat bread.', imageUrl: 'https://i.ibb.co/Jqc34b3/bread.png'),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Price Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
      home: const HomeScreen(),
    );
  }
}

// SCREENS
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State
  late List<Product> _displayedProducts;
  final TextEditingController _searchController = TextEditingController();
  DisplayMode _displayMode = DisplayMode.card;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _displayedProducts = allProducts;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Methods
  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _displayedProducts = allProducts.where((p) => p.name.toLowerCase().contains(query)).toList();
    });
  }

  void _changeDisplayMode(DisplayMode mode) {
    setState(() => _displayMode = mode);
  }

  void _sort<T>(Comparable<T> Function(Product p) getField, int columnIndex, bool ascending) {
    _displayedProducts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  String getMarketLogo(Market market) {
    switch (market) {
      case Market.ravo: return 'https://i.ibb.co/6yYQfCQ/ravo.png';
      case Market.araz: return 'https://i.ibb.co/3k0421h/araz.png';
      case Market.oba: return 'https://i.ibb.co/7jW1bVv/oba.png';
    }
  }
  
  String getCategoryName(Category category) {
    return category.name[0].toUpperCase() + category.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Market Prices'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [Tab(icon: Icon(Icons.shopping_bag), text: 'Products'), Tab(icon: Icon(Icons.category), text: 'Categories') ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProductsTab(context),
            _buildCategoriesTab(context),
          ],
        ),
      ),
    );
  }

  // WIDGET BUILDERS
  Widget _buildProductsTab(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search products',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildDisplayModeButton(),
            ],
          ),
        ),
        Expanded(child: _buildProductDisplay()),
      ],
    );
  }

  Widget _buildCategoriesTab(BuildContext context) {
      final categories = Category.values.toList();
      return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                  title: Text(getCategoryName(category)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CategoryProductsScreen(category: category),
                      ));
                  },
              );
          },
      );
  }

  PopupMenuButton<DisplayMode> _buildDisplayModeButton() {
    return PopupMenuButton<DisplayMode>(
      icon: Icon(
        _displayMode == DisplayMode.card ? Icons.view_module
        : _displayMode == DisplayMode.list ? Icons.view_list
        : Icons.view_table,
      ),
      onSelected: _changeDisplayMode,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<DisplayMode>>[
        const PopupMenuItem(value: DisplayMode.card, child: ListTile(leading: Icon(Icons.view_module), title: Text('Cards'))),
        const PopupMenuItem(value: DisplayMode.list, child: ListTile(leading: Icon(Icons.view_list), title: Text('List'))),
        const PopupMenuItem(value: DisplayMode.table, child: ListTile(leading: Icon(Icons.view_table), title: Text('Table'))),
      ],
    );
  }

  Widget _buildProductDisplay() {
    if (_displayedProducts.isEmpty) {
      return const Center(child: Text('No products found.'));
    }
    switch (_displayMode) {
      case DisplayMode.card:  return _buildCardView();
      case DisplayMode.list:  return _buildListView();
      case DisplayMode.table: return _buildTableView();
    }
  }

  Widget _buildCardView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _displayedProducts.length,
      itemBuilder: (context, index) {
        final product = _displayedProducts[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: InkWell(
            onTap: () => _navigateToDetail(product),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(product.name, style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: product.discountPrice != null
                      ? Wrap( 
                          spacing: 8.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(decoration: TextDecoration.lineThrough, color: Colors.grey),
                            ),
                            Text(
                              '${product.discountPrice!.toStringAsFixed(2)} AZN',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          '${product.price.toStringAsFixed(2)} AZN',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _displayedProducts.length,
      itemBuilder: (context, index) {
        final product = _displayedProducts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            onTap: () => _navigateToDetail(product),
            leading: CircleAvatar(backgroundImage: NetworkImage(getMarketLogo(product.market))),
            title: Text(product.name),
            subtitle: Text(product.market.name),
            trailing: product.discountPrice != null
              ? Wrap(
                  spacing: 4.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '${product.discountPrice!.toStringAsFixed(2)} AZN',
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Text('${product.price.toStringAsFixed(2)} AZN'),
          ),
        );
      },
    );
  }

  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
        child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        columns: [
          DataColumn(label: const Text('Product'), onSort: (i, a) => _sort((p) => p.name, i, a)),
          DataColumn(label: const Text('Market'), onSort: (i, a) => _sort((p) => p.market.name, i, a)),
          DataColumn(label: const Text('Price (AZN)'), numeric: true, onSort: (i, a) => _sort((p) => p.discountPrice ?? p.price, i, a)),
        ],
        rows: _displayedProducts.map((product) {
          return DataRow(
            cells: [
              DataCell(Text(product.name)),
              DataCell(Text(product.market.name)),
              DataCell(
                product.discountPrice != null
                  ? Row(
                      children: [
                        Text('${product.discountPrice!.toStringAsFixed(2)} ',
                          style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold)),
                        Text('(${product.price.toStringAsFixed(2)})',
                          style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 11)),
                      ],
                    )
                  : Text(product.price.toStringAsFixed(2)),
              ),
            ],
            onSelectChanged: (_) => _navigateToDetail(product),
          );
        }).toList(),
      ),
    );
  }

  void _navigateToDetail(Product product) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductDetailScreen(product: product),
    ));
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  String getMarketLogo(Market market) {
    switch (market) {
      case Market.ravo: return 'https://i.ibb.co/6yYQfCQ/ravo.png';
      case Market.araz: return 'https://i.ibb.co/3k0421h/araz.png';
      case Market.oba: return 'https://i.ibb.co/7jW1bVv/oba.png';
    }
  }
  
  String getCategoryName(Category category) {
    return category.name[0].toUpperCase() + category.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    Widget priceWidget;
    if (product.discountPrice != null) {
      priceWidget = Row(
        children: [
          Text(
            '${product.price.toStringAsFixed(2)} AZN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${product.discountPrice!.toStringAsFixed(2)} AZN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      priceWidget = Text(
        '${product.price.toStringAsFixed(2)} AZN',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Image.network(product.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 250, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.error, size: 50))),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            priceWidget,
            const SizedBox(height: 16),
            Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            const Divider(),
            _buildInfoRow(context, Icons.scale, 'Weight', product.weight),
            _buildInfoRow(context, Icons.category, 'Category', getCategoryName(product.category)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.store, color: Colors.grey),
              title: const Text('Sold at', style: TextStyle(color: Colors.grey)),
              subtitle: Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(getMarketLogo(product.market)), radius: 12),
                  const SizedBox(width: 8),
                  Text(product.market.name, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey),
      title: Text(label, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class CategoryProductsScreen extends StatelessWidget {
    final Category category;

    const CategoryProductsScreen({super.key, required this.category});

    String getCategoryName(Category category) {
      return category.name[0].toUpperCase() + category.name.substring(1);
    }

    @override
    Widget build(BuildContext context) {
        final products = allProducts.where((p) => p.category == category).toList();
        return Scaffold(
            appBar: AppBar(title: Text(getCategoryName(category))),
            body: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        onTap: () {
                           Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                           ));
                        },
                        leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl), radius: 25),
                        title: Text(product.name),
                        subtitle: Text(product.market.name),
                        trailing: product.discountPrice != null
                          ? Wrap(
                              spacing: 4.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  '${product.discountPrice!.toStringAsFixed(2)} AZN',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Text('${product.price.toStringAsFixed(2)} AZN'),
                      ),
                    );
                },
            ),
        );
    }
}
