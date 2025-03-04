import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final IconData icon;  // Stores the icon to be displayed
  final String label;   // Stores the text label

  const CategoryIcon(this.icon, this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column (
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 24,
            child: Icon(icon, color: Colors.black45),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}