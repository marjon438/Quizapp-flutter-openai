// En spelomgång

// Spelets notifier

//
import 'package:flutter/material.dart';
import 'package:template/data/http_request.dart';
import 'package:template/data/player.dart';
import 'package:template/data/question.dart';
import 'package:template/data/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/theme/theme.dart';

class GameSession extends ChangeNotifier {
  Settings settings = Settings();
  HttpConection httpConection = HttpConection();

  late bool httpFetchComplete;
  late List<Question> gameQuestions;
  late Question currentQuestion;
  late Question nextQuestion;
  late Player player;
  late int questionCounter;

  late List ballsDataList;

  List get chosenCategories => settings.categories;
  String get chosenDifficulty => settings.difficulty;
  List<Question> get getGameQuestions => gameQuestions;
  double getNumberOfQuestion() {
    return settings.numberOfQuestions.toDouble();
  }

  double getTimePerQuestion() {
    return settings.timePerQuestion.toDouble();
  }

  Future startGame() async {
    gameQuestions = await httpConection.getQuestions(settings: settings);

    if (gameQuestions.isEmpty) {
      httpFetchComplete = false;
    } else {
      httpFetchComplete = true;
      player = Player();
      questionCounter = 0;
      currentQuestion = gameQuestions[questionCounter];
      ballsDataList =
          gameQuestions.map((question) => question.index + 1).toList();
      setNextQuestion();
    }
  }

  void calculatePlayerScore({required String answer}) {
    if (answer == currentQuestion.correctAnswer) {
      Themes.soundeffect.correct();
      player.correctAnswer(answer);
    } else {
      if (answer == "No answer") {
        Themes.soundeffect.timeout();
      } else {
        Themes.soundeffect.incorrect();
      }
      player.incorrectAnswer(newAnswer: answer);
    }
  }

  void resetSettings() {
    Settings standardSettings = Settings();
    settings.setNumberOfQuestions(standardSettings.numberOfQuestions);
    settings.setTimePerQuestion(standardSettings.timePerQuestion);
    settings.resetCategories();
    settings.checkSettings();
    notifyListeners();
  }

  void updateCategory(categoryName) {
    settings.updateSelectedCategories(categoryName);
    notifyListeners();
  }

  void increaseQuestionCounter() {
    questionCounter++;
    if (questionCounter < gameQuestions.length) {
      currentQuestion = gameQuestions[questionCounter];
    }
  }

  void setNextQuestion() {
    if (questionCounter + 1 < gameQuestions.length) {
      nextQuestion = gameQuestions[questionCounter + 1];
    }
  }

  void updateNumberOfQuestion(double numberOfQuestions) {
    settings.setNumberOfQuestions(numberOfQuestions.round());
    notifyListeners();
  }

  void updateTimePerQuestion(double newTime) {
    settings.setTimePerQuestion(newTime.round());
    notifyListeners();
  }

  void updateDifficulty(String newDifficulty) {
    settings.setDifficulty(newDifficulty);
    notifyListeners();
  }

  void addAnswerToBalls() {
    ballsDataList[questionCounter] = player.checkedAnswerList[questionCounter];
  }

  String getPlayerAnswerSummaryView({required int index}) {
    String playerAnswer = player.playerAnswers[index];
    String correctAnswer = getGameQuestions[index].correctAnswer;

    if (playerAnswer == "No answer") {
      return "No answer";
    } else if (playerAnswer == correctAnswer) {
      return "Correct answer";
    } else {
      return "Wrong answer";
    }
  }
}
