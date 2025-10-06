import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:curier2/service/authService.dart';

class ParcelService {
  final String baseUrl = "http://localhost:8085"; // change if using emulator/device

  // 🔹 Save new parcel
  Future<Map<String, dynamic>?> saveParcel(Map<String, dynamic> parcelData) async {
    String? token = await AuthService().getToken();
    if (token == null) {
      print("❌ No token found. Please log in first.");
      return null;
    }

    final url = Uri.parse("$baseUrl/api/parcels/save");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(parcelData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Parcel saved successfully");
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to save parcel: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  // 🔹 Get all parcels (Admin/Employee)
  Future<List<dynamic>> getAllParcels() async {
    String? token = await AuthService().getToken();
    if (token == null) return [];

    final url = Uri.parse("$baseUrl/api/parcels/all");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to fetch parcels: ${response.statusCode}");
      return [];
    }
  }

  // 🔹 Get parcel by ID
  Future<Map<String, dynamic>?> getParcelById(int id) async {
    String? token = await AuthService().getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/parcels/$id");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to fetch parcel: ${response.statusCode}");
      return null;
    }
  }

  // 🔹 Get parcel by tracking ID
  Future<List<dynamic>> getParcelByTrackingId(String trackingId) async {
    String? token = await AuthService().getToken();
    if (token == null) return [];

    final url = Uri.parse("$baseUrl/api/parcels/track/$trackingId");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to fetch tracking info: ${response.statusCode}");
      return [];
    }
  }

  // 🔹 Update existing parcel
  Future<Map<String, dynamic>?> updateParcel(Map<String, dynamic> parcelData) async {
    String? token = await AuthService().getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/parcels/update");
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(parcelData),
    );

    if (response.statusCode == 200) {
      print("✅ Parcel updated");
      return jsonDecode(response.body);
    } else {
      print("❌ Update failed: ${response.statusCode}");
      return null;
    }
  }

  // 🔹 Delete parcel
  Future<bool> deleteParcel(int id) async {
    String? token = await AuthService().getToken();
    if (token == null) return false;

    final url = Uri.parse("$baseUrl/api/parcels/delete/$id");
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      print("✅ Parcel deleted");
      return true;
    } else {
      print("❌ Delete failed: ${response.statusCode}");
      return false;
    }
  }

  // 🔹 Add tracking info for a parcel
  Future<Map<String, dynamic>?> addTrackingToParcel(
      int parcelId, Map<String, dynamic> trackingData) async {
    String? token = await AuthService().getToken();
    if (token == null) return null;

    final url = Uri.parse("$baseUrl/api/parcels/$parcelId/add-tracking");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(trackingData),
    );

    if (response.statusCode == 200) {
      print("✅ Tracking added");
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to add tracking: ${response.statusCode}");
      return null;
    }
  }

  // 🔹 Get parcel tracking history
  Future<List<dynamic>> getParcelTrackingHistory(int parcelId) async {
    String? token = await AuthService().getToken();
    if (token == null) return [];

    final url = Uri.parse("$baseUrl/api/parcels/$parcelId/tracking-history");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to fetch tracking history: ${response.statusCode}");
      return [];
    }
  }

  // 🔹 Get parcel history by consumer
  Future<List<dynamic>> getParcelHistoryByConsumer(int consumerId) async {
    String? token = await AuthService().getToken();
    if (token == null) return [];

    final url = Uri.parse("$baseUrl/api/parcels/history/$consumerId");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("❌ Failed to fetch parcel history: ${response.statusCode}");
      return [];
    }
  }
}
