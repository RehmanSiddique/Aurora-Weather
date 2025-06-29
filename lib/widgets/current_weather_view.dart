// lib/widgets/current_weather_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../models/settings_model.dart'; // 1. Import settings model

class CurrentWeatherView extends StatelessWidget {
  final Weather weather;
  final bool isDayTime;
  final AppSettings settings; // 2. Add settings property

  const CurrentWeatherView({
    super.key,
    required this.weather,
    required this.isDayTime,
    required this.settings, // 3. Make it required
  });

  // ... (getLottieAnimation function is unchanged) ...
  String getLottieAnimation(String? condition, bool isDay) {
    if (condition == null) return isDay ? 'assets/lottie/sunny.json' : 'assets/lottie/night.json';
    if (condition.toLowerCase().contains('clear')) return isDay ? 'assets/lottie/sunny.json' : 'assets/lottie/night.json';
    if (condition.toLowerCase().contains('cloud')) return 'assets/lottie/cloudy.json';
    if (condition.toLowerCase().contains('rain') || condition.toLowerCase().contains('drizzle')) return 'assets/lottie/rainy.json';
    if (condition.toLowerCase().contains('thunder') || condition.toLowerCase().contains('storm')) return 'assets/lottie/stormy.json';
    if (condition.toLowerCase().contains('snow')) return 'assets/lottie/snowy.json';
    return 'assets/lottie/cloudy.json';
  }

  @override
  Widget build(BuildContext context) {
    final animationPath = getLottieAnimation(weather.current.condition, isDayTime);
    // 4. Determine the correct temperature symbol
    final tempSymbol = settings.temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Lottie.asset(
              animationPath,
              key: ValueKey<String>(animationPath),
            ),
          ),
        ),
        Text(
          // 5. Append the symbol to the temperature display
          '${weather.current.temperature.round()}$tempSymbol',
          style: GoogleFonts.poppins(
            fontSize: 96,
            color: Colors.white,
            fontWeight: FontWeight.w200,
            height: 1.1,
          ),
        ),
        Text(
          weather.current.description,
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}