import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/nav_controller.dart';
import '../controllers/filter_provider.dart';
import '../widgets/bottom_navbar.dart';
import '../api/places_api.dart';
import '../widgets/category_icon.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_section.dart';
import '../widgets/category_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Create an instance
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> nearbyRestaurants = [];  // List of nearby restaurants
  Map<String, List<Map<String, dynamic>>> filteredSections = {};  // Map of filtered sections
  bool isLoadingNearby = false; // Loading state for nearby restaurants
  bool isLoadingFilters = false;  // Loading state for filtered sections

  @override
  void initState() {
    super.initState();
    fetchNearbyFood();  // Fetch nearby restaurants on initialization

    // Call after build so context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAndUpdateRestaurants(context); // Fetch and update filtered sections on initialization
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    final selectedFilters = filterProvider.selectedFilters;

    return Scaffold(
      // Header Section
      appBar: AppBar(elevation: 0, toolbarHeight: 10),

      // Body Section
      body: Column(
        children: [
          // Search Bar Section
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchBarWidget(),
          ),
          const SizedBox(height: 20),

          // Category Filter Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Category Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Only show the clear icon if filters are selected
                        if (selectedFilters.isNotEmpty)
                          CategoryIcon(
                            kClearCategory['icon'] as IconData,
                            kClearCategory['label'] as String,
                            selected: false,  // Lets the clear icon be selected
                            // Clear the filters
                            onTap: () {
                              filterProvider.clearFilters();
                              fetchAndUpdateRestaurants(context);
                            },
                          ),

                        // Build the list of categories
                        ...kFoodCategories
                            .where((c) => c['value'] != 'clear_filters') // don't show it twice
                            .map((category) {
                          final label = category['label'] as String;
                          final value = category['value'] as String;
                          final isSelected = selectedFilters.contains(value.toLowerCase());

                          // Build the category icon
                          return CategoryIcon(
                            category['icon'] as IconData,
                            label,
                            selected: isSelected,
                            // Changes the color to dark orange letting the user know it's selected
                            onTap: () {
                              filterProvider.toggleFilter(value);
                              fetchAndUpdateRestaurants(context);
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Always show nearby food
                  isLoadingNearby
                      ? const Center(child: CircularProgressIndicator())
                      : CategorySection(title: "Food Nearby", items: nearbyRestaurants),

                  const SizedBox(height: 20),

                  // Filtered Sections — make sure data exists before showing
                  isLoadingFilters
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (String keyword in selectedFilters)
                        if (filteredSections.containsKey(keyword))
                          CategorySection(
                            title: toTitleCase(keyword),
                            items: filteredSections[keyword]!,
                          ),
                    ],
                  ),
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
  void fetchAndUpdateRestaurants(BuildContext context) async {
    setState(() => isLoadingFilters = true);

    final selectedFilters = Provider.of<FilterProvider>(context, listen: false).selectedFilters;

    // Loops through the selected filters and fetches the results
    for (String keyword in List.from(selectedFilters)) {
      // Makes sure the keyword matches with one of the categories above
      final key = keyword.toLowerCase();

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

  // Help function that converts a string to title case
  String toTitleCase(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
} // end HomeScreenState
