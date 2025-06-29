// lib/providers/weather_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/weather_service.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
// 1. Import the settings provider so we can watch it.
import 'settings_provider.dart';

// --- These providers are correct and do not need changes ---
final weatherServiceProvider = Provider((ref) => WeatherService());
final storageServiceProvider = Provider((ref) => StorageService());
final cityProvider = StateProvider<String>((ref) => 'Lahore');
final initialCityLoaderProvider = FutureProvider<void>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  final lastCity = await storageService.getLastCity();
  if (lastCity != null) {
    ref.read(cityProvider.notifier).state = lastCity;
  }
});


// 2. THE FIX: This is the provider that needs to be updated.
final weatherProvider = FutureProvider<Weather>((ref) async {
  // Watch both the current city and the current settings.
  final city = ref.watch(cityProvider);
  final settings = ref.watch(settingsProvider); // This line makes it reactive to setting changes.

  final weatherService = ref.watch(weatherServiceProvider);

  // Now we pass BOTH the city and the settings to the service method.
  final weather = await weatherService.fetchWeather(city, settings);

  // On success, save the city to storage
  await ref.read(storageServiceProvider).saveLastCity(city);

  return weather;
});