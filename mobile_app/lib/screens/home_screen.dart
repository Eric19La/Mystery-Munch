import 'package:flutter/material.dart';

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

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for restaurants...",
                prefixIcon: const Icon(Icons.search, color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.amber[100],
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Category Scrollable Icons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _categoryIcon(Icons.location_pin, "Location"),
                _categoryIcon(Icons.price_change, "Price"),
                _categoryIcon(Icons.restaurant_menu, "Cuisine"),
                _categoryIcon(Icons.fastfood, "Fast Food"),
                _categoryIcon(Icons.local_drink, "Drinks"),
                _categoryIcon(Icons.coffee, "Coffee"),
                _categoryIcon(Icons.soup_kitchen, "Soup"),
                _categoryIcon(Icons.filter_list_alt, "Filter")
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: labelBehavior,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: "Search"),
          NavigationDestination(icon: Icon(Icons.map), label: "Map"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  // Category Icon Widget
  Widget _categoryIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 24,
            child: Icon(icon, color: Colors.black45),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
