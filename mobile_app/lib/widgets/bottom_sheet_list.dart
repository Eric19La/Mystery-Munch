import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/filter_provider.dart';
import '../widgets/category_constants.dart';
import '../widgets/category_icon.dart';
import 'category_section.dart';

class BottomSheetList extends StatefulWidget {
  final List<Map<String, dynamic>> restaurant;  // List of restaurants to display
  final ScrollController scrollController;  // Controller for the scroll view
  final VoidCallback? onFilterChange; // Callback function to trigger when filters change

  const BottomSheetList({
    super.key,
    required this.restaurant,
    required this.scrollController,
    this.onFilterChange,
  });

  @override
  State<BottomSheetList> createState() => _BottomSheetListState();
}

class _BottomSheetListState extends State<BottomSheetList> {
  late List<Map<String, dynamic>> _shuffledRestaurants; // List of shuffled restaurants

  // Initialize the shuffled restaurants list
  @override
  void initState() {
    super.initState();
    _shuffledRestaurants = List.from(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    // Get the selected filters from the filter provider
    final filterProvider = Provider.of<FilterProvider>(context);
    final selectedFilters = filterProvider.selectedFilters;

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
              const SizedBox(height: 10),

              // Category filter row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: kFoodCategories.map((category) {
                    final label = category['label'] as String;
                    final value = category['value'] as String;
                    final isSelected = selectedFilters.contains(value.toLowerCase());

                    return CategoryIcon(
                      category['icon'] as IconData,
                      label,
                      selected: isSelected,
                      onTap: () {
                        filterProvider.toggleFilter(value);
                        Navigator.pop(context); // re-trigger fetch on map

                        // Let map screen know to refresh markers
                        if (widget.onFilterChange != null) {
                          widget.onFilterChange!();
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 15),

              // Displays each restaurant in the list
              const Center(
                child: Text("Nearby Restaurants", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              ),
              const SizedBox(height: 10),

              Column(
                children: _shuffledRestaurants.map((restaurantData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: buildLargeCategoryCard(restaurantData, true),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Randomize button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: _randomizeRestaurant,
                      icon: const Icon(Icons.shuffle_on_rounded),
                      label: const Text("Randomize", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Function to randomize the restaurant lists
  void _randomizeRestaurant() {
    // If the list is empty, return without doing anything
    if (_shuffledRestaurants.isEmpty) return;

    // Creates a copy of the list and shuffles it
    final random = _shuffledRestaurants.toList()..shuffle();

    // Grabs the first item in the list
    final randomPick = random.first;

    // Displays a pop-up dialog with the random restaurant
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: Title + Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your Mystery Restaurant!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    IconButton(icon: const Icon(Icons.close_outlined), onPressed: () => Navigator.of(context).pop(),),
                  ],
                ),
                const SizedBox(height: 10),

                // The custom card widget (selected restaurant)
                buildLargeCategoryCard(randomPick, true),
              ],
            ),
          ),
        );
      },
    );
  }

} // end BottomSheetList
