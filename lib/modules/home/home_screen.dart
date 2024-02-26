import 'package:flutter/material.dart';
import 'package:senior_project/shared/components/buttons.dart';
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
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Schedule"),
            //BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
                child: G49TextFormField(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Search Building",
                  hintText: "Ex. Building 11",
                ),
              ),
              SizedBox(
                height: 500,
                child: Align(
                  alignment: Alignment.center,
                  child: Text("MAP", style: TextStyle(fontSize: 30),),
                ),
              ),
            ],
          ),
        ));
    ;
  }
}
