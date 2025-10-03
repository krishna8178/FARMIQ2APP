// services/mandi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. Data Model (Structurally the same, but with improved parsing)
class MandiRecord {
  final String commodity;
  final String market;
  final String state;
  final String price;

  MandiRecord({
    required this.commodity,
    required this.market,
    required this.state,
    required this.price,
  });

  factory MandiRecord.fromJson(Map<String, dynamic> json) {
    return MandiRecord(
      commodity: json['commodity'] ?? 'N/A',
      market: json['market'] ?? 'N/A',
      state: json['state'] ?? 'N/A',
      price: (json['modal_price'] ?? '0').toString(),
    );
  }
}

// 2. Updated function to fetch data with state and offset filters
Future<List<MandiRecord>> fetchMandiPrices({String? state, int offset = 0}) async {
  // Updated API Key
  const String apiKey = "579b464db66ec23bdd00000173814e3914264bdb4749bdf14a30004c";
  const String baseUrl = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070";
  const int limit = 50; // Increased limit to get more results per page

  // Start building the URL with the new parameters
  var urlBuilder = Uri.parse(baseUrl).replace(queryParameters: {
    'api-key': apiKey,
    'format': 'json',
    'limit': limit.toString(),
    'offset': offset.toString(),
  }).toString();

  // If a state is provided, add the filter to the URL
  if (state != null && state.isNotEmpty) {
    urlBuilder += '&filters[state.keyword]=${Uri.encodeComponent(state)}';
  }

  try {
    final response = await http.get(Uri.parse(urlBuilder));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Safely handle cases where 'records' might not exist
      final List records = jsonData['records'] ?? [];

      if (records.isEmpty) {
        return []; // Return an empty list if no records are found
      }

      return records.map((item) => MandiRecord.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load mandi prices. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    // Catch network or other errors
    throw Exception('An error occurred: $e');
  }
}