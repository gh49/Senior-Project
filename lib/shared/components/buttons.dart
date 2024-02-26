import 'package:flutter/material.dart';

class G49RoundButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;

  const G49RoundButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xff3b654d),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText, style: TextStyle(color: textColor),),
    );
  }
}
