import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;  // Icon of the category
  final String label; // Label of the category
  final bool selected;  // Whether the category is selected
  final VoidCallback onTap; // Callback when the category is tapped

  const CategoryIcon(this.icon, this.label, {Key? key, required this.selected, required this.onTap}) : super(key: key);

  // Build the category icon
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: selected ? Colors.orange : Colors.amber,
              radius: 24,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.orange : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}