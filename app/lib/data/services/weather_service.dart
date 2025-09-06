import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _weatherFactory;

  WeatherService(String apiKey)
      : _weatherFactory = WeatherFactory(apiKey);



  Future<Weather?> getWeatherFromPosition(Position position) async {
    try {
      final weather = await _weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      return weather;
    } catch (e) {
      print('An error occurred while getting the weather: $e');
      return null;
    }
  }
}