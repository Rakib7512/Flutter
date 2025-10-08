class PoliceStation {
  final int id;
  final String name;

  PoliceStation({required this.id, required this.name});

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
      id: json['id'],
      name: json['name'],
    );
  }
}
