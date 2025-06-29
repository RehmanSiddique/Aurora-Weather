// lib/widgets/hourly_forecast_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../models/settings_model.dart'; // 1. Import the settings model

class HourlyForecastChart extends StatelessWidget {
  final List<HourlyWeather> hourlyForecast;
  final AppSettings settings; // 2. Add settings property

  const HourlyForecastChart({
    super.key,
    required this.hourlyForecast,
    required this.settings, // 3. Make it required in the constructor
  });

  String getLottieForIconCode(String iconCode) {
    if (iconCode.contains('01')) return 'assets/lottie/sunny.json';
    if (iconCode.contains('02') || iconCode.contains('03') || iconCode.contains('04')) return 'assets/lottie/cloudy.json';
    if (iconCode.contains('09') || iconCode.contains('10')) return 'assets/lottie/rainy.json';
    if (iconCode.contains('11')) return 'assets/lottie/stormy.json';
    if (iconCode.contains('13')) return 'assets/lottie/snowy.json';
    return 'assets/lottie/cloudy.json';
  }

  @override
  Widget build(BuildContext context) {
    final chartData = hourlyForecast.take(24).toList();
    final minTemp = chartData.map((e) => e.temperature).reduce((a, b) => a < b ? a : b);
    final maxTemp = chartData.map((e) => e.temperature).reduce((a, b) => a > b ? a : b);

    // 4. Determine the correct temperature symbol from the settings
    final tempSymbol = settings.temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Next 24 Hours",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: Stack(
            children: [
              LineChart(
                LineChartData(
                  minY: minTemp - 2,
                  maxY: maxTemp + 2,
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => const Color(0xff4A335E).withOpacity(0.8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final forecast = chartData[spot.x.toInt()];
                          final time = DateFormat('ha').format(forecast.time);
                          final temp = forecast.temperature.round();
                          // 5. Use the symbol in the interactive tooltip
                          return LineTooltipItem(
                            '$temp$tempSymbol at $time',
                            GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(chartData.length, (index) {
                        return FlSpot(index.toDouble(), chartData[index].temperature);
                      }),
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.white.withOpacity(0.5),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chartData.length,
                itemBuilder: (context, index) {
                  final item = chartData[index];
                  final timeString = DateFormat('ha').format(item.time);
                  final displayTime = index == 0 ? "Now" : timeString;
                  final isNow = index == 0;

                  return Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isNow ? Colors.white.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayTime,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Lottie.asset(getLottieForIconCode(item.iconCode)),
                        ),
                        Text(
                          // 5. Use the symbol in the temperature display
                          '${item.temperature.round()}$tempSymbol',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}