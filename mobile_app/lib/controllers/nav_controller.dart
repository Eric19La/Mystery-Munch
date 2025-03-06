import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/map_screen.dart';
import 'package:mobile_app/screens/settings_screen.dart';

// Function to Navigate to different pages
void selectedPage(BuildContext context, int index) {
  if (index == 0) {
    // Navigate to the Explore Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false, // Clears the stack
    );
  } else if (index == 1) {
    // Navigate to the Explore Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
      (route) => false, // Clears the stack
    );
  } else if (index == 2) {
    // Navigate to the Explore Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
          (route) => false, // Clears the stack
    );
  }
} // end Function selectedPage