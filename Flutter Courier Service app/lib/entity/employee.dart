class Employee {
  int id;
  String name;
  String email;
  String gender;
  String nid;
  String address;
  String designation;
  DateTime joindate;
  String phone;
  double salary;
  String photo;
  String empOnHub;
  Country countryId;
  Division divisionId;
  District districtId;
  PoliceStation policeStationId;
  User userId;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.nid,
    required this.address,
    required this.designation,
    required this.joindate,
    required this.phone,
    required this.salary,
    required this.photo,
    required this.empOnHub,
    required this.countryId,
    required this.divisionId,
    required this.districtId,
    required this.policeStationId,
    required this.userId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      nid: json['nid'],
      address: json['address'],
      designation: json['designation'],
      joindate: DateTime.parse(json['joindate']),
      phone: json['phone'],
      salary: json['salary'],
      photo: json['photo'],
      empOnHub: json['empOnHub'],
      countryId: Country.fromJson(json['countryId']),
      divisionId: Division.fromJson(json['divisionId']),
      districtId: District.fromJson(json['districtId']),
      policeStationId: PoliceStation.fromJson(json['policeStationId']),
      userId: User.fromJson(json['userId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'nid': nid,
      'address': address,
      'designation': designation,
      'joindate': joindate.toIso8601String(),
      'phone': phone,
      'salary': salary,
      'photo': photo,
      'empOnHub': empOnHub,
      'countryId': countryId.toJson(),
      'divisionId': divisionId.toJson(),
      'districtId': districtId.toJson(),
      'policeStationId': policeStationId.toJson(),
      'userId': userId.toJson(),
    };
  }
}

class Country {
  int id;
  String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class Division {
  int id;
  String name;

  Division({required this.id, required this.name});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class District {
  int id;
  String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class PoliceStation {
  int id;
  String name;

  PoliceStation({required this.id, required this.name});

  factory PoliceStation.fromJson(Map<String, dynamic> json) {
    return PoliceStation(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class User {
  int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}
