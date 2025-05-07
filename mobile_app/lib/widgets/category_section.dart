import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/restaurant_popup.dart';
import '../main.dart';

class CategorySection extends StatelessWidget {
  final String title;  // Title of the category
  final List<Map<String, dynamic>> items; // List of items in the category (asians, fast food, etc)
  final String screenContext; // Context of the screen (home or map)

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
  final imageUrl = data["image"] ?? 'https://via.placeholder.com/400';  // Placeholder image if no image is provided
  final title = data["title"] ?? 'Unnamed'; // Default title if no title is provided
  final distance = data["distance"] ?? 0; // Default distance if no distance is provided

  return GestureDetector(
    // When the restaurant is tapped, show the restaurant popup
    onTap: () {
      showDialog(
        context: navigatorKey.currentContext!, // <- Add this key to your MaterialApp (see below)
        builder: (context) => RestaurantPopup(
          title: data['title'],
          imageUrl: data['image'],
          distance: data['distance'],
          rating: data['rating'],
          lat: data['lat'],
          lng: data['lng'],
        ),
      );
    },

    // The Default Image Card you see on the home/map screen
    child: Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: isMapScreen ? 400 : 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.amber[20],
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey[300], child: Icon(Icons.broken_image)),
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

            // Title + Distance Section of the Image Card
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('${distance.toStringAsFixed(0)} meters away', style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
