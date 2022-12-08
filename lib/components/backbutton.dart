import 'package:flutter/material.dart';
import 'package:template/theme/theme.dart';
import 'package:template/views/start_view.dart';

class BackToFirstViewButton extends StatelessWidget {
  const BackToFirstViewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
                pageBuilder: (context, _, __) => StartView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero),
            ((route) => false));
      },
      color: Themes.colors.white,
      icon: Icon(
        Themes.icons.backarrow,
        size: 24,
      ),
    );
  }
}
