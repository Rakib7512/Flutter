import 'package:flutter/material.dart';
import 'package:curier2/service/authService.dart';
import 'package:curier2/loginpage.dart';

class EmployeeProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  EmployeeProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Base URL for backend image folder
    final String baseUrl = "http://localhost:8085/images/users/";
    final String? photoName = profile['photo'];
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName" : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Employee Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),

      // 🟣 Drawer Menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              accountName: Text(
                profile['name'] ?? 'Unknown User',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(profile['email'] ?? 'N/A'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_avatar.png')
                as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title:
              const Text('Logout', style: TextStyle(color: Colors.red)),
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

      // 🟣 Body Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.deepPurple, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_avatar.png')
                as ImageProvider,
              ),
            ),

            const SizedBox(height: 20),

            // Name
            Text(
              profile['name'] ?? 'Unknown',
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Designation
            Text(
              profile['designation'] ?? 'No designation',
              style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1.5, color: Colors.deepPurpleAccent),
            const SizedBox(height: 10),

            // Info Card Section
            infoTile("Email", profile['email']),
            infoTile("Gender", profile['gender']),
            infoTile("NID", profile['nid']),
            infoTile("Phone", profile['phone']),
            infoTile("Address", profile['address']),
            infoTile("Join Date", profile['joindate']?.toString().split('T')[0]),
            infoTile("Salary", "${profile['salary']} ৳"),
            infoTile("Hub", profile['empOnHub']),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Reusable Info Card Widget
  Widget infoTile(String title, String? value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.arrow_right, color: Colors.deepPurple),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }
}
