import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// API Key from our .env file
String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;

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
Future<List<Map<String, dynamic>>> fetchFoodByKeywordList(
  List<String> keywords, {
  int limit = 1,
}) async {
  final position = await getCurrentLocation(); // Get the current location

  // Extract the latitude and longitude
  final latitude = position.latitude;
  final longitude = position.longitude;

  // Create a list to store all the results
  List<Map<String, dynamic>> allResults = [];

  // Loop through each keyword
  for (String keyword in keywords) {
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
      final results = data['results'] as List;
      // print("✅ API Response: ${results.length} results for '$keyword'");

      // Loop through the results and extract the name, description, location, and image URL
      final filtered =
          results.take(limit).map<Map<String, dynamic>>((place) {
            // User Location
            final lat =
                place['geometry']?['location']?['lat']; // Pulls latitude/longitude from the result
            final lng = place['geometry']?['location']?['lng'];

            // Calculates distance from your current location to the restaurant
            final distanceInMeters = Geolocator.distanceBetween(
              latitude,
              longitude,
              lat ?? 0,
              lng ?? 0,
            );

            // Image Logic
            String imageUrl =
                'https://via.placeholder.com/400'; // If the photo has an image, use it, otherwise use a placeholder

            if (place['photos'] != null && place['photos'].isNotEmpty) {
              final photoRef = place['photos'][0]['photo_reference'];
              imageUrl =
                  'https://maps.googleapis.com/maps/api/place/photo'
                  '?maxwidth=400'
                  '&photoreference=$photoRef'
                  '&key=$googlePlacesApiKey';
            }

            // Return the restaurant data
            return {
              'title': place['name'] ?? 'No name',
              'image': imageUrl,
              'lat': lat,
              'lng': lng,
              'distance': distanceInMeters,
            };
          }).toList();

      // Add the filtered results to the allResults list
      allResults.addAll(filtered);
    }
  }

  // Sort by distance before returning
  allResults.sort((a, b) => a['distance'].compareTo(b['distance']));

  // Return the final list of all results
  return allResults;
}
