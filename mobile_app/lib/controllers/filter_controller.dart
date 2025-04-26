import 'package:flutter/foundation.dart';

class FilterController extends ChangeNotifier {
  List<String> _selectedFilters = [];

  List<String> get selectedFilters => _selectedFilters;

  void toggleFilter(String filter) {
    final filterLower = filter.toLowerCase();
    if (_selectedFilters.contains(filterLower)) {
      _selectedFilters.remove(filterLower);
    } else {
      _selectedFilters.add(filterLower);
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedFilters.clear();
    notifyListeners();
  }
}
