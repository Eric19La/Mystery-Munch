import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'category_icon.dart';

class RestaurantPopup extends StatelessWidget {
  final String title; // Name of the restaurant
  final String imageUrl;  // Image of the restaurant
  final double distance;  // Distance from the user
  final double? rating; // Rating of the restaurant

  // Location of the restaurant
  final double lat; // Latitude of the restaurant
  final double lng; // Longitude of the restaurant

  const RestaurantPopup({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.distance,
    this.rating,
    required this.lat,
    required this.lng,
  });

  // Open Google Maps with the restaurant's location
  void _openMaps() async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top: Title + Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                buildCompactCategoryIcon(
                  icon: Icons.close_outlined,
                  onTap: () => Navigator.pop(context)
                )
              ],
            ),
            const SizedBox(height: 10),

            // Restaurant Image Card for the Popup (Rating + Distance)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      ),
                    ),
                  ),

                  // Rating + Distance Section
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ratings Text
                        if (rating != null)
                          Row(
                            children: [
                              const Icon(Icons.star_half_sharp, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                rating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                        // Distance Text
                        Text(
                          '${distance.toStringAsFixed(0)} meters away',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Get Directions Button
            ElevatedButton.icon(
              icon: const Icon(Icons.directions),
              label: Text(
                'Get Directions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _openMaps,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
