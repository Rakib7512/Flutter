import 'package:curier2/consumer/consumer_profile.dart';
import 'package:curier2/employee/employee_profile.dart';
import 'package:curier2/page/adminPage.dart';
import 'package:curier2/registration.dart';
import 'package:curier2/service/authService.dart';
import 'package:curier2/service/consumer_service.dart';
import 'package:curier2/service/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthService authService = AuthService();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'example@gmail.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => loginUser(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()),
                );
              },
              child: Text(
                'Registration',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> loginUser(BuildContext context) async{
    try{

      final response = await authService.login(email.text, password.text);

      // Successful login, role-based navigation
      final  role =await authService.getUserRole(); // Get role from AuthService


      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      }
      else if (role == 'EMPLOYEE') {
        final profile = await EmployeeService().getEmployeeProfile();

        if (profile != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeProgile(profile: profile),
            ),
          );
        }
      }
      else if (role == 'CONSUMER') {
        final profile = await ConsumerService().getConsumerProfile();

        if (profile != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeProgile(profile: profile),
            ),
          );
        }
      }

      else {
        print('Unknown role: $role');
      }


    }
    catch(error){
      print('Login failed: $error');

    }


  }

}