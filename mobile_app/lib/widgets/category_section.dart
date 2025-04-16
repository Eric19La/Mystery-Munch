import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final String screenContext;

  const CategorySection({
    super.key,
    required this.title,
    required this.items,
    this.screenContext = 'home',
  });

  // Build the text displaced on the CategorySection
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 240, // Height of each category section
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                bool isFirstSpecialCard = index == 0 && screenContext == 'map';
                return buildLargeCategoryCard(items[index], isFirstSpecialCard);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

} // end Class Category Section

// Create large category cards
Widget buildLargeCategoryCard(Map<String, dynamic> data, bool isMapScreen) {
  return Padding(
    padding: const EdgeInsets.only(right: 16),
    child: Container(
      width: isMapScreen ? 370 : 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.amber[20],
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              data["image"]!,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          ),
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"]!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
