import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Model/GeocodingModel.dart';
import '../Services/Exceptions.dart';
import '../Services/NetworkServices.dart';

class LocationService {
  static const String _apiKey = '2d4eb6a9c30424daae79b51b5e1db288';
  static const String _baseUrl = 'http://api.openweathermap.org/geo/1.0/direct';
  static const Duration _timeoutDuration = Duration(seconds: 10);

  /// Fetches a list of locations based on the provided city name.
  ///
  /// Throws a [FetchDataException] on network or parsing errors.
  Future<List<LocationModel>> fetchLocations(String city) async {
    try {
      final queryParameters = {'q': city, 'limit': '3', 'appid': _apiKey};
      final uri = Uri.parse(_baseUrl);
      final url = uri.replace(queryParameters: queryParameters);

      final response = await http.get(url).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => LocationModel.fromJson(json)).toList();
      } else {
        throw FetchDataException(
            NetworkServices().handleError(response.statusCode));
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('An unexpected error occurred');
    }
  }
}
