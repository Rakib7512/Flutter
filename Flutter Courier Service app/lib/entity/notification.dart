class NotificationModel {
  final int id;
  final String message;
  final bool received;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.received,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
      received: json['received'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
