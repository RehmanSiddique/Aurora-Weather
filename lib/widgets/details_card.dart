// lib/widgets/details_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../models/settings_model.dart'; // 1. Import settings model

class DetailsCard extends StatelessWidget {
  final CurrentWeather current;
  final AppSettings settings; // 2. Add settings property

  const DetailsCard({
    super.key,
    required this.current,
    required this.settings, // 3. Make it required
  });

  @override
  Widget build(BuildContext context) {
    // 4. Determine the correct wind speed unit and symbol
    final windUnitSymbol = settings.windSpeedUnit == WindSpeedUnit.ms ? 'm/s' : 'mph';
    // The API automatically provides wind speed in the correct unit (m/s for metric, mph for imperial)
    final windSpeedValue = current.windSpeed.toStringAsFixed(1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 5. Update the DetailItem to use the dynamic value and symbol
              _DetailItem(icon: Icons.air_outlined, title: 'Wind', value: '$windSpeedValue $windUnitSymbol'),
              _DetailItem(icon: Icons.water_drop_outlined, title: 'Humidity', value: '${current.humidity}%'),
              _DetailItem(icon: Icons.wb_sunny_outlined, title: 'Sunrise', value: DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(current.sunrise * 1000))),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _DetailItem({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 30),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}