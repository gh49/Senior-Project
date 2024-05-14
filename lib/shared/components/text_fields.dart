import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class G49TextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onTapped;
  final void Function(String?)? onSaved;
  final bool readOnly;
  final InputDecoration? decoration;

  const G49TextFormField({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText = '',
    this.hintText = '',
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTapped,
    this.onSaved,
    this.readOnly = false,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      obscureText: obscureText,
      onTap: onTapped,
      onSaved: onSaved,
      readOnly: readOnly,
      decoration: decoration ??
          InputDecoration(
            labelText: labelText,
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
    );
  }
}

class G49SearchBar extends StatelessWidget {
  final void Function(String?)? callback;

  G49SearchBar({
    super.key,
    this.callback,
  });

  List<String> buildings = ["Building 76"];

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsCallback: (search) => buildings[0].contains(search) ? [buildings[0]] : [],
      builder: (context, controller, focusNode) {
        return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: "Search Building",
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
        );
      },
      itemBuilder: (context, string) {
        return ListTile(
          title: Text(string),
        );
      },
      onSelected: (s) {
        FocusScope.of(context).unfocus();
        callback!(s);
      },
    );
  }
}
