import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/category_section.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _restaurantLocation = LatLng(34.0522, -118.2437);  // Example LA

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map")),
      body: Stack(
        children: [
          // Maps
          FlutterMap(
            options: MapOptions(
              center: _restaurantLocation,
              zoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _restaurantLocation,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context),
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Nav Bar Section
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onPageSelected: (index) => selectedPage(context, index),
      ),
    );
  }

  // Bottom Sheet for Restaurant Info
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Default height
          minChildSize: 0.3, // Minimum height
          maxChildSize: 0.9, // Maximum height
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
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),

                  CategorySection(title: "In-N-Out", items: fastFood),

                  // // Food Menu (Horizontal Scroll)
                  // SizedBox(
                  //   height: 150,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.only(left: 16),
                  //     children: [
                  //       CategorySection(title: "Fast Food", items: fastFood),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 15),

                  // Delivery & Pickup Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOptionButton("Randomize", "🚚", Colors.amber),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Widget for a food item
  Widget _buildFoodItem(String name, String price, String imageUrl) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, width: 120, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  // Widget for Delivery/Pickup Buttons
  Widget _buildOptionButton(String text, String emoji, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: () {},
      icon: Text(emoji),
      label: Text(text),
    );
  }

} // end MapScreen

// Sample fast food data
List<Map<String, String>> fastFood = [
  {
    "title": "Burgers",
    "description": "View →",
    "image": "assets/images/in-n-out.jpeg",
  },
  {
    "title": "Fries",
    "description": "View →",
    "image": "assets/images/mcds.jpg"
  },
];