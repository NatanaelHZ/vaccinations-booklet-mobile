import 'package:flutter/material.dart';
import '../SignUp/SignUp.dart';
import '../../utils/I18n.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => new _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  String _email = '';
  String _password = '';
  String language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.translations[language]['sign_in']),
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
      if (value.isEmpty) return I18n.translations[language]['invalid_field'];
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) return I18n.translations[language]['invalid_field'];
      else return null;
    }

    void onPressedSubmit() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
      }
    }
    
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
          _email = value;
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
            return 'Password should be more than 8 characters';
          else
            return null;
        }),
    );

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(new RaisedButton(
      padding: EdgeInsets.all(20),
      color: Colors.blue,
      textColor: Colors.white,
      child: new Text(I18n.translations[language]['sign_in'], style: TextStyle(fontSize: 20),),
      onPressed: onPressedSubmit
    ));

    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    formWidget.add(
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpForm()),
          );
        },
        child: Center(child: Text(I18n.translations[language]['sign_up'], style: TextStyle(fontSize: 20)))
      ));

    return formWidget;
  }
}
