import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_app/widgets/bottom_sheet_list.dart';
import '../widgets/search_bar.dart';
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
          const SearchBarWidget(),
          const SizedBox(height: 5),
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
                      onTap: () => _showBottomSheet(context, fastFood),
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
  void _showBottomSheet(BuildContext context, List<Map<String, String>> fastFood) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BottomSheetList(
          scrollController: ScrollController(),
          fastFood: fastFood
        );
      }
    );
  } // end _showBottomSheet

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