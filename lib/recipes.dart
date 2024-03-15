// ignore_for_file: camel_case_types, avoid_print, sized_box_for_whitespace

import 'dart:convert';
import 'package:e_learning/recipe_details.dart';
import 'package:e_learning/src/service/api.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recipes extends StatefulWidget {
  final String subCategoryId;

  const Recipes({super.key, required this.subCategoryId});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${API.baseUrl}/recipes/subcategory/${widget.subCategoryId}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          recipes = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        // Handle error
        print('Failed to load recipes');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Recipes',
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
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 6.0,
            childAspectRatio:
                0.8, // Adjust this value to change the aspect ratio
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) => _buildCard(index),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildCard(int index) {
    final recipe = recipes[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(
              subCategoryId: widget.subCategoryId,
              recipeId: recipe['Recipe_id'].toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0, // Adjust vertical margin as needed
        ),
        // height: 500.0, // Increase the card height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 120.0,
                width: double.infinity,
                child: FancyShimmerImage(
                  boxFit: BoxFit.cover,
                  errorWidget: Image.asset(
                    "assets/images/error.png",
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  imageUrl: recipe['Recipe_Thumbnail'],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['Recipe_Title'],
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      recipe['Recipe_Description'] ?? '',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
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
}
