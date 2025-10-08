import 'dart:convert';
import 'package:http/http.dart' as http;

class ParcelService {
  final String baseUrl = 'http://localhost:8085/api/parcels'; // যদি emulator এ না হয় তাহলে use: 10.0.2.2

  // ✅ 1. Save new parcel
  Future<Map<String, dynamic>?> saveParcel(Map<String, dynamic> parcelData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parcelData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Error saving parcel: ${response.body}');
      return null;
    }
  }

  // ✅ 2. Get all parcels
  Future<List<dynamic>> getAllParcels() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load parcels');
    }
  }

  // ✅ 3. Track parcel by trackingId
  Future<Map<String, dynamic>?> getParcelByTrackingId(String trackingId) async {
    final response = await http.get(Uri.parse('$baseUrl/track/$trackingId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Parcel not found');
      return null;
    }
  }

  // ✅ 4. Transfer parcel (hub-to-hub)
  Future<String?> transferParcel(String trackingId, String hubName, int employeeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/parcel/$trackingId/transfer?hubName=$hubName&employeeId=$employeeId'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Transfer failed: ${response.body}');
      return null;
    }
  }

  // ✅ 5. Mark parcel as delivered
  Future<String?> deliverParcel(String trackingId, String hubName, int employeeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/parcel/$trackingId/delevery?hubName=$hubName&employeeId=$employeeId'),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Delivery failed: ${response.body}');
      return null;
    }
  }
}
