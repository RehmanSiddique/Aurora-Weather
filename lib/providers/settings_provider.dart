// lib/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';

// The Notifier class holds the logic for changing the state.
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    // When the notifier is created, immediately try to load the saved settings.
    _loadSettings();
  }

  // --- Keys for saving to device storage ---
  static const _tempUnitKey = 'temperature_unit';
  static const _windUnitKey = 'wind_speed_unit';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load temperature unit, defaulting to celsius if nothing is saved.
    final tempUnitIndex = prefs.getInt(_tempUnitKey) ?? 0;
    final tempUnit = TemperatureUnit.values[tempUnitIndex];

    // Load wind speed unit, defaulting to m/s if nothing is saved.
    final windUnitIndex = prefs.getInt(_windUnitKey) ?? 0;
    final windUnit = WindSpeedUnit.values[windUnitIndex];

    // Update the state with the loaded settings.
    state = AppSettings(
      temperatureUnit: tempUnit,
      windSpeedUnit: windUnit,
    );
  }

  // Method to update the temperature unit
  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tempUnitKey, unit.index);
    // Update the state to trigger a UI rebuild
    state = state.copyWith(temperatureUnit: unit);
  }

  // Method to update the wind speed unit
  Future<void> setWindSpeedUnit(WindSpeedUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_windUnitKey, unit.index);
    // Update the state to trigger a UI rebuild
    state = state.copyWith(windSpeedUnit: unit);
  }
}

// Finally, we create the provider itself.
// This is what our UI will interact with.
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});