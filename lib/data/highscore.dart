import 'package:flutter/material.dart';
import 'package:deta/deta.dart';
import 'package:http_client_deta_api/http_client_deta_api.dart';
import 'package:http/http.dart' as http;
import 'package:template/auth/top_secret.dart';

/// Koppling till Databas för Highscore. Tre listor med Highscores.
/// highscoreEasy, highscoreMedium, highscoreHard.
/// Listorna innehåller Maps(dictionarys) med name, score, difficulty,
/// numberOfQuestions, timePerQuestion, categories(Lista med String).
class Highscore extends ChangeNotifier {
  late var deta;
  late var detabase;
  final String dbName = "highscores"; // under testning "highscore-1"

  late List _scoresEasy;
  late List _scoresMedium;
  late List _scoresHard;
  String _difficultyToView = "medium";
  late bool _showPlayAgain = false;
  String _lastKey = ""; // set to empty string

  // Öppnar kopplingen till databasen.
  Highscore() {
    deta = Deta(
        projectKey: databaseKey,
        client: HttpClientDetaApi(http: http.Client()));
    detabase = deta.base(dbName);
  }

  // Getters för de olika score
  List get highscoreEasy => _scoresEasy;
  List get highscoreMedium => _scoresMedium;
  List get highscoreHart => _scoresHard;
  String get difficultyToView => _difficultyToView;
  bool get showPlayAgain => _showPlayAgain;
  String get lastKey => _lastKey;

  /// Använd för att visa den listan för vald svårighetsgrad.
  List getChosenHighscores() {
    if (difficultyToView == "easy") {
      return _scoresEasy;
    } else if (difficultyToView == "medium") {
      return _scoresMedium;
    } else if (difficultyToView == "hard") {
      return _scoresHard;
    }
    return _scoresMedium;
  }

  /// Används för att byta vilken lista man vill visa.
  void setDifficultyToView(String newDifficultyToView) {
    _difficultyToView = newDifficultyToView;
    notifyListeners();
  }

  void setShowPlayAgain(bool newValue) {
    _showPlayAgain = newValue;
  }

  /// Använd för att skapa ett nytt objekt i databasen.
  void addNewScore({
    required String name,
    required int score,
    required String difficulty,
    required int longestStreak,
    required int numberOfQuestions,
    required int timePerQuestion,
    required List<String> categories,
  }) async {
    // Själva insättningen i databasen.
    Map tempLastKey = await detabase.put({
      "name": name,
      "score": score,
      "difficulty": difficulty,
      "longestStreak": longestStreak,
      "numberOfQuestions": numberOfQuestions,
      "timePerQuestion": timePerQuestion,
      "categories": categories,
    });
    _lastKey = tempLastKey["key"];
  }

  /// Hämtar alla Highscore och använder sortList för att sätta
  /// _scoresEasy-Medium-Hard till nya sorterade listor.
  void fetchScores({String difficulty = "All"}) async {
    if (difficulty == "All" || difficulty == "Easy") {
      final easy = await detabase
          .fetch(query: [DetaQuery("difficulty").equalTo("easy")]);
      _scoresEasy = sortList(easy["items"]);
    }
    if (difficulty == "All" || difficulty == "Medium") {
      final medium = await detabase
          .fetch(query: [DetaQuery("difficulty").equalTo("medium")]);
      _scoresMedium = sortList(medium["items"]);
    }
    if (difficulty == "All" || difficulty == "Hard") {
      final hard = await detabase
          .fetch(query: [DetaQuery("difficulty").equalTo("hard")]);
      _scoresHard = sortList(hard["items"]);
    }
    notifyListeners();
  }

  /// Lämnar tillbaka top tio lista sorterad från störst till lägst.
  List<dynamic> sortList(List<dynamic> scores) {
    List<dynamic> sortedList = [];
    while (scores.isNotEmpty) {
      Map largest = scores.first;
      for (Map score in scores) {
        if (score["score"] > largest["score"]) {
          largest = score;
        }
      }
      sortedList.add(largest);
      scores.remove(largest);
    }
    return sortedList;
  }
}
