import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:flutter/material.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({Key? key, required this.shipping}) : super(key: key);

  final Shipping shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children:  <Widget>[
            Divider(),
            Text('Caracteristicas Generales', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            shipping.statusIcon,
            MyTextField(title: 'Estado', body: checkedString(string: shipping.getStatusName)),
            MyTextField(title: 'ID', body: checkedString(string: shipping.id)),
            MyTextField(title: 'Origen', body: checkedString(string: shipping.remiterLocation)),
            MyTextField(title: 'Destino', body: checkedString(string: shipping.reciverLocation)),
            MyTextField(title: 'Cosecha', body: checkedString(string: shipping.crop)),
            MyTextField(title: 'Lote', body: checkedString(string: shipping.lote)),
            MyTextField(title: 'Tipo de Arroz', body: checkedString(string: shipping.riceType)),
            MyTextField(title: 'Chofer', body: checkedString(string: shipping.driverName)),
            MyTextField(title: 'Patente del Camion', body: checkedString(string: shipping.truckPatent)),
            MyTextField(title: 'Patente del Chasis', body: checkedString(string: shipping.chasisPatent)),
            MyTextField(title: 'Estado de Conexion', body: checkedString(string: shipping.isOnLine ? 'En Linea' : 'No Sincronizado')),

            Divider(),
            Text('Peso Tara Inicial', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(title: 'Peso Tara', body: shipping.remiterTara.toString()),
            MyTextField(title: 'Hora de Tarado', body: shipping.remiterTaraTime.toString()),
            MyTextField(title: 'Usuario', body: shipping.remiterTaraUser.toString()),

            Divider(),
            Text('Peso Bruto Inicial', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(title: 'Peso Bruto', body: checkedString(string: shipping.remiterFullWeight.toString())),
            MyTextField(title: 'Peso Neto', body: checkedString(string: shipping.remiterWetWeight.toString())),
            MyTextField(title: 'Humedad', body: checkedString(string: shipping.humidity)),
            MyTextField(title: 'Peso Neto Seco', body: checkedString(string: shipping.remiterDryWeight.toString())),
            MyTextField(title: 'Hora de Peso Bruto', body: checkedString(string: shipping.remiterFullWeightTime.toString())),
            MyTextField(title: 'Usuario', body: checkedString(string: shipping.remiterFullWeightUser.toString())),

            Divider(),
            Text('Peso Bruto Final', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(title: 'Peso Bruto', body: shipping.reciverFullWeight.toString()),
            MyTextField(title: 'Hora de Peso Bruto', body: shipping.reciverFullWeightTime.toString()),
            MyTextField(title: 'Usuario', body: shipping.reciverFullWeightUser.toString()),

            Divider(),
            Text('Peso Tara Final', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(title: 'Peso Tara', body: checkedString(string: shipping.reciverTara.toString())),
            MyTextField(title: 'Peso Neto', body: checkedString(string: shipping.reciverWetWeight.toString())),
            MyTextField(title: 'Humedad', body: checkedString(string: shipping.humidity)),
            MyTextField(title: 'Peso Neto Seco', body: checkedString(string: shipping.reciverDryWeight.toString())),
            MyTextField(title: 'Hora de Tarado', body: checkedString(string: shipping.reciverTaraTime.toString())),
            MyTextField(title: 'Usuario', body: checkedString(string: shipping.remiterTaraUser.toString())),

            Divider(),
            Text('Historial del Envio', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: shipping.actions!.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width * 0.19, child: Text(shipping.actions![index],maxLines: 1,)),
                      Text(shipping.dateActions![index]),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.19,child: Text(shipping.userActions![index], maxLines: 1))
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

String checkedString({String? string}){
  if (string == null || string == '' || string == 'null')
    return 'No se cargo todavia';
  return string;
}

class MyTextField extends StatelessWidget {
  const MyTextField({Key? key, required this.title, required this.body}) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(title + ':', style: TextStyle(fontWeight: FontWeight.bold),),
        Spacer(),
        Text(body),
      ],
    ),
  );
  }
}