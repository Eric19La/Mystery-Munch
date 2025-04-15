import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import '../widgets/category_icon.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_section.dart';
import '../api/places_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Create an instance
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize the futures
  late Future<List<Map<String, dynamic>>> foodNearbyFuture; // Used for searching food nearby your location
  late Future<List<Map<String, dynamic>>> asianFoodFuture;  // Used for searching asian food nearby your location
  late Future<List<Map<String, dynamic>>> noodleFoodFuture;  // Used for searching noodle soup nearby your location

  @override
  void initState() {
    super.initState();

    // Fetch data when the widget is initialized
    // Comment this out atm so we don't make too many calls when testing
    // foodNearbyFuture = fetchFoodByKeyword('food');
    // asianFoodFuture = fetchFoodByKeyword('asian');
    // noodleFoodFuture = fetchFoodByKeyword('pho');
  }

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
                  CategorySection(title: "Fast Food", items: fastFood, screenContext: 'home',),
                  CategorySection(title: "Asian Food", items: asianFood, screenContext: 'home',),
                  CategorySection(title: "Food", items: fastFood, screenContext: 'home',),

                  // Category Sections with Real Data from API, currently we want to comment this out so we don't make too many calls when testing
                  // FutureBuilder<List<Map<String, dynamic>>>(
                  //   future: foodNearbyFuture,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text("Error loading Fast Food"));
                  //     } else {
                  //       return CategorySection(title: "Food Nearby", items: snapshot.data!);
                  //     }
                  //   },
                  // ),
                  // FutureBuilder<List<Map<String, dynamic>>>(
                  //   future: asianFoodFuture,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text("Error loading Asian Food"));
                  //     } else {
                  //       return CategorySection(title: "Asian Cuisine", items: snapshot.data!);
                  //     }
                  //   },
                  // ),
                  // FutureBuilder<List<Map<String, dynamic>>>(
                  //   future: noodleFoodFuture,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Center(child: CircularProgressIndicator());
                  //     } else if (snapshot.hasError) {
                  //       return Center(child: Text("Error loading Asian Food"));
                  //     } else {
                  //       return CategorySection(title: "Noodle", items: snapshot.data!);
                  //     }
                  //   },
                  // ),

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
    // "description": "View →",
    "image": "assets/images/in-n-out.jpeg",
  },
  {
    "title": "McDonald's",
    // "description": "View →",
    "image": "assets/images/mcds.jpg"
  },
];

// Sample asian food data
List<Map<String, String>> asianFood = [
  {
    "title": "Pho",
    // "description": "View →",
    "image": "assets/images/pho.jpg",
  },
  {
    "title": "Sushi",
    // "description": "View →",
    "image": "assets/images/sushi.jpg"
  },
];
