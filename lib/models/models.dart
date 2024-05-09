import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  late LatLng location;
  late int number;

  Station(double latitude, double longitude, this.number) {
    location = LatLng(latitude, longitude);
  }

  LatLng getLocation() {
    return location;
  }

  String getLocationString() {
    return "${location.latitude}, ${location.longitude}";
  }

  int getNumber() {
    return number;
  }
}