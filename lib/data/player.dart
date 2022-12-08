/// # Player
/// Player is the class that holds information about the player.
///
///
/// Name, score, streakCounter, longestStreak, correctAnswers and playerAnswers boolAnswers.
/// * Player.score => current score as int.
/// * Player.correctAnswers => number of correct answers as int.
/// * Player.playerAnswers => Map of questionID and answer.
/// * Player.correctAnswer(newAnswer) updates the score and streak.
///   Also add answer to playerAnswer.
/// * Player.incorrectAnswer(newAnswer). Also add answer to playerAnswer.
/// * Player.checkedAnswerList returns a list of corrected answers.
class Player {
  String name = '';
  int _score = 0;
  int _streakCounter = 0; // if we deside to implement streakCounter
  int _longestStreak = 0; // or change score per question we also
  int _correctAnswers = 0; // need to track number of correct answers

  final List<String> _playerAnswers =
      []; // if string = "No answer" => player out of time
  List<dynamic> _checkedAnswers = [];

  int get longestStreak => _longestStreak;

  /// Returns score as int.
  int get score => _score;

  /// Returns player answers as bool list
  List<dynamic> get checkedAnswerList => _checkedAnswers;

  /// Returns number of correctAnswer as int.
  int get correctAnswers => _correctAnswers;

  /// Returns list of playerAnswers as string.
  List<String> get playerAnswers => _playerAnswers;

  String get playerName => name;

  void setPlayerName(String newName) {
    name = newName;
  }

  /// Call if player answers correctly we increse score by 1, streakCounter by 1
  /// and correctAnswers by 1. The longest streak is also updatet. Also add
  /// newAnswer(string) to playerAnswers.
  void correctAnswer(String newAnswer) {
    _playerAnswers.add(newAnswer);
    _streakCounter += 1;
    if (_streakCounter > _longestStreak) {
      _longestStreak = _streakCounter;
    }
    if (_streakCounter > 3) {
      _score += 1; //  could be incresed of streak is implemented
    } else {
      _score += 1;
    }
    _correctAnswers += 1;
    _checkedAnswers.add(true);
  }

  /// Call if player answers incorectly, we update the longest streak if
  /// streakCounter is longer and the set streakCounter to 0. Also add
  /// newAnswer(string) to playerAnswers. Default value ="No answer" if player
  /// did not answer.
  void incorrectAnswer({required String newAnswer}) {
    if (_streakCounter > _longestStreak) {
      _longestStreak = _streakCounter;
    }
    _streakCounter = 0;
    _playerAnswers.add(newAnswer);
    if (newAnswer == 'No answer') {
      _checkedAnswers.add(newAnswer);
    } else {
      _checkedAnswers.add(false);
    }
  }
}
