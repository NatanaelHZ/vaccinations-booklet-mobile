import 'package:flutter/widgets.dart';
import '../../providers/Vaccine.dart';
import 'package:flutter/material.dart';
import 'VaccineForm.dart';
import '../../utils/I18n.dart';

class Vaccines extends StatefulWidget {
  @override
  _VaccinesState createState() => new _VaccinesState();
}

class _VaccinesState extends State<Vaccines> {
  VaccineDbProvider db = VaccineDbProvider();
  String language = 'en';
  List<dynamic> _vaccines = [];
  
  @override
  void initState() {
    this.fetchVaccines();
    super.initState();
  }

  void fetchVaccines() async {
    WidgetsFlutterBinding.ensureInitialized();
    VaccineDbProvider db = VaccineDbProvider();
    final registers = await db.fetchVaccines();
    this.setState(() {
      _vaccines = registers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.translations[language]['vaccines']),
      ),
      body: Container(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 0),
          shrinkWrap: true,
          itemCount: null == _vaccines ? 0 : _vaccines.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VaccineForm(vaccine: _vaccines[index])),
                  );
                },
                title: Text(_vaccines[index].title),
                subtitle: Text('01/01/2021 00:00'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(I18n.translations[language]['delete_permanently']),
                          content: new Text(I18n.translations[language]['are_you_sure']),
                          actions: <Widget>[
                            new TextButton(
                              child: new Text(I18n.translations[language]['yes']),
                              onPressed: () async {
                                await db.deleteVaccine(_vaccines[index].id);
                                this.fetchVaccines();
                                Navigator.of(context).pop();
                              },
                            ),
                            new TextButton(
                              child: new Text(I18n.translations[language]['no']),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VaccineForm()),
          );
        },
      )
    );
  }

}

