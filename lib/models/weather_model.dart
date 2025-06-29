// lib/models/weather_model.dart

class Weather {
  final String cityName;
  final CurrentWeather current;
  final List<HourlyWeather> hourlyForecast; // ADDED: For the chart
  final List<DailyWeather> dailyForecast;

  Weather({
    required this.cityName,
    required this.current,
    required this.hourlyForecast, // ADDED
    required this.dailyForecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json, {required String cityName}) {
    return Weather(
      cityName: cityName,
      current: CurrentWeather.fromJson(json['current']),
      // This maps the 'hourly' list from the JSON into our new HourlyWeather objects
      hourlyForecast: (json['hourly'] as List)
          .map((item) => HourlyWeather.fromJson(item))
          .toList(),
      dailyForecast: (json['daily'] as List)
          .map((item) => DailyWeather.fromJson(item))
          .toList(),
    );
  }
}

// Represents a single item in the 'hourly' forecast list
class HourlyWeather {
  final DateTime time;
  final double temperature;
  final String iconCode; // Using icon code to potentially show different icons

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.iconCode,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['temp'].toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}


// --- CurrentWeather and DailyWeather classes remain unchanged ---
class CurrentWeather {
  final double temperature;
  final String condition;
  final String description;
  final double windSpeed;
  final int humidity;
  final int pressure;
  final int sunrise;
  final int sunset;

  CurrentWeather({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      windSpeed: json['wind_speed'].toDouble(),
      humidity: json['humidity'],
      pressure: json['pressure'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class DailyWeather {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String condition;

  DailyWeather({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['temp']['max'].toDouble(),
      tempMin: json['temp']['min'].toDouble(),
      condition: json['weather'][0]['main'],
    );
  }
}