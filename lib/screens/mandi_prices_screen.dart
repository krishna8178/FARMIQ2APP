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
  String _selectedState = 'Punjab';
  int _offset = 0;
  final int _limit = 50;

  final List<String> _states = [
    'Punjab', 'Uttar Pradesh', 'Maharashtra', 'Haryana', 'Rajasthan', 'Andhra Pradesh', 'All States'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- START OF CHANGED CODE ---
        title: const Text(
          'Mandi Prices',
          style: TextStyle(color: Colors.white), // This makes the title text white
        ),
        // --- END OF CHANGED CODE ---
        backgroundColor: const Color(0xFF3B5D46),
        iconTheme: const IconThemeData(color: Colors.white), // Optional: Makes the back button white
      ),
      body: Column(
        children: [
          // --- UI CONTROLS ---
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              children: [
                DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedState,
                  hint: const Text("Select a State"),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedState = newValue;
                        _offset = 0;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _offset == 0 ? null : () {
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
          Expanded(
            child: FutureBuilder<List<MandiRecord>>(
              key: ValueKey('$_selectedState-$_offset'),
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
                        trailing: Chip(
                          backgroundColor: Colors.green[700],
                          label: Text(
                            '₹${record.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
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