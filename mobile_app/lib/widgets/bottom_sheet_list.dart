import 'package:flutter/material.dart';
import 'category_section.dart';

class BottomSheetList extends StatelessWidget {
  final List<Map<String, dynamic>> restaurant;
  final ScrollController scrollController;

  const BottomSheetList({
    super.key,
    required this.restaurant,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: restaurant.asMap().entries.map((entry) {
                int index = entry.key;
                final restaurantData = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: buildLargeCategoryCard(restaurantData, true), // true if it's the tapped marker
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
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return DraggableScrollableSheet(
  //     initialChildSize: 0.5,
  //     minChildSize: 0.5,
  //     maxChildSize: 0.8,
  //     expand: false,
  //     builder: (context, scrollController) {
  //       return SingleChildScrollView(
  //         controller: scrollController,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Drag Handle
  //             Center(
  //               child: Container(
  //                 margin: const EdgeInsets.symmetric(vertical: 10),
  //                 width: 40,
  //                 height: 5,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[400],
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //             ),
  //
  //             // Food Images (CategorySection)
  //             CategorySection(title: "", items: restaurant, screenContext: 'map',),
  //
  //
  //             const SizedBox(height: 10),
  //           ],
  //         ),
  //       );
  //     }
  //   );
  // }
}