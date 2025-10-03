// services/mandi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. Data Model (No changes needed here)
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

// 2. Updated function with an 'offset' parameter for pagination
Future<List<MandiRecord>> fetchMandiPrices({String? state, int offset = 0}) async {
  const String apiKey = "579b464db66ec23bdd000001cdd3946e44ce4aad7209ff7b23ac571b";
  const String baseUrl = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070";
  const int limit = 50; // We will fetch 50 records at a time

  // Start building the URL, now including the offset
  var urlBuilder = Uri.parse(baseUrl).replace(queryParameters: {
    'api-key': apiKey,
    'format': 'json',
    'limit': limit.toString(),
    'offset': offset.toString(), // <-- THE NEW ADDITION
  }).toString();

  // If a state is provided, add the filter to the URL
  if (state != null && state.isNotEmpty) {
    urlBuilder += '&filters[state.keyword]=${Uri.encodeComponent(state)}';
  }

  try {
    final response = await http.get(Uri.parse(urlBuilder));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List records = jsonData['records'] ?? [];

      if (records.isEmpty) {
        return [];
      }

      return records.map((item) => MandiRecord.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load mandi prices. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('An error occurred: $e');
  }
}