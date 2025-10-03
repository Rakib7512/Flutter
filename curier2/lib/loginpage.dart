import 'package:curier2/page/adminPage.dart';
import 'package:curier2/registration.dart';
import 'package:curier2/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget{

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();


  bool _obscurePassword= true;

  final storage = new FlutterSecureStorage();
  AuthService authService=AuthService();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.00),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
               controller: email,
          decoration: InputDecoration(
              labelText: 'example@gmail.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email)),

              ),

            SizedBox(
              height: 20.0,

            ),

            TextField(
              controller: password,
              decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
                obscureText: true,

            ),

            SizedBox(
              height: 20.0,

            ),
            ElevatedButton(
                onPressed: (){
                 loginUser(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white
                ),

                  child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800
                  ),
                )

            ),

            TextButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>Registration()),
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
        ) ,


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
      else {
        print('Unknown role: $role');
      }

    }
    catch(error){
      print('Login failed: $error');

    }




  }

  
}