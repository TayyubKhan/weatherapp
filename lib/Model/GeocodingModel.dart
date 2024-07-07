class LocationModel {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String state;

  LocationModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    required this.state,
  });

  factory LocationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const FormatException("Failed to parse JSON");
    }
    return LocationModel(
      name: json['name'] ?? '',
      lat: json['lat'] ?? 0.0,
      lon: json['lon'] ?? 0.0,
      country: json['country'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
