import 'package:flutter/material.dart';
import 'package:template/theme/theme.dart';

class DisplayCard extends StatelessWidget {
  Color backgroundColor = Themes.colors.white;
  late Text headline;
  late Text body;
  late IconData iconData;
  late Color color;

  DisplayCard(
      {super.key,
      required this.iconData,
      required this.color,
      required this.body,
      required this.headline});

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 30, left: 18, right: 18),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(width: 10, color: color)),
      height: deviceHeight * 0.65,
      width: deviceWidth * 0.85,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: color.withOpacity(0.2),
                size: 120,
              ),
            ],
          ),
          Center(
            child: Column(children: [
              headline,
              const Spacer(),
              body,
              const Spacer(),
            ]),
          )
        ],
      ),
    );
  }
}
