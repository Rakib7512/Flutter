import 'package:curier2/page/add_parcel.dart';
import 'package:curier2/page/final_delivery.dart';
import 'package:curier2/page/notification.dart';
import 'package:curier2/page/track_parcel.dart';
import 'package:flutter/material.dart';
import 'package:curier2/service/authService.dart';
import 'package:curier2/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  EmployeeProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://localhost:8085/images/users/";
    final String? photoName = profile['photo'];
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName" : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      // 🟣 App Bar
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        backgroundColor: Colors.purple.shade600,
        title: const Text(
          "Employee Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delivery_dining, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FinalDeliveryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.spatial_tracking, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TrackParcelPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),

          // 🟣 Add Parcel Button
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddParcelPage()),
              );
            },
            child: Text(
              "Book Parcel",
              style: GoogleFonts.poppins(
                  color: Colors.blueAccent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),

      // 🟣 Drawer Menu
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                profile['name'] ?? 'Unknown User',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(profile['email'] ?? 'N/A'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("My Profile"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await _authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),

      // 🟣 Main Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture with Gradient Border
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3),
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
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // TODO: Add change photo function
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Name and Designation
            Text(
              profile['name'] ?? 'Unknown Employee',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              profile['designation'] ?? 'No designation',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.email_outlined, "Email", profile['email']),
                    _buildDivider(),
                    _buildInfoRow(Icons.person_outline, "Gender", profile['gender']),
                    _buildDivider(),
                    _buildInfoRow(Icons.badge_outlined, "NID", profile['nid']),
                    _buildDivider(),
                    _buildInfoRow(Icons.phone, "Phone", profile['phone']),
                    _buildDivider(),
                    _buildInfoRow(Icons.location_on_outlined, "Address", profile['address']),
                    _buildDivider(),
                    _buildInfoRow(Icons.calendar_today, "Join Date",
                        profile['joindate']?.toString().split('T')[0]),
                    _buildDivider(),
                    _buildInfoRow(Icons.money, "Salary", "${profile['salary']} ৳"),
                    _buildDivider(),
                    _buildInfoRow(Icons.location_city, "Hub", profile['empOnHub']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // TODO: Navigate to edit profile
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🟣 Reusable info row
  Widget _buildInfoRow(IconData icon, String title, String? value) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              Text(value ?? 'N/A',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Divider(height: 1, color: Colors.grey),
  );
}
