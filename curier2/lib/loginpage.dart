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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 40.0),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: password,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                _isLoading
                    ? const CircularProgressIndicator(color: Colors.purple)
                    : ElevatedButton(
                  onPressed: () => loginUser(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.w800),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  child: const Text(
                    'Create a new account',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
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

  // -----------------------------
  // LOGIN LOGIC WITH ROLE HANDLING
  // -----------------------------
  Future<void> loginUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await authService.login(email.text, password.text);

      final role = await authService.getUserRole(); // Get logged-in user role
      print('✅ Logged in user role: $role');

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
          await prefs.setInt('EmployeeID', employeeId);

          print('Employee ID saved: $employeeId');

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
      showErrorDialog(context, 'Invalid email or password.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // -----------------------------
  // ERROR MESSAGE HELPER
  // -----------------------------
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Colors.purple)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
