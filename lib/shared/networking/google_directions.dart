import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Directions {

  static Future<BitmapDescriptor> getCustomIcon(String path) async {
    try{
      final ByteData byteData = await rootBundle.load(path);
      final Uint8List byteList = byteData.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(byteList);
    }
    catch(err) {
      print(err.toString());
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<String> getEncodedPolyline(
      String origin, String destination) async {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$origin'
          '&destination=$destination'
          '&key=AIzaSyAM9fi3kJeCSfu0jfy26CK6ZPSlu4JdhHk'),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final routes = decodedResponse['routes'] as List<dynamic>;
      if (routes.isNotEmpty) {
        final polyline = routes[0]['overview_polyline']['points'] as String;
        return polyline;
      }
    }
    return "";
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      polyline.add(LatLng(latitude, longitude));
    }

    return polyline;
  }

  static double getAngle(LatLng from, LatLng to) {
    const double radiansToDegrees = 180 / pi;

    double startLat = from.latitude * pi / 180.0;
    double startLng = from.longitude * pi / 180.0;
    double endLat = to.latitude * pi / 180.0;
    double endLng = to.longitude * pi / 180.0;

    double dLng = endLng - startLng;

    double y = sin(dLng) * cos(endLat);
    double x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

    double angle = atan2(y, x) * radiansToDegrees;

    if (angle < 0) {
      angle += 360;
    }

    return angle;
  }

  static double getRotation(LatLng oldLocation, LatLng newLocation) {
    double angle = atan2(
      newLocation.longitude - oldLocation.longitude,
      newLocation.latitude - oldLocation.latitude,
    );

    return angle * (180 / pi);
  }

  static List<LatLng> tramTrack = [
    const LatLng(26.31474, 50.14673),
    const LatLng(26.3142, 50.14443),
    const LatLng(26.31426, 50.14439),
    const LatLng(26.31426, 50.14429),
    const LatLng(26.3142, 50.14422),
    const LatLng(26.31415, 50.14421),
    const LatLng(26.31395, 50.14344),
    const LatLng(26.31355, 50.14191),
    const LatLng(26.31274, 50.14217),
    const LatLng(26.31236, 50.1423),
    const LatLng(26.31165, 50.14254),
    const LatLng(26.31141, 50.14256),
    const LatLng(26.31128, 50.14254),
    const LatLng(26.31106, 50.14247),
    const LatLng(26.31095, 50.14246),
    const LatLng(26.31085, 50.14248),
    const LatLng(26.31076, 50.14252),
    const LatLng(26.31034, 50.143),
    const LatLng(26.31, 50.14339),
    const LatLng(26.30994, 50.1435),
    const LatLng(26.30991, 50.14368),
    const LatLng(26.30993, 50.14427),
    const LatLng(26.30993, 50.14451),
    const LatLng(26.30989, 50.14475),
    const LatLng(26.30986, 50.14506),
    const LatLng(26.30981, 50.14505),
    const LatLng(26.30969, 50.14503),
    const LatLng(26.3096, 50.14502),
    const LatLng(26.30939, 50.14507),
    const LatLng(26.30891, 50.14533),
    const LatLng(26.30865, 50.14549),
    const LatLng(26.30838, 50.14571),
    const LatLng(26.30794, 50.14607),
    const LatLng(26.30781, 50.14624),
    const LatLng(26.30767, 50.1464),
    const LatLng(26.3076, 50.14643),
    const LatLng(26.3075, 50.14641),
    const LatLng(26.30737, 50.1462),
    const LatLng(26.30727, 50.14603),
    const LatLng(26.30726, 50.14592),
    const LatLng(26.3072, 50.14573),
    const LatLng(26.3071, 50.14561),
    const LatLng(26.30702, 50.14555),
    const LatLng(26.30689, 50.14554),
    const LatLng(26.30681, 50.14561),
    const LatLng(26.30678, 50.14568),
    const LatLng(26.30678, 50.1458),
    const LatLng(26.30671, 50.14589),
    const LatLng(26.30663, 50.14601),
    const LatLng(26.30649, 50.14636),
    const LatLng(26.30639, 50.14672)
  ];
}
