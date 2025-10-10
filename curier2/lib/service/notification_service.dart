import 'dart:convert';
import 'package:curier2/entity/notification.dart';
import 'package:http/http.dart' as http;


class NotificationService {
  final String baseUrl = 'http://localhost:8085/api/notifications';

  // 🔐 Get Auth Token from localStorage equivalent (SharedPreferences)
  Future<String> _getAuthToken() async {
    // You can replace this with flutter_secure_storage or SharedPreferences
    return ''; // Temporary placeholder if token not stored yet
  }

  // 📨 Fetch Notifications for Employee
  Future<List<NotificationModel>> getEmployeeNotifications(int employeeId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$baseUrl/employee/$employeeId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((n) => NotificationModel.fromJson(n)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // ✅ Receive Notification & Claim Parcel
  Future<void> receiveNotification(int employeeId, String trackingId, int notificationId) async {
    final token = await _getAuthToken();

    final notificationUrl = '$baseUrl/$notificationId/receive';
    final parcelUrl =
        'http://localhost:8085/api/parcels/parcel/$trackingId/claimPickup/$employeeId';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Perform both requests
    final responses = await Future.wait([
      http.put(Uri.parse(notificationUrl), headers: headers),
      http.put(Uri.parse(parcelUrl), headers: headers),
    ]);

    if (responses.any((r) => r.statusCode >= 400)) {
      throw Exception('Failed to receive notification');
    }
  }
}
