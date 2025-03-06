import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map")),
      body: Center(
        child: Text("This is the map screen"),
      ),

      // Nav Bar Section
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
        onPageSelected: (index) => selectedPage(context, index),
      ),
    );
  }
} // end MapScreen