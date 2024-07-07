import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/View/WeatherScreen.dart';
import '../Repository/Geocoding.dart';
import '../ViewViewModel/HomeViewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late SharedPreferences _prefs;
  String _lastSearchedCity = '';
  double _savedLatitude = 0.0;
  double _savedLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  /// Initializes shared preferences and loads last searched city and location.
  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadLastSearchedCity();
    _loadSavedLocation();
  }

  /// Loads the last searched city from shared preferences.
  void _loadLastSearchedCity() {
    setState(() {
      _lastSearchedCity = _prefs.getString('lastSearchedCity') ?? '';
      _controller.text = _lastSearchedCity;
    });
  }

  /// Saves the last searched city to shared preferences.
  Future<void> _saveLastSearchedCity(String city) async {
    setState(() {
      _lastSearchedCity = city;
    });
    await _prefs.setString('lastSearchedCity', city);
  }

  /// Loads the saved location (latitude and longitude) from shared preferences.
  void _loadSavedLocation() {
    setState(() {
      _savedLatitude = _prefs.getDouble('savedLatitude') ?? 0.0;
      _savedLongitude = _prefs.getDouble('savedLongitude') ?? 0.0;
    });
  }

  /// Saves the location (latitude and longitude) to shared preferences.
  Future<void> _saveLocation(double latitude, double longitude) async {
    setState(() {
      _savedLatitude = latitude;
      _savedLongitude = longitude;
    });
    await _prefs.setDouble('savedLatitude', latitude);
    await _prefs.setDouble('savedLongitude', longitude);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final bool showSavedLocation =
        _lastSearchedCity.isNotEmpty && homeViewModel.locations.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF2D2E3A),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weather',
                    style: TextStyle(color: Colors.white, fontSize: 38),
                  ),
                  Gap(constraints.maxHeight * 0.01),
                  _buildSearchField(homeViewModel),
                  homeViewModel.isLoading
                      ? const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _buildLocationList(homeViewModel, showSavedLocation),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the search field for city search.
  Widget _buildSearchField(HomeViewModel homeViewModel) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          CupertinoIcons.search,
          color: Colors.white30,
        ),
        hintText: 'Search for City',
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 20),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white.withOpacity(0.10),
      ),
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          homeViewModel.fetchLocations(value);
        }
      },
    );
  }

  /// Builds the list of locations or saved location tile based on the search result.
  Widget _buildLocationList(
      HomeViewModel homeViewModel, bool showSavedLocation) {
    return showSavedLocation
        ? _buildSavedLocationTile()
        : _buildSearchResultsList(homeViewModel);
  }

  /// Builds a tile for the saved location.
  Widget _buildSavedLocationTile() {
    return Expanded(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeatherScreen(
                latitude: _savedLatitude,
                longitude: _savedLongitude,
              ),
            ),
          );
        },
        title: Text(
          _lastSearchedCity,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          'Last Searched City',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  /// Builds a list of search results.
  Widget _buildSearchResultsList(HomeViewModel homeViewModel) {
    return homeViewModel.locations.isEmpty
        ? const SizedBox()
        : Expanded(
            child: ListView.builder(
              itemCount: homeViewModel.locations.length,
              itemBuilder: (context, index) {
                final location = homeViewModel.locations[index];
                return ListTile(
                  onTap: () {
                    _saveLastSearchedCity(_controller.text.toString());
                    _saveLocation(location.lat, location.lon);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherScreen(
                          latitude: location.lat,
                          longitude: location.lon,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    location.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Country: ${location.country}, State: ${location.state}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
          );
  }
}
