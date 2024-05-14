import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recipeNames = [
    'Dal Makhani',
    'Butter Malai',
    'Paneer Tikka',
    'Aloo Gobi',
    'Spaghetti Bolognese',
    'Margherita Pizza',
    'Tiramisu',
    'Minestrone Soup',
  ];
  List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Hide the keyboard when the user taps anywhere on the screen
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchResults = _filterRecipes(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search recipe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _searchResults.isEmpty
                ? const Text(
                    'Popular Search',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            _searchResults.isEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _recipeNames.length,
                      itemBuilder: (context, index) {
                        return _buildRecipeCard(_recipeNames[index],
                            'assets/food/recipe${index + 1}.jpg');
                      },
                    ),
                  )
                : Expanded(
                    child: _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              return _buildRecipeCard(_searchResults[index],
                                  'assets/food/recipe${index + 1}.jpg');
                            },
                          )
                        : const Center(
                            child: Text('Nothing matched'),
                          ),
                  ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  List<String> _filterRecipes(String query) {
    return _recipeNames
        .where((recipe) => recipe.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _buildRecipeCard(String name, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 14,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 400,
              height: 130,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
  }
}
