import 'dart:convert';

import 'package:cric_club/configurations/config.dart';
import 'package:cric_club/dashboard/club/home_club.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class ClubSignUpScreen extends StatefulWidget {
  const ClubSignUpScreen({super.key});

  @override
  State<ClubSignUpScreen> createState() => _ClubSignUpScreenState();
}

class _ClubSignUpScreenState extends State<ClubSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _organizationNameController = TextEditingController();
  final TextEditingController _headOfficeLocationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _isPasswordVisible = false;
  String? _organizationType;
  String? _country;

  Color customColor1 = const Color(0xff0F2630);
  Color customColor3 = const Color(0xFF088395);

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      final response = await http.post(
        Uri.parse(clubregistration),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _organizationNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'contactNumber': _contactNumberController.text,
          'address': _headOfficeLocationController.text,
          'country': _country,
          'registrationDoc': 'url_to_registration_doc',
          'profilePictureUrl': 'url_to_profile_picture',
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ClubHome(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: ${response.reasonPhrase}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor1,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Let’s Get\nStarted!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Hi, what’s your ',
                    ),
                    TextSpan(
                      text: 'organization name',
                      style: TextStyle(
                        color: customColor3,
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                    const TextSpan(
                      text: '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: customColor3, width: 6),
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                    ),
                    width: 400,
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16,
                      ),
                      child: ListView(
                        children: [
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _organizationNameController,
                            decoration: const InputDecoration(
                              labelText: 'Organization Name',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your organization name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            value: _country,
                            onChanged: (String? newValue) {
                              setState(() {
                                _country = newValue;
                              });
                            },
                            items: <String>['Country 1', 'Country 2', 'Country 3']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return <String>['Country 1', 'Country 2', 'Country 3']
                                  .map<Widget>((String value) {
                                return Text(
                                  value,
                                  style: const TextStyle(color: Colors.black), // Text style for the selected item
                                );
                              }).toList();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                            dropdownColor: customColor3,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Organization Type:',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          RadioListTile<String>(
                            title: const Text(
                              'National',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: 'National',
                            groupValue: _organizationType,
                            onChanged: (value) {
                              setState(() {
                                _organizationType = value;
                              });
                            },
                            activeColor: customColor3,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return customColor3;
                                }
                                return customColor3;
                              },
                            ),
                          ),
                          RadioListTile<String>(
                            title: const Text(
                              'International',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: 'International',
                            groupValue: _organizationType,
                            onChanged: (value) {
                              setState(() {
                                _organizationType = value;
                              });
                            },
                            activeColor: customColor3,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return customColor3;
                                }
                                return customColor3;
                              },
                            ),
                          ),
                          RadioListTile<String>(
                            title: const Text(
                              'Franchise',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: 'Franchise',
                            groupValue: _organizationType,
                            onChanged: (value) {
                              setState(() {
                                _organizationType = value;
                              });
                            },
                            activeColor: customColor3,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return customColor3;
                                }
                                return customColor3;
                              },
                            ),
                          ),
                          TextFormField(
                            controller: _headOfficeLocationController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              labelText: 'Organization Head Office Location',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the head office location';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Implement document upload functionality here
                            },
                            icon: Icon(Icons.upload_file, color: customColor3),
                            label: Text(
                              'Upload Organization Registration Documents',
                              style: TextStyle(color: customColor3),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(color: customColor3, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Organization Email',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your organization email';
                              }
                              if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            controller: _passwordController,
                            decoration:  InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black),
                              hintStyle: const TextStyle(color: Colors.black),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  color: Colors.blueGrey,
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),

                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16,),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration:  InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.black),
                              hintStyle: const TextStyle(color: Colors.black),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder:const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder:const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  color: Colors.blueGrey,
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),

                            ),
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _contactNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Organization Contact Number',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your contact number';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter a valid contact number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() == true) {
                                _submitForm();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fixedSize: const Size(200, 50),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
