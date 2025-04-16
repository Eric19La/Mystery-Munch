import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../api/places_api.dart';
import '../controllers/nav_controller.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/bottom_sheet_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _currentLocation;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _restaurantList = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),

      // Body Section
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
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

  void _initializeMap() async {
    try {
      final position = await getCurrentLocation();
      _currentLocation = LatLng(position.latitude, position.longitude);

      final places = await fetchNearbyRestaurants(limit: 5);
      _restaurantList = places;

      Set<Marker> newMarkers = places.map((place) {
        return Marker(
          markerId: MarkerId(place['title']),
          position: LatLng(place['lat'], place['lng']),
          infoWindow: InfoWindow(title: place['title']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _showBottomSheet(context, place);
          },
        );
      }).toSet();

      setState(() {
        _markers = newMarkers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing map: $e');
      // You could show a SnackBar or error here
    }
  }

  // Bottom Sheet for Restaurant Info
  void _showBottomSheet(BuildContext context, Map<String, dynamic> selectedRestaurant) {
    final reorderedRestaurants = [
      selectedRestaurant,
      ..._restaurantList.where(
            (r) => r['title'] != selectedRestaurant['title'],
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.45,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          builder: (_, scrollController) {
            return BottomSheetList(
              restaurant: reorderedRestaurants,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }





} // end MapScreenState

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