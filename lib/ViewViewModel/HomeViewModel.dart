import 'package:flutter/material.dart';
import 'package:weatherapp/Model/GeocodingModel.dart';
import 'package:weatherapp/Repository/Geocoding.dart';

class HomeViewModel extends ChangeNotifier {
  List<LocationModel> _locations = [];
  bool _isLoading = false;

  List<LocationModel> get locations => _locations;
  bool get isLoading => _isLoading;

  Future<void> fetchLocations(String query) async {
    print('object'+query);
    _isLoading = true;
    notifyListeners();
    try {
      _locations = await LocationService().fetchLocations(query);
      print(_locations);
    } catch (e) {
      // Handle error as needed
      _locations = [];
      print('Error fetching locations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
