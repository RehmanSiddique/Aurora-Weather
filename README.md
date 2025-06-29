# Aurora Weather 🌦️

**A beautiful, feature-rich weather forecast application built with Flutter. Features a dynamic, time-aware UI inspired by the aurora, animated forecast charts, and full user customization.**

This application goes beyond being a simple utility; it aims to provide a delightful and immersive experience for checking real-time weather information, built with a focus on clean architecture and a polished user interface.

<br>

## ✨ Key Features

| Feature | Description |
| :--- | :--- |
| **Dynamic "Aurora" Theme** | A stunning, animated gradient background that shifts from a vibrant blue/purple for daytime to a deep "Digital Dusk" for nighttime, based on the selected city's local sunrise/sunset times. |
| **Animated Forecasts** | The 24-hour forecast is displayed as a beautiful, interactive line chart. The 7-day forecast features fluid Lottie animations for each day's weather condition. |
| **Comprehensive Data** | Fetches current weather, a 24-hour hourly forecast, and a 7-day daily forecast from the OpenWeatherMap One Call API 3.0. |
| **Full Personalization** | A dedicated settings screen allows users to customize units for temperature (°C/°F) and wind speed (m/s/mph), with all preferences saved locally. |
| **Polished User Experience** | Features pull-to-refresh, smooth cross-fade transitions, haptic feedback, and robust error handling to create a premium, responsive feel. |
| **Secure & Scalable** | Built on a clean, Riverpod-based architecture with secure API key management using `.env` files. |

<br>

## 📸 Screenshots

| Main Screen (Day) | Main Screen (Night) & Hourly Forcast | 7-Day Forecast | Settings |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/0f249f2a-f4bb-48d1-946f-b5a09e1c440e" width="200"/> | <img src="https://github.com/user-attachments/assets/8781518a-5241-48eb-b03d-d0b046fdef8d" width="200"/> | <img src="https://github.com/user-attachments/assets/62918a38-a78f-40d6-bac3-59a34ca25ebb" width="200"/> | <img src="https://github.com/user-attachments/assets/86925453-6a1c-406a-9140-0064601a84e4" width="200"/> |


<br>

## Video

<br>

## 🛠️ Tech Stack & Architecture

-   **Language:** [Dart](https://dart.dev/)
-   **Framework:** [Flutter](https://flutter.dev/)
-   **Architecture:** MVVM-like (View > Provider/ViewModel > Service/Repository)
-   **State Management:** [Riverpod](https://riverpod.dev/)
-   **Networking:** [http](https://pub.dev/packages/http)
-   **Animations:** [Lottie](https://pub.dev/packages/lottie)
-   **Charting:** [fl_chart](https://pub.dev/packages/fl_chart)
-   **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences)
-   **API Key Security:** [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
-   **Fonts:** [google_fonts](https://pub.dev/packages/google_fonts)

<br>

## 🚀 Getting Started

Follow these steps to get the project up and running on your local machine.

#### **1. Prerequisites**
-   Flutter SDK (version 3.x or higher)
-   An IDE like Android Studio or VS Code with the Flutter extension.
-   An Android emulator or a physical device.

#### **2. Clone the Repository**
```bash
git clone https://github.com/your-username/aurora-weather.git
cd aurora-weather
```

#### **3. Install Dependencies**
```bash
flutter pub get
```

#### **4. Set Up API Key**
This project requires a free API key from OpenWeatherMap.

1.  Create a free account at [OpenWeatherMap.org](https://openweathermap.org/).
2.  Navigate to your "API keys" tab and copy your key.
3.  **Crucially, subscribe to the "One Call API 3.0" free plan.** The app will not work without this step.
4.  In the root directory of the project, create a file named `.env`.
5.  Add your API key to this file as follows:
    ```
    API_KEY=your_actual_api_key_here
    ```
6.  Ensure the `.env` file is listed in your `.gitignore` to keep it secure.

#### **5. Run the Application**
```bash
flutter run
```

<br>

## 📁 Project Structure

The `lib` folder is structured to maintain a clean and scalable architecture:

```
lib/
├── api/          # Handles all API communication.
├── models/       # Data models for weather and settings.
├── providers/    # Riverpod providers for state management.
├── screens/      # Top-level screen widgets (Weather, Settings).
├── services/     # Services for local storage, etc.
└── widgets/      # Reusable UI components (charts, cards, views).
```

<br>

## 📦 Building for Release

To build a release-ready Android APK, run the following command:
```bash
flutter build apk --release
```
The compiled `.apk` file will be located in `build/app/outputs/flutter-apk/app-release.apk`.

<br>

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/your-username/aurora-weather/issues).

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

<br>

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for more details.

<br>

## 🙏 Acknowledgements

-   **Weather Data:** [OpenWeatherMap](https://openweathermap.org/)
-   **Animations:** [LottieFiles Community](https://lottiefiles.com/)
-   **Fonts:** [Google Fonts](https://fonts.google.com/)
