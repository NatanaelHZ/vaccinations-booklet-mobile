import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'mainPage.title'),),
      ),
      body: Container()
    );
  }

}
