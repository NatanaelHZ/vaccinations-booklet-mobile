import 'package:flutter/material.dart';
import '../../views/Vaccines/Vaccines.dart';
import '../../utils/I18n.dart';
import '../../models/Vaccine.dart';
import '../../providers/Vaccine.dart';

class VaccineForm extends StatefulWidget {
  @override
  _VaccineFormState createState() => new _VaccineFormState();
}

class _VaccineFormState extends State<VaccineForm> {
  final _formKey = GlobalKey<FormState>();
  VaccineDbProvider db = VaccineDbProvider();
  String _title = '';
  String language = 'en';

  void onPressedSubmit() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      VaccineDbProvider db = VaccineDbProvider();
      await db.addItem(
        Vaccine(
          title: _title,
        )
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Vaccines()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.translations[language]['vaccine']),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              onPressedSubmit();
            }
          )
        ],
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

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: I18n.translations[language]['title'], 
      ),
      validator: (value) {
        if (value.isEmpty) return I18n.translations[language]['invalid_field'];
        else return null;
      },
      onSaved: (value) {
        setState(() {
          _title = value;
        });
      },
    ));
    
    formWidget.add(Padding(padding: EdgeInsets.only(bottom: 20)));

    return formWidget;
  }
}
