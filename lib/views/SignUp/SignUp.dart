import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_i18n/flutter_i18n.dart';

const SERVER_IP = 'http://127.0.0.1:3000';

@JsonSerializable()
class FormData {
  String name = '';
  String email = '';
  String password = '';

  FormData({
    this.name,
    this.email,
    this.password,
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

FormData _$FormDataFromJson(Map<String, dynamic> json) {
  return FormData(
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
};

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => new _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  FormData formData = FormData();
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'sign_up')),
      ),
      body: Form(
        key: _formKey,
        child:ListView(
          padding: EdgeInsets.all(20),
          children: getFormWidget()
        ),
      )
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    String validateEmail(String value) {
      if (value.isEmpty) {
        return FlutterI18n.translate(context, 'invalid_field');
      }
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return FlutterI18n.translate(context, 'invalid_field');
      else
        return null;
    }

    Future<void> onPressedSubmit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        await http.post(
          Uri.parse('http://$SERVER_IP/users'),
          body: json.encode(formData.toJson()),
          headers: {'content-type': 'application/json'}
        );
      }
    }

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: FlutterI18n.translate(context, 'name'), 
      ),
      validator: (value) {
        if (value.isEmpty) {
          return FlutterI18n.translate(context, 'invalid_field');
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          formData.name = value;
        });
      },
    ));

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
            return FlutterI18n.translate(context, 'invalid_password');
          else
            return null;
        }),
    );

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(
      new TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: FlutterI18n.translate(context, 'password_confirmation')
        ),
        validator: (confirmPassword) {
          if (confirmPassword.isEmpty) return FlutterI18n.translate(context, 'invalid_field');
          var password = _passKey.currentState.value;
          if (confirmPassword.compareTo(password) != 0)
            return FlutterI18n.translate(context, 'password_mismatch');
          else
            return null;
        },
        onSaved: (value) {
          setState(() {
            _password = value;
          });
        }),
    );

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(new RaisedButton(
      padding: EdgeInsets.all(20),
      color: Colors.blue,
      textColor: Colors.white,
      child: new Text(FlutterI18n.translate(context, 'sign_up'), style: TextStyle(fontSize: 20),),
      onPressed: onPressedSubmit));

    return formWidget;
  }
}
