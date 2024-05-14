import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senior_project/modules/map/map_ui.dart';
import 'package:senior_project/shared/components/text_fields.dart';
import 'package:senior_project/shared/components/themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  late int _start;

  late Future<void> Function() addDirections;

  bool buildingCardVisibility = false;
  int timeLeft = 100;

  @override
  void initState() {
    super.initState();
    _start = 100; // Initial timer value
  }

  void setDirFunction(Future<void> Function() function) {
    addDirections = function;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            timeLeft = _start;
          });
        }
      },
    );
  }

  void startTripS(String? s) {
    startTrip();
  }

  Future<bool> startTrip() async {
    bool start = await showAlertDialog(context, "");
    if (!start) {
      return false;
    }

    addDirections();
    startTimer();
    buildingCardVisibility = true;
    setState(() {});
    return true;
  }

  void updateSeconds(int seconds) {
    if(!buildingCardVisibility || (timeLeft - seconds).abs() < 1) {
      return;
    }
    timeLeft = seconds;
    _timer.cancel();
    _start = seconds;
    startTimer();
    setState(() {});
  }

  Future<bool> showAlertDialog(BuildContext context, String message) async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        // returnValue = false;
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        // returnValue = true;
        Navigator.of(context).pop(true);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Do you want to go to Building 76?"),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "KFUPM Tram",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appPrimaryColor,
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.schedule), label: "Schedule"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: MapSample(
                  startTrip: startTrip,
                  updateSeconds: updateSeconds,
                      setDirFunction: setDirFunction,
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  //Buiheight: 140.0,
                  child: G49SearchBar(
                callback: startTripS,
              )),
            ),
            AnimatedOpacity(
              opacity: buildingCardVisibility ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 400,
                  child: Card(
                    margin: EdgeInsets.all(20.0),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: const Image(
                                  image: NetworkImage(
                                      "https://pbs.twimg.com/media/DQ02u7MWAAALsAZ.jpg:large"),
                                  fit: BoxFit.cover,
                                  width: 130,
                                ),
                              ),
                              Spacer(),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Building 76",
                                    style: TextStyle(fontSize: 14.0),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "College of Petroleum Engineering & Geosciences",
                                      maxLines: null,
                                      style: TextStyle(fontSize: 10.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text(
                                    "Go to Station 7",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Time left for Tram Arrival",
                                style: TextStyle(fontSize: 14.0),
                                textAlign: TextAlign.right,
                              ),
                              Text(
                                "$timeLeft s",
                                style: const TextStyle(fontSize: 24.0),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
