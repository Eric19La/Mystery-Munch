import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../api/places_api.dart';
import '../controllers/nav_controller.dart';
import '../controllers/filter_provider.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/bottom_sheet_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isLoading = true; // Loading state

  late LatLng _currentLocation; // Location of the user
  Set<Marker> _markers = {}; // List of markers
  GoogleMapController? _mapController; // Controller for the map
  List<Map<String, dynamic>> _restaurantList = []; // List of restaurants

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 10),

      // Body Section
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 13,
            ),
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ],
      ),

      // Bottom NavBar Section
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onPageSelected: (index) => selectedPage(context, index),
      ),
    );
  }

  // Function to initialize the map
  void _initializeMap() async {
    try {
      // Gets the user's current location and saves it into _currentLocation
      final position = await getCurrentLocation();
      _currentLocation = LatLng(position.latitude, position.longitude);

      final filters = Provider.of<FilterProvider>(context, listen: false).selectedFilters;

      // Fetch nearby restaurants (For testing purposes use 5 we can change this num in the future)
      final places = await fetchFoodByKeywordList(filters.isNotEmpty ? filters : ['food'], limit: 7);
      _restaurantList = places; // Save the fetched restaurants in _restaurantList

      // Create markers for each restaurant by looping through all restaurants
      Set<Marker> newMarkers = places.map((place) {
        return Marker(
          markerId: MarkerId(place['title']),
          position: LatLng(place['lat'], place['lng']),
          infoWindow: InfoWindow(title: place['title']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _showBottomSheet(context, place),
        );
      }).toSet();

      setState(() {
        _markers = newMarkers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing map: $e');
    }
  }

  // Function that takes the selected restaurant and builds the bottom sheet when a marker is tapped
  void _showBottomSheet(BuildContext context, Map<String, dynamic> selectedRestaurant) {
    // Reorder the list to put the selected restaurant at the top
    final reorderedRestaurants = [
      selectedRestaurant,

      // We don't want to include the selected restaurant in the list
      ..._restaurantList.where((r) => r['title'] != selectedRestaurant['title']),
    ];

    // Displays a scrollable bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BottomSheetList(
          restaurant: reorderedRestaurants,
          scrollController: ScrollController(),
          onFilterChange: _initializeMap,
        );
      },
    );
  }
} // end MapScreenState
