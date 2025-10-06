import 'package:curier2/service/authService.dart';

class EmployeeService{

  final String baseUrl = "http://localhost:8085";


  Future<Map<String, dynamic>?> getEmployeeProfile()async{
    String? token=await AuthService().getToken();

    if(token ==null){
      print('No Token found, Please login first ');
      return null;

    }
    final url=Uri.parse('$baseUrl/api/employee/profile');
    final response=await Uri.http.get(
      url,
    )
  }


}