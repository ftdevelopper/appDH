import 'package:app_dos_hermanos/classes/dataBaseClass.dart';
import 'package:flutter/material.dart';

class EntryShipPage extends StatefulWidget {

  EntryShipPage({Key? key, required this.database}) : super(key: key);

  RiceShipDB database;

  @override
  _EntryShipPageState createState() => _EntryShipPageState();
}

class _EntryShipPageState extends State<EntryShipPage> {
  @override
  Widget build(BuildContext context) {
    RiceShipDB _database = widget.database;
    return Column(
      
    );
  }
}