import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/screens/sign_in_screen.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 12), // Adjust spacing here
            Text(
              "Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),

      // Body Section
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Sections
          SectionHeader(title: "Profile Info"),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()), // Ensure it's properly structured
              );
            },
          ),
          Divider(),

          SectionHeader(title: "Bookmarks"),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text("Saved Restaurants"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()), // Ensure it's properly structured
              );
            },
          ),
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

} // end SettingsScreen

// Returns a widget for the section header
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
} // end SectionHeader