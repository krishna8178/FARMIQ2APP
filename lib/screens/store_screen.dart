import 'package:flutter/material.dart';
import 'package:farmiq_app/models/product.dart';
import 'package:farmiq_app/services/api_service.dart';
import 'package:farmiq_app/widgets/product_card.dart';
import 'package:farmiq_app/widgets/product_card_skeleton.dart';
import 'package:farmiq_app/screens/add_product_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Future<List<Product>> _productsFuture;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      // --- START OF FIX ---
      // Corrected the method name from fetchProducts to getProducts.
      _productsFuture = apiService.getProducts();
      // --- END OF FIX ---
    });
  }

  Future<void> _navigateAndRefresh() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );

    // If a product was successfully added, the AddProductScreen returns true.
    // We then refresh the product list to show the new item.
    if (result == true) {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmIQ Store'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show skeleton loaders while waiting for data.
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => const ProductCardSkeleton(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            // Display the grid of products once data is loaded.
            final products = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => _loadProducts(),
              child: GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            );
          }
        },
      ),
      // This button opens the "Add Product" screen.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateAndRefresh,
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

