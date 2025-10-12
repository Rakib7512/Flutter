import 'package:curier2/loginpage.dart';
import 'package:curier2/page/add_parcel.dart';
import 'package:curier2/service/authService.dart';
import 'package:curier2/service/parcel_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsumerProfile extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ConsumerProfile({Key? key, required this.profile}) : super(key: key);

  @override
  State<ConsumerProfile> createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  final AuthService _authService = AuthService();
  final ParcelService _parcelService = ParcelService();

  List<dynamic> _parcels = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadParcelHistory();
  }

  Future<void> _loadParcelHistory() async {
    try {
      String? token = await _authService.getToken();
      if (token == null) {
        print("⚠️ No token found");
        return;
      }

      final parcels = await _parcelService.getParcelHistoryByConsumer(token);
      setState(() {
        _parcels = parcels;
        _loading = false;
      });
    } catch (e) {
      print("Parcel history error: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final String baseUrl = "http://localhost:8085/images/consumer/";
    final String? photoName = profile['photo'];
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName" : null;

    // 🟢 Handle email from either direct or nested structure
    final String email = profile['email'] ??
        (profile['user'] != null ? profile['user']['email'] : 'N/A');

    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            tooltip: "Book Parcel",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddParcelPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadParcelHistory,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildProfileHeader(photoUrl, profile, email),
              const SizedBox(height: 20),
              _buildProfileInfo(profile),
              const SizedBox(height: 25),
              _buildParcelHistorySection(),
              const SizedBox(height: 25),
              _buildEditProfileButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String? photoUrl, Map<String, dynamic> profile, String email) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_avatar.png')
                as ImageProvider,
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt, color: Colors.purple),
                  iconSize: 22,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          profile['name'] ?? 'Unknown',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(Map<String, dynamic> profile) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: Colors.purple.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _infoTile(Icons.phone, "Phone", profile['phone'] ?? "Not provided"),
            _divider(),
            _infoTile(Icons.location_on, "Address", profile['address'] ?? "N/A"),
            _divider(),
            _infoTile(Icons.calendar_today, "Joined Date",
                profile['joinedDate'] ?? "Unknown"),
          ],
        ),
      ),
    );
  }

  Widget _buildParcelHistorySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Parcel History",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _parcels.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "No parcel history found.",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
            )
                : Column(
              children: _parcels.map((parcel) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFF8F6FB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_shipping,
                          color: Colors.deepPurple),
                    ),
                    title: Text(
                      "Tracking ID: ${parcel['trackingId']}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "Status: ${parcel['status'] ?? 'Pending'}\n"
                          "From: ${parcel['sendCountry']?['name'] ?? 'N/A'} → "
                          "To: ${parcel['receiveCountry']?['name'] ?? 'N/A'}",
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: Colors.deepPurpleAccent.withOpacity(0.4),
        ),
        onPressed: () {},
        label: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Divider(height: 1, color: Colors.grey),
  );
}
