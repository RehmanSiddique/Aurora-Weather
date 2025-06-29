// lib/widgets/summary_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weather_model.dart';

class SummaryView extends StatelessWidget {
  final Weather weather;
  final bool isDayTime;
  const SummaryView({
    super.key,
    required this.weather,
    required this.isDayTime,
  });

  // This is the core logic for generating the descriptive summary.
  String getWeatherSummary() {
    final current = weather.current;
    final condition = current.condition.toLowerCase();
    final temp = current.temperature.round();

    // Prioritize severe weather first
    if (condition.contains('thunder') || condition.contains('storm')) {
      return "Thunderstorms expected. Stay safe indoors!";
    }
    if (condition.contains('rain')) {
      if (temp < 10) {
        return "A cold, rainy day. Best to stay warm and dry.";
      }
      return "Expect rain today. Don't forget your umbrella!";
    }
    if (condition.contains('snow')) {
      return "Snowfall expected. Drive carefully and bundle up!";
    }

    // Check for temperature extremes
    if (temp > 35) {
      return "It's a very hot day. Stay hydrated!";
    }
    if (temp < 5) {
      return "Brr, it's quite cold out there. Wear warm clothes.";
    }

    // General day/night conditions
    if (isDayTime) {
      if (condition.contains('clear')) {
        return "A beautiful, sunny day. Perfect for outdoor activities.";
      }
      if (condition.contains('cloud')) {
        return "A pleasant day with some cloud cover.";
      }
    } else { // Nighttime
      if (condition.contains('clear')) {
        return "A clear and peaceful night ahead.";
      }
      if (condition.contains('cloud')) {
        return "A calm night with some clouds in the sky.";
      }
    }

    // A final, safe fallback message
    return "Enjoy the weather!";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getWeatherSummary(),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.w400,
        height: 1.4, // A bit of extra line spacing for readability
      ),
    );
  }
}