import 'dart:convert';
import 'package:http/http.dart' as http;

class ParcelService {
  final String baseUrl = "http://localhost:8085/api/parcels";

  Future<Map<String, dynamic>?> saveParcel(Map<String, dynamic> parcelData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(parcelData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print("Error: ${response.body}");
      return null;
    }
  }
}
