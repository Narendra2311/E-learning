// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api, avoid_print, deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
import 'package:e_learning/src/home/home_screen.dart';
import 'package:e_learning/src/service/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'sign_in.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          centerTitle: true,
          title: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
              fontStyle: FontStyle.italic,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Container(
        // Wrap the body in a Container to set the background color
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Complete your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 29,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Finish setting up your account now',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 123, 123, 123),
              ),
            ),
            SizedBox(height: 15),
            _buildFormFieldWithIcon(
              Icons.account_circle_rounded,
              'Full Name',
              _nameController,
              'Your Name',
            ),
            SizedBox(height: 15),
            _buildFormFieldWithIcon(
              Icons.email,
              'Email',
              _emailController,
              'XYZ@gmail.com',
            ),
            SizedBox(height: 15),
            _buildFormFieldWithIcon(
              Icons.phone,
              'Contact No',
              _contactController,
              '99********',
            ),
            SizedBox(height: 15),
            _buildFormFieldWithIcon(
              Icons.lock,
              'Password',
              _passwordController,
              '**********',
              isPassword: true,
            ),
            SizedBox(height: 15),
            _buildFormFieldWithIcon(
              Icons.lock,
              'Confirm Password',
              _confirmPasswordController,
              '**********',
              isPassword: true,
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Check if password and confirm password match
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    _showErrorDialog(
                        'Password and Confirm Password do not match');
                    return;
                  }

                  final response = await _registerUser(
                    _nameController.text,
                    _emailController.text,
                    _contactController.text,
                    _passwordController.text,
                  );

                  if (response['success'] != null && response['success']) {
                    // Registration successful
                    _showSuccessDialog(
                        'Registration success',
                        response['user']['id'].toString(),
                        response['user']['token'],
                        response['user']['full_name'],
                        response['user']['email_address'],
                        response['user']['phone_number']);
                  } else {
                    // Registration failed
                    print('Registration failed: ${response['message']}');

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
              child: Text('Sign Up'),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? '),
                GestureDetector(
                  onTap: () {
                    // Navigate to the Sign In page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFEF6C00),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _registerUser(
    String name,
    String email,
    String contact,
    String password,
  ) async {
    try {
      final timeoutDuration =
          Duration(seconds: 3); // Set your desired timeout duration

      final response = await http
          .post(
            Uri.parse('${API.baseUrl}/register'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'full_name': name,
              'email_address': email,
              'phone_number': contact,
              'password': password,
            }),
          )
          .timeout(timeoutDuration);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('message') &&
            responseBody.containsKey('user')) {
          // Registration successful
          return {
            'success': true,
            'message': responseBody['message'],
            'user': responseBody['user']
          };
        } else {
          print('Invalid response format: "message" or "user" is not present');
          return {'success': false, 'message': 'Something went wrong'};
        }
      } else if (response.statusCode == 400) {
        // Handle validation errors (HTTP status code 400)
        final Map<String, dynamic> errorBody = json.decode(response.body);
        final String errorMessage = errorBody['error'] ?? 'Validation error';

        print('Validation error: $errorMessage');

        return {'success': false, 'message': errorMessage};
      } else {
        print('Server returned an error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Unexpected server error. Please try again later.'
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

  void _showSuccessDialog(String message, String userId, String token,
      String name, String email, String contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', int.parse(userId));
    await prefs.setString('token', token);
    await prefs.setString('name', name); // Store user's name
    await prefs.setString('email', email); // Store user's email
    await prefs.setString('contact', contact); // Store user's contact

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Success',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Registration Successful',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    print('Stored UserID: $userId');
    print('Stored Token: $token');
    print('Stored Name: $name');
    print('Stored Email: $email');
    print('Stored Contact: $contact');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
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
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
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
                        Text(
                          'Error',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: Text('OK'),
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
              size: 15,
              color: const Color.fromARGB(255, 138, 137, 137),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: const Color.fromARGB(255, 123, 123, 123),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEF6C00), width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText:
                label, // Set labelText to null if you want to use hintText as the label
            labelStyle: TextStyle(
              color: const Color.fromARGB(255, 123, 123, 123),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter $label';
            }
            // Check email format
            if (label.toLowerCase() == 'email' &&
                !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                    .hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }
}
