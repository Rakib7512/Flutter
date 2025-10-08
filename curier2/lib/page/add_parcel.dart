import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddParcelPage extends StatefulWidget {
  const AddParcelPage({super.key});

  @override
  State<AddParcelPage> createState() => _AddParcelPageState();
}

class _AddParcelPageState extends State<AddParcelPage> {
  // Base URL (change this to your Spring Boot backend)
  final String baseUrl = "http://localhost:8080/api";

  // Sender selections
  String? selectedSendCountry;
  String? selectedSendDivision;
  String? selectedSendDistrict;
  String? selectedSendPoliceStation;

  // Receiver selections
  String? selectedReceiveCountry;
  String? selectedReceiveDivision;
  String? selectedReceiveDistrict;
  String? selectedReceivePoliceStation;

  // Sender lists
  List<dynamic> sendCountries = [];
  List<dynamic> sendDivisions = [];
  List<dynamic> sendDistricts = [];
  List<dynamic> sendPoliceStations = [];

  // Receiver lists
  List<dynamic> receiveCountries = [];
  List<dynamic> receiveDivisions = [];
  List<dynamic> receiveDistricts = [];
  List<dynamic> receivePoliceStations = [];

  // Load all countries when the page opens
  @override
  void initState() {
    super.initState();
    fetchSendCountries();
    fetchReceiveCountries();
  }

  // ------------------ Sender API calls ------------------

  Future<void> fetchSendCountries() async {
    final response = await http.get(Uri.parse("$baseUrl/countries"));
    if (response.statusCode == 200) {
      setState(() {
        sendCountries = jsonDecode(response.body);
      });
    }
  }

  Future<void> fetchSendDivisions(String countryId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/countries/$countryId/divisions"));
    if (response.statusCode == 200) {
      setState(() {
        sendDivisions = jsonDecode(response.body);
        sendDistricts = [];
        sendPoliceStations = [];
        selectedSendDivision = null;
        selectedSendDistrict = null;
        selectedSendPoliceStation = null;
      });
    }
  }

  Future<void> fetchSendDistricts(String divisionId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/divisions/$divisionId/districts"));
    if (response.statusCode == 200) {
      setState(() {
        sendDistricts = jsonDecode(response.body);
        sendPoliceStations = [];
        selectedSendDistrict = null;
        selectedSendPoliceStation = null;
      });
    }
  }

  Future<void> fetchSendPoliceStations(String districtId) async {
    final response = await http
        .get(Uri.parse("$baseUrl/districts/$districtId/policestations"));
    if (response.statusCode == 200) {
      setState(() {
        sendPoliceStations = jsonDecode(response.body);
        selectedSendPoliceStation = null;
      });
    }
  }

  // ------------------ Receiver API calls ------------------

  Future<void> fetchReceiveCountries() async {
    final response = await http.get(Uri.parse("$baseUrl/countries"));
    if (response.statusCode == 200) {
      setState(() {
        receiveCountries = jsonDecode(response.body);
      });
    }
  }

  Future<void> fetchReceiveDivisions(String countryId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/countries/$countryId/divisions"));
    if (response.statusCode == 200) {
      setState(() {
        receiveDivisions = jsonDecode(response.body);
        receiveDistricts = [];
        receivePoliceStations = [];
        selectedReceiveDivision = null;
        selectedReceiveDistrict = null;
        selectedReceivePoliceStation = null;
      });
    }
  }

  Future<void> fetchReceiveDistricts(String divisionId) async {
    final response =
    await http.get(Uri.parse("$baseUrl/divisions/$divisionId/districts"));
    if (response.statusCode == 200) {
      setState(() {
        receiveDistricts = jsonDecode(response.body);
        receivePoliceStations = [];
        selectedReceiveDistrict = null;
        selectedReceivePoliceStation = null;
      });
    }
  }

  Future<void> fetchReceivePoliceStations(String districtId) async {
    final response = await http
        .get(Uri.parse("$baseUrl/districts/$districtId/policestations"));
    if (response.statusCode == 200) {
      setState(() {
        receivePoliceStations = jsonDecode(response.body);
        selectedReceivePoliceStation = null;
      });
    }
  }

  // ------------------ Dropdown Widget ------------------

  Widget buildDropdown(String label, String? selectedValue, List<dynamic> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text("Select $label"),
              value: selectedValue,
              items: items.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: Text(item['name']),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------ UI Build ------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Parcel"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sender Information",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            const SizedBox(height: 12),
            buildDropdown("Country", selectedSendCountry, sendCountries, (v) {
              setState(() => selectedSendCountry = v);
              if (v != null) fetchSendDivisions(v);
            }),
            const SizedBox(height: 10),
            buildDropdown("Division", selectedSendDivision, sendDivisions, (v) {
              setState(() => selectedSendDivision = v);
              if (v != null) fetchSendDistricts(v);
            }),
            const SizedBox(height: 10),
            buildDropdown("District", selectedSendDistrict, sendDistricts, (v) {
              setState(() => selectedSendDistrict = v);
              if (v != null) fetchSendPoliceStations(v);
            }),
            const SizedBox(height: 10),
            buildDropdown("Police Station", selectedSendPoliceStation,
                sendPoliceStations, (v) {
                  setState(() => selectedSendPoliceStation = v);
                }),
            const Divider(height: 40, thickness: 1.5),
            const Text("Receiver Information",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            const SizedBox(height: 12),
            buildDropdown(
                "Country", selectedReceiveCountry, receiveCountries, (v) {
              setState(() => selectedReceiveCountry = v);
              if (v != null) fetchReceiveDivisions(v);
            }),
            const SizedBox(height: 10),
            buildDropdown(
                "Division", selectedReceiveDivision, receiveDivisions, (v) {
              setState(() => selectedReceiveDivision = v);
              if (v != null) fetchReceiveDistricts(v);
            }),
            const SizedBox(height: 10),
            buildDropdown(
                "District", selectedReceiveDistrict, receiveDistricts, (v) {
              setState(() => selectedReceiveDistrict = v);
              if (v != null) fetchReceivePoliceStations(v);
            }),
            const SizedBox(height: 10),
            buildDropdown("Police Station", selectedReceivePoliceStation,
                receivePoliceStations, (v) {
                  setState(() => selectedReceivePoliceStation = v);
                }),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    backgroundColor: Colors.deepPurple),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Save Parcel",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  // TODO: Add save parcel logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Parcel Saved Successfully!")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
