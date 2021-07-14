import 'package:flutter/material.dart';
// import 'components/SignUp.dart';
import 'components/SignUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Sign Up';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: SignUpForm(),
      ),
    );
  }
}