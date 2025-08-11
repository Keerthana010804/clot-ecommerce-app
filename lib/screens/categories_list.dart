import 'package:e_commerce/repositories/product_repository.dart';
import 'package:e_commerce/screens/category_products_screen.dart';
import 'package:e_commerce/screens/home/home_page_screen.dart';
import 'package:e_commerce/utils/color_constants.dart';
import 'package:e_commerce/utils/string_constants.dart';
import 'package:e_commerce/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  late Future<Map<String, String>> _categoryImageMapFuture;

  @override
  void initState() {
    super.initState();
    _categoryImageMapFuture = ProductRepository().fetchCategoryImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconContainer(
              icon: Icons.arrow_back_ios_rounded,
              color: AppColors.black,
              size: 16,
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageScreen(),));
              },
            ),
            SizedBox(height: 16,),
            buildText(text: shopByCategoriesText, size: 24,fontWeight: FontWeight.bold),
            SizedBox(height: 16,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: FutureBuilder<Map<String, String>>(
                future: _categoryImageMapFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading categories"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No categories found."));
                  } else {
                    final categoryMap = snapshot.data!;
                    return ListView.builder(
                      itemCount: categoryMap.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemBuilder: (context, index) {
                        final category = categoryMap.keys.elementAt(index);
                        final imageUrl = categoryMap.values.elementAt(index);
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(category: category),
                              ),
                            );
                          },
                          child: Container(
                            margin:  EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
