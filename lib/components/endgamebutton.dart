import 'package:flutter/material.dart';
import 'package:template/components/end_game_dialog.dart';
import 'package:template/theme/theme.dart';

class EndGameButton extends StatelessWidget {
  const EndGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: ((BuildContext context) => const EndGameDialog()));
      },
      color: Themes.colors.white,
      padding: const EdgeInsets.all(0),
      icon: Icon(
        Themes.icons.wrong,
        size: 24,
      ),
    );
  }
}
