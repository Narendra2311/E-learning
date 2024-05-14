// ignore_for_file: sized_box_for_whitespace, library_prefixes

import 'package:e_learning/category.dart'
    as categoryModel; // Rename category.dart to avoid conflict
import 'package:e_learning/recipe_details.dart';
import 'package:e_learning/src/service/api.dart';
import 'package:e_learning/sub_category.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'subscription_plans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Recipe {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int subCategoryId;
  final String cookingTime;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.subCategoryId,
    required this.cookingTime,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['Recipe_id'],
      title: json['Recipe_Title'],
      description: json['Recipe_Description'],
      thumbnailUrl: json['Recipe_Thumbnail'],
      subCategoryId: json['Sub_Category_id'],
      cookingTime: json['Recipe_Cooking_Time'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String thumbnailUrl;

  Category({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['Category_id'],
      name: json['Category_Name'],
      thumbnailUrl: json['Category_Thumbnail'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Recipe> trendingRecipes = [];
  List<Category> categories = [];

  final PageController _bannerPageController = PageController(
    viewportFraction: 1.0,
    initialPage: 100,
  );
  int currentBannerPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();

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

  Future<void> fetchDataFromApi() async {
    final recipeUrl = Uri.parse('${API.baseUrl}/recipes/featured');
    final categoryUrl = Uri.parse('${API.baseUrl}/viewcategories');

    final recipeResponse = await http.get(recipeUrl);
    final categoryResponse = await http.get(categoryUrl);

    if (recipeResponse.statusCode == 200 &&
        categoryResponse.statusCode == 200) {
      final List<dynamic> recipeData = jsonDecode(recipeResponse.body);
      final List<dynamic> categoryData = jsonDecode(categoryResponse.body);

      setState(() {
        trendingRecipes =
            recipeData.map((data) => Recipe.fromJson(data)).toList();
        categories =
            categoryData.map((data) => Category.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Visibility(
      visible: trendingRecipes.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(),
            child: Row(
              children: [
                Text(
                  "Trending Recipe 🔥",
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
      ),
    );
  }

  Widget buildTrendingCards() {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingRecipes.length,
        itemBuilder: (context, index) {
          Recipe recipe = trendingRecipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetails(
                    recipeId: recipe.id.toString(),
                    subCategoryId: recipe.subCategoryId.toString(),
                  ),
                ),
              );
            },
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 8),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            height: 220,
                            child: FancyShimmerImage(
                              imageUrl: recipe.thumbnailUrl,
                              boxFit: BoxFit.cover,
                              errorWidget: Container(
                                color: Colors.grey[300],
                                
                                child: const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
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
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        recipe.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        recipe.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
          buildCategoryCards(),
        ],
      ),
    );
  }

  Widget buildSeeAllLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const categoryModel.Category()),
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

  Widget buildCategoryCards() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return buildCategoryCard(category);
        },
      ),
    );
  }

  Widget buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SubCategoryPage(categoryId: category.id.toString()),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 170,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                FancyShimmerImage(
                  imageUrl: category.thumbnailUrl,
                  boxFit: BoxFit.cover,
                  errorWidget: Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(1.0),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          const SizedBox(height: 8),
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
                  'assets/combo_image/combo1.png',
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
                  'assets/combo_image/combo2.png',
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
                  'assets/combo_image/combo3.png',
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
