import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weatherapp/Model/WeatherModel.dart';
import 'package:weatherapp/View/HomeScreen.dart';
import '../Components/WeatheWidget.dart';
import '../Components/screen_size.dart';
import '../Repository/WeatherRepo.dart';

class WeatherScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherScreen(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherModel> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather();
  }

  /// Fetches weather data based on the provided latitude and longitude.
  Future<WeatherModel> _fetchWeather() {
    return WeatherService().fetchWeather(widget.latitude, widget.longitude);
  }

  /// Refreshes the weather data.
  Future<void> _refreshWeather() async {
    setState(() {
      _weatherFuture = _fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0x0f251e1e),
      body: SafeArea(
        child: FutureBuilder<WeatherModel>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else {
              return buildWeatherContent(snapshot.data!, _refreshWeather);
            }
          },
        ),
      ),
    );
  }

  /// Builds the content of the weather screen based on the fetched weather data.
}
