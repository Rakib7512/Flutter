import 'package:curier2/loginpage.dart';
import 'package:curier2/page/add_parcel.dart';
import 'package:curier2/registration.dart';
import 'package:curier2/service/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

        debugShowCheckedModeBanner: false,
        home: AddParcelPage()

    );


  }





}