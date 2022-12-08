import 'package:flutter/cupertino.dart';
import 'package:template/data/http_request.dart';

import '../theme/theme.dart';

class About extends ChangeNotifier {
  late Color color;
  late String headline;
  late String body;
  late IconData iconData;

  About() {
    aboutCardCredits();
  }

  void aboutCardCredits() {
    headline = 'We who have made this app are:';
    body =
        'August Aublet\nLudwig Boström\nAndreas Fredrikson\nJosef Gunnarsson\nGustaf Hasselgren\nMårten Jonsson';
    iconData = Themes.icons.info;
    color = Themes.colors.blueDark;
    notifyListeners();
  }

  void aboutCardWill() async {
    Map map = await HttpConection().getMetadata();
    String approved = map["byState"]["approved"].toString();
    String created = map["lastCreated"].toString().substring(0, 10);
    String body2 =
        "\n\nInfo about api\nTotal number of questions today: ${approved}\nLast question created: ${created}";
    headline = 'Thanks!';
    body =
        'This project would not have been possible without Will Fry, who generously maintains and runs The Trivia API.' +
            body2;
    iconData = Themes.icons.favorite;
    color = Themes.colors.blueLight;
    notifyListeners();
  }
}
