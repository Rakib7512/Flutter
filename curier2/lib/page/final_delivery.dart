import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/delivery_service.dart';

class FinalDeliveryPage extends StatefulWidget {
  const FinalDeliveryPage({Key? key}) : super(key: key);

  @override
  State<FinalDeliveryPage> createState() => _FinalDeliveryPageState();
}

class _FinalDeliveryPageState extends State<FinalDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trackingIdController = TextEditingController();
  final DeliveryService _deliveryService = DeliveryService();

  String? _hubName;
  String? _hubNumber; // ✅ declared here (top level)
  int? _employeeId;
  String _message = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _employeeId = prefs.getInt('employeeId');
      _hubName = prefs.getString('employeeHub');
      _hubNumber = prefs.getString('employeeHubNumber');
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = '';
    });

    try {
      final trackingId = _trackingIdController.text.trim();
      final response = await _deliveryService.deliverParcel(
        trackingId,
        _hubName ?? '',
        _employeeId ?? 0,
      );

      setState(() {
        _message = '✅ Delivery Successful!';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _loading = false;
        _trackingIdController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 Final Delivery'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Employee Info
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Employee ID',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _employeeId?.toString() ?? '',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Hub Name',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _hubName ?? '',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Optional Hub Number (if you want to show)
                  if (_hubNumber != null && _hubNumber!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Hub Number',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _hubNumber ?? '',
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Tracking ID
                  TextFormField(
                    controller: _trackingIdController,
                    decoration: const InputDecoration(
                      labelText: 'Tracking ID',
                      hintText: 'Enter Tracking ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tracking ID is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.local_shipping),
                    label: Text(_loading ? 'Processing...' : 'Deliver Parcel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Message Section
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: TextStyle(
                        color: _message.startsWith('✅') ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
