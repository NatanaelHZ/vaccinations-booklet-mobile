import 'dart:convert';
import 'package:flutter/material.dart';
import '../SignUp/SignUp.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import '../MainPage/MainPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

const SERVER_IP = 'http://127.0.0.1:3000';
final storage = FlutterSecureStorage();

@JsonSerializable()
class FormData {
  String email;
  String password;

  FormData({
    this.email,
    this.password,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

FormData _$FormDataFromJson(Map<String, dynamic> json) {
  return FormData(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
};
class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => new _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  FormData formData = FormData();
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();
  var storage = FlutterSecureStorage();

  String _email = '';
  String _password = '';
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'sign_in')),
      ),
      body: Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(20),
        children: getFormWidget()
      ),
    ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    String validateEmail(String value) {
      if (value.isEmpty) return FlutterI18n.translate(context, 'invalid_field');
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) return FlutterI18n.translate(context, 'invalid_field');
      else return null;
    }

    Future<void> onPressedSubmit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        var jwt = null;

        // FOR TESTS WITHOUT API
        // final Map response_body = {
        //     "auth": true,
        //     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwibmFtZSI6IkRvdWdsYXMiLCJlbWFpbCI6ImFAYS5jb20iLCJjcmVhdGVkQXQiOiIyMDIxLTA5LTAxVDAzOjA0OjAxLjM2OVoiLCJ1cGRhdGVkQXQiOiIyMDIxLTA5LTAxVDAzOjA0OjAxLjM2OVoiLCJpYXQiOjE2MzA1NDAyMjksImV4cCI6MTY0MDU0MDIyOX0.6b1o_AiN-OUmwBuhl7mwDOrwEvu-ja82eSZtrRrgTfg"
        // };
        // jwt = response_body['token'];
              
        final response = await http.post(
          Uri.parse('http://$SERVER_IP/users/login'),
          body: json.encode(formData.toJson()),
          headers: {'content-type': 'application/json'}
        );
        
        if(response.statusCode == 200) jwt = jsonDecode(response.body).token;
        else {
          String _responseMessage = '';
          if (response.statusCode == 401) _responseMessage = 'Unable to sign in.';
          else _responseMessage = 'Something went wrong. Please try again.';

          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(_responseMessage)
          ));
        }
        
        if(jwt != null) {
          storage.write(key: "jwt", value: jwt);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage.fromBase64(jwt)
            )
          );
        }
      }
    }

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: FlutterI18n.translate(context, 'email'), 
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (value) {
        setState(() {
          formData.email = value;
        });
      },
    ));

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(
      new TextFormField(
        key: _passKey,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: FlutterI18n.translate(context, 'password')
        ),
        validator: (value) {
          if (value.isEmpty)
            return FlutterI18n.translate(context, 'invalid_field');
          else if (value.length < 8)
            return 'Password should be more than 8 characters';
          else
            return null;
        },
        onSaved: (value) {
          setState(() {
            formData.password = value;
          });
        },
      ),
    );

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(new RaisedButton(
      padding: EdgeInsets.all(20),
      color: Colors.blue,
      textColor: Colors.white,
      child: new Text(FlutterI18n.translate(context, 'sign_in'), style: TextStyle(fontSize: 20),),
      onPressed: onPressedSubmit
    ));

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpForm()),
          );
        },
        child: Center(child: Text(FlutterI18n.translate(context, 'sign_up'), style: TextStyle(fontSize: 20)))
      ));

    return formWidget;
  }
}
