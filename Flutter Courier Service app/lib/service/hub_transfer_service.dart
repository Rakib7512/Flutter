import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TransferHubService {
  final String baseUrl; // e.g. from environment

  TransferHubService({ required this.baseUrl });

  Future<String> transferParcel({
    required String trackingId,
    required String hubName,
    required int employeeId,
  }) async {
    final url = Uri.parse('$baseUrl/parcels/parcel/$trackingId/transfer');
    final response = await http.post(
      url,
      // If your backend expects query parameters:
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'hubName': hubName,
        'employeeId': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      // assume body contains a message as string
      return response.body;
    } else {
      throw Exception('Failed to transfer parcel: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getParcelDetailsForTransfer(String trackingId) async {
    final url = Uri.parse('$baseUrl/parcels/tracking/$trackingId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonBody;
    } else {
      throw Exception('Failed to load parcel details: ${response.body}');
    }
  }
}
