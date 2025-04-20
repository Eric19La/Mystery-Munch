import 'package:flutter/material.dart';
import 'category_section.dart';

class BottomSheetList extends StatefulWidget {
  final List<Map<String, dynamic>> restaurant; // List of restaurants
  final ScrollController scrollController;     // Controller for the scroll

  const BottomSheetList({
    super.key,
    required this.restaurant,
    required this.scrollController,
  });

  @override
  State<BottomSheetList> createState() => _BottomSheetListState();
}

class _BottomSheetListState extends State<BottomSheetList> {
  late List<Map<String, dynamic>> _shuffledRestaurants;

  @override
  void initState() {
    super.initState();
    _shuffledRestaurants = List.from(widget.restaurant);
  }

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
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Nearby Restaurants",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Restaurant List starting with the tapped/random restaurant
              Column(
                children: _shuffledRestaurants.asMap().entries.map((entry) {
                  final restaurantData = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: buildLargeCategoryCard(restaurantData, true), // true = map screen
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
                      onPressed: _randomizeRestaurant,
                      icon: const Icon(Icons.shuffle_on_rounded),
                      label: const Text(
                        "Randomize",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _randomizeRestaurant() {
    if (_shuffledRestaurants.isEmpty) return;

    final random = _shuffledRestaurants.toList()..shuffle();
    final randomPick = random.first;

    setState(() {
      _shuffledRestaurants = [
        randomPick,
        ..._shuffledRestaurants.where((r) => r['title'] != randomPick['title']),
      ];
    });

    // Optional: Scroll to top
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

}
