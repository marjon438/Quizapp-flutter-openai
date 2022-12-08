import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:template/components/card.dart';
import 'package:template/components/displayCard.dart';
import 'package:template/components/endgamebutton.dart';
import 'package:template/data/game_session.dart';

import 'dart:math' as math;

import 'package:template/theme/theme.dart';
import 'package:template/views/answer_view.dart';

class QuestionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
        child: Center(
      child: Consumer<GameSession>(
        builder: (context, gameSession, child) => Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 60),
                Expanded(child: CountDownTimer()),
                Container(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [EndGameButton()],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Question ${gameSession.questionCounter + 1}/${gameSession.gameQuestions.length}",
              style: Themes.textStyle.headline3,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.85,
              child: AppinioSwiper(
                padding: const EdgeInsets.symmetric(),
                isDisabled: true,
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
                            answerable: true),
                      ]
                    : [
                        QuestionCard(
                            question: gameSession.currentQuestion,
                            answerable: true)
                      ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
  }
}

class CountDownTimer extends StatefulWidget {
  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  @override
  Widget build(BuildContext context) {
    double _duration =
        Provider.of<GameSession>(context, listen: false).getTimePerQuestion();
    if (_duration == 61) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Time left', style: Themes.textStyle.headline3),
          const SizedBox(height: 15),
          CircularCountDownTimer(
            duration: _duration.toInt(),
            initialDuration: 0,

            width: 100,
            height: 100,
            ringColor: Themes.colors.white,
            ringGradient: null,
            fillColor:
                Colors.transparent, //Måste finnas med men används inte...
            fillGradient: SweepGradient(
              colors: [
                Themes.colors.red,
                Themes.colors.yellow,
                Themes.colors.green
              ],
              stops: [
                0.1,
                0.3,
                1,
              ],
              startAngle: 3 * math.pi / 2,
              endAngle: 7 * math.pi / 2,
              tileMode: TileMode.repeated,
            ),
            backgroundColor: Themes.colors.blueDark,
            strokeWidth: 20.0,
            textStyle: TextStyle(
                fontSize: 33.0,
                color: Themes.colors.white,
                fontWeight: FontWeight.bold,
                inherit: false),
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onComplete: () {
              Provider.of<GameSession>(context, listen: false)
                  .calculatePlayerScore(answer: 'No answer');
              Provider.of<GameSession>(context, listen: false)
                  .addAnswerToBalls();
              Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                      pageBuilder: (context, _, __) => AnswerView(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero),
                  ((route) => false));
            },
          )
        ],
      );
    }
  }
}
