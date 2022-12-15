import 'dart:html';

import 'package:template/views/settings_view.dart';
import 'package:template/theme/theme.dart';

/// # Settings
/// Holds all parameters for a game.
///
/// int numberOfQuestions defaullt 10.
/// List<String> categorys defaullt [].
/// Stirng difficulty defaullt medium.
/// int timePerQuestion defaullt 20.
class Settings {
  bool activateAi = false;
  int _numberOfQuestions = 25;
  late List<String> _selectedCategories = Themes.categories.listCategories
      .map((category) => category.name)
      .toList();
  String _difficulty = "medium";
  int _timePerQuestion = 20;
  bool _standardSettings = true;

  bool get standardSettings => _standardSettings;

  /// Returns number of questions.
  int get numberOfQuestions => _numberOfQuestions;

  /// Returns list of categorys.
  List<String> get categories => _selectedCategories;

  /// Returns the difficulty.
  String get difficulty => _difficulty;

  /// Returns time per question,
  int get timePerQuestion => _timePerQuestion;

  set standardSettings(bool value) {
    _standardSettings = value;
  }

  void setActiveAi() {
    activateAi = !activateAi;
  }

  void setDifficulty(String newDifficulty) {
    _difficulty = newDifficulty;
  }

  void setTimePerQuestion(int newTime) {
    _timePerQuestion = newTime;
  }

  void setNumberOfQuestions(int newNumberOfQuestions) {
    _numberOfQuestions = newNumberOfQuestions;
  }

  void updateSelectedCategories(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
  }

  void resetCategories() {
    _selectedCategories = Themes.categories.listCategories
        .map((category) => category.name)
        .toList();
  }

  void checkSettings() {
    Settings newSettings = Settings();
    if ((_numberOfQuestions == newSettings.numberOfQuestions) &
        (_timePerQuestion == newSettings.timePerQuestion) &
        (_selectedCategories.length == newSettings.categories.length)) {
      _standardSettings = true;
    } else {
      _standardSettings = false;
    }
  }
}
