import 'package:flutter/material.dart';
import 'package:mobile_app/controllers/nav_controller.dart';
import 'package:mobile_app/screens/sign_in_screen.dart';
import 'package:mobile_app/widgets/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  // Create an instance of the SettingsScreen
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user; // Define the user variable, will store the currently signed-in Firebase user

  @override
  void initState() {
    // Listens for authentication changes (user sign/out)
    super.initState();

    // Firebase reports a new user state, calls setState() to update the user variable and refresh the UI
    FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      setState(() {
        user = newUser; // Ensures the UI is always in sync with Firebase Auth
      });
    });
  }

  // Checks if the user is signed in and returns a welcome message
  String _getWelcomeText() {
    if (user != null && user!.email != null) {
      return "Welcome back, ${user!.email!.split('@')[0]}";
    }

    // If not signed in, return a default message
    return "Settings";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 12), // Adjust spacing here
            Text(
              _getWelcomeText(),
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