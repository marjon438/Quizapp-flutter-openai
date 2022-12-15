//Objektet Question innehåller information som rör en fråga.

class Question {
  late String _id;
  late String _category;
  late String _correctAnswer;
  late List
      _incorrectAnswers; // Denna variabeln kommer förmodligen aldrig användas och kan tas bort /August
  late String _question;
  late String _difficulty;
  late List _allAnswersInRandomOrder;
  late int _index;

  Question(
      {required String id,
      required String category,
      required String correctAnswer,
      required List<String> incorrectAnswers,
      required String question,
      required String difficulty,
      required int index}) {
    _id = id;
    _category = category;
    _correctAnswer = correctAnswer;
    _incorrectAnswers = incorrectAnswers;
    _question = question;
    _difficulty = difficulty;
    _index = index;
    _allAnswersInRandomOrder =
        scrambleAllAnswers(incorrectAnswers, correctAnswer);
  }
  /* Bygger objektet Question från json och returnerar ett färdigt objekt */
  factory Question.fromJson(Map<String, dynamic> json, index) {
    List<String> incorrectInFormat = [];
    for (String stringAnswer in json["incorrectAnswers"]) {
      incorrectInFormat.add(stringAnswer);
    }
    return Question(
        id: json["id"],
        category: json["category"],
        correctAnswer: json["correctAnswer"],
        //incorrectAnswers: json["incorrectAnswers"],
        incorrectAnswers: incorrectInFormat,
        question: json["question"],
        difficulty: json["difficulty"],
        index: index);
  }
  // getters
  get id => _id;
  get category => _category;
  get question => _question;
  get correctAnswer => _correctAnswer;
  get allAnswersInRandomOrder => _allAnswersInRandomOrder;
  get difficulty => _difficulty;
  get index => _index;

  /* Funktion för att sätta samman alla fyra svarsalternativ 
  till en lista och randomisera ordningen.*/
  List<String> scrambleAllAnswers(
    List<String> incorrectAnswers,
    String correctAnswer,
  ) {
    List<String> allAnswersInRandomOrder = incorrectAnswers;
    allAnswersInRandomOrder.add(correctAnswer);
    allAnswersInRandomOrder.shuffle();

    return allAnswersInRandomOrder;
  }
}
