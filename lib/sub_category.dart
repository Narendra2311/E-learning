// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace

import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubCategory {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  SubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['Sub_Category_id']?.toString() ?? 'N/A',
      name: json['Sub_Category_Name'] as String? ?? '',
      description: json['Sub_Category_Description'] as String? ?? '',
      imageUrl: json['Sub_Category_Thumbnail'] as String? ?? '',
    );
  }
}

class SubCategoryPage extends StatefulWidget {
  final String categoryId;

  const SubCategoryPage({super.key, required this.categoryId});

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List<SubCategory> subCategories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://ff7e-2405-201-2009-d9ed-913b-844b-9334-2774.ngrok-free.app/subcategories/${widget.categoryId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subCategories = data
              .map((subCategoryData) => SubCategory.fromJson(subCategoryData))
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
          'Sub categories',
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  return _buildCard(
                    subCategories[index].name,
                    subCategories[index].imageUrl,
                    subCategories[index].description,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildCard(String cardTitle, String imagePath, String description) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 250,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: FancyShimmerImage(
                height: 140,
                width: double.infinity,
                boxFit: BoxFit.cover,
                imageUrl: imagePath,
                errorWidget: Image.asset(
                  "assets/images/error.png",
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2, // Add this line to limit to 2 lines
                    overflow: TextOverflow.ellipsis, // Add this line
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
