import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/I18n.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

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
  final http.Client httpClient;

  const SignUpForm({
    this.httpClient,
    Key key,
  }) : super(key: key);

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
        title: Text(I18n.translations[language]['sign_up']),
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
        return I18n.translations[language]['invalid_field'];
      }
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return I18n.translations[language]['invalid_field'];
      else
        return null;
    }

    Future<void> onPressedSubmit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        var response = await http.post(
            Uri.parse('https://jsonplaceholder.typicode.com/post'),
            body: json.encode(formData.toJson()),
            headers: {'content-type': 'application/json'});

        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Form Submitted')));
      }
    }

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: I18n.translations[language]['name'], 
      ),
      validator: (value) {
        if (value.isEmpty) {
          return I18n.translations[language]['invalid_field'];
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
        labelText: I18n.translations[language]['email'], 
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
          labelText: I18n.translations[language]['password']
        ),
        validator: (value) {
          if (value.isEmpty)
            return I18n.translations[language]['invalid_field'];
          else if (value.length < 8)
            return I18n.translations[language]['invalid_password'];
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
          labelText: I18n.translations[language]['password_confirmation']
        ),
        validator: (confirmPassword) {
          if (confirmPassword.isEmpty) return I18n.translations[language]['invalid_field'];
          var password = _passKey.currentState.value;
          if (confirmPassword.compareTo(password) != 0)
            return I18n.translations[language]['password_mismatch'];
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
      child: new Text(I18n.translations[language]['sign_up'], style: TextStyle(fontSize: 20),),
      onPressed: onPressedSubmit));

    return formWidget;
  }
}
