import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'WeatherScreen.dart';

/// The initial screen of the app to handle navigation based on user preferences.
class InitialScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const InitialScreen({super.key, required this.prefs});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 1), () {
      _navigateBasedOnLastSearchedCity();
    });
  }

  /// Navigates to the appropriate screen based on the last searched city.
  _navigateBasedOnLastSearchedCity() {
    try {
      String? lastSearchedCity = widget.prefs.getString('lastSearchedCity');
      double? lastLatitude = widget.prefs.getDouble('savedLatitude');
      double? lastLongitude = widget.prefs.getDouble('savedLongitude');

      // Navigate to the WeatherScreen if last searched city data exists
      if (lastSearchedCity != null &&
          lastLatitude != null &&
          lastLongitude != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherScreen(
              latitude: lastLatitude,
              longitude: lastLongitude,
            ),
          ),
        );
      } else {
        // Navigate to the HomeScreen if no last searched city data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      // Error handling: navigate to HomeScreen in case of any exception
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: const Color(0xFF2D2E3A),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white,),
      ),
    );
  }
}
