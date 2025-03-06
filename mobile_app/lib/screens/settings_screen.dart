import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: Text("This is the settings screen"),
      ),

      // Nav Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onPageSelected: (index) => selectedPage(context, index),
      ),
    );
  }
}