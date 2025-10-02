import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
                  String em =email.text;
                  String pass = password.text;
                  print('Email: $em, Password: $pass');


                  
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


          ],
        ) ,


      ),


    );
  }

  
}