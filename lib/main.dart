import 'package:flutter/material.dart';
import 'components/Vaccines.dart';
// import 'components/SignIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SignInForm(),
      home: Vaccines(),
    );
  }
}