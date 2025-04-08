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


Future<List<Map<String, dynamic>>> fetchFoodByKeyword(String keyword) async {
  // final position = await getCurrentLocation();
  final latitude = 34.0961;
  final longitude = -118.1058;

  final apiKey = 'AIzaSyDVo8s1pwsKtLGutO4L-yHA1yiMXLnPZ4E';

  final url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=${latitude},${longitude}'
      '&radius=5000'
      '&type=restaurant'
      '&keyword=${Uri.encodeComponent(keyword)}'
      '&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'];
    print("✅ API Response: ${results.length} results for '$keyword'");

    try {
      return results.map<Map<String, dynamic>>((place) {
        String imageUrl;
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
      print('🔥 Error parsing results: $e');
      throw Exception('Failed to parse $keyword data');
    }
  } else {
    print("❌ API call failed with status: ${response.statusCode}");
    print("❌ Response body: ${response.body}");
    throw Exception('Failed to load $keyword data');
  }
}
