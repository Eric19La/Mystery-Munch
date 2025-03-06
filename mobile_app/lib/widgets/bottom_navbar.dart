import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onPageSelected;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 14),
        ),
      ),
      child: NavigationBar(
        backgroundColor: Colors.amber[20],
        selectedIndex: selectedIndex,
        onDestinationSelected: onPageSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_sharp), label: "Explore"),
          NavigationDestination(icon: Icon(Icons.map_sharp), label: "Map"),
          NavigationDestination(icon: Icon(Icons.settings_applications_sharp), label: "Settings"),
        ],
      )
    );
  }

} // end BottomNavBar