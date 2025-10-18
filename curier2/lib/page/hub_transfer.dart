import 'package:curier2/service/hub_transfer_service.dart';
import 'package:flutter/material.dart';


class TransferHubScreen extends StatefulWidget {
  const TransferHubScreen({ Key? key }) : super(key: key);

  @override
  _TransferHubScreenState createState() => _TransferHubScreenState();
}

class _TransferHubScreenState extends State<TransferHubScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _trackingIdController = TextEditingController();
  String? _previousHub;
  String? _currentHub;
  String? _toHub;
  final TextEditingController _employeeIdController = TextEditingController();

  bool _loading = false;
  String? _successMessage;
  String? _errorMessage;

  final TransferHubService _service = TransferHubService(baseUrl: 'https://yourapi.example.com/api');

  List<String> _allHubs = ['Hub A', 'Hub B', 'Hub C']; // you would load this dynamically

  void _onTrackingIdChanged() async {
    final trackingId = _trackingIdController.text.trim();
    if (trackingId.isEmpty) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final details = await _service.getParcelDetailsForTransfer(trackingId);
      // adjust based on your backend’s response structure
      setState(() {
        _previousHub = details['previousHubName'] as String? ?? 'Unknown';
        _currentHub = details['currentHubName'] as String? ?? 'Unknown';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final trackingId = _trackingIdController.text.trim();
    final toHub = _toHub!;
    final employeeId = int.tryParse(_employeeIdController.text.trim());
    if (employeeId == null) {
      setState(() {
        _errorMessage = 'Invalid employee ID';
      });
      return;
    }

    setState(() {
      _loading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    try {
      final msg = await _service.transferParcel(
        trackingId: trackingId,
        hubName: toHub,
        employeeId: employeeId,
      );
      setState(() {
        _successMessage = msg;
        _loading = false;
      });
      // Optionally reset form
      _formKey.currentState!.reset();
      _previousHub = null;
      _currentHub = null;
      _toHub = null;
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _trackingIdController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Parcel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              if (_errorMessage != null)
                Container(
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(8),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              if (_successMessage != null)
                Container(
                  color: Colors.green.shade100,
                  padding: const EdgeInsets.all(8),
                  child: Text(_successMessage!, style: const TextStyle(color: Colors.green)),
                ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _trackingIdController,
                      decoration: const InputDecoration(
                        labelText: 'Tracking ID',
                      ),
                      onFieldSubmitted: (_) => _onTrackingIdChanged(),
                      onChanged: (_) {
                        // optionally debounce
                      },
                      validator: (v) => v == null || v.isEmpty ? 'Please enter tracking ID' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'From Hub',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                      enabled: false,
                      initialValue: _previousHub,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Current Hub',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                      enabled: false,
                      initialValue: _currentHub,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _toHub,
                      items: _allHubs.map((hub) {
                        return DropdownMenuItem<String>(
                          value: hub,
                          child: Text(hub),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() { _toHub = val; });
                      },
                      decoration: const InputDecoration(labelText: 'To Hub'),
                      validator: (v) => v == null || v.isEmpty ? 'Please select target hub' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Employee ID',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter employee ID';
                        final n = int.tryParse(v);
                        if (n == null || n < 1) return 'Enter a valid employee ID';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onSubmit,
                        child: const Text('Transfer Parcel'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
