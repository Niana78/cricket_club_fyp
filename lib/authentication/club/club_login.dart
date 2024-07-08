import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../configurations/config.dart';
import '../../dashboard/club/home_club.dart';

class ClubLoginScreen extends StatefulWidget {
  const ClubLoginScreen({super.key});

  @override
  State<ClubLoginScreen> createState() => _ClubLoginScreenState();
}

class _ClubLoginScreenState extends State<ClubLoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color customColor1 = const Color(0xff0F2630);
  Color customColor2 = const Color(0xff0F2630);
  Color customColor3 = const Color(0xFF088395);
  bool _isPasswordVisible = false;

  void loginClub() async {
    try {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        var reqBody = {
          "email": _emailController.text,
          "password": _passwordController.text
        };

        var response = await http.post(Uri.parse(clublogin),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));

        print("Request URL: $login");
        print("Request Body: $reqBody");
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          if (jsonResponse.containsKey('status')) {
            if (jsonResponse['status']) {
              var myToken = jsonResponse['token'];

              // Decode the token to get userId
              Map<String, dynamic> decodedToken = JwtDecoder.decode(myToken);
              var userId = decodedToken['_id'];

              if (userId != null) {


                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ClubHome()));
              } else {
                throw Exception("User ID not found in token");
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invalid email or password. Please try again."),
                ),
              );
            }
          } else {
            print("Unexpected JSON structure: $jsonResponse");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Unexpected response from server"),
              ),
            );
          }
        } else {
          print("HTTP request failed with status code: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("HTTP request failed. Please try again."),
            ),
          );
        }
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong email or password. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: customColor1,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Enter your details',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white, width: 3.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white, width: 3.0),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 3.0),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 3.0),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          RegExp regex =
                          RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid Gmail address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white, width: 3.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.white, width: 3.0),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 3.0),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 3.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              color: Colors.white,
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
                        style: const TextStyle(color: Colors.white),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginClub();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: customColor3,
                          minimumSize: const Size(200, 48),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {},
                      child: Text('Forgot password?',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 15)),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              )
            ]));
  }
}
