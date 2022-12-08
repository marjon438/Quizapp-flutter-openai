import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:template/app/app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0.002),
      systemStatusBarContrastEnforced: true));

  runApp(App());
}
