import 'package:flutter/material.dart';
import '../models.dart';
import '../l10n/app_localizations.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    Widget priceWidget;
    if (product.discountPrice != null) {
      priceWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${product.price.toStringAsFixed(2)} AZN',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${product.discountPercentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${product.discountPrice!.toStringAsFixed(2)} AZN',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      priceWidget = Text(
        '${product.price.toStringAsFixed(2)} AZN',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение продукта
            Hero(
              tag: 'product_${product.id}',
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Center(
                    child: Icon(Icons.error, size: 50),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Цена
                  priceWidget,
                  const SizedBox(height: 24),

                  // Описание
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 16),

                  // Детали
                  _buildInfoRow(
                    context,
                    Icons.scale,
                    loc.translate('weight'),
                    product.weight,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoRow(
                    context,
                    Icons.category,
                    loc.translate('category'),
                    product.category.name,
                  ),
                  const SizedBox(height: 12),

                  // Магазин
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(product.market.logoUrl),
                            radius: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.translate('sold_at'),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.market.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
