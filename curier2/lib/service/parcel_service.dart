import 'dart:convert';
import 'package:curier2/entity/country.dart';
import 'package:curier2/entity/district.dart';
import 'package:curier2/entity/division.dart';
import 'package:curier2/entity/parcel.dart';
import 'package:curier2/entity/police_station.dart';
import 'package:http/http.dart' as http;

class ParcelService {
  final String baseUrl = "http://localhost:8085/api";

  Future<bool> addParcel(Parcel parcel) async {


    final response = await http.post(
      Uri.parse(baseUrl+'/parcels/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(parcel.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      return false;
    }
  }



  Future<List<Country>> getCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/countries/'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Country.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries');
  }



  Future<List<Division>> getDivisionsByCountry(int countryId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/division/by-country/$countryId'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Division.fromJson(e)).toList();
    }
    throw Exception('Failed to load divisions');
  }

  Future<List<District>> getDistrictsByDivision(int divisionId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/district/by-division/$divisionId'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => District.fromJson(e)).toList();
    }
    throw Exception('Failed to load districts');
  }

  Future<List<PoliceStation>> getPoliceStationsByDistrict(int districtId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/policestation/by-district/$districtId'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => PoliceStation.fromJson(e)).toList();
    }
    throw Exception('Failed to load police stations');
  }


  // 🟣 Get parcel history for logged-in consumer
  Future<List<dynamic>> getParcelHistoryByConsumer(String token) async {
    final url = Uri.parse('$baseUrl/parcels/history');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error loading parcel history: ${response.statusCode}");
      throw Exception("Failed to load parcel history");
    }
  }
}