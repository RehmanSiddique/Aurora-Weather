// lib/widgets/forecast_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart'; // Ensure Lottie is imported

import '../models/weather_model.dart';
import '../models/settings_model.dart'; // Ensure Settings are imported for unit display

class ForecastView extends StatelessWidget {
  final List<DailyWeather> dailyForecast;
  final AppSettings settings; // This is required for displaying the correct units

  const ForecastView({
    super.key,
    required this.dailyForecast,
    required this.settings, // Make sure it's passed in the constructor
  });

  // Helper function to get the correct Lottie animation path for each forecast day.
  // This logic is robust and handles various conditions.
  String getLottieAnimation(String? condition) {
    if (condition == null) return 'assets/lottie/cloudy.json'; // A safe default

    final lowerCaseCondition = condition.toLowerCase();
    if (lowerCaseCondition.contains('cloud')) return 'assets/lottie/cloudy.json';
    if (lowerCaseCondition.contains('rain') || lowerCaseCondition.contains('drizzle')) return 'assets/lottie/rainy.json';
    if (lowerCaseCondition.contains('thunder') || lowerCaseCondition.contains('storm')) return 'assets/lottie/stormy.json';
    if (lowerCaseCondition.contains('snow')) return 'assets/lottie/snowy.json';
    if (lowerCaseCondition.contains('clear')) return 'assets/lottie/sunny.json';

    // A safe fallback for other conditions like mist, haze, fog, etc.
    return 'assets/lottie/cloudy.json';
  }

  @override
  Widget build(BuildContext context) {
    // This logic ensures the correct temperature symbol is always shown based on user settings.
    final tempSymbol = settings.temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "7-Day Forecast",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailyForecast.length > 7 ? 7 : dailyForecast.length,
          itemBuilder: (context, index) {
            final day = dailyForecast[index];
            final dayOfWeek = DateFormat('EEEE').format(day.date);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // Day of the week
                  Expanded(
                    flex: 3,
                    child: Text(
                      dayOfWeek,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  // The Lottie animation in a fixed-size box to prevent layout errors.
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Lottie.asset(
                      getLottieAnimation(day.condition),
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Max / Min Temperature with the correct unit symbol.
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${day.tempMax.round()}$tempSymbol / ${day.tempMin.round()}$tempSymbol',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}