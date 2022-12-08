import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/components/displayCard.dart';
import 'package:template/components/custom_button.dart';
import 'package:template/data/about.dart';
import 'package:template/theme/theme.dart';
import 'package:template/views/start_view.dart';

class AboutView extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
        child: Center(
      child: Consumer<About>(
        builder: (context, aboutData, child) => Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: BackButton(),
                ),
                Expanded(
                  child: Center(
                    child: Text('About', style: Themes.textStyle.headline1),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AboutButton(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ThanksButton(),
                )
              ],
            ),
            InfoCard(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ));
  }
}

class InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<About>(
        builder: (context, aboutData, child) => DisplayCard(
            iconData: aboutData.iconData,
            color: aboutData.color,
            headline: Text(
                textAlign: TextAlign.center,
                style: TextStyle(color: Themes.colors.greyDark, fontSize: 24),
                aboutData.headline),
            body: Text(
                style: TextStyle(color: Themes.colors.greyDark, fontSize: 20),
                aboutData.body)));
  }
}

class ThanksButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
        text: Text(
          'Thanks to',
          textAlign: TextAlign.center,
          style: Themes.textStyle.headline3,
        ),
        onPressed: () =>
            Provider.of<About>(context, listen: false).aboutCardWill(),
        width: 100,
        height: 45,
        color: Themes.colors.blueDark);
  }
}

class AboutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
        text: Text(
          'About us',
          textAlign: TextAlign.center,
          style: Themes.textStyle.headline3,
        ),
        onPressed: () =>
            Provider.of<About>(context, listen: false).aboutCardCredits(),
        width: 100,
        height: 45,
        color: Themes.colors.blueDark);
  }
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: const EdgeInsets.all(0),
        icon: Icon(Themes.icons.backarrow, color: Themes.colors.white),
        onPressed: () => Navigator.of(context).pop(PageRouteBuilder(
            pageBuilder: (context, _, __) => StartView(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero)));
  }
}
