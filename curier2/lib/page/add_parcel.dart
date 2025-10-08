import 'dart:convert';
import 'package:curier2/entity/country.dart';
import 'package:curier2/entity/district.dart';
import 'package:curier2/entity/division.dart';
import 'package:curier2/entity/police_station.dart';
import 'package:curier2/service/address_service.dart';
import 'package:curier2/service/parcel_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddParcelPage extends StatefulWidget {
  const AddParcelPage({super.key});

  @override
  State<AddParcelPage> createState() => _AddParcelPageState();
}

class _AddParcelPageState extends State<AddParcelPage> {
  final AddressService addressService = AddressService();
  final ParcelService parcelService = ParcelService();
  final uuid = Uuid();

  // sender info
  String senderName = '';
  String senderPhone = '';
  int? sendCountry, sendDivision, sendDistrict, sendPoliceStation;

  // receiver info
  String receiverName = '';
  String receiverPhone = '';
  int? receiveCountry, receiveDivision, receiveDistrict, receivePoliceStation;

  String size = '';
  double fee = 0;
  String paymentMethod = '';
  String? confirmationCode;

  List<Country> countries = [];
  List<Division> divisions = [];
  List<District> districts = [];
  List<PoliceStation> policeStations = [];

  List<Country> receiverCountries = [];
  List<Division> receiverDivisions = [];
  List<District> receiverDistricts = [];
  List<PoliceStation> receiverPoliceStations = [];

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> loadCountries() async {
    countries = await addressService.getCountries();
    receiverCountries = await addressService.getCountries();
    setState(() {});
  }

  Future<void> onSendCountryChange(int countryId) async {
    divisions = await addressService.getDivisionsByCountry(countryId);
    setState(() {});
  }

  Future<void> onSendDivisionChange(int divisionId) async {
    districts = await addressService.getDistrictsByDivision(divisionId);
    setState(() {});
  }

  Future<void> onSendDistrictChange(int districtId) async {
    policeStations = await addressService.getPoliceStationsByDistrict(districtId);
    setState(() {});
  }

  Future<void> onReceiveCountryChange(int countryId) async {
    receiverDivisions = await addressService.getDivisionsByCountry(countryId);
    setState(() {});
  }

  Future<void> onReceiveDivisionChange(int divisionId) async {
    receiverDistricts = await addressService.getDistrictsByDivision(divisionId);
    setState(() {});
  }

  Future<void> onReceiveDistrictChange(int districtId) async {
    receiverPoliceStations = await addressService.getPoliceStationsByDistrict(districtId);
    setState(() {});
  }

  void calculateFee() {
    double base = 0;
    switch (size) {
      case 'SMALL': base = 100; break;
      case 'MEDIUM': base = 300; break;
      case 'LARGE': base = 500; break;
      case 'EXTRA_LARGE': base = 800; break;
    }
    fee = base;
    setState(() {});
  }

  Future<void> submitParcel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final consumerId = prefs.getInt('consumerId') ?? 1; // fallback

    final trackingId = uuid.v4();

    final parcelData = {
      "senderName": senderName,
      "senderPhone": senderPhone,
      "receiverName": receiverName,
      "receiverPhone": receiverPhone,
      "trackingId": trackingId,
      "size": size,
      "fee": fee,
      "sendCountry": {"id": sendCountry},
      "sendDivision": {"id": sendDivision},
      "sendDistrict": {"id": sendDistrict},
      "sendPoliceStation": {"id": sendPoliceStation},
      "receiveCountry": {"id": receiveCountry},
      "receiveDivision": {"id": receiveDivision},
      "receiveDistrict": {"id": receiveDistrict},
      "receivePoliceStation": {"id": receivePoliceStation},
      "consumer": {"id": consumerId}
    };

    final result = await parcelService.saveParcel(parcelData);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Parcel Created Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create parcel!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Parcel")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Sender Name"),
              onChanged: (v) => senderName = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Sender Phone"),
              onChanged: (v) => senderPhone = v,
            ),
            DropdownButtonFormField<int>(
              value: sendCountry,
              hint: const Text("Select Country"),
              items: countries.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (v) {
                sendCountry = v;
                onSendCountryChange(v!);
              },
            ),
            if (divisions.isNotEmpty)
              DropdownButtonFormField<int>(
                value: sendDivision,
                hint: const Text("Select Division"),
                items: divisions.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                onChanged: (v) {
                  sendDivision = v;
                  onSendDivisionChange(v!);
                },
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitParcel,
              child: const Text("Submit Parcel"),
            ),
          ],
        ),
      ),
    );
  }
}
