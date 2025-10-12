import 'package:curier2/entity/parcel_tracking.dart';
import 'package:flutter/material.dart';
import '../service/parcel_service.dart';

class TrackParcelPage extends StatefulWidget {
  const TrackParcelPage({Key? key}) : super(key: key);

  @override
  State<TrackParcelPage> createState() => _TrackParcelPageState();
}

class _TrackParcelPageState extends State<TrackParcelPage> {
  final TextEditingController _trackingIdController = TextEditingController();
  final ParcelService _parcelService = ParcelService();

  List<ParcelTrackingDTO> trackingList = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadTracking() async {
    final trackingId = _trackingIdController.text.trim();

    if (trackingId.isEmpty) {
      setState(() => errorMessage = 'Please enter a tracking ID');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      trackingList = [];
    });

    try {
      final result = await _parcelService.getParcelTracking(trackingId);
      setState(() {
        trackingList = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Parcel not found or failed to load.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Parcel'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _trackingIdController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Tracking ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: loadTracking,
                  child: const Text('Track'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Loading
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // Error Message
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

            // Tracking List
            if (!isLoading && trackingList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: trackingList.length,
                  itemBuilder: (context, index) {
                    final track = trackingList[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.blue),
                        title: Text(track.hubName,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${track.status}'),
                            Text('Time: ${track.timestamp}'),
                          ],
                        ),
                      ),
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
