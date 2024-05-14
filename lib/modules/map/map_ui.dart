import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:senior_project/shared/functions/latlng_interpolater.dart';
import 'package:senior_project/shared/networking/db.dart';
import 'package:senior_project/shared/networking/google_directions.dart';
import '../../models/models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MapSample extends StatefulWidget {
  const MapSample(
      {super.key, required this.startTrip, required this.updateSeconds, required this.setDirFunction});

  final Future<bool> Function() startTrip;
  final void Function(int) updateSeconds;
  final void Function(Future<void> Function()) setDirFunction;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>
    with AutomaticKeepAliveClientMixin {
  late IO.Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addMyLocation();
    widget.setDirFunction(addDirections);
    addTram();
    socketHandler();
    _addMarker(
      'Building 76',
      const LatLng(26.305533, 50.147778),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      alpha: 0.75,
      onTap: () async {
        bool start = await widget.startTrip();
        if(start) {
          addDirections();
        }
      },
    );
  }

  @override
  void dispose() {
    // Dispose the socket when the widget is disposed
    super.dispose();
    socket.dispose();
  }

  void socketHandler() {
    print("trying to connect socket");
    socket = IO.io('http://192.168.100.81:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    //socket.connect();
    socket.onConnect((_) {
      print('connected to socket --------------- ');
      socket.emit('msg', 'test');
    });
    socket.on(
        'location',
        (data) =>
            changeTramLocation(LatLng(data['latitude'], data['longitude'])));
    //socket.on('time', (data) => widget.updateSeconds((data as double).toInt()));
    socket.on('time', (data) {
      print(data);
      if (data is int) {
        widget.updateSeconds(data);
      } else {
        double time = data;
        widget.updateSeconds(time.toInt());
      }
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  bool get wantKeepAlive => true;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  List<Station> stations = Database.getStations();
  late Marker tramMarker;
  late BitmapDescriptor tramIcon;

  void _addMarker(String markerIdVal, LatLng location,
      {BitmapDescriptor icon = BitmapDescriptor.defaultMarker,
      double alpha = 1.0,
        double zIndex = 10,
      void Function()? onTap}) {
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      icon: icon,
      position: location,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      alpha: alpha,
      zIndex: zIndex,
      onTap: onTap,
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _addPolyline(String polylineIdVal, List<LatLng> points,
      {Color color = Colors.blue, int zIndex = 0, int width = 5}) {
    final PolylineId polylineId = PolylineId(polylineIdVal);

    // creating a new polyline
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      points: points,
      color: color,
      width: width,
      zIndex: zIndex,
    );

    setState(() {
      // adding a new marker to map
      polylines[polylineId] = polyline;
    });
  }

  // KFUPM location: Latitude=26.30695646378138, Longitude=50.14589543009121
  static const CameraPosition camInitPosition = CameraPosition(
    target: LatLng(26.311423, 50.145291),
    zoom: 15,
  );

  // Bottom left bound: Latitude=26.299148477860896, Longitude=50.13933215855204
  // Top right bound: Latitude=26.31862019326997, Longitude=50.15662819834159
  static final CameraTargetBounds cameraTargetBounds =
      CameraTargetBounds(LatLngBounds(
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
      onMapCreated: (GoogleMapController controller) async {
        _controller.complete(controller);
        _addStations();
        _addPolyline('tram-track', Directions.tramTrack,
            color: Colors.green.withAlpha(128), width: 8, zIndex: -1);

        //_addMarker("tram", stations[1].getLocation());
      },
      onCameraMove: (position) {
        if (position.zoom > 16.32239532470703) {
          //TODO: Change tram icon
        }
      },
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
    );
  }

  Future<void> addDirections() async {
    String encodedPoints1 = await Directions.getEncodedPolyline(
        stations[2].getLocationString(), stations[3].getLocationString());
    String encodedPoints2 = await Directions.getEncodedPolyline(
        stations[3].getLocationString(), stations[6].getLocationString());
    List<LatLng> points = Directions.decodePolyline(encodedPoints1);
    points.addAll(Directions.decodePolyline(encodedPoints2));

    _addPolyline('goal', points);
  }

  Future<void> _addStations() async {
    //Add stations to map
    BitmapDescriptor stationIcon =
        await Directions.getCustomIcon("assets/station_resized.png");
    for (var station in stations) {
      _addMarker("Station ${station.number}", station.getLocation(),
          icon: stationIcon);
    }
  }

  Future<void> _addMyLocation() async {
    //Add stations to map
    BitmapDescriptor myLocationIcon = await Directions.getCustomIcon("assets/my_location.png");
    _addMarker("", const LatLng(26.314119, 50.143652), icon: myLocationIcon, zIndex: 20);
    setState(() {

    });
  }

  bool tramAdded = false;

  Future<void> addTram() async {
    tramIcon = await Directions.getCustomIcon("assets/tram.png");
    MarkerId markerId = const MarkerId("tram");
    tramMarker = Marker(
      markerId: markerId,
      icon: tramIcon,
      position: const LatLng(26.312360000000005, 50.14238999999993),
      infoWindow: const InfoWindow(title: "Tram"),
      zIndex: 10,
    );
    setState(() {
      markers[markerId] = tramMarker;
      tramAdded = true;
    });
  }

  void changeTramLocation(LatLng newLocation) {
    LatLng oldLocation = tramMarker.position;
    MarkerId markerId = const MarkerId("tram");
    tramMarker = Marker(
      markerId: markerId,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      rotation: Directions.getRotation(oldLocation, newLocation),
      icon: tramIcon,
      position: newLocation,
      infoWindow: const InfoWindow(title: "Tram"),
      zIndex: 10,
    );
    markers[markerId] = tramMarker;
    //print("Tram Position: ${tramMarker.position.latitude}, ${tramMarker.position.longitude}");
    setState(() {});
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(camInitPosition));
  }
}
