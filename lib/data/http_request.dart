import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:template/auth/top_secret.dart';
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
  Future getTriviaQuestions({required Settings settings}) async {
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
    Map map = jsonDecode(utf8.decode(response.bodyBytes));
    return map;
  }

  Future getOpenAiQuestions({required Settings settings}) async {
    List<Question> questionList = [];
    List<String> categories = settings.categories;
    String difficulty = settings.difficulty;
    String key = openAiKey;
    int index = 0;
    Map<String, String> openAIHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $key'
    };
    String returnFormat =
        """[{"question": ,"correctAnswer": , "incorrectAnswers": []},]""";
    List<int> categoriesCount =
        getRandomCategories(categories.length, settings.numberOfQuestions);
    for (int x = 0; x < categories.length; x += 1) {
      if (categoriesCount[x] != 0) {
        String category = categories[x];
        String number = categoriesCount[x].toString();

        String prompt =
            "Generate $number $difficulty quiz question in category $category with 4 answer options return in $returnFormat";

        Map<dynamic, dynamic> openAIData = {
          'model': 'text-davinci-003',
          'prompt': prompt,
          'temperature': 1,
          'max_tokens': 800,
        };
        int numberOfTries = 3;
        for (int i = 1; i <= numberOfTries; i += 1) {
          http.Response answer = await http.post(
              Uri.parse('https://api.openai.com/v1/completions'),
              headers: openAIHeaders,
              body: json.encode(openAIData));
          if (answer.statusCode == 200) {
            // Removes chars before the json obj that could crash the jsonDecode on the text
            String newAnswerText =
                getNewSubText(jsonDecode(answer.body)["choices"][0]["text"]);
            bool success = tryDecode(text: newAnswerText, body: answer.body);
            if (success) {
              List responseList = jsonDecode(newAnswerText);
              for (Map question in responseList) {
                Map questionInfo = {
                  "index": index,
                  "category": category,
                  "question": question,
                  "difficulty": difficulty
                };

                questionList.add(createQuestion(questionInfo));
                index += 1;
              }
              i = numberOfTries;
            }
          } else {
            print("####################ANSWER.STATUSCODE####################");
            print(answer.statusCode);
            i = numberOfTries;
          }
        }
      }
    }
    return questionList;
  }

  String getNewSubText(String text) {
    for (int x = 0; x <= 15; x++) {
      if (text[x] == "[" || text[x] == "{") {
        return text.substring(x);
      }
    }
    return text.substring(15);
  }

  bool tryDecode({required String text, required String body}) {
    try {
      jsonDecode(text);
    } catch (error) {
      print("####################ERRORMESSAGE####################");
      print(error);
      print("####################ANSWER.BODY#####################");
      print(body);
      print("####################################################");
      return false;
    }
    return true;
  }

  Question createQuestion(Map questionInfo) {
    List<String> tempList =
        List<String>.from(questionInfo["question"]['incorrectAnswers'] as List);
    return Question(
        id: questionInfo["index"].toString(),
        category: questionInfo["category"],
        correctAnswer: questionInfo["question"]["correctAnswer"],
        incorrectAnswers: tempList,
        question: questionInfo["question"]["question"],
        difficulty: questionInfo["difficulty"],
        index: questionInfo["index"]);
  }

  List<int> getRandomCategories(int lenght, int questions) {
    List<int> categoriesCount = List.filled(lenght, 0);
    for (int i = 1; i <= questions; i += 1) {
      categoriesCount[Random().nextInt(lenght)] += 1;
    }
    return categoriesCount;
  }
}
