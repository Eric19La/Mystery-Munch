import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import '../widgets/category_icon.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Create an instance
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header Section
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),

      // Body Section
      body: Column(
        children: [
          const SizedBox(height: 20),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: SearchBarWidget()
          ),
          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Category Scrollable Icons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        CategoryIcon(Icons.location_pin, "Location"),
                        CategoryIcon(Icons.price_change, "Price"),
                        CategoryIcon(Icons.restaurant_menu, "Cuisine"),
                        CategoryIcon(Icons.fastfood, "Fast Food"),
                        CategoryIcon(Icons.local_drink, "Drinks"),
                        CategoryIcon(Icons.coffee, "Coffee"),
                        CategoryIcon(Icons.soup_kitchen, "Soup"),
                        CategoryIcon(Icons.filter_list_alt, "Filter"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Sections
                  CategorySection(title: "Fast Food", items: fastFood),
                  CategorySection(title: "Asian Food", items: asianFood),
                  CategorySection(title: "Food", items: fastFood),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0, // Explore/Home Page has the index 0
        onPageSelected: (index) => selectedPage(context, index),
      ),

    );
  }
}

// Sample fast food data
List<Map<String, String>> fastFood = [
  {
    "title": "In-N-Out Burger",
    "description": "View →",
    "image": "assets/images/in-n-out.jpeg",
  },
  {
    "title": "McDonald's",
    "description": "View →",
    "image": "assets/images/mcds.jpg"
  },
];

// Sample asian food data
List<Map<String, String>> asianFood = [
  {
    "title": "Pho",
    "description": "View →",
    "image": "assets/images/pho.jpg",
  },
  {
    "title": "Sushi",
    "description": "View →",
    "image": "assets/images/sushi.jpg"
  },
];
