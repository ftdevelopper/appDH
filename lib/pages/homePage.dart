import 'package:app_dos_hermanos/classes/dataBaseClass.dart';
import 'package:app_dos_hermanos/pages/entryShipPage.dart';
import 'package:app_dos_hermanos/pages/shippingPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  RiceShipDB _database = RiceShipDB.initialize();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/logo.png'),
              width: 150,
              height: 150,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _database.shipsDB.length,
                itemBuilder: (BuildContext context, int index){
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.delete),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Envio numero: $index (${_database.shipsDB[index].pesoNeto}kg)'),
                          subtitle: Text('${_database.shipsDB[index].riceType}          Hola de Llegada: ${DateFormat().add_jm().format(_database.shipsDB[index].llegada)}'),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ShippingPage(index: index, database: _database)));
                          },
                        ),
                        Divider(),
                      ],
                    ),
                    onDismissed: (direction){
                      setState(() {
                        _database.shipsDB.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EntryShipPage(database: _database))).then((value) => setState((){
            _database.shipsDB.sort((comp1, comp2) => comp1.llegada.compareTo(comp2.llegada));
          }));
        },
      ),
    );
  }
}
