// ignore_for_file: unnecessary_import
import 'dart:ui';
import 'package:e_learning/src/wishlist/wish_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfiletState();
}

class _ProfiletState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/Avatar.png',
              width: 90,
              height: 50,
            ),
            const SizedBox(width: 2),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Narendra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'serif',
                  ),
                ),
                Text(
                  'What are you cooking today?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage('assets/images/Avatar.png'),
            // backgroundColor: Color(0xFFEF6C00),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Narendra Choudhary",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@narendra1499',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Actual dialog
            AlertDialog(
              backgroundColor: Colors.white, // Set background color to white
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Are you sure you want to ",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const Text(
                    "to log out ?",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
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
                        onPressed: () {
                          // Add your logic for logging out here
                          Navigator.of(context).pop(); // Close the dialog
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
