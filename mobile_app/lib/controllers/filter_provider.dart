import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  List<String> _selectedFilters = [];

  List<String> get selectedFilters => _selectedFilters;

  void toggleFilter(String filter) {
    filter = filter.toLowerCase();
    if (_selectedFilters.contains(filter)) {
      _selectedFilters.remove(filter);
    } else {
      _selectedFilters.add(filter);
    }
    notifyListeners();
  }

  void setFilters(List<String> filters) {
    _selectedFilters = filters.map((f) => f.toLowerCase()).toList();
    notifyListeners();
  }
}
