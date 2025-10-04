import 'package:flutter/material.dart';

class CalculatorResultsScreen extends StatelessWidget {
  const CalculatorResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Powered Estimate'),
        backgroundColor: const Color(0xFF3b5d46),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- START OF FIX ---
            // Replaced the Row with a GridView for better item spacing and wrapping.
            GridView.count(
              crossAxisCount: 3, // We still want 3 items in a row
              shrinkWrap: true, // Important for use inside a SingleChildScrollView
              physics:
              const NeverScrollableScrollPhysics(), // The parent is already scrollable
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio:
              0.85, // Adjust this value to change card height vs width
              children: [
                _buildResultCard(
                  title: 'Required Investment',
                  value: '₹2,250,000.00',
                  icon: Icons.savings,
                  iconColor: Colors.orange,
                ),
                _buildResultCard(
                  title: 'Expected Yield',
                  value: '120.00 tons',
                  icon: Icons.trending_up,
                  iconColor: Colors.blue,
                ),
                _buildResultCard(
                  title: 'Potential Profit',
                  value: '₹9,750,000.00',
                  icon: Icons.monetization_on,
                  iconColor: Colors.green,
                ),
              ],
            ),
            // --- END OF FIX ---
            const SizedBox(height: 24),

            // AI's Explanation Card
            _buildExplanationCard(),
          ],
        ),
      ),
    );
  }

  // Reusable widget for the top result cards
  Widget _buildResultCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding slightly
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.center, // Center content vertically
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 4),
                // Use Flexible to allow the title to wrap if needed
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11, // Reduced font size
                      color: Colors.grey[700],
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // FittedBox scales down the text to ensure it fits within the available space
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15, // Slightly reduced font size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the detailed explanation section
  Widget _buildExplanationCard() {
    // This is the hardcoded explanation text from your screenshot.
    const explanation =
        'For cultivating rice on 30 acres of loamy soil in Noida, Uttar Pradesh, the estimated cost is around ₹2,250,000 considering expenses related to seeds, fertilizers, labor, irrigation, and machinery. The expected yield is approximately 120 tons, based on an average yield of 4 tons per acre on loamy soil in this region. With current market prices for rice hovering around ₹27,500 per ton, the potential revenue is ₹3,300,000. After deducting costs, the projected profit would be ₹975,000, reflecting favorable soil conditions and adequate infrastructure available in Noida for rice cultivation.';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFE8F5E9), // A light green background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFF3b5d46)),
                SizedBox(width: 8),
                Text(
                  "AI's Explanation",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3b5d46),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              explanation,
              style: TextStyle(
                fontSize: 15,
                height: 1.5, // Improves readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}