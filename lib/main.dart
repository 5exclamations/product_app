
                  import 'package:flutter/material.dart';
                  import 'api_service.dart'; // Импортируй ApiService
                  import 'models.dart';
// ENUMS
                  enum DisplayMode { card, list, table }


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
          cardTheme: CardThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
          late Future<List<Product>> _productsFuture;
          late Future<List<Category>> _categoriesFuture;
          final TextEditingController _searchController = TextEditingController();
          DisplayMode _displayMode = DisplayMode.card;

          @override
          void initState() {
          super.initState();
          _loadData();
          _searchController.addListener(_onSearchChanged);
          }

          @override
          void dispose() {
          _searchController.dispose();
          super.dispose();
          }

          void _loadData() {
          setState(() {
          _productsFuture = ApiService.fetchProducts();
          _categoriesFuture = ApiService.fetchCategories();
          });
          }

          void _onSearchChanged() {
          setState(() {
          _productsFuture = ApiService.fetchProducts(search: _searchController.text);
          });
          }

          void _changeDisplayMode(DisplayMode mode) {
          setState(() => _displayMode = mode);
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
          tabs: [
          Tab(icon: Icon(Icons.shopping_bag), text: 'Products'),
          Tab(icon: Icon(Icons.category), text: 'Categories')
          ],
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
          return FutureBuilder<List<Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
          title: Text(category.name),
          onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryProductsScreen(category: category),
          ));
          },
          );
          },
          );
          },
          );
          }

          PopupMenuButton<DisplayMode> _buildDisplayModeButton() {
          return PopupMenuButton<DisplayMode>(
          icon: Icon(
          _displayMode == DisplayMode.card
          ? Icons.view_module
              : _displayMode == DisplayMode.list
          ? Icons.view_list
              : Icons.table_chart,
          ),
          onSelected: _changeDisplayMode,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<DisplayMode>>[
          const PopupMenuItem(
          value: DisplayMode.card,
          child: ListTile(leading: Icon(Icons.view_module), title: Text('Cards'))),
          const PopupMenuItem(
          value: DisplayMode.list,
          child: ListTile(leading: Icon(Icons.view_list), title: Text('List'))),
          const PopupMenuItem(
          value: DisplayMode.table,
          child: ListTile(leading: Icon(Icons.table_chart), title: Text('Table'))),
          ],
          );
          }

          Widget _buildProductDisplay() {
          return FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;
          switch (_displayMode) {
          case DisplayMode.card:
          return _buildCardView(products);
          case DisplayMode.list:
          return _buildListView(products);
          case DisplayMode.table:
          return _buildTableView(products);
          }
          },
          );
          }

          Widget _buildCardView(List<Product> products) {
          return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
          final product = products[index];
          return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: InkWell(
          onTap: () => _navigateToDetail(product),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(
          child: Stack(
          fit: StackFit.expand,
          children: [
          Image.network(product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.error)),
          Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(product.market.logoUrl),
          backgroundColor: Colors.white,
          ),
          ),
          ],
          ),
          ),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          product.name,
          style: Theme.of(context).textTheme.titleMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
          product.market.name,
          style: Theme.of(context).textTheme.bodySmall,
          ),
          ],
          ),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 8.0),
          child: product.discountPrice != null
          ? Wrap(
          spacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
          Text(
          '${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
          decoration: TextDecoration.lineThrough, color: Colors.grey),
          ),
          Text(
          '${product.discountPrice!.toStringAsFixed(2)} AZN',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold),
          ),
          ],
          )
              : Text(
          '${product.price.toStringAsFixed(2)} AZN',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          ),
          ],
          ),
          ),
          );
          },
          );
          }

          Widget _buildListView(List<Product> products) {
          return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
          final product = products[index];
          return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
          onTap: () => _navigateToDetail(product),
          leading: CircleAvatar(backgroundImage: NetworkImage(product.market.logoUrl)),
          title: Text(product.name),
          subtitle: Text(product.market.name),
          trailing: product.discountPrice != null
          ? Wrap(
          spacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
          Text(
          '${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
          fontSize: 12),
          ),
          Text(
          '${product.discountPrice!.toStringAsFixed(2)} AZN',
          style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold),
          ),
          ],
          )
              : Text('${product.price.toStringAsFixed(2)} AZN'),
          ),
          );
          },
          );
          }

          Widget _buildTableView(List<Product> products) {
          return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
          columns: const [
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Market')),
          DataColumn(label: Text('Price (AZN)'), numeric: true),
          ],
          rows: products.map((product) {
          return DataRow(
          cells: [
          DataCell(Text(product.name)),
          DataCell(Text(product.market.name)),
          DataCell(
          product.discountPrice != null
          ? Row(
          children: [
          Text('${product.discountPrice!.toStringAsFixed(2)} ',
          style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold)),
          Text('(${product.price.toStringAsFixed(2)})',
          style: const TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
          fontSize: 11)),
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
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
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
          child: Image.network(product.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
          errorBuilder: (c, e, s) =>
          const Center(child: Icon(Icons.error, size: 50))),
          ),
          const SizedBox(height: 16),
          Text(product.name,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          priceWidget,
          const SizedBox(height: 16),
          Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          const Divider(),
          _buildInfoRow(context, Icons.scale, 'Weight', product.weight),
          _buildInfoRow(context, Icons.category, 'Category', product.category.name),
          ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.store, color: Colors.grey),
          title: const Text('Sold at', style: TextStyle(color: Colors.grey)),
          subtitle: Row(
          children: [
          CircleAvatar(
          backgroundImage: NetworkImage(product.market.logoUrl), radius: 12),
          const SizedBox(width: 8),
          Text(product.market.name,
          style: Theme.of(context).textTheme.titleMedium),
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

          @override
          Widget build(BuildContext context) {
          return Scaffold(
          appBar: AppBar(title: Text(category.name)),
          body: FutureBuilder<List<Product>>(
          future: ApiService.fetchProducts(categoryId: category.id),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products in this category.'));
          }

          final products = snapshot.data!;
          return ListView.builder(
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
          leading:
          CircleAvatar(backgroundImage: NetworkImage(product.imageUrl), radius: 25),
          title: Text(product.name),
          subtitle: Text(product.market.name),
          trailing: product.discountPrice != null
          ? Wrap(
          spacing: 4.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
          Text(
          '${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
          fontSize: 12),
          ),
          Text(
          '${product.discountPrice!.toStringAsFixed(2)} AZN',
          style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold),
          ),
          ],
          )
              : Text('${product.price.toStringAsFixed(2)} AZN'),
          ),
          );
          },
          );
          },
          ),
          );
          }
          }
