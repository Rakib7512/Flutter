// lib/models/police_station.dart
class PoliceStation {
  final int id;
  final String name;
  // Assuming PoliceStation has an ID and a Name, based on your component logic

  PoliceStation({required this.id, required this.name});

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
      id: json['id'],
      name: json['name'],
    );
  }
}