import 'package:flutter/material.dart';
import '../widgets/category_icon.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Create an instance
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Tracks the current active tab

  // Determine when the navigation label appears
  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.alwaysShow;

  // Updates _selectedIndex when a navigation item is pressed and rebuilds the UI
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          const SearchBarWidget(),
          const SizedBox(height: 5),

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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Colors.amber[20],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          labelBehavior: labelBehavior,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.search), label: "Search"),
            NavigationDestination(icon: Icon(Icons.map), label: "Map"),
            NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
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
