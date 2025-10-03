// lib/screens/mandi_prices_screen.dart

import 'package:flutter/material.dart';
import '../services/mandi_service.dart';

class MandiPricesScreen extends StatefulWidget {
  const MandiPricesScreen({super.key});

  @override
  State<MandiPricesScreen> createState() => _MandiPricesScreenState();
}

class _MandiPricesScreenState extends State<MandiPricesScreen> {
  // --- STATE MANAGEMENT ---
  // Variables to hold the user's current selections.
  String _selectedState = 'Punjab'; // Default state to show first
  int _offset = 0; // Start at the beginning (page 1)
  final int _limit = 50; // The number of items to fetch per page

  // A list of states for the dropdown menu
  final List<String> _states = [
    'Punjab', 'Uttar Pradesh', 'Maharashtra', 'Haryana', 'Rajasthan', 'Andhra Pradesh', 'All States'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandi Prices'),
        backgroundColor: const Color(0xFF3B5D46), // Matching your theme
      ),
      body: Column(
        children: [
          // --- UI CONTROLS ---
          // This container holds the state dropdown and pagination buttons.
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              children: [
                // Dropdown for selecting a state
                DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedState,
                  hint: const Text("Select a State"),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // When a new state is selected, reset offset and rebuild
                      setState(() {
                        _selectedState = newValue;
                        _offset = 0; // Go back to the first page
                      });
                    }
                  },
                  items: _states.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Row for Previous/Next page buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _offset == 0 ? null : () { // Disable if on the first page
                        setState(() {
                          _offset -= _limit;
                        });
                      },
                      child: const Text('<< Previous'),
                    ),
                    Text('Page ${_offset ~/ _limit + 1}'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _offset += _limit;
                        });
                      },
                      child: const Text('Next >>'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- DYNAMIC DATA LIST ---
          // The FutureBuilder is now wrapped in an Expanded widget
          // and its 'future' call is dynamic.
          Expanded(
            child: FutureBuilder<List<MandiRecord>>(
              // VITAL: The key tells Flutter to re-run the future when the state or offset changes.
              key: ValueKey('$_selectedState-$_offset'),
              // DYNAMIC CALL: Uses the current state variables to fetch data.
              future: fetchMandiPrices(
                state: _selectedState == 'All States' ? null : _selectedState,
                offset: _offset,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No records found.'));
                }

                // If data is available, build the list
                final records = snapshot.data!;
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(record.commodity, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${record.market}, ${record.state}'),
                        trailing: Text(
                          '₹${record.price}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}