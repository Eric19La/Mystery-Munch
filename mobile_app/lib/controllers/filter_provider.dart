import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  List<String> _selectedFilters = []; // List of selected filters

  // Getters for the selected filters
  List<String> get selectedFilters => _selectedFilters;

  // Function to toggle the selected filters
  void toggleFilter(String filter) {
    filter = filter.toLowerCase();
    if (_selectedFilters.contains(filter)) {
      _selectedFilters.remove(filter);
    } else {
      _selectedFilters.add(filter);
    }
    notifyListeners();
  }

  // Function to set the selected filters
  void setFilters(List<String> filters) {
    _selectedFilters = filters.map((f) => f.toLowerCase()).toList();
    notifyListeners();
  }

  // Function to clear the selected filters
  void clearFilters() {
    _selectedFilters.clear();
    notifyListeners();
  }

}
