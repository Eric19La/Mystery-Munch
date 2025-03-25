import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng _currentLocation = const LatLng(34.0522, -118.2437); // Default: LA
  Set<Marker> _markers = {};

  // 🔥 Hardcoded API Key - Replace with your actual key
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
        title: const Text("Nearby Restaurants"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
