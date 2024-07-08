import 'dart:convert';
import 'package:cric_club/dashboard/player/home_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cric_club/configurations/config.dart';

class OptionalOnboarding extends StatefulWidget {
  const OptionalOnboarding({
    super.key,
    required this.name,
    required this.dob,
    required this.email,
    required this.password,
    required this.gender,
    required this.contactNumber,
  });

  final String name;
  final String dob;
  final String email;
  final String password;
  final String? gender;
  final String contactNumber;

  @override
  State<OptionalOnboarding> createState() => _OptionalOnboardingState();
}

class _OptionalOnboardingState extends State<OptionalOnboarding> {
  Color customColor1 = const Color(0xff0F2630);
  Color customColor3 = const Color(0xFF088395);
  String? _country;
  String? _category;
  final _formKey = GlobalKey<FormState>();
  final List<String> _organizations = [];
  final TextEditingController _organizationController = TextEditingController();


  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _organizationsController = TextEditingController();

  bool _isLoading = false;

  void signUpUser() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var reqBody = {
        "name": widget.name,
        "email": widget.email,
        "password": widget.password,
        "dateOfBirth": widget.dob,
        "gender": widget.gender,
        "contactNumber": widget.contactNumber,
        "address": _addressController.text,
        "country": _country,
        "category": _category,
        // "cnic": _cnicController.text,
        "affiliatedOrganizations": _organizations,
      };

      var response = await http.post(
        Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      print("Request URL: $registration");
      print("Request Body: $reqBody");
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User registered successfully!")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PlayerHome()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to register user: ${response.body}")),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor1,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 70,
                ),
                const Center(
                  child: Text(
                    "Continue Your Sign Up Process",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: customColor3, width: 6),
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white),
                  width: 400,
                  height: 500,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            controller: _cnicController,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              labelText: 'CNIC',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 3.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'CNIC Picture:',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customColor3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fixedSize: const Size(140, 40),
                                ),
                                child: const Text('Upload Front',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: customColor3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  fixedSize: const Size(140, 40),
                                ),
                                child: const Text('Upload Back',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
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
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            value: _country,
                            onChanged: (String? newValue) {
                              setState(() {
                                _country = newValue;
                              });
                            },
                            items: <String>[
                              'Country 1',
                              'Country 2',
                              'Country 3'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return <String>[
                                'Country 1',
                                'Country 2',
                                'Country 3'
                              ].map<Widget>((String value) {
                                return Text(
                                  value,
                                  style: const TextStyle(
                                      color: Colors.black),
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
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                              ),
                            ),
                            value: _category,
                            onChanged: (String? newValue) {
                              setState(() {
                                _category = newValue;
                              });
                            },
                            items: <String>[
                              'Under 13',
                              'Under 15',
                              'Under 19',
                              'Above 19'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return <String>[
                                'Under 13',
                                'Under 15',
                                'Under 19',
                                'Above 19'
                              ].map<Widget>((String value) {
                                return Text(
                                  value,
                                  style: const TextStyle(
                                      color: Colors.black),
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
                            'Experience Document:',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fixedSize: const Size(100, 40),
                            ),
                            child: const Text(
                              'Upload Document',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _organizationController,
                            decoration: const InputDecoration(
                              labelText: 'Add Organization',
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 2.0),
                              ),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_organizationController.text.isNotEmpty) {
                                setState(() {
                                  _organizations.add(_organizationController.text);
                                  _organizationController.clear();
                                });
                              }
                            },
                            child: const Text('Add Organization'),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _organizations.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  _organizations[index],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _organizations.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : signUpUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: customColor3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fixedSize: const Size(200, 50),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
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
}
