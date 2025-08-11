import 'package:e_commerce/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favorite_provider.dart';
import '../models/product_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteProvider>(context);
    final favs = favProvider.favorites;

    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(context, 2),
      appBar: AppBar(
        title: Center(child: Text('My Favourites (${favs.length})')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: favs.isEmpty
                  ? const Center(child: Text("No favorites yet"))
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  itemCount: favs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product = favs[index];
                    return FavoriteGridItem(product: product);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteGridItem extends StatelessWidget {
  final ProductModel product;

  const FavoriteGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image ?? '',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                product.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              // Price
              Text(
                '\$${product.price?.toStringAsFixed(2) ?? ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: 8,
          right: 8,
          child: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
