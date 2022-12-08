import 'package:flutter/material.dart';
import 'package:template/theme/theme.dart';

/// # CustomButton
/// En knapp för
class GradientCircle extends StatelessWidget {
  Widget child;
  Color color;
  double size;
  GradientCircle(
      {super.key,
      required this.child,
      required this.color,
      required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Themes.functions.lightenColor(color, 40),
                color,
                Themes.functions.darkenColor(color, 60)
              ],
              stops: const [
                0,
                0.2,
                0.9,
              ])),
      child: Center(child: child),
    );
  }
}
