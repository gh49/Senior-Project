import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // KFUPM location: Latitude=26.30695646378138, Longitude=50.14589543009121
  static const CameraPosition camInitPosition = CameraPosition(
    target: LatLng(26.30695646378138, 50.14589543009121),
    zoom: 15,
  );

  // Bottom left bound: Latitude=26.299148477860896, Longitude=50.13933215855204
  // Top right bound: Latitude=26.31862019326997, Longitude=50.15662819834159
  static final CameraTargetBounds cameraTargetBounds = CameraTargetBounds(LatLngBounds(
    southwest: const LatLng(26.299148477860896, 50.13933215855204),
    northeast: const LatLng(26.31862019326997, 50.15662819834159),
  ));

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: camInitPosition,
      zoomControlsEnabled: false,
      cameraTargetBounds: cameraTargetBounds,
      padding: EdgeInsets.zero,
      minMaxZoomPreference: const MinMaxZoomPreference(13.5, 19.5),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(camInitPosition));
  }

}
