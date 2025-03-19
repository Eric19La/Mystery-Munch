import 'package:flutter/material.dart';

import 'category_section.dart';

class BottomSheetList extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, String>> fastFood;  // Expecting list of fast food images

  const BottomSheetList({Key? key, required this.scrollController, required this.fastFood}) : super(key: key);

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

              // Restaurant Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "In-N-Out",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        Text(" 4.4 (500+) • \$ • 900 ft"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("🟢 Open • Closes at 1:30 AM", style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),

              // Food Images (CategorySection)
              CategorySection(title: "", items: fastFood),

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