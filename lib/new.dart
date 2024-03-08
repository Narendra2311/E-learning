// import 'package:flutter/foundation.dart';
// ignore_for_file: prefer_const_constructors

import 'package:e_learning/subscription_plans.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Fruits';

  final PageController _bannerPageController = PageController(
    viewportFraction: 1.0, // Adjust the viewportFraction
    initialPage: 100, // Set initialPage to a non-zero index
  );
  int currentBannerPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _bannerPageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });

    // Listen for page changes to implement circular loop
    _bannerPageController.addListener(() {
      if (_bannerPageController.page ==
          _bannerPageController.page!.toInt().toDouble()) {
        // Page is an integer, meaning the user manually swiped
        setState(() {
          currentBannerPage = _bannerPageController.page!.toInt() %
              4; // Use % to get the circular effect
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  // Function to generate a list of scrollable cards based on the selected category
  List<Widget> generateCardsForCategory(String category) {
    // Replace this with your logic to fetch data based on the category
    List<String> dishNames = [
      '$category 1',
      '$category 2',
      '$category 3',
      '$category 4',
      '$category 5',
    ];

    return List.generate(5, (index) {
      return Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                'assets/food/$category$index.jpg',
                width: 250,
                fit: BoxFit.cover,
                height: 350,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(1.0),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  child: Center(
                    child: Text(
                      dishNames[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Function to generate cards for each tab
  Widget generateCardsForTab(String category) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: generateCardsForCategory(category),
      ),
    );
  }

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Hello Narendra',
              //             style: TextStyle(
              //               fontSize: 25,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           SizedBox(height: 1),
              //           Text(
              //             'What are you cooking today?',
              //             style: TextStyle(fontSize: 14, color: Colors.grey),
              //           ),
              //         ],
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Image.asset(
              //           'assets/images/Avatar.png',
              //           width: 70,
              //           height: 70,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              // New Banner Section with Smooth Pagination
              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _bannerPageController,
                  itemCount: 10000, // A large number to ensure looping
                  onPageChanged: (index) {
                    setState(() {
                      currentBannerPage =
                          index % 4; // Use % to get the circular effect
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: buildBannerCard(
                          index % 4), // Use % to get the circular effect
                    );
                  },
                  // physics: BouncingScrollPhysics(),
                ),
              ),
              const SizedBox(height: 16),

              // Smooth Pagination for Banners
              Container(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: _bannerPageController,
                  count: 4, // Number of banners
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey,
                    dotHeight: 6.0,
                    dotWidth: 6.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(),
                    child: Row(
                      children: [
                        Text(
                          "Trending 🔥",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        List<String> dishNames = [
                          'Spaghetti Bolognese',
                          'Chicken Alfredo',
                          'Vegetable Stir-Fry',
                          'Chocolate Cake',
                        ];

                        return Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      index == 0
                                          ? 'assets/food/food1.jpg'
                                          : index == 1
                                              ? 'assets/food/food2.jpg'
                                              : index == 2
                                                  ? 'assets/food/food3.jpg'
                                                  : 'assets/food/food4.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 254, 170, 0),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '4.5',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // Add functionality to play the video
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '1 hour 30 minutes',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 245, 4, 4),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Color.fromARGB(255, 158, 20, 20),
                                    ),
                                    onPressed: () {
                                      // Add functionality for favorite button
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                dishNames[index],
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Popular Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add navigation logic to the "See all" page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Category()));
                      },
                      child: const Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFEF6C00),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Color(0xFFEF6C00),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Add a DefaultTabController and TabBar with custom style
              DefaultTabController(
                length: 6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 0,
                      ),
                      child: TabBar(
                        isScrollable: true,
                        tabs: const [
                          Tab(text: 'Fruits'),
                          Tab(text: 'Fast Food'),
                          Tab(text: 'Indian'),
                          Tab(text: 'Italian'),
                          Tab(text: 'Chinese'),
                          Tab(text: 'Desserts'),
                        ],
                        indicatorColor: Color(0xFFEF6C00),
                        indicatorWeight: 3,
                        labelColor: Colors.orange[800],
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        children: [
                          generateCardsForTab('Fruits'),
                          generateCardsForTab('Fast Food'),
                          generateCardsForTab('Indian'),
                          generateCardsForTab('Italian'),
                          generateCardsForTab('Chinese'),
                          generateCardsForTab('Desserts'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Subscription Plan text and "See all" link with arrow icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Subscription Plan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add navigation logic to the "See all" page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => subscription_plan()));
                      },
                      child: const Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFEF6C00)),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 12, color: Color(0xFFEF6C00)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Placeholder for subscription plan content
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: SizedBox(
                        height: 400,
                        width: 200,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(66),
                                        bottomLeft: Radius.circular(66),
                                      ),
                                      color: Color(0xFFd6a443), // Brown color
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 50.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          left: 0.0,
                                        ), // Add padding to the content
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Chinese',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Serif',
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height:
                                                  5, // Adjust the space between text and image
                                            ),
                                            Image.asset(
                                              'assets/bgr_image/Chinese3.png', // Replace with the actual image URL
                                              height:
                                                  130, // Adjust the height of the image
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(66),
                                        bottomRight: Radius.circular(0),
                                      ),
                                      color: Color(0xFFae5e3d), // Yellow color
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 50.0,
                                          right: 0.0,
                                          bottom: 0.0,
                                          left: 0.0,
                                        ), // Add padding to the content
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Indian',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Serif',
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height:
                                                  5, // Adjust the space between text and image
                                            ),
                                            Image.asset(
                                              'assets/bgr_image/Indian3.png', // Replace with the actual image URL
                                              height:
                                                  130, // Adjust the height of the image
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Positioned(
                              top: 10,
                              left: 35,
                              right: 0,
                              child: Text(
                                'Go Salsa',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Serif',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 27,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 37,
                              left: 64,
                              right: 0,
                              child: Text(
                                'with',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: 'Serif',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 39, // Adjust the top position for "Combos!"
                              left:
                                  87, // Adjust the left position for "Combos!"
                              right: 0,
                              child: Text(
                                'Combos!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Serif',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Combo ₹499',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Serif',
                                      fontStyle: FontStyle.italic,
                                      fontSize: 19,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '+Tax',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: 'Serif',
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                        child: SizedBox(
                          height: 400,
                          width: 200,
                          child: Image.asset(
                            'assets/combo_image/combo1.png', // Replace with the actual image path
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                        child: SizedBox(
                          height: 400,
                          width: 200,
                          child: Image.asset(
                            'assets/combo_image/combo2.png', // Replace with the actual image path
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(66),
                          bottomLeft: Radius.circular(66),
                          topRight: Radius.circular(66),
                          bottomRight: Radius.circular(0),
                        ),
                        child: SizedBox(
                          height: 400,
                          width: 200,
                          child: Image.asset(
                            'assets/combo_image/combo3.png', // Replace with the actual image path
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBannerCard(int index) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: Image.asset(
      'assets/Banner/Banner${index + 1}.jpg',
      fit: BoxFit.fill,
      height: 220,
    ),
  );
}
