import 'package:dam_music_streaming/consts.dart';
import 'package:dam_music_streaming/data/services/geolocator_service.dart';
import 'package:dam_music_streaming/data/services/weather_service.dart';
import 'package:weather/weather.dart';

class WeatherRepository {
  final WeatherService weatherService = WeatherService(OPENWEATHER_API_KEY);
  final LocationService locationService = LocationService();

  WeatherRepository();

  Future<Weather?> getCurrentWeather() async {
    final position = await locationService.getCurrentPosition();
    
    if (position == null) return null;

    return weatherService.getWeatherFromPosition(position);
  }
}