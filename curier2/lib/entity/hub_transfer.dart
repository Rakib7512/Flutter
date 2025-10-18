class HubTransfer {
  final String id;
  final String parcelId;
  final String fromHub;
  final String toHub;
  final String departedAt;
  final String currentHub;
  final String courierBy;

  HubTransfer({
    required this.id,
    required this.parcelId,
    required this.fromHub,
    required this.toHub,
    required this.departedAt,
    required this.currentHub,
    required this.courierBy,
  });

  factory HubTransfer.fromJson(Map<String, dynamic> json) {
    return HubTransfer(
      id: json['id'] as String,
      parcelId: json['parcelId'] as String,
      fromHub: json['fromHub'] as String,
      toHub: json['toHub'] as String,
      departedAt: json['departedAt'] as String,
      currentHub: json['currentHub'] as String,
      courierBy: json['courierBy'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parcelId': parcelId,
      'fromHub': fromHub,
      'toHub': toHub,
      'departedAt': departedAt,
      'currentHub': currentHub,
      'courierBy': courierBy,
    };
  }
}
