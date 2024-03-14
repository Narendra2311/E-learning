import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class RecipeDetails extends StatefulWidget {
  final String recipeId;

  const RecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.asset(
        'assets/videos/cake.mp4',
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
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
            child: Image.asset(
              'assets/food/Indian3.jpg',
              fit: BoxFit.cover,
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
                    _buildTitleAndFavoriteIcon(),
                    const SizedBox(height: 8),
                    _buildRecipeDescription(),
                    const SizedBox(height: 16),
                    _buildIngredients(),
                    const SizedBox(height: 16),
                    _buildNutrition(),
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

  Widget _buildTitleAndFavoriteIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Recipe Title ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Adjust the color if needed
            ),
            children: [
              TextSpan(
                text: '(45min)',
                style: TextStyle(
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

  Widget _buildRecipeDescription() {
    return const Text(
      'Recipe Description goes here. Provide details about the recipe and any additional information you want to display.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildIngredients() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('- 1 large eggplant, diced'),
            Text('- 1 can (14 oz) diced tomatoes'),
            Text('- 1/2 cup green olives, sliced'),
            Text('- 1/4 cup capers'),
            Text('- 2 tablespoons red wine vinegar'),
            Text('- 2 tablespoons olive oil'),
            Text('- Salt and pepper to taste'),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrition() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition (per serving):',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('- Calories: 140'),
            Text('- Protein: 3g'),
            Text('- Fat: 8g'),
            Text('- Carbohydrates: 16g'),
            Text('- Fiber: 6g'),
          ],
        ),
      ],
    );
  }
}
