// lib/screens/weather_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart'; // Import settings to pass them down
import '../models/weather_model.dart';
import '../models/settings_model.dart'; // Import settings model
import '../widgets/current_weather_view.dart';
import '../widgets/details_card.dart';
import '../widgets/forecast_view.dart';
import '../widgets/hourly_forecast_chart.dart';
import '../widgets/summary_view.dart';
import 'settings_screen.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(weatherProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xff2E225B), // Dark purple fallback
        body: weatherData.when(
          data: (weather) => _WeatherSuccessView(weather: weather),
          loading: () => const _LoadingView(),
          error: (err, stack) => const _ErrorView(),
        ),
      ),
    );
  }
}

// Main success view with all features and bug fixes
class _WeatherSuccessView extends ConsumerWidget {
  final Weather weather;
  const _WeatherSuccessView({required this.weather});

  // ... (isDayTime and getWeatherGradient methods are unchanged) ...
  bool _isDayTime(CurrentWeather current) {
    final now = DateTime.now().toUtc();
    final sunrise = DateTime.fromMillisecondsSinceEpoch(current.sunrise * 1000, isUtc: true);
    final sunset = DateTime.fromMillisecondsSinceEpoch(current.sunset * 1000, isUtc: true);
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  List<Color> getWeatherGradient(String? condition, bool isDay) {
    if (condition == null) {
      return isDay ? [const Color(0xff8A49F7), const Color(0xff5D50FE)] : [const Color(0xff2E225B), const Color(0xff4A335E)];
    }
    final lowerCaseCondition = condition.toLowerCase();
    if (isDay) {
      if (lowerCaseCondition.contains('cloud')) return [const Color(0xff9D75DE), const Color(0xff7B85E1)];
      if (lowerCaseCondition.contains('rain') || lowerCaseCondition.contains('drizzle')) return [const Color(0xff5f5f92), const Color(0xff746f9f)];
      if (lowerCaseCondition.contains('thunder') || lowerCaseCondition.contains('storm')) return [const Color(0xff4A335E), const Color(0xff2E225B)];
      return [const Color(0xff8A49F7), const Color(0xff5D50FE)];
    } else {
      if (lowerCaseCondition.contains('rain') || lowerCaseCondition.contains('drizzle') || lowerCaseCondition.contains('thunder')) return [const Color(0xff24213E), const Color(0xff3A3359)];
      return [const Color(0xff2E225B), const Color(0xff4A335E)];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDay = _isDayTime(weather.current);
    final colors = getWeatherGradient(weather.current.condition, isDay);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          ref.invalidate(weatherProvider);
        },
        backgroundColor: Colors.white,
        color: const Color(0xff8A49F7),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            constraints: BoxConstraints(minHeight: screenHeight),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Column(
                    key: ValueKey<String>("${weather.cityName}-${settings.temperatureUnit}-${settings.windSpeedUnit}"),
                    children: [
                      const SizedBox(height: 20),
                      _buildCityName(context, ref, weather.cityName),
                      const SizedBox(height: 20),
                      CurrentWeatherView(weather: weather, isDayTime: isDay, settings: settings),
                      const SizedBox(height: 10),
                      SummaryView(weather: weather, isDayTime: isDay),
                      const SizedBox(height: 20),
                      HourlyForecastChart(hourlyForecast: weather.hourlyForecast, settings: settings),
                      const SizedBox(height: 20),
                      DetailsCard(current: weather.current, settings: settings),
                      const SizedBox(height: 20),
                      ForecastView(dailyForecast: weather.dailyForecast, settings: settings),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ... (The _buildCityName and _showSearchDialog methods remain unchanged) ...
  Widget _buildCityName(BuildContext context, WidgetRef ref, String cityName) {
    return GestureDetector(
      onTap: () => _showSearchDialog(context, ref),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            cityName,
            style: GoogleFonts.poppins(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit_location_alt_outlined, color: Colors.white70, size: 28),
        ],
      ),
    );
  }

  Future<void> _showSearchDialog(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          title: Text('Search City', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: searchController,
            autofocus: true,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: "e.g., London",
              hintStyle: GoogleFonts.poppins(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                HapticFeedback.lightImpact();
                ref.read(cityProvider.notifier).state = value;
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white70)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff8A49F7).withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final value = searchController.text;
                if (value.trim().isNotEmpty) {
                  HapticFeedback.lightImpact();
                  ref.read(cityProvider.notifier).state = value;
                  Navigator.of(context).pop();
                }
              },
              child: Text('Search', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
// Loading and Error Views remain unchanged
class _LoadingView extends StatelessWidget {
  const _LoadingView();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2E225B), Color(0xff4A335E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(weatherProvider).error;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff6e3a3a), Color(0xff953838)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "An error occurred:\n${error.toString()}",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xff6e3a3a),
              ),
              onPressed: () => ref.invalidate(weatherProvider),
              child: Text('Try Again', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}