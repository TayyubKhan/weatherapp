import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Model/WeatherModel.dart';
import '../Services/Exceptions.dart';
import '../Services/NetworkServices.dart';

class WeatherService {
  static const String _apiKey = '2d4eb6a9c30424daae79b51b5e1db288';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  /// Fetches weather data for a specific location based on latitude and longitude.
  ///
  /// Throws a [FetchDataException] on network or parsing errors.
  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    try {
      final queryParameters = {
        'units': 'metric',
        'lat': lat.toString(),
        'lon': lon.toString(),
        'appid': _apiKey,
      };

      final uri = Uri.parse(_baseUrl);
      final url = uri.replace(queryParameters: queryParameters);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw FetchDataException(
          NetworkServices().handleError(response.statusCode),
        );
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('An unexpected error occurred');
    }
  }
}
