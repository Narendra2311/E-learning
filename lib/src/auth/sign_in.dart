// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'dart:ui';
import 'package:e_learning/src/auth/sign_up.dart';
import 'package:e_learning/src/home/home_screen.dart';
import 'package:e_learning/src/service/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
                  const SignInForm(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
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
  const SignInForm({super.key});

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome back!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 29,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Sign in for a seamless experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 123, 123, 123),
              ),
            ),
            const SizedBox(height: 20),
            _buildFormFieldWithIcon(
              Icons.email,
              'Email',
              _emailController,
              'xyz@gmail.com',
            ),
            const SizedBox(height: 20),
            _buildFormFieldWithIcon(
              Icons.lock,
              'Password',
              _passwordController,
              '**********',
              isPassword: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await _signInUser(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (response['success'] != null && response['success']) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                    await checkStoredData();
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
                backgroundColor: const Color(0xFFEF6C00),
              ),
              child: const Text('Sign In'),
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
        Uri.parse('${API.baseUrl}/clogin'),
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
          final int userId = responseBody['customerId'];
          final String token = responseBody['token'];
          final String name =
              responseBody['customerName']; // Extract name from response
          final String email =
              responseBody['email']; // Extract email from response
          final String phoneNumber =
              responseBody['phoneNumber']; // Extract phone number from response
          // Save user ID, token, name, email, and phone number to local storage
          saveLoginStatus(userId, token, name, email, phoneNumber);

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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    child: const Text(
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
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 123, 123, 123),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.black, // Set the label text color to black
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Color(0xFFEF6C00),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 138, 137, 137),
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

  // Function to save login status along with user ID and token
  Future<void> saveLoginStatus(
    int userId,
    String token,
    String name,
    String email,
    String phoneNumber,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userId', userId);
    prefs.setString('token', token);
    prefs.setString('name', name); // Store user's name
    prefs.setString('email', email); // Store user's email
    prefs.setString('phoneNumber', phoneNumber); // Store user's phone number
  }

  Future<void> checkStoredData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId != null && token != null) {
        print('User ID: $userId');
        print('Token: $token');
      } else {
        print('User ID and/or token not found in local storage.');
      }
    } catch (e) {
      print('Error occurred while checking stored data: $e');
    }
  }
}
