import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'dart:convert' show json, base64, ascii;
// import 'package:http/http.dart' as http;
// const SERVER_IP = 'http://localhost:3000';

class MainPage extends StatelessWidget {
  MainPage(this.jwt, this.payload);
  
  factory MainPage.fromBase64(String jwt) =>
    MainPage(
      jwt,
      json.decode(
        ascii.decode(
          base64.decode(base64.normalize(jwt.split(".")[1]))
        )
      )
    );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, 'mainPage.title'))),
      body: Center(
        child: 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(FlutterI18n.translate(context, 'mainPage.hello'), style: TextStyle(fontSize: 30),),
              Text(", ${payload['email']}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ]
          ),
          // FutureBuilder(
          //   future: http.read('$SERVER_IP/data', headers: { "Authorization": jwt }),
          //   builder: (context, snapshot) =>
          //     snapshot.hasData ?
          //     Column(children: <Widget>[
          //       Text("${payload['email']}, here's the data:"),
          //       Text(snapshot.data, style: Theme.of(context).textTheme.display1)
          //     ],)
          //     :
          //     snapshot.hasError ? Text(FlutterI18n.translate(context, 'mainPage.error_occured')) : CircularProgressIndicator()
        // ),
      ),
    );
  }
}
