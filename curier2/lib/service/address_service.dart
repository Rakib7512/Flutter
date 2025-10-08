import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:curier2/entity/country.dart';
import 'package:curier2/entity/division.dart';
import 'package:curier2/entity/district.dart';
import 'package:curier2/entity/police_station.dart';

class AddressService {
  final String baseUrl = "http://localhost:8080/api";

  Future<List<Country>> getCountries() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/countries"));
      print("Country Response: ${response.body}"); // Debug print
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Country.fromJson(e)).toList();
      } else {
        print("Error loading countries: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in getCountries: $e");
    }
    return [];
  }

  Future<List<Division>> getDivisionsByCountry(int countryId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/divisions/by-country/$countryId"));
      print("Division Response: ${response.body}");
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Division.fromJson(e)).toList();
      }
    } catch (e) {
      print("Exception in getDivisionsByCountry: $e");
    }
    return [];
  }

  Future<List<District>> getDistrictsByDivision(int divisionId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/districts/by-division/$divisionId"));
      print("District Response: ${response.body}");
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => District.fromJson(e)).toList();
      }
    } catch (e) {
      print("Exception in getDistrictsByDivision: $e");
    }
    return [];
  }

  Future<List<PoliceStation>> getPoliceStationsByDistrict(int districtId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/police-stations/by-district/$districtId"));
      print("PoliceStation Response: ${response.body}");
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => PoliceStation.fromJson(e)).toList();
      }
    } catch (e) {
      print("Exception in getPoliceStationsByDistrict: $e");
    }
    return [];
  }
}
