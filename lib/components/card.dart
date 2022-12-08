import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/data/question.dart';
import 'package:template/theme/theme.dart';
import 'package:template/views/answer_view.dart';

import '../data/game_session.dart';

class QuestionCard extends StatelessWidget {
  Question question;
  bool answerable; // Avgör om det är ett klickbart kort eller inte.

  QuestionCard({super.key, required this.question, required this.answerable});

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    List<String> options = question.allAnswersInRandomOrder;
    Color categoryColor = Themes.category(question.category).color;
    Color backgroundColor = Themes.colors.white;
    IconData categoryIcon = Themes.category(question.category).icon;

    return Container(
      constraints: BoxConstraints(
        minHeight: deviceHeight * 0.65,
      ),
      padding: const EdgeInsets.only(top: 30, bottom: 30, left: 12, right: 12),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Themes.colors.greyDark.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 3,
            )
          ],
          color: backgroundColor,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(width: 10, color: categoryColor)),
      width: deviceWidth * 0.85,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categoryIcon,
                color: categoryColor.withOpacity(0.2),
                size: 120,
              ),
            ],
          ),
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      style: Themes.textStyle.questionText,
                      '${question.question}',
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        OptionsRow('A', options[0], categoryColor, question,
                            answerable),
                        OptionsRow('B', options[1], categoryColor, question,
                            answerable),
                        OptionsRow('C', options[2], categoryColor, question,
                            answerable),
                        OptionsRow('D', options[3], categoryColor, question,
                            answerable),
                      ],
                    )
                  ]),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class OptionsRow extends StatelessWidget {
  String optionText = 'Option is missing.';
  String leadingLetter;
  Color categoryColor;
  Color borderColor = Themes.colors.grey;
  Color tileColor = Colors.transparent;
  Color circleColor = Themes.colors.white;
  Question question;
  bool answerable;
  var icon = null;

  OptionsRow(this.leadingLetter, this.optionText, this.categoryColor,
      this.question, this.answerable);

  @override
  Widget build(BuildContext context) {
    // Om kortet inte är aktivt så skall varje rad byggas upp enligt nedan
    if (answerable == false) {
      String playerAnswer = Provider.of<GameSession>(context, listen: false)
          .player
          .playerAnswers[question.index];
      String correctAnswer = question.correctAnswer;
      // 1 Om spelarens svar är samma som radens värde
      if (playerAnswer == optionText) {
        // 1.1 Om spelarens svar också är det rätta svaret så skall raden bli grön och en grön ikon ritas ut
        if (playerAnswer == correctAnswer) {
          borderColor = Themes.colors.green;
          tileColor = Themes.colors.greenLight;
          circleColor = Themes.colors.green;
          icon = Icon(Themes.icons.correct, color: Colors.white);
          // 1.2 Om det inte är det rätta svaret så skall raden ritas ut som röd med en röd ikon
        } else {
          borderColor = Themes.colors.red;
          tileColor = Themes.colors.redLight;
          circleColor = Themes.colors.red;
          icon = Icon(
            Themes.icons.wrong,
            color: Colors.white,
          );
        }
        // 2 Om raden inte är spelarens svar men det är det rätta svaret så skall raden ritas ut som grön
      } else if (optionText == correctAnswer) {
        borderColor = Themes.colors.green;
        tileColor = Themes.colors.greenLight;
        circleColor = Themes.colors.greenLight;
        // 3 Om tiden går ut skall alla rader förutom den rätta raden ritas ut som röd
      } else if (playerAnswer == "No answer") {
        borderColor = Themes.colors.red;
        tileColor = Themes.colors.redLight;
        circleColor = Themes.colors.red;
        icon = Icon(Themes.icons.timeout, color: Themes.colors.white);
      }
    }

    return Material(
      color: Themes.colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListTile(
          tileColor: tileColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(width: 2, color: borderColor)),
          contentPadding:
              const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
          title: Row(children: [
            CircleAvatar(
              backgroundColor: categoryColor,
              radius: 14,
              child: Text(
                leadingLetter,
                style: Themes.textStyle.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                style: Themes.textStyle.answerText,
                optionText,
              ),
            ),
          ]),
          trailing: Container(
            child: icon,
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: circleColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 2, color: borderColor),
            ),
          ),
          onTap: (answerable == true)
              ? (() {
                  Provider.of<GameSession>(context, listen: false)
                      .calculatePlayerScore(answer: optionText);
                  Provider.of<GameSession>(context, listen: false)
                      .addAnswerToBalls();
                  Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                          pageBuilder: (context, _, __) => AnswerView(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero),
                      ((route) => false));
                })
              : null,
        ),
      ),
    );
  }
}
