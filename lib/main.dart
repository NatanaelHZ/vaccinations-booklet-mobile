import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:vaccines_app/routes.dart';
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
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInForm(),
      routes: buildRoutes(),
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(basePath: 'assets/locales', fallbackFile: 'pt'),
        ),
      ],
    );
  }
}
