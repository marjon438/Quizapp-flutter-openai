import 'package:flutter/material.dart';
import 'package:template/data/about.dart';
import 'package:template/data/game_session.dart';
import 'package:template/data/highscore.dart';
import 'package:template/views/start_view.dart';
import 'package:template/theme/theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameSession()),
        ChangeNotifierProvider(create: (context) => Highscore()),
        ChangeNotifierProvider(create: (context) => About()),
      ],
      child: MaterialApp(
        home: StartView(),
        theme: Themes.themeData,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
