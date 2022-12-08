import 'package:flutter/material.dart';
import 'package:template/components/custom_button.dart';
import 'package:template/data/highscore.dart';
import 'package:template/theme/theme.dart';
import 'package:template/views/about_view.dart';
import 'package:template/views/settings_view.dart';
import 'package:provider/provider.dart';

import 'highscore_view.dart';

// Startskärm med knappar för singleplayer och highscore. Multiplayer är ej implemnterad än

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Fetching data for highscore at start.
    Provider.of<Highscore>(context, listen: false).fetchScores();
    return ScaffoldWithBackground(
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.info_outline_rounded,
                      color: Themes.colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, _, __) => AboutView(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  },
                ),

              ],
            ),
            Themes.textStyle.headlineGradient(text: 'Quizter', fontSize: 44),
            Themes.textStyle.headlineGradient(text: 'Pettersson', fontSize: 44),
            const Spacer(),
            SinglePlayerButton(),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.4,
              child: MultiPlayerButton(),
            ),
            const SizedBox(height: 20),
            HighscoreButton(),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

class HighscoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: Text(
        "Highscore",
        style: Themes.textStyle.headline1,
      ),
      width: 250,
      height: 50,
      color: Themes.colors.blueDark,
      onPressed: () {
        Provider.of<Highscore>(context, listen: false).setShowPlayAgain(false);
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, _, __) => HighscoreView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
      },
    );
  }
}

class MultiPlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: Text(
        "Multiplayer",
        style: Themes.textStyle.headline1,
      ),
      width: 250,
      height: 50,
      color: Themes.colors.blueDark,
      onPressed: () {},
    );
  }
}

class SinglePlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: Text(
        "Singleplayer",
        style: Themes.textStyle.headline1,
      ),
      width: 250,
      height: 50,
      color: Themes.colors.blueDark,
      onPressed: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, _, __) => SettingsView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
      },
    );
  }
}

class InformationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info_outline_rounded, color: Themes.colors.white),
      onPressed: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, _, __) => AboutView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
      },
    );
  }
}
