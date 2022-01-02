import 'package:app_dos_hermanos/classes/dataBaseClass.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShippingPage extends StatelessWidget {

  final int index;
  final RiceShipDB database;

  ShippingPage({Key? key, required this.index, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especificaciones', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Image(
              image: AssetImage('assets/logo.png'),
              width: 150,
              height: 150,
            ),
              Text('Tipo de Arroz: ${database.shipsDB[index].riceType}', style: TextStyle(
                fontSize: 25
              ),),
              Divider(),
              Text('Codigo de Producto: ${database.shipsDB[index].product}'),
              Text('Peso Bruto: ${database.shipsDB[index].pesoBruto}'),
              Text('Peso Tara: ${database.shipsDB[index].pesoTara}'),
              Text('Peso Neto: ${database.shipsDB[index].pesoNeto}', style: TextStyle(fontWeight: FontWeight.bold),),
              Divider(),
              Text('Procedencia: ${database.shipsDB[index].procedencia}'),
              Text('Cosecha: ${database.shipsDB[index].cosecha}'),
              Text('Contrato: ${database.shipsDB[index].contrato}'),
              Text('Nuemro de Partida: ${database.shipsDB[index].partidanum}'),
              Divider(),
              Text('Llegada: ${DateFormat.yMd().add_jm().format(database.shipsDB[index].llegada)}'),
            ]
          ),
        )
      ),
    );
  }
}