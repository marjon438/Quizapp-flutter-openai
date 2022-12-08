import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/components/gradient_circle.dart';
import 'package:template/data/game_session.dart';
import 'package:template/data/highscore.dart';
import 'package:template/theme/theme.dart';
import 'package:template/components/card.dart';
import 'package:template/components/custom_button.dart';
import 'package:template/views/highscore_view.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:template/data/string_extension.dart';
import 'package:template/views/loading_screen.dart';
import 'package:template/views/start_view.dart';

import '../data/question.dart';

class SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
        child: Consumer<GameSession>(
      builder: (context, gameSession, child) => Column(
        children: [
          Text("Summary", style: Themes.textStyle.headline1),
          const SizedBox(height: 15),
          ScoreTable(),
          const SizedBox(height: 30),
          Text(
            '${gameSession.chosenDifficulty.capitalize()} difficulty',
            style: Themes.textStyle.headline2,
          ),
          SummaryTable(),
          const SizedBox(height: 15),
          Column(
            children: [
              const SizedBox(height: 10),
              gameSession.settings.standardSettings
                  ? AddNameButton()
                  : const SizedBox(
                      height: 10,
                    ),
              Container(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NewGameButton(),
                  Container(
                    width: 10,
                  ),
                  ToMenuButton(),
                ],
              )
            ],
          )
        ],
      ),
    ));
  }
}

class ScoreTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int playerScore =
        Provider.of<GameSession>(context, listen: false).player.score;
    int totalScore =
        Provider.of<GameSession>(context, listen: false).gameQuestions.length;
    int wrongAnswers = (totalScore - playerScore);

    double spaceBetween = 15;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _scoreCircle(playerScore, "Correct \nAnswers", Themes.colors.green),
        Container(
          width: spaceBetween,
        ),
        _scoreCircle(wrongAnswers, "Wrong \nAnswers", Themes.colors.red),
        Container(
          width: spaceBetween,
        ),
        _scoreCircle(totalScore, "Total", Themes.colors.grey)
      ],
    );
  }

  Widget _scoreCircle(int number, String textBelow, Color color) {
    return Column(
      children: [
        GradientCircle(
            color: color,
            size: 80,
            child: Text(
              number.toString(),
              style: Themes.textStyle.headline1,
            )),
        Container(
          height: 5,
        ),
        Text(
          textBelow,
          style: Themes.textStyle.headline3,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class SummaryTable extends StatelessWidget {
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Container(
            height: 10,
          ),
          _listView(context),
        ],
      ),
    );
  }

  Widget _listView(context) {
    int questionListLenght = Provider.of<GameSession>(context, listen: false)
        .getGameQuestions
        .length;
    return Expanded(
      child: Container(
        child: FadingEdgeScrollView.fromScrollView(
          child: ListView.builder(
              controller: _controller,
              padding: const EdgeInsets.all(8),
              itemCount: questionListLenght,
              itemBuilder: (BuildContext context, index) {
                return CustomListTile(index: index);
              }),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  late int index;
  CustomListTile({required int this.index});
  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color tileColor;
    IconData tileIcon;
    String category = Provider.of<GameSession>(context, listen: false)
        .getGameQuestions[index]
        .category;
    Color categoryColor = Themes.category(category).color;
    IconData categoryIcon = Themes.category(category).icon;
    String playerAnswer = Provider.of<GameSession>(context, listen: false)
        .getPlayerAnswerSummaryView(index: index);
    if (playerAnswer == "No answer") {
      borderColor = Themes.colors.red;
      tileColor = Themes.colors.redLight;
      tileIcon = Themes.icons.timeout;
    } else if (playerAnswer == "Correct answer") {
      borderColor = Themes.colors.green;
      tileColor = Themes.colors.greenLight;
      tileIcon = Themes.icons.correct;
    } else {
      borderColor = Themes.colors.red;
      tileColor = Themes.colors.redLight;
      tileIcon = Themes.icons.wrong;
    }
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: ((BuildContext context) => ShowCard(index)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          height: 30,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 3, color: borderColor),
              color: tileColor),
          child: Row(
            children: [
              _categoryIconLeft(categoryIcon, categoryColor),
              Container(width: 10),
              Text("Question: ${index + 1}"),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _tileIconRight(tileIcon, borderColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryIconLeft(IconData categoryIcon, Color categoryColor) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Container(
        width: 21,
        height: 21,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Themes.colors.grey),
            color: categoryColor,
            shape: BoxShape.circle),
        child: Center(
            child: Icon(
          categoryIcon,
          color: Themes.colors.white,
          size: 14,
        )),
      ),
    );
  }

  Widget _tileIconRight(IconData tileIcon, Color color) {
    double size = 15;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: Icon(tileIcon, size: 12, color: Themes.colors.white)),
    );
  }
}

class NewGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: Text(
        "Play again",
        style: Themes.textStyle.headline2,
      ),
      width: 135,
      height: 50,
      color: Themes.colors.blueDark,
      onPressed: () {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, _, __) => LoadingView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero));
      },
    );
  }
}

class ToMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: Text(
        "Menu",
        style: Themes.textStyle.headline2,
      ),
      width: 135,
      height: 50,
      color: Themes.colors.blueDark,
      onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
                pageBuilder: (context, _, __) => StartView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero),
            ((route) => false));
      },
    );
  }
}

class AddNameButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return CustomButton(
        text: Text(
          'Add to highscore',
          style: Themes.textStyle.headline2,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: ((BuildContext context) => AddNameDialog()));
        },
        width: 280,
        height: 50,
        color: Themes.colors.blueDark);
  }
}

class AddNameDialog extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Themes.colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(15),
      actionsPadding: const EdgeInsets.all(15),
      title: Text('Add your name:'),
      content: TextField(
        controller: nameController,
        maxLength: 25,
      ),
      actions: [
        Row(
          children: [
            Consumer2<GameSession, Highscore>(
                builder: (BuildContext context, gameSession, highscore, child) {
              return CustomButton(
                  text: Text('Add name', style: Themes.textStyle.headline3),
                  onPressed: () {
                    gameSession.player
                        .setPlayerName(nameController.text); // Set player name
                    highscore.setShowPlayAgain(
                        true); // För att visa "spela-igen"-knapp
                    highscore.addNewScore(
                        // Add data to highscore database
                        name: gameSession.player.name,
                        score: gameSession.player.score,
                        difficulty: gameSession.settings.difficulty,
                        longestStreak: gameSession.player.longestStreak,
                        numberOfQuestions:
                            gameSession.settings.numberOfQuestions,
                        timePerQuestion: gameSession.settings.timePerQuestion,
                        categories: gameSession.settings.categories);

                    highscore.setDifficultyToView(Provider.of<GameSession>(
                            context,
                            listen: false)
                        .chosenDifficulty); // Visa vilken svårighet som ska visas direkt i highscore

                    Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                            pageBuilder: (context, _, __) => HighscoreView(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero),
                        ((route) => false));
                  },
                  width: 100,
                  height: 30,
                  color: Themes.colors.blueDark);
            }),
            const Spacer(),
            CustomButton(
                text: Text('Cancel', style: Themes.textStyle.headline3),
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

class ShowCard extends StatelessWidget {
  int index;
  ShowCard(this.index);
  @override
  Widget build(BuildContext context) {
    Question question =
        Provider.of<GameSession>(context, listen: false).gameQuestions[index];
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width * 0.85,
          child: QuestionCard(
            question: question,
            answerable: false,
          )),
    );
  }
}
