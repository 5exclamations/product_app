import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';
import '../l10n/app_localizations.dart';
import 'product_detail_screen.dart';

enum DisplayMode { card, list, table }

class CategoryProductsScreen extends StatefulWidget {
  final Category category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late Future<List<Product>> _productsFuture;
  late Future<List<Market>> _marketsFuture;

  final TextEditingController _searchController = TextEditingController();
  DisplayMode _displayMode = DisplayMode.card;

  int? _selectedMarketId;
  String? _sortBy;
  String _sortOrder = 'asc';

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
      _productsFuture = ApiService.fetchProducts(
        categoryId: widget.category.id,
        search: _searchController.text.isEmpty ? null : _searchController.text,
        marketId: _selectedMarketId,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      );
      _marketsFuture = ApiService.fetchMarkets();
    });
  }

  void _onSearchChanged() {
    _loadData();
  }

  void _showFilterDialog() async {
    final markets = await _marketsFuture;

    showDialog(
      context: context,
      builder: (context) {
        int? tempMarketId = _selectedMarketId;
        String? tempSortBy = _sortBy;
        String tempSortOrder = _sortOrder;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final loc = AppLocalizations.of(context);

            return AlertDialog(
              title: Text(loc.translate('filter')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('market'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButton<int?>(
                      isExpanded: true,
                      value: tempMarketId,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(loc.translate('all_markets')),
                        ),
                        ...markets.map((market) => DropdownMenuItem(
                          value: market.id,
                          child: Text(market.name),
                        )),
                      ],
                      onChanged: (value) {
                        setDialogState(() => tempMarketId = value);
                      },
                    ),
                    const SizedBox(height: 16),

                    Text(loc.translate('sort_by'),
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButton<String?>(
                      isExpanded: true,
                      value: tempSortBy,
                      items: [
                        DropdownMenuItem(value: null, child: const Text('-')),
                        DropdownMenuItem(
                          value: 'name',
                          child: Text(loc.translate('name')),
                        ),
                        DropdownMenuItem(
                          value: 'price',
                          child: Text(loc.translate('price')),
                        ),
                        DropdownMenuItem(
                          value: 'discount',
                          child: Text(loc.translate('discount_percentage')),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() => tempSortBy = value);
                      },
                    ),

                    if (tempSortBy != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('↑'),
                              value: 'asc',
                              groupValue: tempSortOrder,
                              onChanged: (value) {
                                setDialogState(() => tempSortOrder = value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('↓'),
                              value: 'desc',
                              groupValue: tempSortOrder,
                              onChanged: (value) {
                                setDialogState(() => tempSortOrder = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedMarketId = null;
                      _sortBy = null;
                      _sortOrder = 'asc';
                    });
                    _loadData();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _selectedMarketId = tempMarketId;
                      _sortBy = tempSortBy;
                      _sortOrder = tempSortOrder;
                    });
                    _loadData();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(String? iconName) {
    switch (iconName) {
      case 'local_drink': return Icons.local_drink;
      case 'bakery_dining': return Icons.bakery_dining;
      case 'set_meal': return Icons.set_meal;
      case 'eco': return Icons.eco;
      case 'kitchen': return Icons.kitchen;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_getCategoryIcon(widget.category.icon)),
            const SizedBox(width: 8),
            Text(widget.category.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: loc.translate('search_products'),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _selectedMarketId != null || _sortBy != null
                        ? Icons.filter_alt
                        : Icons.filter_alt_outlined,
                  ),
                  onPressed: _showFilterDialog,
                ),
                PopupMenuButton<DisplayMode>(
                  icon: Icon(
                    _displayMode == DisplayMode.card
                        ? Icons.view_module
                        : _displayMode == DisplayMode.list
                        ? Icons.view_list
                        : Icons.table_chart,
                  ),
                  onSelected: (mode) => setState(() => _displayMode = mode),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: DisplayMode.card,
                      child: ListTile(
                        leading: Icon(Icons.view_module),
                        title: Text('Cards'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: DisplayMode.list,
                      child: ListTile(
                        leading: Icon(Icons.view_list),
                        title: Text('List'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: DisplayMode.table,
                      child: ListTile(
                        leading: Icon(Icons.table_chart),
                        title: Text('Table'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: _buildProductDisplay(loc)),
        ],
      ),
    );
  }

  Widget _buildProductDisplay(AppLocalizations loc) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(loc.translate('no_products_found')),
          );
        }

        final products = snapshot.data!;
        switch (_displayMode) {
          case DisplayMode.card:
            return _buildCardView(products);
          case DisplayMode.list:
            return _buildListView(products);
          case DisplayMode.table:
            return _buildTableView(products, loc);
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
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.error),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(product.market.logoUrl),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0)
                  .copyWith(bottom: 8.0),
              child: product.discountPrice != null
                  ? Wrap(
                spacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${product.discountPrice!.toStringAsFixed(2)} AZN',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : Text(
                '${product.price.toStringAsFixed(2)} AZN',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.imageUrl),
              radius: 25,
            ),
            title: Text(product.name),
            subtitle: Text(product.market.name),
            trailing: product.discountPrice != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${product.discountPrice!.toStringAsFixed(2)} AZN',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
                : Text('${product.price.toStringAsFixed(2)} AZN'),
          ),
        );
      },
    );
  }

  Widget _buildTableView(List<Product> products, AppLocalizations loc) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(loc.translate('name'))),
          DataColumn(label: Text(loc.translate('market'))),
          DataColumn(label: Text('${loc.translate('price')} (AZN)'), numeric: true),
        ],
        rows: products.map((product) {
          return DataRow(
            cells: [
              DataCell(Text(product.name)),
              DataCell(Text(product.market.name)),
              DataCell(
                product.discountPrice != null
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${product.discountPrice!.toStringAsFixed(2)} ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '(${product.price.toStringAsFixed(2)})',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
                    : Text(product.price.toStringAsFixed(2)),
              ),
            ],
            onSelectChanged: (_) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
