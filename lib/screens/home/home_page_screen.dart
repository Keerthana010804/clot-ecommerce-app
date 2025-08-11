import 'dart:convert';
import 'package:e_commerce/provider/favorite_provider.dart';
import 'package:e_commerce/repositories/product_repository.dart';
import 'package:e_commerce/screens/all_products_Screen.dart';
import 'package:e_commerce/screens/cart_page.dart';
import 'package:e_commerce/screens/categories_list.dart';
import 'package:e_commerce/screens/product_details_screen.dart';
import 'package:e_commerce/screens/profile/profile_screen.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:e_commerce/widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';
import '../../utils/color_constants.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late Future<List<ProductModel>> _productsFuture;
  late Future<List<String>> _categoriesFuture;
  late Future<Map<String, String>> _categoryImageMapFuture;
  Uint8List? _webImage;


  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRepository().fetchAllProducts();
    _categoriesFuture = ProductRepository().fetchCategories();
    _categoryImageMapFuture = ProductRepository().fetchCategoryImages();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');
    if (base64Image != null) {
      setState(() {
        _webImage = base64Decode(base64Image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(context, 0),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionTitle(
                    categoriesText,
                  onSeeAllTap: () async {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoriesList(),
                    ),
                  );
                  },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: FutureBuilder<Map<String, String>>(
                      future: _categoryImageMapFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return loadingWidget();
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error loading categories"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No categories found."));
                        } else {
                          final categoryMap = snapshot.data!;
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: categoryMap.entries.map((entry) {
                              final category = entry.key;
                              final imageUrl = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category.length > 10 ? '${category.substring(0, 10)}...' : category,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle(
                    topSellingText,
                    onSeeAllTap: () async {
                      final products = await _productsFuture;
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllProductsScreen(products: products),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<ProductModel>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingWidget();
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No products available."));
                      } else {
                        final topTenProducts = snapshot.data!.take(10).toList();
                        return _buildProductList(topTenProducts);
                      }
                    },
                  ),
                  _buildSectionTitle(
                    newInText,
                    onSeeAllTap: () async {
                      final products = await _productsFuture;
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllProductsScreen(products: products),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<ProductModel>>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingWidget();
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No products available."));
                      } else {
                        final newIn = snapshot.data!.skip(10).take(10).toList();
                        return _buildProductList(newIn);
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),));
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: _webImage != null ? MemoryImage(_webImage!) : null,
              child: _webImage == null
                  ? Icon(Icons.person, size: 20, color: Colors.white)
                  : null,
            ),
          ),
          GestureDetector(
            onTap:  (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(),));},
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.shopping_bag_outlined, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: searchText,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAllTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        GestureDetector(
          onTap: onSeeAllTap,
            child: Text(seeAllText, style: TextStyle(color: Colors.grey))
        ),
      ],
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        product.image ?? '',
                        width: 150,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        right: 10,
                        top: 8,
                        child: Consumer<FavoriteProvider>(
                          builder: (context, favProvider, _) {
                            final isFav = favProvider.isFavorite(product);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : null,
                              ),
                              onPressed: () {
                                favProvider.toggleFavorite(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(isFav ? 'Removed from favorites' : 'Added to favorites')),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title ?? noTitleText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\u{20B9}${product.price?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
