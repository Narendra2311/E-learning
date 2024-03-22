// ignore_for_file: sized_box_for_whitespace

import 'package:e_learning/category.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'subscription_plans.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _popularCategoryTabController;
  final PageController _bannerPageController = PageController(
    viewportFraction: 1.0,
    initialPage: 100,
  );
  int currentBannerPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _popularCategoryTabController = TabController(
      length: 6,
      vsync: this,
    );
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _bannerPageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });

    _bannerPageController.addListener(() {
      if (_bannerPageController.page ==
          _bannerPageController.page!.toInt().toDouble()) {
        setState(() {
          currentBannerPage = _bannerPageController.page!.toInt() % 4;
        });
      }
    });
  }

  @override
  void dispose() {
    _popularCategoryTabController.dispose();
    _bannerPageController.dispose();
    _timer.cancel();
    super.dispose();
  }

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
              // FancyShimmerImage(
              //   imageUrl: 'assets/food/$category$index.jpg',
              //   width: 250,
              //   boxFit: BoxFit.cover,
              //   height: 350,
              //   errorWidget: Container(
              //     height: 150.0, // Set the height to match the container
              //     width:
              //         double.infinity, // Set the width to match the container
              //     child: Image.asset(
              //       "assets/images/error.png",
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBannerSection(),
              buildTrendingSection(),
              buildPopularCategorySection(),
              buildSubscriptionPlanSection(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildAppBar() {
  //   return AppBar(
  //     title: Row(
  //       children: [
  //         Image.asset(
  //           'assets/images/Avatar.png',
  //           width: 90,
  //           height: 50,
  //         ),
  //         const SizedBox(width: 2),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: const [
  //             Text(
  //               'Hello, Narendra',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color.fromARGB(255, 0, 0, 0),
  //                 fontFamily: 'serif',
  //               ),
  //             ),
  //             Text(
  //               'What are you cooking today?',
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //     flexibleSpace: Container(
  //       decoration: const BoxDecoration(color: Colors.white),
  //     ),
  //     automaticallyImplyLeading: false,
  //   );
  // }

  Widget buildBannerSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        buildBannerCarousel(),
        const SizedBox(height: 16),
        buildBannerPagination(),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget buildBannerCarousel() {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _bannerPageController,
        itemCount: 10000,
        onPageChanged: (index) {
          setState(() {
            currentBannerPage = index % 4;
          });
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: buildBannerCard(index % 4),
          );
        },
      ),
    );
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

  Widget buildBannerPagination() {
    return Container(
      alignment: Alignment.center,
      child: SmoothPageIndicator(
        controller: _bannerPageController,
        count: 4,
        effect: const ExpandingDotsEffect(
          activeDotColor: Colors.black,
          dotColor: Colors.grey,
          dotHeight: 6.0,
          dotWidth: 6.0,
        ),
      ),
    );
  }

  Widget buildTrendingSection() {
    return Column(
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
        buildTrendingCards(),
      ],
    );
  }

  Widget buildTrendingCards() {
    return SizedBox(
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
                            color: const Color.fromARGB(255, 254, 170, 0),
                            borderRadius: BorderRadius.circular(9),
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
                              color: Colors.black.withOpacity(0.6),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget buildPopularCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Popular Category",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              buildSeeAllLink(),
            ],
          ),
          const SizedBox(height: 8),
          buildPopularCategoryTabs(),
          buildPopularCategoryCard(),
        ],
      ),
    );
  }

  Widget buildSeeAllLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Category()),
        );
      },
      child: const Row(
        children: [
          Text(
            "See all",
            style: TextStyle(
              fontSize: 15,
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
    );
  }

  Widget buildPopularCategoryTabs() {
    return Container(
      padding: const EdgeInsets.only(left: 0),
      child: DefaultTabController(
        length: 6, // Adjust the length based on the number of tabs
        child: TabBar(
          controller: _popularCategoryTabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Fruits'),
            Tab(text: 'Fast Food'),
            Tab(text: 'Indian'),
            Tab(text: 'Italian'),
            Tab(text: 'Chinese'),
            Tab(text: 'Desserts'),
          ],
          indicatorColor: const Color(0xFFEF6C00),
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
    );
  }

  Widget buildPopularCategoryCard() {
    return SizedBox(
      height: 200,
      child: TabBarView(
        controller: _popularCategoryTabController,
        children: [
          buildPopularCategoryCards('Fruits'),
          buildPopularCategoryCards('Fast Food'),
          buildPopularCategoryCards('Indian'),
          buildPopularCategoryCards('Italian'),
          buildPopularCategoryCards('Chinese'),
          buildPopularCategoryCards('Desserts'),
        ],
      ),
    );
  }

  Widget buildPopularCategoryCards(String category) {
    return Container(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: generateCardsForCategory(category),
      ),
    );
  }

  Widget buildSubscriptionPlanSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Subscription Plan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              buildSubscriptionPlanLink(),
            ],
          ),
          const SizedBox(height: 8), // Add some space between text and links

          buildSubscriptionPlanCard(),
        ],
      ),
    );
  }

  Widget buildSubscriptionPlanLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const subscription_plan()),
        );
      },
      child: const Row(
        children: [
          Text(
            "See all",
            style: TextStyle(fontSize: 15, color: Color(0xFFEF6C00)),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: Color(0xFFEF6C00),
          ),
        ],
      ),
    );
  }

  Widget buildSubscriptionPlanCard() {
    return SizedBox(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Your subscription plan cards go here
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
    );
  }
}
