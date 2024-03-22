import 'package:e_learning/homepage.dart';
import 'package:e_learning/src/profile/profile.dart';
import 'package:e_learning/src/search/search.dart';
import 'package:e_learning/src/wishlist/wish_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logo.png',
              width: 90,
              height: 50,
            ),
            const SizedBox(width: 2),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CrazeeCook',
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
      body: IndexedStack(
        index: _index,
        children: const [HomePage(), SearchPage(), WishList(), Profile()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        // backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFEF6C00),
        unselectedItemColor: Colors.grey[600],
        iconSize: 28.0,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: _bottomBar(),
      ),
    );
  }

  /// Bottom Bar
  List<BottomNavigationBarItem> _bottomBar() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search_rounded),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: '',
      ),
    ];
  }
}
