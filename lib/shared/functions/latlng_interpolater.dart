import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLngInterpolate {

  static void printLatLngToFile(List<LatLng> latLngList, String filePath) {
    try{
      File file = File(filePath);
      IOSink sink = file.openWrite();

      for (var latLng in latLngList) {
        sink.writeln('${latLng.latitude}, ${latLng.longitude}');
      }

      sink.close();
    }
    catch(err) {
      print(err.toString());
    }
  }

  static List<LatLng> interpolateLatLng(List<LatLng> latLngList, double step) {
    List<LatLng> interpolatedList = [];

    for (int i = 0; i < latLngList.length - 1; i++) {
      LatLng currentLatLng = latLngList[i];
      LatLng nextLatLng = latLngList[i + 1];

      double distance = calculateDistance(currentLatLng, nextLatLng);

      if (distance > step) {
        int numberOfSteps = (distance / step).ceil();
        double fraction = 1 / numberOfSteps;

        for (int j = 0; j < numberOfSteps; j++) {
          double fractionAlongSegment = fraction * (j + 1);
          double? lat = lerpDouble(currentLatLng.latitude, nextLatLng.latitude, fractionAlongSegment);
          double? lng = lerpDouble(currentLatLng.longitude, nextLatLng.longitude, fractionAlongSegment);
          interpolatedList.add(LatLng(lat!, lng!));
        }
      } else {
        interpolatedList.add(currentLatLng);
      }
    }

    interpolatedList.add(latLngList.last);

    return interpolatedList;
  }

  static double calculateDistance(LatLng latLng1, LatLng latLng2) {
    const earthRadius = 6371; // Radius of the earth in km
    double latDiff = radians(latLng2.latitude - latLng1.latitude);
    double lngDiff = radians(latLng2.longitude - latLng1.longitude);
    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(radians(latLng1.latitude)) * cos(radians(latLng2.latitude)) *
            sin(lngDiff / 2) * sin(lngDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; // Distance in km
    return distance;
  }

  static double radians(double degrees) {
    return degrees * pi / 180;
  }

}