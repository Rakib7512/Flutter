import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curier2/entity/parcel_tracking.dart';
import 'package:curier2/service/parcel_service.dart';
import 'package:curier2/loginpage.dart';
import 'package:curier2/registration.dart';

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
      setState(() => errorMessage = '⚠️ Please enter a tracking ID');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      trackingList = [];
    });

    try {
      final result = await _parcelService.getParcelTracking(trackingId);
      setState(() => trackingList = result);
    } catch (e) {
      setState(() => errorMessage = '❌ No parcel found with this tracking ID.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildTrackingList() {
    return ListView.builder(
      itemCount: trackingList.length,
      itemBuilder: (context, index) {
        final track = trackingList[index];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blueAccent.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blueAccent.withOpacity(0.15),
                child: const Icon(Icons.local_shipping_rounded,
                    color: Color(0xff0069D9), size: 30),
              ),
              title: Text(
                track.hubName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueGrey.shade900,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📦 Status: ${track.status}',
                        style: GoogleFonts.roboto(fontSize: 15, color: Colors.black87)),
                    Text(
                      '⏰ Time: ${track.timestamp}',
                      style: GoogleFonts.roboto(
                        color: Colors.grey[600],
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _appBarButton(String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Text(
          'EXPRESS COURIER SERVICE',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff0069D9), Color(0xff00B0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          _appBarButton('Login', Icons.login, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
          }),
          _appBarButton('Register', Icons.person_add_alt, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Registration()));
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Modern Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0069D9), Color(0xff00B0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Fast • Reliable • Secure Delivery',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your parcel anytime, anywhere in real-time.',
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tracking Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _trackingIdController,
                      style: GoogleFonts.poppins(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter your Tracking ID',
                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                        prefixIcon: const Icon(Icons.qr_code_2_rounded, color: Color(0xff0069D9)),
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.03),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.blueAccent.shade100, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xff0069D9), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: searchParcel,
                      icon: const Icon(Icons.search_rounded, size: 22),
                      label: const Text(
                        'TRACK PARCEL',
                        style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0069D9),
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Loading / Error / Tracking List
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: CircularProgressIndicator(color: Color(0xff0069D9)),
              ),
            if (errorMessage.isNotEmpty && !isLoading)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  errorMessage,
                  style: GoogleFonts.poppins(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (!isLoading && trackingList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: SizedBox(height: 420, child: _buildTrackingList()),
              ),
          ],
        ),
      ),
    );
  }
}
