import 'dart:convert';

import 'package:http/http.dart' as http;
import 'settings.dart';
import 'question.dart';

class HttpConection {
  late Settings settings;
  final String url = 'https://the-trivia-api.com/api/questions';
  // Huge thanks to Will Fry who created this open API!
  Map<String, String> listCategories = {
    "Food & Drink": "food_and_drink",
    "General Knowledge": "general_knowledge",
    "Film & TV": "film_and_tv",
    "Arts & Literature": "arts_and_literature",
    "Geography": "geography",
    "History": "history",
    "Music": "music",
    "Science": "science",
    "Society & Culture": "society_and_culture",
    "Sport & Leisure": "sport_and_leisure"
  };

  /// Gets a set of answers from the trivia Api. This function recuires
  /// an object of setting that contains game settings. It returns a
  /// complete list of Question objects.
  Future getQuestions({required Settings settings}) async {
    List<Question> questionList = [];
    int index = 0;
    String path =
        '?${_pathToCategorys(settings)}${_pathToDifficulty(settings)}${_pathToNumberOfQuestions(settings)}';
    http.Response response = await http.get(Uri.parse('$url$path'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var question in data) {
        questionList.add(Question.fromJson(question, index));
        index += 1;
      }
    }
    return questionList;
  }

  String _pathToDifficulty(Settings settings) {
    return '&difficulty=${settings.difficulty}';
  }

  String _pathToCategorys(Settings settings) {
    if (settings.categories.isEmpty) {
      return "";
    }
    String categories = '&categories=';
    for (String category in settings.categories) {
      categories += '${listCategories[category]},';
    }
    return categories.substring(0, categories.length - 1);
  }

  String _pathToNumberOfQuestions(Settings settings) {
    if (settings.numberOfQuestions > 0) {
      return '&limit=${settings.numberOfQuestions}';
    }
    return '&limit=10';
  }

  Future getMetadata() async {
    http.Response response =
        await http.get(Uri.parse('https://the-trivia-api.com/api/metadata'));
    Map map = jsonDecode(response.body);
    return map;
  }
}
