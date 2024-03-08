import 'package:flutter/material.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
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
      body: const Center(
        child: Text('Wishlist'),
      ),
      backgroundColor: Colors.white,
    );
  }
}
