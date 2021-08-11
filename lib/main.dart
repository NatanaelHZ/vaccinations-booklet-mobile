import 'package:flutter/material.dart';
import 'components/SignIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String language = 'en';
    var translations = {
      "en": {
        "app_name": "Vaccinations",
      },
      "es": {
        "app_name": "Vacinas",
      },
      "pt": {
        "app_name": "Vacinas",
      },
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: translations[language]['app_name'],
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(translations[language]['app_name']),
        ),
        body: SignInForm(),
      ),
    );
  }
}