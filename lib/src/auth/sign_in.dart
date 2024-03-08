// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'package:e_learning/src/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'sign_up.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            // fontFamily: 'Serif',
            fontStyle: FontStyle.italic,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SignInForm(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEF6C00),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // _emailController.text = 'narendra1499@gmail.com';
    // _passwordController.text = 'Divya@12';
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome back!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 29,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Sign in for a seamless experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 123, 123, 123),
              ),
            ),
            SizedBox(height: 20),
            _buildFormFieldWithIcon(
              Icons.email,
              'Email',
              _emailController,
              'xyz@gmail.com',
            ),
            SizedBox(height: 20),
            _buildFormFieldWithIcon(
              Icons.lock,
              'Password',
              _passwordController,
              '**********',
              isPassword: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await _signInUser(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (response['success'] != null && response['success']) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    print('Sign-in failed: ${response['message']}');

                    if (response['message'] != null) {
                      // Show specific validation error
                      _showErrorDialog(response['message']);
                    } else {
                      // Show a generic error message
                      _showErrorDialog(
                          'Something went wrong, please try again later');
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFEF6C00),
              ),
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _signInUser(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://ce16-2405-201-2009-d9ed-c07d-419f-a8aa-604.ngrok-free.app/clogin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email_address': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('message') && responseBody['success']) {
          return {
            'success': true,
            'message': responseBody['message'],
            'user': responseBody['user']
          };
        } else {
          print(
              'Invalid response format: "message" or "success" is not present');
          return {'success': false, 'message': 'Something went wrong'};
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client-side errors (4xx)
        final Map<String, dynamic> errorBody = json.decode(response.body);
        final String errorMessage = errorBody['message'] ?? 'Client-side error';

        print('Client-side error: $errorMessage');

        return {'success': false, 'message': errorMessage};
      } else if (response.statusCode >= 500 && response.statusCode < 600) {
        // Handle server-side errors (5xx)
        print('Server-side error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Unexpected server error. Please try again later.'
        };
      } else {
        // Handle other unexpected errors
        print('Unexpected error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again later.'
        };
      }
    } on TimeoutException catch (_) {
      // Timeout exception
      return {
        'success': false,
        'message': 'Request timed out. Please try again later.'
      };
    } on SocketException catch (_) {
      // Network-related exception
      return {
        'success': false,
        'message': 'Network error, please check your connection'
      };
    } catch (e) {
      // Other unexpected exceptions
      print('Error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again later.'
      };
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormFieldWithIcon(
    IconData icon,
    String label,
    TextEditingController controller,
    String hintText, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color.fromARGB(255, 138, 137, 137),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 123, 123, 123),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.black, // Set the label text color to black
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Color(0xFFEF6C00),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 138, 137, 137),
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
