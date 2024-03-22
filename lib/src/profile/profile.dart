// ignore_for_file: unnecessary_import, use_build_context_synchronously, avoid_print
import 'dart:ui';
import 'package:e_learning/src/auth/sign_in.dart';
import 'package:e_learning/src/wishlist/wish_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfiletState();
}

class _ProfiletState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/images/Avatar.png',
      //         width: 90,
      //         height: 50,
      //       ),
      //       const SizedBox(width: 2),
      //       const Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             'Hello, Narendra',
      //             style: TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.bold,
      //               color: Color.fromARGB(255, 0, 0, 0),
      //               fontFamily: 'serif',
      //             ),
      //           ),
      //           Text(
      //             'What are you cooking today?',
      //             style: TextStyle(
      //               fontSize: 12,
      //               color: Colors.grey,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(color: Colors.white),
      //   ),
      //   automaticallyImplyLeading: false,
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageAndTextSection(),
            buildPersonalInfoSection(),
            buildSecuritySection(),
            buildAboutSection(),
            buildLogoutSection(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildImageAndTextSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<String>(
        future:
            _getUserName(), // Call the function to get the user's name from local storage
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If the data is available, display the user's name
            return Row(
              children: [
                const CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('assets/images/Avatar.png'),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!, // Display the user's name
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // If data is not available yet, show a loading indicator
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<String> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ??
        ''; // Get the user's name from local storage
  }

  Widget buildPersonalInfoSection() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Info",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          buildButton("Profile", Icons.person, Icons.arrow_forward_ios_rounded,
              () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProfilePage()),
            // );
          }),
          buildButton(
              "Wishlist", Icons.favorite, Icons.arrow_forward_ios_rounded, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WishList()),
            );
          }),
        ],
      ),
    );
  }

  Widget buildSecuritySection() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Security",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          buildButton(
              "Change Password", Icons.lock, Icons.arrow_forward_ios_rounded,
              () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            // );
          }),
        ],
      ),
    );
  }

  Widget buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          buildButton("Terms & Conditions", Icons.library_books,
              Icons.arrow_forward_ios_rounded, () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ChangePasswordPage()),
            // );
          }),
          buildButton("Privacy & Policy", Icons.help_outline,
              Icons.arrow_forward_ios_rounded, () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            // );
          }),
          // buildToggleSwitch("Dark Mode", Icons.dark_mode),
        ],
      ),
    );
  }

  Widget buildButton(
      String text, IconData icon, IconData arrowIcon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8.0),
            Text(text),
            const Spacer(),
            Icon(arrowIcon),
          ],
        ),
      ),
    );
  }

  // Widget buildToggleSwitch(String text, IconData icon) {
  //   bool isSwitched = false;

  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Icon(icon),
  //         const SizedBox(width: 8.0),
  //         Text(text),
  //         const Spacer(),
  //         CupertinoSwitch(
  //           value: isSwitched,
  //           onChanged: (value) {
  //             // Add logic here for handling the switch state
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildLogoutSection() {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showLogoutConfirmationDialog(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFFEF6C00),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: const BorderSide(color: Color(0xFFEF6C00)),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Log out',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Are you sure you want to log out ?",
                    style: TextStyle(
                        color: Colors.black, fontSize: 20, fontFamily: 'Serif'),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF6C00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Remove all data from local storage
                          await prefs.clear();
                          // Print data after clearing
                          print('Data after clearing: ${prefs.getKeys()}');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: const Text("Log out",
                            style: TextStyle(color: Color(0xFFEF6C00))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
