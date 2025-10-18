import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// fl_chart is no longer needed on the public page, but keeping the import for now
import 'package:fl_chart/fl_chart.dart';
// Assuming these files exist in your project structure
import 'package:curier2/loginpage.dart';
import 'package:curier2/registration.dart';

class CourierHomePage extends StatelessWidget {
  const CourierHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Media Query for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Very light, modern background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1, // Subtle elevation
        centerTitle: false,
        title: Text(
          "Real Service",
          style: GoogleFonts.poppins(
              color: const Color(0xFF1E3A8A), // Deep Blue
              fontWeight: FontWeight.w800),
        ),
        actions: [
          _buildAuthButton(context, "Register", () => Registration(), isPrimary: true),
          _buildAuthButton(context, "Login", () => LoginPage(), isPrimary: false),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌟 Hero Section & Tracking (The main focus)
              _buildHeroSection(screenWidth),

              const SizedBox(height: 50),

              // ✨ Key Features/Benefits Section
              _buildFeatureSection(),

              const SizedBox(height: 50),

              // 🚀 Call to Action Banner
              _buildCTABanner(context),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS --- //

  Widget _buildAuthButton(
      BuildContext context, String text, Widget Function() targetPage,
      {required bool isPrimary}) {
    final Color accentColor = const Color(0xFF3B82F6); // Tailwind Blue 500

    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage()),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(text,
          style: GoogleFonts.poppins(
              color: isPrimary ? accentColor : Colors.black87,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildHeroSection(double screenWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000), // Very light shadow
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to Next-Gen Logistics",
            style: GoogleFonts.poppins(
              color: const Color(0xFF3B82F6), // Accent Blue
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Seamless Tracking, Reliable Delivery.",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 32, // Bolder title
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          // 🔍 Tracking Input Field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF), // Lighter Blue Background
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter tracking ID...",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 60,
                  width: screenWidth > 600 ? 140 : 80, // Responsive button width
                  child: Center(
                    child: screenWidth > 600
                        ? Text("Track", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))
                        : const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection() {
    final List<Map<String, dynamic>> features = [
      {
        "title": "Fast Delivery",
        "description": "Deliver your goods to the destination in minimal time.",
        "icon": Icons.speed,
        "color": Colors.green.shade600
      },
      {
        "title": "Secure Handling",
        "description": "We ensure package transportation with maximum security and care.",
        "icon": Icons.security,
        "color": Colors.orange.shade600
      },
      {
        "title": "24/7 Support",
        "description": "Our support team is always ready for any assistance you may need.",
        "icon": Icons.support_agent,
        "color": Colors.blue.shade600
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why Choose Us?",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 25),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return _buildFeatureItem(
                  feature["title"]!,
                  feature["description"]!,
                  feature["icon"],
                  feature["color"]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTABanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)], // Refined Blue Gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Join Our Service Today",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Register or log in to manage your shipments and track your deliveries.",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              // Registration Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1D4ED8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 5,
                  ),
                  child: Text("Register Now",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 15),
              // Login Button (Secondary CTA)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text("Login",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
