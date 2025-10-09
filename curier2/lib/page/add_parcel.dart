import 'dart:convert';
import 'package:curier2/entity/country.dart';
import 'package:curier2/entity/district.dart';
import 'package:curier2/entity/division.dart';
import 'package:curier2/entity/parcel.dart';
import 'package:curier2/entity/police_station.dart';
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
  final ParcelService parcelService = ParcelService();
  final uuid = Uuid();

  // Address data
  List<Country> countries = [];
  List<Division> divisions = [];
  List<District> districts = [];
  List<PoliceStation> policeStations = [];

  // Sender
  final senderName = TextEditingController();
  final senderPhone = TextEditingController();
  Country? selectedSenderCountry;
  Division? selectedSenderDivision;
  District? selectedSenderDistrict;
  PoliceStation? selectedSenderPoliceStation;
  final senderLine1 = TextEditingController();
  final senderLine2 = TextEditingController();

  // Receiver
  final receiverName = TextEditingController();
  final receiverPhone = TextEditingController();
  Country? selectedReceiverCountry;
  Division? selectedReceiverDivision;
  District? selectedReceiverDistrict;
  PoliceStation? selectedReceiverPoliceStation;
  final receiverLine1 = TextEditingController();
  final receiverLine2 = TextEditingController();

  String? size;
  double fee = 0;

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  // ✅ Loaders
  Future<void> loadCountries() async {
    countries = await parcelService.getCountries();
    setState(() {});
  }

  Future<void> loadDivisions(int countryId, bool isSender) async {
    divisions = await parcelService.getDivisionsByCountry(countryId);
    setState(() {
      if (isSender) {
        selectedSenderDivision = null;
        selectedSenderDistrict = null;
        selectedSenderPoliceStation = null;
      } else {
        selectedReceiverDivision = null;
        selectedReceiverDistrict = null;
        selectedReceiverPoliceStation = null;
      }
      districts.clear();
      policeStations.clear();
    });
  }

  Future<void> loadDistricts(int divisionId, bool isSender) async {
    districts = await parcelService.getDistrictsByDivision(divisionId);
    setState(() {
      if (isSender) {
        selectedSenderDistrict = null;
        selectedSenderPoliceStation = null;
      } else {
        selectedReceiverDistrict = null;
        selectedReceiverPoliceStation = null;
      }
      policeStations.clear();
    });
  }

  Future<void> loadPoliceStations(int districtId, bool isSender) async {
    policeStations = await parcelService.getPoliceStationsByDistrict(districtId);
    setState(() {
      if (isSender) {
        selectedSenderPoliceStation = null;
      } else {
        selectedReceiverPoliceStation = null;
      }
    });
  }

  // ✅ Fee calculation
  void calculateFee() {
    double base = 0;

    final feeMap = {
      'SMALL': 100.0,
      'MEDIUM': 300.0,
      'LARGE': 500.0,
      'EXTRA_LARGE': 800.0,
    };

    base = feeMap[size] ?? 0;

    // Optional: add extra cost for different district
    if (selectedSenderDistrict != null &&
        selectedReceiverDistrict != null &&
        selectedSenderDistrict!.id != selectedReceiverDistrict!.id) {
      base += 100; // extra fee if different district
    }

    setState(() {
      fee = base;
    });
  }

  // ✅ Save Parcel
  Future<void> saveParcel() async {
    if (senderName.text.isEmpty ||
        senderPhone.text.isEmpty ||
        selectedSenderCountry == null ||
        selectedSenderDivision == null ||
        selectedSenderDistrict == null ||
        selectedSenderPoliceStation == null ||
        senderLine1.text.isEmpty ||
        senderLine2.text.isEmpty ||
        receiverName.text.isEmpty ||
        receiverPhone.text.isEmpty ||
        selectedReceiverCountry == null ||
        selectedReceiverDivision == null ||
        selectedReceiverDistrict == null ||
        selectedReceiverPoliceStation == null ||
        receiverLine1.text.isEmpty ||
        receiverLine2.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final consumerId = prefs.getInt('consumerId') ?? 1;
    final trackingId = uuid.v4();

    final parcel = Parcel(
      senderName: senderName.text,
      senderPhone: senderPhone.text,
      receiverName: receiverName.text,
      receiverPhone: receiverPhone.text,
      addressLineForSender1: senderLine1.text,
      addressLineForSender2: senderLine2.text,
      addressLineForReceiver1: receiverLine1.text,
      addressLineForReceiver2: receiverLine2.text,
      senderCountryId: selectedSenderCountry!.id,
      senderDivisionId: selectedSenderDivision!.id,
      senderDistrictId: selectedSenderDistrict!.id,
      senderPoliceStationId: selectedSenderPoliceStation!.id,
      receiverCountryId: selectedReceiverCountry!.id,
      receiverDivisionId: selectedReceiverDivision!.id,
      receiverDistrictId: selectedReceiverDistrict!.id,
      receiverPoliceStationId: selectedReceiverPoliceStation!.id,
      trackingId: trackingId,
      // consumerId: consumerId,
      // size: size,
      // fee: fee,
    );

    bool success = await parcelService.addParcel(parcel);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
      Text(success ? 'Parcel Saved Successfully' : 'Failed to Save Parcel'),
      backgroundColor: success ? Colors.green : Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Parcel")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sender Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: senderName, decoration: const InputDecoration(labelText: 'Sender Name')),
            TextField(controller: senderPhone, decoration: const InputDecoration(labelText: 'Sender Phone')),
            const SizedBox(height: 8),
            DropdownButtonFormField<Country>(
              value: selectedSenderCountry,
              decoration: const InputDecoration(labelText: 'Sender Country'),
              items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderCountry = val);
                if (val != null) loadDivisions(val.id, true);
              },
            ),
            DropdownButtonFormField<Division>(
              value: selectedSenderDivision,
              decoration: const InputDecoration(labelText: 'Sender Division'),
              items: divisions.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderDivision = val);
                if (val != null) loadDistricts(val.id, true);
              },
            ),
            DropdownButtonFormField<District>(
              value: selectedSenderDistrict,
              decoration: const InputDecoration(labelText: 'Sender District'),
              items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderDistrict = val);
                if (val != null) loadPoliceStations(val.id, true);
              },
            ),
            DropdownButtonFormField<PoliceStation>(
              value: selectedSenderPoliceStation,
              decoration: const InputDecoration(labelText: 'Sender Police Station'),
              items: policeStations.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderPoliceStation = val);
              },
            ),
            TextField(controller: senderLine1, decoration: const InputDecoration(labelText: 'Sender Address Line 1')),
            TextField(controller: senderLine2, decoration: const InputDecoration(labelText: 'Sender Address Line 2')),

            const SizedBox(height: 20),
            const Text("Receiver Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: receiverName, decoration: const InputDecoration(labelText: 'Receiver Name')),
            TextField(controller: receiverPhone, decoration: const InputDecoration(labelText: 'Receiver Phone')),
            const SizedBox(height: 8),
            DropdownButtonFormField<Country>(
              value: selectedReceiverCountry,
              decoration: const InputDecoration(labelText: 'Receiver Country'),
              items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverCountry = val);
                if (val != null) loadDivisions(val.id, false);
              },
            ),
            DropdownButtonFormField<Division>(
              value: selectedReceiverDivision,
              decoration: const InputDecoration(labelText: 'Receiver Division'),
              items: divisions.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverDivision = val);
                if (val != null) loadDistricts(val.id, false);
              },
            ),
            DropdownButtonFormField<District>(
              value: selectedReceiverDistrict,
              decoration: const InputDecoration(labelText: 'Receiver District'),
              items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverDistrict = val);
                if (val != null) loadPoliceStations(val.id, false);
              },
            ),
            DropdownButtonFormField<PoliceStation>(
              value: selectedReceiverPoliceStation,
              decoration: const InputDecoration(labelText: 'Receiver Police Station'),
              items: policeStations.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverPoliceStation = val);
              },
            ),
            TextField(controller: receiverLine1, decoration: const InputDecoration(labelText: 'Receiver Address Line 1')),
            TextField(controller: receiverLine2, decoration: const InputDecoration(labelText: 'Receiver Address Line 2')),

            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: size,
              decoration: const InputDecoration(labelText: 'Parcel Size'),
              items: const [
                DropdownMenuItem(value: 'SMALL', child: Text('Small')),
                DropdownMenuItem(value: 'MEDIUM', child: Text('Medium')),
                DropdownMenuItem(value: 'LARGE', child: Text('Large')),
                DropdownMenuItem(value: 'EXTRA_LARGE', child: Text('Extra Large')),
              ],
              onChanged: (val) {
                setState(() => size = val);
                calculateFee();
              },
            ),

            const SizedBox(height: 10),
            Text("Calculated Fee: ৳${fee.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveParcel,
              child: const Text('Save Parcel'),
            ),
          ],
        ),
      ),
    );
  }
}
