import 'package:flutter/material.dart';

import 'category_section.dart';

class BottomSheetList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> restaurant;  // Expecting list of fast food images

  const BottomSheetList({Key? key, required this.scrollController, required this.restaurant}) : super(key: key);

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
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Food Images (CategorySection)
              CategorySection(title: "", items: restaurant, screenContext: 'map',),

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

              const SizedBox(height: 10),
            ],
          ),
        );
      }
    );
  }
}