import 'package:flutter/material.dart';
import 'category_icon.dart';

// Widget for the search bar input with optional trailing clear icon
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller; // Controls the search text field
  final void Function(String query) onSearch; // Called on text submit
  final bool showClearIcon; // Controls visibility of clear icon
  final VoidCallback? onClear; // Action when the clear icon is tapped

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.showClearIcon = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // TextField takes most of the space
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSearch,
              decoration: InputDecoration(
                hintText: "Search for food...",
                prefixIcon: const Icon(Icons.search, color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.amber[100],
              ),
            ),
          ),

          // Show clear icon if applicable
          if (showClearIcon && onClear != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: buildCompactCategoryIcon(
                icon: Icons.clear,
                onTap: onClear!,
              ),
            ),
        ],
      ),
    );
  }
}
