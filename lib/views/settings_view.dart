import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:provider/provider.dart';
import 'package:template/components/custom_button.dart';
import 'package:template/theme/theme.dart';
import 'package:template/views/loading_screen.dart';
import '../data/game_session.dart';
import 'package:template/components/backbutton.dart';
import 'package:template/components/slider.dart';
import 'package:template/data/settings.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      child: Consumer<GameSession>(
          builder: (BuildContext context, gameSession, child) =>
              Stack(children: [
                Center(
                    child: Opacity(
                  opacity: getOpacityAiIcon(context),
                  child: Icon(Icons.psychology_outlined,
                      size: 300, color: Themes.colors.white),
                )),
                (Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20, child: BackToFirstViewButton()),
                          Expanded(
                            child: Text(
                              'Singleplayer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Themes.colors.white, fontSize: 35),
                            ),
                          ),
                          SizedBox(width: 20)
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CategoryRow(),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Number of questions',
                          style: TextStyle(
                              color: Themes.colors.white, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SliderModel(
                          onchanged: gameSession.updateNumberOfQuestion,
                          getValue: gameSession.getNumberOfQuestion,
                          displayInCircle:
                              getNumberOfQuestionSlider(gameSession),
                          max: 50),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Time per question',
                          style: TextStyle(
                              color: Themes.colors.white, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SliderModel(
                          onchanged: gameSession.updateTimePerQuestion,
                          getValue: gameSession.getTimePerQuestion,
                          displayInCircle:
                              getTimePerQuestionSlider(gameSession),
                          max: 61),
                      const SizedBox(
                        height: 20,
                      ),
                      DifficultyRow(),
                      const SizedBox(
                        height: 20,
                      ),
                      HighscoreRulesRow(),
                      Spacer(),
                      CustomButton(
                        text: Text(
                          "Start",
                          style: Themes.textStyle.headline1,
                        ),
                        onPressed: () {
                          gameSession.settings.checkSettings();
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, _, __) =>
                                      LoadingView(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero));
                        },
                        width: 250,
                        height: 50,
                        color: Themes.colors.blueDark,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.psychology_outlined,
                              size: 30, color: Themes.colors.white),
                          Text(
                            'Activate AI-generated questions',
                            style: TextStyle(
                                color: Themes.colors.white, fontSize: 15),
                          ),
                          Checkbox(
                              value: Provider.of<GameSession>(context,
                                      listen: false)
                                  .getActivateAi,
                              activeColor: Themes.colors.white,
                              onChanged: (bool? active) {
                                Provider.of<GameSession>(context, listen: false)
                                    .setActiveAi();
                              }),
                        ],
                      ),
                    ],
                  ),
                )),
              ])),
    );
  }

  double getOpacityAiIcon(context) {
    bool active =
        Provider.of<GameSession>(context, listen: false).getActivateAi;
    if (active == true) {
      return 0.1;
    } else {
      return 0;
    }
  }

  Widget getTimePerQuestionSlider(gameSession) {
    double number = gameSession.getTimePerQuestion();
    if (number == 61) {
      return Icon(
        OctIcons.infinity_16,
        size: 15,
        color: Themes.colors.white,
      );
    } else {
      return Text(number.round().toString(),
          style: TextStyle(color: Themes.colors.white));
    }
  }

  Widget getNumberOfQuestionSlider(gameSession) {
    return Text(gameSession.getNumberOfQuestion().round().toString(),
        style: TextStyle(color: Themes.colors.white));
  }
}

class CategoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themesCategory = ThemeCategories();
    List<ThemeCategory> categoryList = themesCategory.listCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Categories',
              style: TextStyle(color: Themes.colors.white, fontSize: 15),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(Icons.info_outline_rounded,
                  size: 30, color: Themes.colors.white),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((BuildContext context) => InfoAboutCategories()));
              },
            ),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 5),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 5,
          children: categoryList
              .map(
                (category) => CategoryButton(category),
              )
              .toList(),
        ),
      ],
    );
  }
}

/// # Categorybutton
/// Builds a button for categories. Updates the categories selected in settings
class CategoryButton extends StatelessWidget {
  ThemeCategory category;
  CategoryButton(this.category, {super.key});

  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    List tempValdaKategorier =
        Provider.of<GameSession>(context, listen: true).chosenCategories;

    Color categoryColor = category.color;
    Color iconColor = Themes.colors.white;
    double opacity = 1;
    if (!tempValdaKategorier.contains(category.name)) {
      categoryColor = Themes.functions.lightenColor(categoryColor, 40);
      opacity = 0.40;
    }
    return InkWell(
      child: Opacity(
        opacity: opacity,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: Themes.functions.applyGradient(categoryColor)),
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Center(
                  child: Icon(
                category.icon,
                color: iconColor,
              )),
            ),
          ),
        ),
      ),
      onTap: () {
        Provider.of<GameSession>(context, listen: false)
            .updateCategory(category.name);
        Provider.of<GameSession>(context, listen: false)
            .settings
            .checkSettings();
      },
    );
  }
}

class DifficultyRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String difficulty =
        Provider.of<GameSession>(context, listen: true).chosenDifficulty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty',
          style: TextStyle(color: Themes.colors.white, fontSize: 15),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Difficultybutton(
              context,
              "Easy",
              difficulty,
              Themes.colors.green,
            ),
            const SizedBox(width: 20),
            _Difficultybutton(
              context,
              "Medium",
              difficulty,
              Themes.colors.yellow,
            ),
            const SizedBox(width: 20),
            _Difficultybutton(
              context,
              "Hard",
              difficulty,
              Themes.colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _Difficultybutton(
      context, String newDifficulty, String setDifficulty, color) {
    double opacity = 0.4;
    if (newDifficulty.toLowerCase() == setDifficulty) {
      opacity = 1;
    }
    return Opacity(
      opacity: opacity,
      child: CustomButton(
        text: Text(newDifficulty, style: Themes.textStyle.headline3),
        width: 80,
        height: 40,
        color: color,
        onPressed: () => Provider.of<GameSession>(context, listen: false)
            .updateDifficulty(newDifficulty.toLowerCase()),
      ),
    );
  }
}

class HighscoreRulesRow extends StatelessWidget {
  double opacityCheck(context) {
    if (Provider.of<GameSession>(context, listen: false)
            .settings
            .standardSettings ==
        false) {
      return 1;
    } else {
      return 0.4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSession>(
      builder: (context, gameSession, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
              opacity: opacityCheck(context),
              child: Container(
                height: 45,
                width: 190,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:
                        Themes.functions.applyGradient(Themes.colors.blueDark)),
                child: TextButton(
                  onPressed: () {
                    Provider.of<GameSession>(context, listen: false)
                        .resetSettings();
                  },
                  child: Text(
                    "Use highscore settings",
                    style: Themes.textStyle.headline3,
                  ),
                ),
              )),
          const SizedBox(width: 30),
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Icon(Icons.info_outline_rounded,
                size: 30, color: Themes.colors.white),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: ((BuildContext context) => GameRulesDialog()));
            },
          ),
        ],
      ),
    );
  }
}

//ALERTDIALOG MED INFO FÖR ATT KUNNA FÅ RESULTAT PÅ HIGHSCORE-LISTAN
class GameRulesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings newSettings = Settings();
    int questions = newSettings.numberOfQuestions;
    int time = newSettings.timePerQuestion;
    final highscoreRules =
        '''To be able to get your result on the highscore list you must use default settings.
  
Default settings are:
All categories
$questions questions
$time sec time limit

You can change the difficulty.
   ''';
    return AlertDialog(
      backgroundColor: Themes.colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(15),
      actionsPadding: const EdgeInsets.all(15),
      title: const Text('Highscore info'),
      content: Text(highscoreRules),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                text: Text('Return', style: Themes.textStyle.headline3),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                width: 100,
                height: 30,
                color: Themes.colors.blueDark),
          ],
        ),
      ],
    );
  }
}

class InfoAboutCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Themes.colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(15),
      actionsPadding: const EdgeInsets.all(15),
      title: const Text('Category info:'),
      content: _categoryinfoBuilder(context),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                text: Text('Return', style: Themes.textStyle.headline3),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                width: 100,
                height: 30,
                color: Themes.colors.blueDark),
          ],
        ),
      ],
    );
  }

  _categoryinfoBuilder(context) {
    List<ThemeCategory> ListlistCategories = Themes.categories.listCategories;
    return SizedBox(
      height: 350,
      width: 100,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: ListlistCategories.length,
          itemBuilder: (BuildContext context, index) {
            return _categoryRow(ListlistCategories[index]);
          }),
    );
  }

  _categoryRow(ThemeCategory themeCategory) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(themeCategory.icon, color: themeCategory.color),
          SizedBox(width: 10),
          Text(themeCategory.name)
        ],
      ),
    );
  }
}
