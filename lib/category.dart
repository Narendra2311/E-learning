// ignore_for_file: avoid_print, sized_box_for_whitespace, prefer_const_constructors

import 'dart:convert';
import 'package:e_learning/sub_category.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CategoryData {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  CategoryData({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    final id = json['Category_id']?.toString() ?? 'N/A';
    final name = json['Category_Name'] as String? ?? '';
    final description = json['Category_Description'] as String? ?? '';
    final imageUrl = json['Category_Thumbnail'] as String? ?? '';

    return CategoryData(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }

  @override
  String toString() {
    return 'CategoryData{id: $id, name: $name, description: $description, imageUrl: $imageUrl}';
  }
}

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late PageController _pageController;
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);

  int numCards = 0;
  List<CategoryData> categories = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _pageIndexNotifier.addListener(() {
      setState(() {});
    });

    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://ff7e-2405-201-2009-d9ed-913b-844b-9334-2774.ngrok-free.app/viewcategories');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data
              .map((categoryData) => CategoryData.fromJson(categoryData))
              .toList();
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'All categories',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Serif',
            fontStyle: FontStyle.italic,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  // decoration: const BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.bottomCenter,
                  //     end: Alignment.topCenter,
                  //     colors: [
                  //       Color.fromARGB(148, 255, 166, 0),
                  //       Color.fromARGB(255, 255, 255, 255),
                  //     ],
                  //   ),
                  // ),
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 220.0,
                      child: buildCard(
                        categories[index],
                        index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildCard(CategoryData category, int index) {
    return GestureDetector(
      onTap: () {
        print('Category: $category');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryPage(categoryId: category.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150.0,
                width: double.infinity,
                child: FancyShimmerImage(
                  boxFit: BoxFit.cover,
                  imageUrl: category.imageUrl,
                  errorWidget: Container(
                    height: 150.0, // Set the height to match the container
                    width:
                        double.infinity, // Set the width to match the container
                    child: Image.asset(
                      "assets/images/error.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
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
