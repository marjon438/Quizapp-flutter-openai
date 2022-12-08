import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/components/card.dart';
import 'package:template/components/displayCard.dart';
import 'package:template/components/gradient_circle.dart';
import 'package:template/theme/theme.dart';
import 'package:template/data/game_session.dart';
import 'package:template/views/question_view.dart';
import 'package:template/views/summary_view.dart';
import 'package:template/components/endgamebutton.dart';

class AnswerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
        child: Consumer<GameSession>(
      builder: (context, gameSession, child) => Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: EndGameButton(),
                ),
              ],
            ),
            Text('Score: ${gameSession.player.score}',
                style: Themes.textStyle.headline1),
            SizedBox(
              height: 15,
            ),
            SideScrollBalls(),
            SizedBox(
              height: 15,
            ),
            Text(
              "Question ${gameSession.questionCounter + 1}/${gameSession.gameQuestions.length}",
              style: Themes.textStyle.headline2,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.85,
              child: AppinioSwiper(
                  padding: const EdgeInsets.symmetric(),
                  isDisabled: false,
                  onSwipe: (index, direction) {
                    gameSession.increaseQuestionCounter();
                    if (gameSession.questionCounter >=
                        gameSession.gameQuestions.length) {
                      Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                              pageBuilder: (context, _, __) => SummaryView(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero),
                          ((route) => false));
                    } else {
                      gameSession.setNextQuestion();
                      Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                              pageBuilder: (context, _, __) => QuestionView(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero),
                          ((route) => false));
                    }
                  },
                  cards: gameSession.questionCounter + 1 <
                          gameSession.gameQuestions.length
                      ? [
                          DisplayCard(
                              iconData: Themes.category(
                                      gameSession.nextQuestion.category)
                                  .icon,
                              color: Themes.category(
                                      gameSession.nextQuestion.category)
                                  .color,
                              headline: Text(''),
                              body: Text('')),
                          QuestionCard(
                              question: gameSession.currentQuestion,
                              answerable: false),
                        ]
                      : [
                          QuestionCard(
                              question: gameSession.currentQuestion,
                              answerable: false)
                        ]),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}

class SideScrollBalls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameSession>(
      builder: (context, gameSession, child) => Expanded(
        child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView(
            controller: FixedExtentScrollController(
                initialItem: gameSession.questionCounter),
            itemExtent: 50,
            children: gameSession.ballsDataList.map((answer) {
              double size = gameSession.questionCounter == answer ? 35 : 25;

              if (answer == true) {
                return RotatedBox(
                  quarterTurns: 1,
                  child: GradientCircle(
                    color: Themes.colors.green,
                    size: size,
                    child: Icon(Themes.icons.correct,
                        color: Themes.colors.white, size: 20),
                  ),
                );
              } else if (answer == false) {
                return RotatedBox(
                  quarterTurns: 1,
                  child: GradientCircle(
                    color: Themes.colors.red,
                    size: size,
                    child: Icon(Themes.icons.wrong,
                        color: Themes.colors.white, size: 20),
                  ),
                );
              } else if (answer == 'No answer') {
                return RotatedBox(
                  quarterTurns: 1,
                  child: GradientCircle(
                    color: Themes.colors.red,
                    size: size,
                    child: Icon(Themes.icons.timeout,
                        color: Themes.colors.white, size: 20),
                  ),
                );
              } else {
                return RotatedBox(
                  quarterTurns: 1,
                  child: GradientCircle(
                    color: Themes.colors.grey,
                    size: 25,
                    child: Text('$answer',
                        style: TextStyle(color: Themes.colors.white)),
                  ),
                );
              }
            }).toList(),
          ),
        ),
      ),
    );
  }
}
