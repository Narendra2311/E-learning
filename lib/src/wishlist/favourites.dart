// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFavouriteCard(
            image:
                'assets/food/Indian1.jpg', // Replace 'assets/image.jpg' with actual image path
            name: 'Video Name',
            description: 'Video Description',
          ),
          _buildFavouriteCard(
            image:
                'assets/food/Indian1.jpg', // Replace 'assets/image.jpg' with actual image path
            name: 'Video Name',
            description: 'Video Description',
          ),
          _buildFavouriteCard(
            image:
                'assets/food/Indian1.jpg', // Replace 'assets/image.jpg' with actual image path
            name: 'Video Name',
            description: 'Video Description',
          ),
          _buildFavouriteCard(
            image:
                'assets/food/Indian1.jpg', // Replace 'assets/image.jpg' with actual image path
            name: 'Video Name',
            description: 'Video Description',
          ),
          _buildFavouriteCard(
            image:
                'assets/food/Indian1.jpg', // Replace 'assets/image.jpg' with actual image path
            name: 'Video Name',
            description: 'Video Description',
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildFavouriteCard({
    required String image,
    required String name,
    required String description,
  }) {
    return Card(
      color: Colors.white, // Set background color to white
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              height: 150, // Adjust height as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.red, // Set heart icon color
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
