import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_project/modules/login/cubit.dart';
import 'package:senior_project/shared/components/buttons.dart';
import 'package:senior_project/shared/components/text_fields.dart';
import 'package:senior_project/shared/components/themes.dart';
import 'package:senior_project/shared/functions/input_checks.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? kfupmEmail;
  String? password;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginCEvent>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "KFUPM Tram",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: appPrimaryColor,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Image(
                  image: AssetImage("assets/tramlogo.png"),
                  height: 250.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      G49TextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "KFUPM ID",
                        hintText: "s20XXXXXXXX",
                        prefixIcon: const Icon(Icons.perm_identity),
                        onSaved: (value) {
                          kfupmEmail = "$value@kfupm.edu.sa";
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your KFUPM student ID";
                          }
                          if (!InputCheck.isKfupmId(value)) {
                            return "The KFUPM ID is not valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      G49TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                        obscureText: true,
                        onSaved: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 6) {
                            return "Please enter a password with more than 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      if (state is! LoginCLoginLoading)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: G49RoundButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                cubit.emailLogin(kfupmEmail!, password!);
                              }
                            },
                            buttonText: "Log In",
                          ),
                        ),
                      if (state is LoginCLoginLoading)
                        const CircularProgressIndicator(
                          color: appPrimaryColor,
                        ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("Continue as guest"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
