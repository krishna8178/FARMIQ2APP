import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory = 'Seeds'; // Default category

  final List<String> _categories = [
    'Seeds',
    'Fertilizers',
    'Pesticides',
    'Vegetables',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- START OF FIX ---
  // The context passed to this function must be from a widget inside the Scaffold.
  void _submitForm(BuildContext scaffoldContext) {
    if (_formKey.currentState!.validate()) {
      // Check if the widget is still mounted before showing the SnackBar.
      if (!mounted) return;

      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );

      // Pop the screen to go back.
      Navigator.of(context).pop();
    }
  }
  // --- END OF FIX ---

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Product'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      // --- START OF FIX ---
      // We wrap the body in a `Builder` to get a new `context` that is a
      // descendant of the Scaffold. This new context can be used to show the SnackBar.
      body: Builder(
        builder: (scaffoldContext) => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Product Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Product Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Price Field
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Product Price',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.price_change_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Image URL Field
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Product Image URL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link_outlined),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  // Pass the new context from the Builder to the submit function.
                  onPressed: () => _submitForm(scaffoldContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
      // --- END OF FIX ---
    );
  }
}

