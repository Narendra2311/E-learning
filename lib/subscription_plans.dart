// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class subscription_plan extends StatefulWidget {
  const subscription_plan({super.key});

  @override
  State<subscription_plan> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<subscription_plan> {
  late PageController _pageController;
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);

  int numCards = 3;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _pageIndexNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Subscription plan',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Serif',
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(148, 255, 166, 0),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            right: 16.0,
            child: Center(
              child: SizedBox(
                width: 250.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTabButton(0, 'Plans'),
                      _buildTabButton(1, 'Combos'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 120.0,
            left: 0,
            right: 0,
            bottom: 100,
            child: PageView.builder(
              key: ValueKey<int>(numCards),
              controller: _pageController,
              itemCount: numCards,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 300.0,
                  child: _selectedTabIndex == 0
                      ? buildPlanCard(index)
                      : buildComboCard(index),
                );
              },
              onPageChanged: (index) {
                _pageIndexNotifier.value = index;
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: ClipRect(
                child: Container(
                  width: 100.0,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: numCards,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey,
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedTabIndex = index;
            _pageController.jumpToPage(0);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedTabIndex == index
              ? Color.fromARGB(182, 239, 108, 0)
              : Colors.white,
          elevation: 0, // No shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.black : Colors.grey,
            fontStyle: FontStyle.italic,
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildPlanCard(int index) {
    List<String> planNames = ['Silver', 'Gold', 'Diamond'];
    List<Color> backgroundColors = [
      Colors.white,
      Colors.white,
      Colors.white,
    ];
    List<Color> lineColors = [
      Color(0xFFCD7F32),
      Color(0xFFC0C0C0),
      Color(0xFFFFD700),
    ];

    List<String> prices = [
      '\u20B9 499',
      '\u20B9 599',
      '\u20B9 699',
    ];

    List<String> durations = [
      '1 month validity',
      '6 month validity',
      '1 year validity',
    ];

    List<List<Map<String, dynamic>>> features = [
      [
        {
          'icon': Icons.check,
          'color': Colors.green,
          'text': 'Unlimited access'
        },
        {'icon': Icons.clear, 'color': Colors.red, 'text': 'No ads'},
        {'icon': Icons.clear, 'color': Colors.red, 'text': '24/7 support'},
      ],
      [
        {
          'icon': Icons.check,
          'color': Colors.green,
          'text': 'Unlimited access'
        },
        {'icon': Icons.check, 'color': Colors.green, 'text': 'No ads'},
        {'icon': Icons.clear, 'color': Colors.red, 'text': '24/7 support'},
      ],
      [
        {
          'icon': Icons.check,
          'color': Colors.green,
          'text': 'Unlimited access'
        },
        {'icon': Icons.check, 'color': Colors.green, 'text': 'No ads'},
        {'icon': Icons.check, 'color': Colors.green, 'text': '24/7 support'},
      ],
    ];

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: backgroundColors[index],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Column(
              children: [
                Text(
                  planNames[index],
                  style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Serif',
                  ),
                ),
                SizedBox(height: 4.0),
                Container(
                  height: 2.0,
                  width: 200,
                  color: lineColors[index],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  prices[index],
                  style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  durations[index],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 38.0),
                for (var feature in features[index])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(feature['icon'], color: feature['color']),
                      SizedBox(width: 8.0),
                      Text(feature['text']),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComboCard(int index) {
    List<String> comboImages = [
      'assets/combo_image/combo1.png',
      'assets/combo_image/combo2.png',
      'assets/combo_image/combo3.png',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Image.asset(
              comboImages[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
