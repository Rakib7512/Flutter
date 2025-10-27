import 'package:curier2/consumer/consumer_profile.dart';
import 'package:curier2/employee/employee_profile.dart';
import 'package:curier2/page/adminPage.dart';
import 'package:curier2/registration.dart';
import 'package:curier2/service/authService.dart';
import 'package:curier2/service/consumer_service.dart';
import 'package:curier2/service/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Added GoogleFonts

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService authService = AuthService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  bool _obscurePassword = true;
  bool _isLoading = false; // For progress indicator

  // --- Modern Colors ---
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep Indigo
  static const Color accentColor = Color(0xFF3B82F6); // Bright Blue

  @override
  Widget build(BuildContext setContext) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Light Background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450), // Max width for web/tablet
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Sign in to access your dashboard",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),

                _buildInputField(
                  controller: email,
                  labelText: 'Email Address',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25.0),

                _buildPasswordField(),
                const SizedBox(height: 35.0),

                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: accentColor))
                    : _buildLoginButton(setContext),

                const SizedBox(height: 20),

                // Register Link
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      setContext,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  child: Text(
                    'Create a new account',
                    style: GoogleFonts.poppins(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function for modern TextField styling
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: primaryColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: accentColor),
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
      ),
    );
  }

  // Helper function for modern Password Field styling
  Widget _buildPasswordField() {
    return TextField(
      controller: password,
      obscureText: _obscurePassword,
      style: GoogleFonts.poppins(color: primaryColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        prefixIcon: const Icon(Icons.lock_rounded, color: accentColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            color: Colors.grey.shade500,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
      ),
    );
  }

  // Helper function for the gorgeous Login Button
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [accentColor, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => loginUser(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Important for gradient to show
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Login",
          style: GoogleFonts.poppins(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // LOGIN LOGIC WITH ROLE HANDLING
  // -----------------------------
  Future<void> loginUser(BuildContext context) async {
    // Check if context is still mounted before setState
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Assuming authService.login handles token storage internally
      await authService.login(email.text, password.text);

      final role = await authService.getUserRole(); // Get logged-in user role
      print('✅ Logged in user role: $role');

      // Ensure context is still mounted before navigating
      if (!mounted) return;

      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else if (role == 'EMPLOYEE') {
        final profile = await EmployeeService().getEmployeeProfile();

        if (profile != null) {
          // Assuming profile is a Map and has an 'id' field
          final employeeId = profile['id'];

          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          // Assuming 'id' is an integer, matching the original code's preference saving logic
          if (employeeId is int) {
            await prefs.setInt('EmployeeID', employeeId);
            print('Employee ID saved: $employeeId');
          } else {
            // Handle case where id is not an int (e.g., if it's a String UUID, though original code used int)
            print('Warning: Employee ID is not an integer. Skipping SharedPreferences save.');
          }


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeProfile(profile: profile),
            ),
          );
        } else {
          showErrorDialog(context, 'Failed to load employee profile.');
        }
      } else if (role == 'CONSUMER') {
        final profile = await ConsumerService().getConsumerProfile();

        if (profile != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ConsumerProfile(profile: profile),
            ),
          );
        } else {
          showErrorDialog(context, 'Failed to load consumer profile.');
        }
      } else {
        showErrorDialog(context, 'Unknown role: $role');
      }
    } catch (error) {
      print('❌ Login failed: $error');
      // Use the context passed from the build method for safety
      showErrorDialog(context, 'Invalid email or password. Please try again.');
    } finally {
      // Ensure context is still mounted before setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // -----------------------------
  // ERROR MESSAGE HELPER (Styled)
  // -----------------------------
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Login Error",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
      ),
    );
  }
}
