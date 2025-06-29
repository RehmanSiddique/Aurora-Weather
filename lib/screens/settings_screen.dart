// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/settings_model.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the settings provider to get the current state
    final settings = ref.watch(settingsProvider);
    // Get a reference to the notifier to call its methods
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xff2E225B), // Matching our theme
      ),
      backgroundColor: const Color(0xff1A223B), // Matching our theme
      body: ListView(
        children: [
          // Temperature Unit Setting
          SwitchListTile(
            title: Text('Temperature Unit', style: GoogleFonts.poppins(color: Colors.white)),
            subtitle: Text(
              settings.temperatureUnit == TemperatureUnit.celsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            value: settings.temperatureUnit == TemperatureUnit.fahrenheit,
            onChanged: (isFahrenheit) {
              final newUnit = isFahrenheit ? TemperatureUnit.fahrenheit : TemperatureUnit.celsius;
              settingsNotifier.setTemperatureUnit(newUnit);
            },
            secondary: const Icon(Icons.thermostat, color: Colors.white70),
            activeColor: const Color(0xff8A49F7), // Purple accent color
          ),

          const Divider(color: Colors.white24),

          // Wind Speed Unit Setting
          SwitchListTile(
            title: Text('Wind Speed Unit', style: GoogleFonts.poppins(color: Colors.white)),
            subtitle: Text(
              settings.windSpeedUnit == WindSpeedUnit.ms ? 'Meters per second (m/s)' : 'Miles per hour (mph)',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            value: settings.windSpeedUnit == WindSpeedUnit.mph,
            onChanged: (isMph) {
              final newUnit = isMph ? WindSpeedUnit.mph : WindSpeedUnit.ms;
              settingsNotifier.setWindSpeedUnit(newUnit);
            },
            secondary: const Icon(Icons.air, color: Colors.white70),
            activeColor: const Color(0xff8A49F7),
          ),
        ],
      ),
    );
  }
}