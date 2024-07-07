import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weatherapp/Components/screen_size.dart';

import '../Model/WeatherModel.dart';

Widget buildWeatherContent(
    WeatherModel weather, Future<void> Function() refreshWeather) {
  return LayoutBuilder(
    builder: (context, constraints) {
      bool isTablet = constraints.maxWidth >= 600;
      double fontSizeTitle = isTablet ? 60 : 40;
      double fontSizeTemp = isTablet ? 120 : 70;
      double fontSizeDescription = isTablet ? 40 : 20;
      double iconSize = isTablet ? 100 : 50;

      return RefreshIndicator(
        onRefresh: refreshWeather,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Gap(ScreenSize.height * 0.3),
            Center(
              child: Text(
                weather.name.toString(),
                style: TextStyle(color: Colors.white, fontSize: fontSizeTitle),
              ),
            ),
            Center(
              child: Text(
                '${weather.main!.temp!}°',
                style: TextStyle(color: Colors.white, fontSize: fontSizeTemp),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weather.weather![0].main!,
                  style: TextStyle(
                      color: Colors.white, fontSize: fontSizeDescription),
                ),
                Gap(isTablet ? 20 : 10),
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.weather![0].icon}@2x.png',
                  width: iconSize,
                  height: iconSize,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
