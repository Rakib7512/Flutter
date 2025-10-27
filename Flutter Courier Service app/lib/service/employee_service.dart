import 'dart:convert';

import 'package:curier2/service/authService.dart';
import 'package:http/http.dart' as http;

class EmployeeService{

  final String baseUrl = "http://localhost:8085";


  Future<Map<String, dynamic>?> getEmployeeProfile()async{
    String? token=await AuthService().getToken();

    if(token ==null){
      print('No Token found, Please login first ');
      return null;

    }
    final url=Uri.parse('$baseUrl/api/employee/profile');
    final response=await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load profile: ${response.statusCode} - ${response.body}');
      return null;
    }
  }



}