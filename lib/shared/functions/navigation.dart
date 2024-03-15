import 'package:flutter/material.dart';

class G49Nav {
  static void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );

  static void navigateAndFinish(
      context,
      widget,
      ) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
            (route) {
          return false;
        },
      );
}

