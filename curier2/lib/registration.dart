import 'package:curier2/loginpage.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radio_group_v2/radio_group_v2.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;


class Registration extends StatefulWidget{
  @override
  State<Registration> createState() => _RegistrationState();

  }
class _RegistrationState extends State<Registration> {

  bool _obscurePassword = true;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  final RadioGroupController genderController = RadioGroupController();

  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;

  DateTime? selectedDOB;

  // XFile? selectedImage;
  //
  // Uint8List? webImage;
  // final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        TextField(
                          controller: name,
                          decoration: InputDecoration(
                            labelText: "Full Namne",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),


                        ),
                        SizedBox(
                            height: 20.0),

                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),


                        ),
                        SizedBox(height: 20.0),



                        TextField(
                          controller: password,
                          decoration: InputDecoration(
                            labelText: "password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.password),

                          ),
                          obscureText: true,
                        ),


                        SizedBox(height: 20.0),

                        TextField(
                          controller: confirmPassword,
                          decoration: InputDecoration(
                            labelText: "confirmPassword",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.password),

                          ),
                          obscureText: true,
                        ),


                        SizedBox(height: 20.0),


                        TextField(
                          controller: address,
                          decoration: InputDecoration(
                            labelText: "Address",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.maps_home_work_rounded),
                          ),


                        ),
                        SizedBox(height: 20.0),

                          DateTimeField(
                            decoration: const InputDecoration(
                              labelText: "Date of Birth",

                            ),

                            mode: DateTimeFieldPickerMode.date,
                            pickerPlatform: dob,

                            onChanged: (DateTime? value){
                              setState(() {
                                selectedDOB=value;
                              });
                            },

                          ),

                        SizedBox(height: 20.0),

                        // Gender Selection
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Gender:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              v2.RadioGroup(
                                controller: genderController,
                                values: const ["Male", "Female", "Other"],
                                indexOfDefault: 0,
                                orientation: RadioGroupOrientation.horizontal,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedGender = newValue.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.0),


ElevatedButton(
    onPressed: (){

    },
    child: Text(
      "Registration",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: GoogleFonts.lato().fontFamily
      ),

    ),

  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
  ),
),

 SizedBox(height: 20.0),
                        
   TextButton(
       onPressed: (){
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context)=>LoginPage()),
         );
       },
     child: Text(
       'Login',
       style: TextStyle(
         color: Colors.blue,
         decoration: TextDecoration.underline,
       ),
     ),
   ),
                     
                    
                   
        ],
      )),

      ),


      ),
    );
  }



  
}


