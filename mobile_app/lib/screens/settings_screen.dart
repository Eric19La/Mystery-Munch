import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        // elevation: 0,
        // toolbarHeight: 40,
      ),
      body: ListView(
        children: const [
          SectionHeader(title: "Profile Info"),
          ListTile(leading: Icon(Icons.person), title: Text("Edit Profile")),
          Divider(),
        ],
      ),

      // Nav Bar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onPageSelected: (index) => selectedPage(context, index),
      ),
    );
  }
}


class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}