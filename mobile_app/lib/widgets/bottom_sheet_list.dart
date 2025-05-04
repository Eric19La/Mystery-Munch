import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/filter_provider.dart';
import '../widgets/category_constants.dart';
import '../widgets/category_icon.dart';
import 'category_section.dart';

class BottomSheetList extends StatefulWidget {
  final List<Map<String, dynamic>> restaurant;
  final ScrollController scrollController;
  final VoidCallback? onFilterChange;

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
  late List<Map<String, dynamic>> _shuffledRestaurants;

  @override
  void initState() {
    super.initState();
    _shuffledRestaurants = List.from(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
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

              const Center(
                child: Text(
                  "Nearby Restaurants",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
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

  void _randomizeRestaurant() {
    if (_shuffledRestaurants.isEmpty) return;

    final random = _shuffledRestaurants.toList()..shuffle();
    final randomPick = random.first;

    setState(() {
      _shuffledRestaurants = [
        randomPick,
        ..._shuffledRestaurants.where((r) => r['title'] != randomPick['title']),
      ];
    });

    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
