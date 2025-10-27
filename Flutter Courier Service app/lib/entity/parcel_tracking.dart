class ParcelTrackingDTO {
  final String hubName;
  final String status;
  final String timestamp;

  ParcelTrackingDTO({
    required this.hubName,
    required this.status,
    required this.timestamp,
  });

  factory ParcelTrackingDTO.fromJson(Map<String, dynamic> json) {
    return ParcelTrackingDTO(
      hubName: json['hubName'] ?? '',
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
