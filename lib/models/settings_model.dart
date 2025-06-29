// lib/models/settings_model.dart

// An enum to represent the available temperature units.
enum TemperatureUnit { celsius, fahrenheit }

// An enum to represent the available wind speed units.
enum WindSpeedUnit { ms, mph }

// A simple class to hold all user-configurable settings.
class AppSettings {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;

  AppSettings({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.ms,
  });

  // A helper method to create a copy of the settings with some values changed.
  AppSettings copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
  }) {
    return AppSettings(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
    );
  }
}