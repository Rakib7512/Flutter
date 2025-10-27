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
  List<Country> senderCountries = [];
  List<Division>senderDivisions = [];
  List<District> senderDistricts = [];
  List<PoliceStation> senderPoliceStations = [];

  List<Country> receiverCountries = [];
  List<Division> receiverDivisions = [];
  List<District> receiverDistricts = [];
  List<PoliceStation> receiverPoliceStations = [];

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
    loadCountriesForSender();
    loadCountriesForReceiver();
  }

  // ✅ Loaders
  Future<void> loadCountriesForSender() async {
    senderCountries = await parcelService.getCountries();
    setState(() {});
  }

  Future<void> loadDivisionsForSender(int countryId, bool isSender) async {
    senderDivisions = await parcelService.getDivisionsByCountry(countryId);
    setState(() {
        selectedSenderDivision = null;
        selectedSenderDistrict = null;
        selectedSenderPoliceStation = null;
      senderDistricts.clear();
      senderPoliceStations.clear();
    });
  }

  Future<void> loadDistrictsForSender(int divisionId, bool isSender) async {
    senderDistricts = await parcelService.getDistrictsByDivision(divisionId);
    setState(() {

        selectedSenderDistrict = null;
        selectedSenderPoliceStation = null;
      senderPoliceStations.clear();
    });
  }

  Future<void> loadPoliceStationsForSender(int districtId, bool isSender) async {
    senderPoliceStations = await parcelService.getPoliceStationsByDistrict(districtId);
    setState(() {
        selectedSenderPoliceStation = null;
    });
  }





  Future<void> loadCountriesForReceiver() async {
    receiverCountries = await parcelService.getCountries();
    setState(() {});
  }

  Future<void> loadDivisionsForReceiver(int countryId, bool isSender) async {
    receiverDivisions = await parcelService.getDivisionsByCountry(countryId);
    setState(() {
      selectedReceiverDivision = null;
      selectedReceiverDistrict = null;
      selectedReceiverPoliceStation = null;
      receiverDistricts.clear();
      receiverPoliceStations.clear();
    });
  }

  Future<void> loadDistrictsForReceiver(int divisionId, bool isSender) async {
    receiverDistricts = await parcelService.getDistrictsByDivision(divisionId);
    setState(() {
        selectedReceiverDistrict = null;
        selectedReceiverPoliceStation = null;
      receiverPoliceStations.clear();
    });
  }

  Future<void> loadPoliceStationsForReceiver(int districtId, bool isSender) async {
    receiverPoliceStations = await parcelService.getPoliceStationsByDistrict(districtId);
    setState(() {
        selectedReceiverPoliceStation = null;
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
      sendCountry: {'id': selectedSenderCountry!.id},
      sendDivision: {'id': selectedSenderDivision!.id},
      sendDistrict: {'id': selectedSenderDistrict!.id},
      sendPoliceStation: {'id': selectedSenderPoliceStation!.id},
      receiveCountry: {'id': selectedReceiverCountry!.id},
      receiveDivision: {'id': selectedReceiverDivision!.id},
      receiveDistrict: {'id': selectedReceiverDistrict!.id},
      receivePoliceStation: {'id': selectedReceiverPoliceStation!.id},
      trackingId: trackingId,
      size: size ?? 'SMALL',
      fee: fee.round(),
      consumer: {'id': consumerId}, // if needed
    );



    print(parcel.toString());

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
              items: senderCountries.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderCountry = val);
                if (val != null) loadDivisionsForSender(val.id, true);
              },
            ),


            DropdownButtonFormField<Division>(
              value: selectedSenderDivision,
              decoration: const InputDecoration(labelText: 'Sender Division'),
              items: senderDivisions.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderDivision = val);
                if (val != null) loadDistrictsForSender(val.id, true);
              },
            ),


            DropdownButtonFormField<District>(
              value: selectedSenderDistrict,
              decoration: const InputDecoration(labelText: 'Sender District'),
              items: senderDistricts.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedSenderDistrict = val);
                if (val != null) loadPoliceStationsForSender(val.id, true);
              },
            ),


            DropdownButtonFormField<PoliceStation>(
              value: selectedSenderPoliceStation,
              decoration: const InputDecoration(labelText: 'Sender Police Station'),
              items: senderPoliceStations.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
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
              items: receiverCountries.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverCountry = val);
                if (val != null) loadDivisionsForReceiver(val.id, false);
              },
            ),
            DropdownButtonFormField<Division>(
              value: selectedReceiverDivision,
              decoration: const InputDecoration(labelText: 'Receiver Division'),
              items: receiverDivisions.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverDivision = val);
                if (val != null) loadDistrictsForReceiver(val.id, false);
              },
            ),
            DropdownButtonFormField<District>(
              value: selectedReceiverDistrict,
              decoration: const InputDecoration(labelText: 'Receiver District'),
              items: receiverDistricts.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
              onChanged: (val) {
                setState(() => selectedReceiverDistrict = val);
                if (val != null) loadPoliceStationsForReceiver(val.id, false);
              },
            ),
            DropdownButtonFormField<PoliceStation>(
              value: selectedReceiverPoliceStation,
              decoration: const InputDecoration(labelText: 'Receiver Police Station'),
              items: receiverPoliceStations.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
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
                setState(() => size = val ?? 'SMALL');
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
