import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import '../controllers/nav_controller.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/bottom_sheet_list.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  LatLng _currentLocation = const LatLng(34.0522, -118.2437); // Default Example Location: LA
  Set<Marker> _markers = {};

  // Hardcoded API Key - Replace with your actual key
  final String googleApiKey = 'AIzaSyDVo8s1pwsKtLGutO4L-yHA1yiMXLnPZ4E';
  // String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Get User Location
  bool _hasFetchedPlaces = false;  // Add this to prevent duplicate calls

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return;
      }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      if (!_hasFetchedPlaces) {
        _hasFetchedPlaces = true;
        _fetchNearbyRestaurants();
      }
    } else {
      print("Location permission denied.");
    }
  }


  // Fetch Nearby Restaurants
  Future<void> _fetchNearbyRestaurants() async {
    final places = GoogleMapsPlaces(apiKey: googleApiKey);
    final location = Location(lat: _currentLocation.latitude, lng: _currentLocation.longitude);

    print("Fetching nearby restaurants...");

    final result = await places.searchNearbyWithRadius(location, 1500, type: "restaurant");

    print("API Response Status: ${result.status}");
    print("API Response Error: ${result.errorMessage}");

    if (result.status == "OK") {
      setState(() {
        _markers = result.results.map((place) {
          return Marker(
            markerId: MarkerId(place.placeId!),
            position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.vicinity,
            ),
          );
        }).toSet();
      });

      print("Fetched ${_markers.length} restaurants.");
      for (var marker in _markers) {
        print("Marker: ${marker.infoWindow.title} at ${marker.position}");
      }
    } else {
      print("Error fetching places: ${result.errorMessage}");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 10,
      ),

      // Body Section
      body: Stack(
        children: [
          // Google Map Implementation
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 13,
            ),
            // markers: _markers,
            markers: {
              Marker(
                markerId: const MarkerId('restaurant'),
                position: _currentLocation,
                infoWindow: const InfoWindow(title: 'Restaurant'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                onTap: () {
                  _showBottomSheet(context, fastFood);
                },
              ),
            },
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