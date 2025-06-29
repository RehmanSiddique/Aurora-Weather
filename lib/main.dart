// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Import the package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/weather_provider.dart';
import 'screens/weather_screen.dart';

// 2. Make main asynchronous
Future<void> main() async {
  // 3. Load the .env file
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(initialCityLoaderProvider);

    return MaterialApp(
      title: 'Aurora Weather',
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const WeatherScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}