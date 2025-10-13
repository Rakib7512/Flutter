import 'package:curier2/loginpage.dart';
import 'package:curier2/page/add_parcel.dart';
import 'package:curier2/page/track_parcel.dart';
import 'package:curier2/service/authService.dart';
import 'package:curier2/service/parcel_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Constants for a cleaner look ---
const Color kPrimaryColor = Color(0xFF673AB7); // DeepPurple 500
const Color kAccentColor = Color(0xFF9C27B0); // PurpleAccent
const Color kBackgroundColor = Color(0xFFF0F2F5); // Light Gray/Blue for background
const Color kCardColor = Colors.white;

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
      if (mounted) {
        setState(() {
          _parcels = parcels;
          _loading = false;
        });
      }
    } catch (e) {
      print("Parcel history error: $e");
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    const String baseUrl = "http://localhost:8085/images/consumer/";
    final String? photoName = profile['photo'];
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName" : null;

    final String email = profile['email'] ??
        (profile['user'] != null ? profile['user']['email'] : 'N/A');

    return Scaffold(
      backgroundColor: kBackgroundColor,

      // --- Modernized AppBar ---
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kCardColor,
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          _buildAppBarAction(Icons.search_rounded, "Track Parcel", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackParcelPage()));
          }),
          _buildAppBarAction(Icons.add_box_rounded, "Book Parcel", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AddParcelPage()));
          }),
          _buildAppBarAction(Icons.logout_rounded, "Logout", () async {
            await _authService.logout();
            if (mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
            }
          }),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _loadParcelHistory,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildProfileHeader(photoUrl, profile, email),
              const SizedBox(height: 30), // Increased spacing
              _buildProfileInfo(profile),
              const SizedBox(height: 25),
              _buildParcelHistorySection(),
              const SizedBox(height: 25),
              _buildEditProfileButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable AppBar Action Button ---
  Widget _buildAppBarAction(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: kPrimaryColor, size: 24),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  // --- Profile Header (No changes needed, already modern) ---
  Widget _buildProfileHeader(String? photoUrl, Map<String, dynamic> profile, String email) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [kPrimaryColor, kAccentColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: kBackgroundColor,
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_avatar.png')
                as ImageProvider,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: kAccentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: kCardColor, width: 3),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement photo change logic
                  },
                  icon: const Icon(Icons.camera_alt, color: kCardColor),
                  iconSize: 20,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          profile['name'] ?? 'Unknown User',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- Modernized Profile Info Card (Re-adding joined date) ---
  Widget _buildProfileInfo(Map<String, dynamic> profile) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Tighter padding
      child: Column(
        children: [
          _infoTile(Icons.phone_android_rounded, "Phone Number", profile['phone'] ?? "Not provided"),
          _divider(),
          _infoTile(Icons.home_rounded, "Address", profile['address'] ?? "N/A"),
          _divider(),
          _infoTile(Icons.date_range_rounded, "Joined Since",
              profile['joinedDate'] ?? "Unknown"), // Re-added this tile
        ],
      ),
    );
  }

  // --- Enhanced Info Tile for better alignment and padding ---
  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
        children: [
          Container(
            padding: const EdgeInsets.all(10), // Increased padding for icon background
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12), // Slightly more rounded
            ),
            child: Icon(icon, color: kPrimaryColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2), // Reduced spacing
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey), // Add an indicator
        ],
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10), // Padding to match tile content
    child: Divider(height: 1, color: Colors.grey.shade200),
  );

  // --- Modernized Parcel History Section (with loading animation) ---
  Widget _buildParcelHistorySection() {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Parcels 📦",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 15),
          // Use AnimatedSwitcher for a smooth loading transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _loading
                ? const Center(key: ValueKey('loading'), child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: kPrimaryColor),
            ))
                : _parcels.isEmpty
                ? Center(key: ValueKey('empty'),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No recent parcel history found. Book one now!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            )
                : Column(key: ValueKey('list'),
              children: _parcels.take(3).map((parcel) {
                return _buildParcelListItem(parcel);
              }).toList(),
            ),
          ),
          if (_parcels.isNotEmpty && _parcels.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement navigation to full parcel history page
                    print("View all parcels clicked");
                  },
                  child: Text(
                    "View All History (${_parcels.length} total)",
                    style: GoogleFonts.poppins(
                      color: kAccentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- Modernized Parcel List Item ---
  Widget _buildParcelListItem(Map<String, dynamic> parcel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // Slightly less vertical padding
      child: Container(
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ListTile(
          dense: true, // Makes it slightly more compact
          onTap: () {
            // TODO: Implement navigation to parcel detail
          },
          leading: Container(
            padding: const EdgeInsets.all(8), // Reduced padding
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_shipping_rounded, color: kCardColor, size: 18), // Smaller icon
          ),
          title: Text(
            parcel['trackingId'],
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 14, // Slightly smaller font
            ),
          ),
          subtitle: Text(
            "${parcel['sendCountry']?['name'] ?? 'N/A'} → ${parcel['receiveCountry']?['name'] ?? 'N/A'}",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Reduced padding
            decoration: BoxDecoration(
              color: _getStatusColor(parcel['status'] ?? 'Pending'),
              borderRadius: BorderRadius.circular(10), // More rounded badge
            ),
            child: Text(
              parcel['status'] ?? 'Pending',
              style: GoogleFonts.poppins(
                color: kCardColor,
                fontWeight: FontWeight.bold,
                fontSize: 11, // Smaller font for badge
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function for status colors (no change needed)
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue.shade600;
      case 'processing':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade500;
    }
  }

  // --- Modernized Full-Width Button (no change needed) ---
  Widget _buildEditProfileButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit_note_rounded, color: kCardColor, size: 24),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          shadowColor: kPrimaryColor.withOpacity(0.5),
        ),
        onPressed: () {
          // TODO: Implement navigation to Edit Profile page
        },
        label: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: kCardColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}