import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory _weatherFactory;

  WeatherService(String apiKey)
      : _weatherFactory = WeatherFactory(apiKey);



  Future<Weather?> getWeatherFromPosition(String city) async {
    try {
      print('CIDADEEEEEEEEEEEEEEEEEEE $city');
      final weather = await _weatherFactory.currentWeatherByCityName(city);
      return weather;
    } catch (e) {
      print('An error occurred while getting the weather: $e');
      return null;
    }
  }
}