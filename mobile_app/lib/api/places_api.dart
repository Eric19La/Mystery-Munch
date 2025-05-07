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
Future<List<Map<String, dynamic>>> fetchFoodByKeywordList(List<String> keywords, {int limit = 2}) async {
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
          final lat = place['geometry']?['location']?['lat']; // Pulls latitude/longitude from the result
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
            'rating': (place['rating'] ?? 0).toDouble(),
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

// Async Function that returns a list of restaurants with the title, description, and image used for Searching
Future<List<Map<String, dynamic>>> fetchPlacesByTextSearch(String query, {int limit = 3}) async {
  final position = await getCurrentLocation(); // for distance calculation

  // Extract the latitude and longitude
  final latitude = position.latitude;
  final longitude = position.longitude;

  // Builds a URL to query the Google Places API through the search results (query)
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/place/textsearch/json'
        '?query=${Uri.encodeComponent(query)}'
        '&type=restaurant'
        '&radius=3000'
        '&key=$googlePlacesApiKey',
  );

  // Sends a GET request to the URL and waits for the response
  final response = await http.get(url);

  // Check the response status
  if (response.statusCode != 200) {
    throw Exception('❌ Network error: ${response.statusCode}');
  }

  final data = jsonDecode(response.body); // Decode the JSON response
  final status = data['status'];  // Get the status from the response

  // Handle different status codes
  switch (status) {
    case 'OK':
      final List results = data['results']; // Pulls the results from the response

      // Loop through the results and extract the name, description, location, and image
      return results.take(limit).map<Map<String, dynamic>>((place) {
        final lat = place['geometry']?['location']?['lat'];
        final lng = place['geometry']?['location']?['lng'];

        // Distance calc if lat/lng exists
        final distanceInMeters = (lat != null && lng != null)
            ? Geolocator.distanceBetween(latitude, longitude, lat, lng)
            : 999999.0;

        // Image logic
        String imageUrl = 'https://via.placeholder.com/400';
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
          'address': place['formatted_address'] ?? 'No address',
          'lat': lat ?? 0.0,
          'lng': lng ?? 0.0,
          'rating': (place['rating'] ?? 0).toDouble(),
          'image': imageUrl,
          'distance': distanceInMeters,
          'placeId': place['place_id'] ?? '',
        };
      }).toList();

    // Return an empty list if no results are found
    case 'ZERO_RESULTS':
      return [];

    // Throw exceptions for other status codes
    case 'OVER_QUERY_LIMIT':
      throw Exception('🚫 You’ve exceeded your quota for the Places API.');

    case 'REQUEST_DENIED':
      throw Exception('🔒 API request was denied. Check your API key and permissions.');

    case 'INVALID_REQUEST':
      throw Exception('⚠️ Invalid request. Make sure your query string is valid.');

    default:
      throw Exception('❓ Unknown error from Places API: $status');
  }
}
