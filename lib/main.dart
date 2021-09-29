import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:vaccines_app/routes.dart';
import 'components/SignIn.dart';
import './components/MainPage.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;
final storage = FlutterSecureStorage();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,            
        builder: (context, snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          if(snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");

            if(jwt.length !=3) {
              return SignInForm();
            } else {
              var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                return MainPage(str, payload);
              } else {
                return SignInForm();
              }
            }
          } else {
            return SignInForm();
          }
        }
      ),
      // routes: buildRoutes(),
      // routes: {
      //   "/": (context) => MainPage(),
      // },
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(basePath: 'assets/locales', fallbackFile: 'pt'),
        ),
      ],
    );
  }
}
