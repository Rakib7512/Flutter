import 'package:curier2/entity/notification.dart';
import 'package:flutter/material.dart';

import '../service/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  int employeeId = 1; // 🔹 Replace with your stored ID (from SharedPreferences)
  bool _isLoading = true;
  bool _showToast = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final data = await _notificationService.getEmployeeNotifications(employeeId);
      setState(() {
        _notifications = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> _markAsReceived(NotificationModel n) async {
    final trackingIdRegex = RegExp(
        r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}');
    final match = trackingIdRegex.firstMatch(n.message);
    final trackingId = match?.group(0);
    if (trackingId == null) return;

    try {
      await _notificationService.receiveNotification(employeeId, trackingId, n.id);

      setState(() {
        _showToast = true;
        _notifications = _notifications.map((notif) {
          if (notif.id == n.id) {
            return NotificationModel(
              id: notif.id,
              message: notif.message,
              received: true,
              createdAt: notif.createdAt,
            );
          }
          return notif;
        }).toList();
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() => _showToast = false);
      });
    } catch (e) {
      print('Error receiving notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final n = _notifications[index];
              return Card(
                color: n.received ? Colors.grey[200] : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    n.message,
                    style: TextStyle(
                      fontWeight: n.received ? FontWeight.normal : FontWeight.bold,
                      color: n.received ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(n.createdAt),
                  trailing: n.received
                      ? const Chip(label: Text('Received'))
                      : ElevatedButton(
                    onPressed: () => _markAsReceived(n),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Receive'),
                  ),
                ),
              );
            },
          ),

          // ✅ Toast Message
          if (_showToast)
            Positioned(
              top: 40,
              right: 20,
              child: AnimatedOpacity(
                opacity: _showToast ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Parcel received successfully!',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
