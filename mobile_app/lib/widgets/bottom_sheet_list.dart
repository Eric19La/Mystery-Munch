import 'package:flutter/material.dart';
import 'category_section.dart';

class BottomSheetList extends StatelessWidget {
  final List<Map<String, dynamic>> restaurant;  // List of restaurants
  final ScrollController scrollController;   // Controller for the scroll

  const BottomSheetList({
    super.key,
    required this.restaurant,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Text
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Nearby Restaurants",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Restaurant List starting with the tapped marker
              Column(
                children: restaurant.asMap().entries.map((entry) {
                  final restaurantData = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: buildLargeCategoryCard(restaurantData, true), // true, bc its the map screen
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Randomize Feature
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: () {
                        // TODO: Implement the randomize feature
                      },
                      icon: Text("🚗"),
                      label: Text("Randomize"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

} // end BottomSheetList Class