import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/components/card.dart';
import 'package:template/data/game_session.dart';
import 'package:template/data/highscore.dart';
import 'package:template/data/question.dart';
import 'package:template/theme/theme.dart';

List<Question> cardStackList = [
  Question(
      id: '0',
      category: 'Arts & Literature',
      correctAnswer: 'Häst',
      incorrectAnswers: ['Åsna', 'Kamel', 'Zebra'],
      question: 'Vad kan man rida på?',
      difficulty: 'Hard',
      index: 0),
  Question(
      id: '0',
      category: 'Arts & Literature',
      correctAnswer: 'Häst',
      incorrectAnswers: ['Åsna', 'Kamel', 'Zebra'],
      question: 'Vad kan man rida på?',
      difficulty: 'Hard',
      index: 0),
];

class TestView extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScaffoldWithBackground(
      child: AppinioSwiper(
        isDisabled: true,
        cards: cardStackList
            .map((question) =>
                QuestionCard(question: question, answerable: true))
            .toList(),
        //QuestionCard(question: cardStackList[0], answerable: true)
        /*cardStackList.map((question) {
          QuestionCard(question: question, answerable: true);
        }).toList()*/
      ),
    );
  }
}
