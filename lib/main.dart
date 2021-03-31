import 'package:flutter/material.dart';
import 'package:mini_whatsapp/Contacts.dart';
import 'FlutterFire.dart';
import 'FirstPage.dart';

void main() {
  runApp(App());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home:FirstPage(),
        theme: ThemeData.light(),
      );
  }
}