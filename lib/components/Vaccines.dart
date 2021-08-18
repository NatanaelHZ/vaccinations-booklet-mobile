import 'package:flutter/widgets.dart';
import '../providers/Vaccine.dart';
import '../models/Vaccine.dart';
import 'package:flutter/material.dart';
import '../utils/I18n.dart';

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

  await db.addItem(
    Vaccine(
      id: 1,
      title: 'Vaccine 1',
      // scheduledAt: new DateTime(2021),
    )
  );

  await db.addItem(
    Vaccine(
      id: 2,
      title: 'Vaccine 2',
      // scheduledAt: new DateTime(2021),
    )
  );

  await db.updateVaccine(1, Vaccine(
    id: 1,
    title: 'Vaccine 1 changed',
    // scheduledAt: vaccine.scheduledAt,
  ));
  // await db.deleteVaccine(vaccine.id);

  final registers = await db.fetchVaccines();
  this.setState(() {
    _vaccines = registers;
  });
}

  @override
  Widget build(BuildContext context) {
    // print('VACCINES $_vaccines');
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
                title: Text(_vaccines[index].title),
                // subtitle: Text(_vaccines[index].scheduledAt),
                subtitle: Text('01/01/2021 00:00'),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: (){},
                ),
              ),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      )
    );
  }

}

