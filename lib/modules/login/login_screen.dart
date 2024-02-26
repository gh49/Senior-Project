import 'package:flutter/material.dart';
import 'package:senior_project/shared/components/buttons.dart';
import 'package:senior_project/shared/components/text_fields.dart';
import 'package:senior_project/shared/components/themes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    print("KEEP THIS");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "KFUPM Tram",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: appPrimaryColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          const Image(image: AssetImage("assets/tramlogo.png"), height: 250.0),
          const G49TextFormField(
            keyboardType: TextInputType.text,
            labelText: "KFUPM ID",
            hintText: "s20XXXXXXXX",
            prefixIcon: Icon(Icons.perm_identity),
          ),
          const SizedBox(
            height: 26.0,
          ),
          const G49TextFormField(
            keyboardType: TextInputType.visiblePassword,
            labelText: "Password",
            prefixIcon: Icon(Icons.lock),
            suffixIcon: Icon(Icons.remove_red_eye_outlined),
            obscureText: true,
          ),
          SizedBox(
            height: 16.0,
          ),
          G49RoundButton(
            onPressed: () {},

            buttonText: "Log In",
          ),
          SizedBox(
            height: 2.0,
          ),
          OutlinedButton(onPressed: (){}, child: Text("Continue as guest"),)
        ],
      ),
    );
  }
}
