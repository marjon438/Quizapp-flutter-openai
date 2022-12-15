import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:audioplayers/audioplayers.dart';

/// Themes.category(name)
/// Returns the first category object with that name
/// Object.color returns Color of that category
/// Object.icon returns IconData of that category
/// Object.name returns String name of that category
class Themes {
  static ThemeColors colors = ThemeColors();

  static ThemeCategories categories = ThemeCategories();

  static ThemeCategory category(String name) {
    return categories.listCategories
        .where((category) => category.name == name)
        .first;
  }

  static ThemeData themeData = ThemeData(fontFamily: 'RobotoRegular');

  static ThemeTextStyles textStyle = ThemeTextStyles();

  static ThemeIcons icons = ThemeIcons();

  static ThemeFunctions functions = ThemeFunctions();

  static Soundeffect soundeffect = Soundeffect();
}

class ThemeColors {
  // Färger för varje kategori
  final Color artLiterature = const Color.fromARGB(255, 29, 121, 197);
  final Color filmTv = const Color(0xffF04349);
  final Color foodDrink = const Color(0xffFCB752);
  final Color generalKnowledge = const Color(0xffF47D55);
  final Color geography = const Color.fromARGB(255, 56, 69, 149);
  final Color history = const Color(0xff7E4D9F);
  final Color music = const Color.fromARGB(255, 60, 132, 84);
  final Color science = const Color.fromARGB(255, 135, 174, 69);
  final Color societyCulture = const Color(0xff53DAF8);
  final Color sportLeisure = const Color.fromARGB(255, 208, 77, 151);

  // Övriga färger
  final textGrey = const Color(0xff3A3A3A);
  final white = const Color(0xffEAEAEA);
  final backgroundMiddle = const Color.fromARGB(240, 0, 41, 72);
  final backgroundDark = const Color.fromARGB(240, 10, 29, 45);
  final backgroundLight = const Color.fromARGB(240, 41, 130, 152);

  final greenLight = const Color.fromARGB(255, 227, 255, 222);
  final green = const Color.fromARGB(255, 77, 210, 53);
  final greenDark = const Color(0xff102C0C);

  final redLight = const Color.fromARGB(255, 255, 232, 232);
  final red = const Color(0xffD64545);
  final redDark = const Color(0xff391515);

  final yellowLight = const Color(0xffE7C694);
  final yellow = const Color(0xffD6B645);
  final yellowDark = const Color(0xff392D15);

  final greyLight = const Color(0xff9FA9B5);
  final grey = const Color(0xff465E77);
  final greyDark = const Color(0xff182837);

  final blueLight = const Color(0xff4E9CBD);
  final blueDark = const Color(0xff22566C);
}

class ThemeCategory {
  final String name;
  final Color color;
  final IconData icon;

  ThemeCategory({required this.name, required this.color, required this.icon});
}

class ThemeCategories {
  final List<ThemeCategory> listCategories = [
    ThemeCategory(
        name: 'Arts & Literature',
        color: Themes.colors.artLiterature,
        icon: Icons.color_lens),
    ThemeCategory(
        name: 'Film & TV', color: Themes.colors.filmTv, icon: Icons.movie),
    ThemeCategory(
        name: 'Food & Drink',
        color: Themes.colors.foodDrink,
        icon: Icons.fastfood),
    ThemeCategory(
        name: 'General Knowledge',
        color: Themes.colors.generalKnowledge,
        icon: Icons.lightbulb),
    ThemeCategory(
        name: 'Geography', color: Themes.colors.geography, icon: Icons.public),
    ThemeCategory(
        name: 'History', color: Themes.colors.history, icon: Icons.castle),
    ThemeCategory(
        name: 'Music', color: Themes.colors.music, icon: Icons.music_note),
    ThemeCategory(
        name: 'Science', color: Themes.colors.science, icon: Icons.science),
    ThemeCategory(
        name: 'Society & Culture',
        color: Themes.colors.societyCulture,
        icon: Icons.account_balance),
    ThemeCategory(
        name: 'Sport & Leisure',
        color: Themes.colors.sportLeisure,
        icon: Icons.sports_soccer),
  ];
}

class ScaffoldWithBackground extends StatelessWidget {
  final Widget child;

  ScaffoldWithBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/backgroundimage.jpg'),
              fit: BoxFit.cover),
        ),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Themes.colors.backgroundDark,
              Themes.colors.backgroundMiddle,
              Themes.colors.backgroundLight
            ])),
      ),
      Padding(
          padding:
              const EdgeInsets.only(top: 55, left: 35, right: 35, bottom: 30),
          child: child),
    ]));
  }
}

class ThemeTextStyles {
  final TextStyle headline1 =
      TextStyle(fontSize: 28, color: Themes.colors.white);
  final TextStyle headline2 =
      TextStyle(fontSize: 20, color: Themes.colors.white);
  final TextStyle headline3 =
      TextStyle(fontSize: 15, color: Themes.colors.white);
  final TextStyle questionText =
      TextStyle(fontSize: 16, color: Themes.colors.textGrey);
  final TextStyle highscoreText =
      TextStyle(fontSize: 16, color: Themes.colors.textGrey);
  final TextStyle highscoreTextBold = TextStyle(
      fontSize: 20, color: Themes.colors.textGrey, fontWeight: FontWeight.bold);
  final TextStyle answerText =
      TextStyle(fontSize: 14, color: Themes.colors.textGrey);
  GradientText headlineGradient(
      {required String text, required double fontSize}) {
    return GradientText(
      text,
      style: TextStyle(fontSize: fontSize),
      colors: const [
        Color(0xffD04DC3),
        Color(0xff7E4D9F),
        Color(0xff1D83C5),
        Color(0xff53DAF8),
        Color(0xff54BB77),
        Color(0xffA4CD63),
        Color(0xffDFE34E),
        Color(0xffFCB752),
        Color(0xffF47D55),
        Color.fromARGB(255, 240, 67, 73),
      ],
    );
  }
}

class ThemeIcons {
  final IconData correct = Icons.done;
  final IconData wrong = Icons.close;
  final IconData reset = Icons.manage_history;
  final IconData timeout = Icons.timer_off_outlined;
  final IconData backarrow = Icons.arrow_back_ios_new;
  final IconData info = Icons.info_outline_rounded;
  final IconData favorite = Icons.favorite_border_outlined;
}

class ThemeFunctions {
  Color darkenColor(Color color, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = 1 - percent / 100;
    return Color.fromARGB(color.alpha, (color.red * p).round(),
        (color.green * p).round(), (color.blue * p).round());
  }

  Color lightenColor(Color color, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        color.alpha,
        color.red + ((255 - color.red) * p).round(),
        color.green + ((255 - color.green) * p).round(),
        color.blue + ((255 - color.blue) * p).round());
  }

  LinearGradient applyGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Themes.functions.lightenColor(color, 40),
        color,
        Themes.functions.darkenColor(color, 60)
      ],
      stops: const [
        0,
        0.2,
        0.9,
      ],
    );
  }
}

//Klass med funktioner för att kalla på ljudeffekter vid rätt/fel svar.
class Soundeffect {
  final player = AudioPlayer();
  String _correctSound = 'correct.mp3';
  String _incorrectSound = 'incorrect.mp3';
  String _timeoutSound = 'timeout.mp3';

  correct() {
    return player.play(AssetSource(_correctSound));
  }

  incorrect() {
    return player.play(AssetSource(_incorrectSound));
  }

  timeout() {
    return player.play(AssetSource(_timeoutSound));
  }
}
