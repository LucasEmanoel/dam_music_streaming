import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);


Future<void> getPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied, we cannot request permissions.');
    return;
  }

  try {
    final position = await Geolocator.getCurrentPosition();
    print('Position: $position');
  } catch (e) {
    print('An error occurred while getting the position: $e');
  }
}