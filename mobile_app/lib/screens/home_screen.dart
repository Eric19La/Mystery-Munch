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
  List<Map<String, dynamic>> nearbyRestaurants = [];   // List of nearby restaurants
  Map<String, List<Map<String, dynamic>>> filteredSections = {};  // Map of filtered sections
  List<String> selectedFilters = [];  // List of selected filters
  bool isLoadingNearby = false; // Loading state for nearby restaurants
  bool isLoadingFilters = false;  // Loading state for filtered sections

  @override
  void initState() {
    super.initState();
    fetchNearbyFood();  // Fetch nearby restaurants on initialization
    fetchAndUpdateRestaurants();  // Fetch and update filtered sections on initialization
  }

  // List of categories the user is able to select
  final categories = [
    {"icon": Icons.fastfood, "label": "Fast Food"},
    {"icon": Icons.local_drink, "label": "Drinks"},
    {"icon": Icons.coffee, "label": "Coffee"},
    {"icon": Icons.restaurant_menu, "label": "Cuisine"},
    {"icon": Icons.soup_kitchen, "label": "Soup"},
    {"icon": Icons.filter_list_alt, "label": "Filter"},
  ];

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
                      children: categories.map((category) {
                        final label = category['label'] as String;  // Get the label of the category
                        final isSelected = selectedFilters.contains(label.toLowerCase()); // Check if the category is selected

                        // Build the category icon
                        return CategoryIcon(
                          category['icon'] as IconData,
                          label,
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? selectedFilters.remove(label.toLowerCase())
                                  : selectedFilters.add(label.toLowerCase());
                            });
                            fetchAndUpdateRestaurants();
                          },
                        );
                      }).toList(),

                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🍽️ Always show nearby food
                  isLoadingNearby
                    ? const Center(child: CircularProgressIndicator())
                    : CategorySection(title: "Food Nearby", items: nearbyRestaurants),

                  const SizedBox(height: 20),

                  // 🧠 Filtered Sections — make sure data exists before showing
                  // for (String keyword in List.from(selectedFilters))
                  //   if (filteredSections.containsKey(keyword.toLowerCase()) &&
                  //       filteredSections[keyword.toLowerCase()] != null)
                  //     CategorySection(
                  //       title: keyword,
                  //       items: filteredSections[keyword.toLowerCase()]!,
                  //     )
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

  // Function to get the nearby food
  void fetchNearbyFood() async {
    setState(() => isLoadingNearby = true); // Set loading state to true

    // Fetch for nearby food
    final results = await fetchFoodByKeywordList(['food']);

    // Update the state with the results
    setState(() {
      nearbyRestaurants = results;
      isLoadingNearby = false;
    });
  }

  // Function update filtered sections
  void fetchAndUpdateRestaurants() async {
    setState(() => isLoadingFilters = true);

    // Loops through the selected filters and fetches the results
    for (String keyword in List.from(selectedFilters)) {
      final key = keyword.toLowerCase();  // Makes sure the keyword matches with one of the categories above

      // Prevent duplicate fetches
      if (filteredSections.containsKey(key)) continue;

      try {
        // Fetch the results for the keyword
        final results = await fetchFoodByKeywordList([key]);

        // Update the state with the results
        setState(() {
          filteredSections[key] = results;
        });
      } catch (e) {
        print("❌ Failed to fetch results for $key: $e");
      }
    }

    // Set loading state to false
    setState(() => isLoadingFilters = false);
  }

} // end HomeScreenState


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
