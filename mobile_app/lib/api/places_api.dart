import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// Temp API Key
const String googlePlacesApiKey = 'AIzaSyDVo8s1pwsKtLGutO4L-yHA1yiMXLnPZ4E';

// Async Function that returns the current location
Future<Position> getCurrentLocation() async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check and request permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permission is permanently denied.');
  }

  // Get the current position
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

// Async Function that returns a list of restaurants with the title, description, and image
Future<List<Map<String, dynamic>>> fetchFoodByKeyword(String keyword, {int limit = 5}) async {
  final position = await getCurrentLocation();
  final latitude = position.latitude;
  final longitude = position.longitude;

  // Hardcoded location (SG)
  // final latitude = 34.0961;
  // final longitude = -118.1058;

  // Builds a URL to query the Google Places API with Location, Radius, Type, and Keyword
  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$latitude,$longitude'
      '&radius=3000'
      '&type=restaurant'
      '&keyword=${Uri.encodeComponent(keyword)}'
      '&key=$googlePlacesApiKey';

  // Sends a GET request to the URL and waits for the response
  final response = await http.get(Uri.parse(url));

  // Check the response status
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body); // Decode the JSON response
    final results = data['results'];
    print("✅ API Response: ${results.length} results for '$keyword'");

    try {
      // For each place we extract the name, description, and image URL to convert to a list
      return results
        .take(limit)  // Limit to first 5 search results
        .map<Map<String, dynamic>>((place) {
        String imageUrl;

        // If the place has an image, use it, otherwise use a placeholder
        if (place['photos'] != null && place['photos'].isNotEmpty) {
          final photoRef = place['photos'][0]['photo_reference'];
          imageUrl = 'https://maps.googleapis.com/maps/api/place/photo'
              '?maxwidth=400'
              '&photoreference=$photoRef'
              '&key=$googlePlacesApiKey';
        } else {
          imageUrl = 'https://via.placeholder.com/400x200.png?text=No+Image';
        }

        return {
          'title': place['name'] ?? 'No name',
          // 'description': 'View >',
          'image': imageUrl,
        };
      }).toList();
    } catch (e) {
      // print('🔥 Error parsing results: $e');
      throw Exception('Failed to parse $keyword data');
    }
  } else {
    // print("❌ API call failed with status: ${response.statusCode}");
    // print("❌ Response body: ${response.body}");
    throw Exception('Failed to load $keyword data');
  }
}

Future<List<Map<String, dynamic>>> fetchNearbyRestaurants({int limit = 5}) async {
  final position = await getCurrentLocation();
  final latitude = position.latitude;
  final longitude = position.longitude;

  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$latitude,$longitude'
      '&radius=3000'
      '&type=restaurant'
      '&key=$googlePlacesApiKey';

  final response = await http.get(Uri.parse(url));
  final data = json.decode(response.body);

  List<Map<String, dynamic>> places = [];

  for (var place in data['results']) {
    if (places.length >= limit) break;

    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];

    final distanceInMeters = Geolocator.distanceBetween(
      latitude, longitude, lat, lng,
    );

    String imageUrl;
    if (place['photos'] != null && place['photos'].isNotEmpty) {
      final photoRef = place['photos'][0]['photo_reference'];
      imageUrl =
      'https://maps.googleapis.com/maps/api/place/photo'
          '?maxwidth=400'
          '&photoreference=$photoRef'
          '&key=$googlePlacesApiKey';
    } else {
      imageUrl = 'https://via.placeholder.com/400x200.png?text=No+Image';
    }

    places.add({
      'title': place['name'] ?? 'No name',
      'lat': lat,
      'lng': lng,
      'distance': distanceInMeters,
      'image': imageUrl,
    });
  }

  // Sort by distance before returning
  places.sort((a, b) => a['distance'].compareTo(b['distance']));

  return places;
}



