import 'package:flutter/material.dart';
import 'package:senior_project/modules/map/map_ui.dart';
import 'package:senior_project/shared/components/text_fields.dart';
import 'package:senior_project/shared/components/themes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map",),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
        body: const Stack(
          children: [
            Column(
              children: [
                Expanded(child: MapSample()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50.0,
                child: G49TextFormField(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Search Building",
                ),
              ),
            ),
          ],
        ));
  }
}