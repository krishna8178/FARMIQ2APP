import 'package:flutter/material.dart';
import 'package:farmiq_app/screens/calculator_results_screen.dart';
import 'package:farmiq_app/widgets/custom_button.dart';

class ProfitabilityCalculatorScreen extends StatefulWidget {
  const ProfitabilityCalculatorScreen({super.key});

  @override
  State<ProfitabilityCalculatorScreen> createState() =>
      _ProfitabilityCalculatorScreenState();
}

class _ProfitabilityCalculatorScreenState
    extends State<ProfitabilityCalculatorScreen> {
  // Controllers and variables to hold form state
  String? _selectedCrop;
  String? _selectedSoil = 'Loamy'; // Default value
  final TextEditingController _locationController =
  TextEditingController(text: 'Noida, Uttar Pradesh'); // Default value
  final TextEditingController _areaController = TextEditingController();
  String _selectedUnit = 'Acres';

  // Dummy data for dropdowns
  final List<String> _cropTypes = ['Rice', 'Wheat', 'Corn', 'Sugarcane'];
  final List<String> _soilTypes = ['Loamy', 'Sandy', 'Clay', 'Silty'];
  final List<String> _areaUnits = ['Acres', 'Hectares'];

  void _calculateEstimate() {
    // In a real app, you would perform validation here
    // For this example, we'll navigate directly to the results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalculatorResultsScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Crop Profitability Calculator'),
        backgroundColor: const Color(0xFF3b5d46),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Crop Type
            _buildDropdown(
              label: 'Crop Type',
              icon: Icons.grass,
              value: _selectedCrop,
              items: _cropTypes,
              hint: 'Select a crop',
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Soil Type
            _buildDropdown(
              label: 'Soil Type',
              icon: Icons.terrain,
              value: _selectedSoil,
              items: _soilTypes,
              hint: 'Select soil type',
              onChanged: (value) {
                setState(() {
                  _selectedSoil = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Location
            _buildTextField(
              label: 'Location (City, State)',
              icon: Icons.location_on,
              controller: _locationController,
            ),
            const SizedBox(height: 20),

            // Area of Land
            _buildAreaInput(),
            const SizedBox(height: 40),

            // Calculate Button
            CustomButton(
              text: 'Calculate Estimate',
              onPressed: _calculateEstimate,
            )
          ],
        ),
      ),
    );
  }

  // Helper widget to build styled dropdowns to reduce code repetition
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          hint: Text(hint),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for the location text field
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for the combined Area input field
  Widget _buildAreaInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Area of Land',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _areaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.square_foot, color: Colors.grey[600]),
                  hintText: 'e.g., 5',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedUnit,
                underline: const SizedBox(), // Hides the underline
                items: _areaUnits.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}