import 'package:flutter/material.dart';
import 'package:curier2/entity/parcel_tracking.dart';
import 'package:curier2/service/parcel_service.dart';

class PublicHomePage extends StatefulWidget {
  const PublicHomePage({Key? key}) : super(key: key);

  @override
  State<PublicHomePage> createState() => _PublicHomePageState();
}

class _PublicHomePageState extends State<PublicHomePage> {
  final TextEditingController _trackingIdController = TextEditingController();
  final ParcelService _parcelService = ParcelService();

  List<ParcelTrackingDTO> trackingList = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> searchParcel() async {
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
        errorMessage = 'No parcel found with this tracking ID.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTrackingList() {
    if (trackingList.isEmpty) {
      return const Center(
        child: Text(
          'No tracking information yet.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: trackingList.length,
      itemBuilder: (context, index) {
        final track = trackingList[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: Text(
              track.hubName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Courier Service',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Banner Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    'Welcome to Express Courier Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Fast, Reliable, and Secure Delivery!',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Row(
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
                      ElevatedButton.icon(
                        onPressed: searchParcel,
                        icon: const Icon(Icons.search),
                        label: const Text('Track'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Center(child: CircularProgressIndicator()),

            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            if (!isLoading && trackingList.isNotEmpty)
              SizedBox(
                height: 400,
                child: _buildTrackingList(),
              ),
          ],
        ),
      ),
    );
  }
}
