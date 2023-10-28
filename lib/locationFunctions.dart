import 'dart:math';
import 'package:geolocator/geolocator.dart';

int getDist(stationCoords,currentCoords){
  var toRad = (180/pi);
  var x1 = stationCoords[0]/toRad;
  var x2 =  currentCoords[0]/toRad;

  var y1 = stationCoords[1]/toRad;
  var y2 =  currentCoords[1]/toRad;

  var dlon  = y1-y2;
  var dlat = x1-x2;

  var a = pow(sin(dlat/2),2) + cos(x2) * cos(x1) * pow(sin(dlon/2),2);
  var c = 2*asin(sqrt(a));
  var r = 6371;
  var dist = c*r;

  return dist.round();

}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
