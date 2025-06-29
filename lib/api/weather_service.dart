// lib/api/weather_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Import the package
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/settings_model.dart';

class WeatherService {
  // 2. THE FIX: Load the key securely from the environment variables.
  // We provide a fallback string to make debugging easier if the .env file is not loaded correctly.
  static final String _apiKey = dotenv.env['API_KEY'] ?? 'NO_API_KEY_FOUND';

  // This private method gets coordinates for a given city name.
  Future<Map<String, double>> _getCoordinates(String city) async {
    // The _apiKey variable is now used here.
    final geoUrl = 'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=1&appid=$_apiKey';
    final response = await http.get(Uri.parse(geoUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return {
          'lat': data[0]['lat'].toDouble(),
          'lon': data[0]['lon'].toDouble(),
        };
      } else {
        throw Exception('City "$city" not found by Geocoding API.');
      }
    } else {
      throw Exception('Failed to fetch coordinates (Geocoding API). Status Code: ${response.statusCode}');
    }
  }

  // This is the main method that fetches all weather data.
  Future<Weather> fetchWeather(String city, AppSettings settings) async {
    try {
      final coords = await _getCoordinates(city);
      final lat = coords['lat'];
      final lon = coords['lon'];

      final units = settings.temperatureUnit == TemperatureUnit.celsius ? 'metric' : 'imperial';

      // The _apiKey variable is also used here.
      final oneCallUrl = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,alerts&appid=$_apiKey&units=$units';
      final response = await http.get(Uri.parse(oneCallUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data, cityName: city);
      } else {
        throw Exception('Failed to load weather data (One Call API). Status Code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}