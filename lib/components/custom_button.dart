import 'package:flutter/material.dart';
import 'package:template/theme/theme.dart';

class CustomButton extends StatelessWidget {
  late Widget text;
  late VoidCallback onPressed;
  late double width;
  late double height;
  late Color color;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: Themes.functions.applyGradient(color)),
        child: TextButton(
          onPressed: onPressed,
          child: text,
        ),
      ),
    );
  }
}
