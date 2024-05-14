// ignore_for_file: non_constant_identifier_names, deprecated_member_use, avoid_print

import 'package:e_learning/src/service/api.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Recipedetails {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String ingredients;
  final String nutrition;
  final String cookingtime;
  final String Recipevideo;

  Recipedetails({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.nutrition,
    required this.cookingtime,
    required this.Recipevideo,
  });

  factory Recipedetails.fromJson(Map<String, dynamic> json) {
    return Recipedetails(
      id: json['Recipe_id']?.toString() ??
          'N/A',
      title: json['Recipe_Title'] as String? ?? '',
      description: json['Recipe_Description'] as String? ?? '',
      imageUrl: json['Recipe_Thumbnail'] as String? ?? '',
      ingredients: json['Recipe_Ingredients'] as String? ?? '',
      nutrition: json['Recipe_Nutritional_Info'] as String? ?? '',
      cookingtime: json['Recipe_Cooking_Time']?.toString() ?? '',
      Recipevideo: json['Recipe_Url']?.toString() ?? '',
    );
  }
}

class RecipeDetails extends StatefulWidget {
  final String subCategoryId;
  final String recipeId;

  const RecipeDetails({
    super.key,
    required this.subCategoryId,
    required this.recipeId,
  });
  

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late FlickManager flickManager;
  List<Recipedetails> Recipedetail = [];

  @override
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final url = Uri.parse(
        '${API.baseUrl}/recipes/subcategory/${widget.subCategoryId}/${widget.recipeId}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          Recipedetail = [
            Recipedetails.fromJson(data)
          ]; // Wrap the single data item in a list
          // Initialize flickManager with the retrieved video URL
          flickManager = FlickManager(
            videoPlayerController: VideoPlayerController.network(
              Recipedetail[0].Recipevideo.toString(), // Convert Uri to String
            ),
          );
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Stack(
            children: [
              Positioned(
                top: 9,
                left: 8,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 500,
            child: Recipedetail.isNotEmpty
                ? FancyShimmerImage(
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      "assets/images/error.png",
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    imageUrl: Recipedetail[0].imageUrl,
                  )
                : Container(
                    color: Colors.grey, // Placeholder color while loading
                    // You can add loading indicator or any placeholder widget here
                  ),
          ),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 300),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Material(
                            child: SafeArea(
                              child: AspectRatio(
                                aspectRatio: 20 / 12, // adjust aspect ratio
                                child: FlickVideoPlayer(
                                  flickManager: flickManager,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleAndFavoriteIcon(
                      recipeTitle:
                          Recipedetail.isNotEmpty ? Recipedetail[0].title : '',
                      cooktime: Recipedetail.isNotEmpty
                          ? Recipedetail[0].cookingtime
                          : '',
                    ),
                    const SizedBox(height: 8),
                    _buildRecipeDescription(Recipedetail.isNotEmpty
                        ? Recipedetail[0].description
                        : ''),
                    const SizedBox(height: 16),
                    _buildIngredients(Recipedetail.isNotEmpty
                        ? Recipedetail[0].ingredients
                        : ''),
                    const SizedBox(height: 16),
                    _buildNutrition(Recipedetail.isNotEmpty
                        ? Recipedetail[0].nutrition
                        : ''),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndFavoriteIcon(
      {required String recipeTitle, required String cooktime}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: recipeTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Adjust the color if needed
            ),
            children: [
              TextSpan(
                text: ' ($cooktime min)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEF6C00),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border_rounded),
          onPressed: () {
            // Handle favorite icon tap
          },
        ),
      ],
    );
  }

  Widget _buildRecipeDescription(String description) {
    return Text(
      description,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildIngredients(String ingredients) {
    // Parse the ingredients string into a list and display them
    List<String> ingredientList = ingredients.split(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ingredientList
              .map((ingredient) => Text('- $ingredient'))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNutrition(String nutrition) {
    // Parse the nutrition string into a list and display them
    List<String> nutritionList = nutrition.split(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition (per serving):',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nutritionList.map((item) => Text('- $item')).toList(),
        ),
      ],
    );
  }
}
