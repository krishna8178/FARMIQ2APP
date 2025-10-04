// services/mandi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. Data Model (Unchanged)
class MandiRecord {
  // ... (MandiRecord class is unchanged) ...
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

// 2. Function to fetch paginated and filtered mandi prices (Unchanged)
Future<List<MandiRecord>> fetchMandiPrices({String? state, int offset = 0}) async {
  const String apiKey = "579b464db66ec23bdd0000010480e1dd38d6406a7c243d1d219e02d7";
  const String baseUrl = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070";
  const int limit = 50;

  Map<String, String> queryParams = {
    'api-key': apiKey,
    'format': 'json',
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  if (state != null && state.isNotEmpty) {
    // Ensure the state name is used correctly in the main query
    queryParams['filters[state.keyword]'] = state;
  }

  final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List records = jsonData['records'] ?? [];

      return records.map((item) => MandiRecord.fromJson(item)).toList();
    } else {
      print('Failed URI: $uri');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load mandi prices. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred during mandi prices request: $e');
    return [];
  }
}

// -------------------------------------------------------------------------
// 3. FINAL ROBUST FUNCTION: With date filter and explicit price filter
// -------------------------------------------------------------------------

// Helper function to check if a state has at least one record with a non-zero price AND recent date
Future<bool> _hasValidPriceRecord(String state, String apiKey, String baseUrl) async {
  // Calculate the date 7 days ago in YYYY-MM-DD format
  final sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
  final dateFilter = '${sevenDaysAgo.year}-${sevenDaysAgo.month.toString().padLeft(2, '0')}-${sevenDaysAgo.day.toString().padLeft(2, '0')}';

  // Use the state name returned by the group_by directly in the filter
  final uri = Uri.parse(baseUrl).replace(queryParameters: {
    'api-key': apiKey,
    'format': 'json',
    'limit': '1', // Only need 1 record
    'sort[modal_price]': 'desc',
    'filters[state.keyword]': state,
    'filters[arrival_date.gte]': dateFilter, // Data must be recent (last 7 days)
    'filters[modal_price.gt]': '0',        // Price must be greater than zero
  });

  // NOTE: This print statement is for deep debugging. You should remove it later.
  // print('Validation URI for $state: $uri');

  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List records = jsonData['records'] ?? [];

      // If the API returns any record, it meets all criteria
      return records.isNotEmpty;
    }
    return false;
  } catch (e) {
    return false;
  }
}

Future<List<String>> fetchUniqueStates() async {
  const String apiKey = "579b464db66ec23bdd0000010480e1dd38d6406a7c243d1d219e02d7";
  const String baseUrl = "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070";

  // 1. Get all unique state names using group_by
  final uniqueStatesUri = Uri.parse(baseUrl).replace(queryParameters: {
    'api-key': apiKey,
    'format': 'json',
    'group_by': 'state',
    'limit': '100',
  });

  List<String> rawStateList = [];
  try {
    final response = await http.get(uniqueStatesUri);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List records = jsonData['records'] ?? [];

      // Trim whitespace just in case the API has inconsistent formatting
      rawStateList = records
          .map((item) => (item['state'] as String?)?.trim())
          .where((state) => state != null && state.isNotEmpty)
          .cast<String>()
          .toList();
    } else {
      print('Failed to get raw state list. Status Code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching raw state list: $e');
    return [];
  }

  // ----------------------------------------------------
  // 2. Filter the raw list by checking for valid price data concurrently
  // ----------------------------------------------------

  List<Future<bool>> validationFutures = [];

  for (String state in rawStateList) {
    validationFutures.add(_hasValidPriceRecord(state, apiKey, baseUrl));
  }

  // Wait for all checks to complete (concurrent API calls)
  List<bool> validationResults = await Future.wait(validationFutures);

  // 3. Build the final list of responsive states
  List<String> responsiveStates = [];
  for (int i = 0; i < rawStateList.length; i++) {
    if (validationResults[i]) {
      responsiveStates.add(rawStateList[i]);
    }
  }

  return responsiveStates;
}