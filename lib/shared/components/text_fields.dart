import 'package:flutter/material.dart';

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
      decoration: InputDecoration(
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
