import 'package:e_commerce/provider/cart_provider.dart';
import 'package:e_commerce/provider/favorite_provider.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import 'package:e_commerce/widgets/custom_widgets.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedSize = "M";
  String selectedColor = "Red";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: iconContainer(
          icon: Icons.arrow_back_ios_rounded,
          color: AppColors.black,
          size: 18,
          onTap: () => Navigator.of(context).pop()
        ),
        title: buildText(text: productDetailsText),
          actions: [
            Consumer<FavoriteProvider>(
              builder: (context, favProvider, _) {
                final isFav = favProvider.isFavorite(widget.product);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onPressed: () {
                    favProvider.toggleFavorite(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isFav ? 'Removed from favorites' : 'Added to favorites')),
                    );
                  },
                );
              },
            ),
          ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
            onPressed: () {
              final isClothing = widget.product.category == "men's clothing" ||
                  widget.product.category == "women's clothing";

              Provider.of<CartProvider>(context, listen: false).addToCart(
                product: widget.product,
                selectedSize: isClothing ? selectedSize : null,
                selectedColor: isClothing ? selectedColor : null,
                quantity: quantity,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to cart')),
              );
            },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\u{20B9}${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text(addToBagText, style: TextStyle(fontSize: 18,color: Colors.white)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Image.network(
                        widget.product.image ?? '',
                        height: 200,
                        width: 150,
                        fit: BoxFit.contain,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              Text(widget.product.title ?? noTitleText,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('\u{20B9}${widget.product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(fontSize: 18, color: AppColors.purple)),
              if (widget.product.category == "men's clothing" || widget.product.category == "women's clothing") ...[
                SizedBox(height: 20),
                buildDropdownTile(
                  title: "Size",
                  selectedValue: selectedSize,
                  options: ["S", "M", "L", "XL"],
                  onChanged: (val) {
                    setState(() {
                      selectedSize = val!;
                    });
                  },
                ),
                SizedBox(height: 12),
                buildDropdownTile(
                  title: "Color",
                  selectedValue: selectedColor,
                  options: ["Red", "Blue", "Black","Green","White"],
                  onChanged: (val) {
                    setState(() {
                      selectedColor = val!;
                    });
                  },
                  colorDot: true,
                ),
              ],
              SizedBox(height: 12),
              buildQuantityTile(
                quantity: quantity,
                onAdd: () {
                  setState(() {
                    quantity++;
                  });
                },
                onRemove: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              Text(widget.product.description ?? '',
                  style: TextStyle(color: AppColors.grey)),
              SizedBox(height: 8),
              Text('${widget.product.rating?.rate?.toStringAsFixed(1) ?? '0.0'} Ratings',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
