import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator;

// Future<geolocator.Position> getCurrentLocation() async {
//   bool serviceEnabled = await geolocator.isLocationServiceEnabled();
//   geolocator.LocationPermission permission = await geolocator.checkPermission();
//
//   if (permission == geolocator.LocationPermission.denied) {
//     permission = await geolocator.requestPermission();
//   }
//
//   return await geolocator.getCurrentPosition(
//     desiredAccuracy: geolocator.LocationAccuracy.high,
//   );
// }

// Async Function that returns a list of maps with the title, description, and image
Future<List<Map<String, dynamic>>> fetchFoodByKeyword(String keyword) async {
  // final position = await getCurrentLocation();
  final latitude = 34.0961;
  final longitude = -118.1058;

  final apiKey = 'AIzaSyDVo8s1pwsKtLGutO4L-yHA1yiMXLnPZ4E';

  // Builds a URL to query the Google Places API with Location, Radius, Type, and Keyword
  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${latitude},${longitude}'
      '&radius=3000'
      '&type=restaurant'
      '&keyword=${Uri.encodeComponent(keyword)}'
      '&key=$apiKey';

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
        .take(5)  // Limit to first 5 search results
        .map<Map<String, dynamic>>((place) {
        String imageUrl;

        // If the place has an image, use it, otherwise use a placeholder
        if (place['photos'] != null && place['photos'].isNotEmpty) {
          final photoRef = place['photos'][0]['photo_reference'];
          imageUrl = 'https://maps.googleapis.com/maps/api/place/photo'
              '?maxwidth=400'
              '&photoreference=$photoRef'
              '&key=$apiKey';
        } else {
          imageUrl = 'https://via.placeholder.com/400x200.png?text=No+Image';
        }

        return {
          'title': place['name'] ?? 'No name',
          'description': 'View >',
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
