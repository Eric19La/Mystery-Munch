import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/filter_controller.dart';
import 'category_section.dart';
import 'category_icon.dart';

class BottomSheetList extends StatefulWidget {
  final List<Map<String, dynamic>> restaurant;
  final ScrollController scrollController;

  const BottomSheetList({
    super.key,
    required this.restaurant,
    required this.scrollController,
  });

  @override
  State<BottomSheetList> createState() => _BottomSheetListState();
}

class _BottomSheetListState extends State<BottomSheetList> {
  late List<Map<String, dynamic>> _shuffledRestaurants;

  // List of categories the user is able to select
  final categories = [
    {"icon": Icons.restaurant_menu, "label": "Grub", "value": "restaurants"},
    {"icon": Icons.fastfood, "label": "Fast Food", "value": "fast food"},
    {"icon": Icons.cake, "label": "Desserts", "value": "desserts"},
    {"icon": Icons.coffee, "label": "Coffee", "value": "coffee"},
    {"icon": Icons.circle_outlined, "label": "Boba", "value": "milk tea"},
    {"icon": Icons.soup_kitchen, "label": "Soup", "value": "soup"},
    {"icon": Icons.local_pizza, "label": "Pizza", "value": "pizza"},
    {
      "icon": Icons.egg_rounded,
      "label": "Breakfast",
      "value": "breakfast food",
    },
    {
      "icon": Icons.rice_bowl_sharp,
      "label": "Chinese",
      "value": "chinese food",
    },
    {
      "icon": Icons.ramen_dining_sharp,
      "label": "Japanese",
      "value": "japanese food",
    },
    {
      "icon": Icons.local_fire_department_sharp,
      "label": "Mexican",
      "value": "mexican food",
    },
    {
      "icon": Icons.room_service_sharp,
      "label": "Italian",
      "value": "italian food",
    },
    {"icon": Icons.liquor_sharp, "label": "Drinks", "value": "drinks"},
    {"icon": Icons.forest_sharp, "label": "Healthy", "value": "salad"},
  ];

  @override
  void initState() {
    super.initState();
    _shuffledRestaurants = List.from(widget.restaurant);
  }

  void _filterRestaurants() {
    final filterController = Provider.of<FilterController>(
      context,
      listen: false,
    );
    if (filterController.selectedFilters.isEmpty) {
      setState(() {
        _shuffledRestaurants = List.from(widget.restaurant);
      });
      return;
    }

    setState(() {
      _shuffledRestaurants =
          widget.restaurant.where((restaurant) {
            final restaurantName = restaurant['title'].toString().toLowerCase();
            return filterController.selectedFilters.any(
              (filter) => restaurantName.contains(filter),
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Nearby Restaurants",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),

              // Category Filter Section
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children:
                      categories.map((category) {
                        final label =
                            category['label'] as String? ?? 'No label';
                        final value =
                            category['value'] as String? ?? 'No value';
                        final filterController = Provider.of<FilterController>(
                          context,
                        );
                        final isSelected = filterController.selectedFilters
                            .contains(value.toLowerCase());

                        return CategoryIcon(
                          category['icon'] as IconData,
                          label,
                          selected: isSelected,
                          onTap: () {
                            filterController.toggleFilter(value);
                            _filterRestaurants();
                          },
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Restaurant List
              Column(
                children:
                    _shuffledRestaurants.asMap().entries.map((entry) {
                      final restaurantData = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: buildLargeCategoryCard(restaurantData, true),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 20),

              // Randomize Feature
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      onPressed: _randomizeRestaurant,
                      icon: const Icon(Icons.shuffle_on_rounded),
                      label: const Text(
                        "Randomize",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
