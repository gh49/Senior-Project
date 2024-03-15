import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_project/modules/building_adder/cubit.dart';
import 'package:senior_project/modules/login/cubit.dart';
import 'package:senior_project/shared/components/buttons.dart';
import 'package:senior_project/shared/components/text_fields.dart';
import 'package:senior_project/shared/components/themes.dart';
import 'package:senior_project/shared/functions/input_checks.dart';

class BuildingAdderScreen extends StatefulWidget {
  const BuildingAdderScreen({super.key});

  @override
  State<BuildingAdderScreen> createState() => _BuildingAdderScreenState();
}

class _BuildingAdderScreenState extends State<BuildingAdderScreen> {
  final _formKey = GlobalKey<FormState>();
  int? number;
  String? name;
  double? latitude;
  double? longitude;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuildingAdderCubit(),
      child: BlocConsumer<BuildingAdderCubit, BuildingAdderEvent>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = BuildingAdderCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "DATA ENTRY",
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        labelText: "Building Number",
                        prefixIcon: const Icon(Icons.numbers),
                        onSaved: (value) {
                          number = int.parse(value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter building number";
                          }
                          if (!InputCheck.isInteger(value)) {
                            return "The building number is not valid";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      G49TextFormField(
                        keyboardType: TextInputType.text,
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.local_convenience_store),
                        onSaved: (value) {
                          name = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter building name";
                          }
                          if (value.length < 6) {
                            return "Please enter a building name with more than 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      G49TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        labelText: "Latitude",
                        prefixIcon: const Icon(Icons.swap_horiz),
                        onSaved: (value) {
                          latitude = double.parse(value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter latitude";
                          }
                          if (!InputCheck.isNumber(value)) {
                            return "Please enter a valid latitude";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      G49TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        labelText: "Longitude",
                        prefixIcon: const Icon(Icons.swap_vert),
                        onSaved: (value) {
                          longitude = double.parse(value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter longitude";
                          }
                          if (!InputCheck.isNumber(value)) {
                            return "Please enter a valid longitude";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      if (state is! BuildingAdderLoading)
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: G49RoundButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              }
                            },
                            buttonText: "Add to Database",
                          ),
                        ),
                      if (state is BuildingAdderLoading)
                        const CircularProgressIndicator(
                          color: appPrimaryColor,
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
