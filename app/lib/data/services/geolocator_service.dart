import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition();

      if (position == null) {
        return null;
      }

      return position;
    } catch (e) {
      print('An error occurred while getting the position: $e');
      return null;
    }
  }

  Future<String?> getCityFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        var locality = null;
        for (var placemark in placemarks) {
            if (placemark.locality != null && placemark.locality!.isNotEmpty) {
              locality = placemark.locality;
              break;
            }
        }
        return locality;
      }
      return null;
    } catch (e) {
      print('An error occurred while getting the city: $e');
      return null;
    }
  }

}
