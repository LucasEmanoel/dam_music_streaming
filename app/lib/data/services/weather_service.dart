import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _weatherFactory;

  WeatherService(String apiKey)
      : _weatherFactory = WeatherFactory(apiKey);



  Future<Weather?> getWeatherFromPosition(String city) async {
    try {
      final List<Weather> forecast = await _weatherFactory.fiveDayForecastByCityName(city);

      final now = DateTime.now();
      final nextWeather = forecast.firstWhere(
        (weather) => weather.date != null && weather.date!.isAfter(now),
      );
      return nextWeather;
    } catch (e) {
      print('An error occurred while getting the weather: $e');
      return null;
    }
  }
}