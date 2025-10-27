import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryService {
  final String baseUrl = "http://localhost:8085/api/parcels/parcel";

  Future<String> deliverParcel(String trackingId, String hubName, int employeeId) async {
    final url = Uri.parse('$baseUrl/$trackingId/delevery')
        .replace(queryParameters: {
      'hubName': hubName,
      'employeeId': employeeId.toString(),
    });

    final response = await http.post(url);

    if (response.statusCode == 200) {
      return response.body.isNotEmpty
          ? response.body
          : "Delivery successful!";
    } else {
      throw Exception('Delivery failed: ${response.body}');
    }
  }
}
