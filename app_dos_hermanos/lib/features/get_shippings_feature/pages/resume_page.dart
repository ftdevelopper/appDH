import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/repositories/authentication_repository.dart';
import 'package:app_dos_hermanos/repositories/shipping_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({Key? key, required this.shipping}) : super(key: key);

  final Shipping shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen'),
        actions: <Widget>[
          shipping.shippingState == ShippingStatus.deletedShipping
              ? IconButton(
                  icon: Icon(
                    Icons.restore_from_trash_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await restoreShipping(context);
                  })
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await deleteShipping(context);
                  },
                )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Divider(),
            Text('Caracteristicas generales',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            shipping.statusIcon,
            MyTextField(
                title: 'Estado',
                body: checkedString(string: shipping.getStatusName)),
            MyTextField(title: 'ID', body: checkedString(string: shipping.id)),
            MyTextField(
                title: 'Origen',
                body: checkedString(string: shipping.remiterLocation)),
            MyTextField(
                title: 'Destino',
                body: checkedString(string: shipping.reciverLocation)),
            MyTextField(
                title: 'Cosecha', body: checkedString(string: shipping.crop)),
            MyTextField(
                title: 'Lote', body: checkedString(string: shipping.lote)),
            MyTextField(
                title: 'Tipo de arroz',
                body: checkedString(string: shipping.riceType)),
            MyTextField(
                title: 'Chofer',
                body: checkedString(string: shipping.driverName)),
            MyTextField(
                title: 'Patente del camion',
                body: checkedString(string: shipping.truckPatent)),
            MyTextField(
                title: 'Patente del chasis',
                body: checkedString(string: shipping.chasisPatent)),
            MyTextField(
                title: 'Estado de conexion',
                body: checkedString(
                    string: (shipping.isOnLine ?? false)
                        ? 'En Línea'
                        : 'No Sincronizado')),
            Divider(),
            Text('Peso tara inicial',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(
                title: 'Peso tara',
                body: checkedString(string: shipping.remiterTara.toString())),
            MyTextField(
                title: 'Hora de tarado',
                body:
                    checkedString(string: shipping.remiterTaraTime.toString())),
            MyTextField(
                title: 'Usuario',
                body:
                    checkedString(string: shipping.remiterTaraUser.toString())),
            Divider(),
            Text('Peso bruto inicial',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(
                title: 'Peso bruto',
                body: checkedString(
                    string: shipping.remiterFullWeight.toString())),
            MyTextField(
                title: 'Peso neto',
                body: checkedString(
                    string: shipping.remiterWetWeight.toString())),
            MyTextField(
                title: 'Humedad',
                body: checkedString(string: shipping.humidity)),
            MyTextField(
                title: 'Peso neto seco',
                body: checkedString(
                    string: shipping.remiterDryWeight.toString())),
            MyTextField(
                title: 'Hora de peso bruto',
                body: checkedString(
                    string: shipping.remiterFullWeightTime.toString())),
            MyTextField(
                title: 'Usuario',
                body: checkedString(
                    string: shipping.remiterFullWeightUser.toString())),
            Divider(),
            Text('Peso bruto final',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(
                title: 'Peso bruto',
                body: checkedString(
                    string: shipping.reciverFullWeight.toString())),
            MyTextField(
                title: 'Hora de peso bruto',
                body: checkedString(
                    string: shipping.reciverFullWeightTime.toString())),
            MyTextField(
                title: 'Usuario',
                body: checkedString(
                    string: shipping.reciverFullWeightUser.toString())),
            Divider(),
            Text('Peso tara final',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            MyTextField(
                title: 'Peso tara',
                body: checkedString(string: shipping.reciverTara.toString())),
            MyTextField(
                title: 'Peso neto',
                body: checkedString(
                    string: shipping.reciverWetWeight.toString())),
            MyTextField(
                title: 'Humedad',
                body: checkedString(string: shipping.humidity)),
            MyTextField(
                title: 'Peso neto seco',
                body: checkedString(
                    string: shipping.reciverDryWeight.toString())),
            MyTextField(
                title: 'Hora de tarado',
                body:
                    checkedString(string: shipping.reciverTaraTime.toString())),
            MyTextField(
                title: 'Usuario',
                body:
                    checkedString(string: shipping.remiterTaraUser.toString())),
            Divider(),
            Text('Historial del envío',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: shipping.actions!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.19,
                          child: Text(
                            shipping.actions![index],
                            maxLines: 1,
                          )),
                      Text(shipping.dateActions![index]),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.19,
                          child:
                              Text(shipping.userActions![index], maxLines: 1))
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

  Future<void> deleteShipping(BuildContext context) async {
    shipping.actions!.add('Eliminó');
    shipping.userActions!.add(context.read<AuthenticationRepository>().user.id);
    shipping.dateActions!
        .add(DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()).toString());
    shipping.shippingState = ShippingStatus.deletedShipping;
    try {
      print('Deleting Shiping');
      await ShippingRepository().updateParameter(shipping: shipping);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  Future<void> restoreShipping(BuildContext context) async {
    shipping.actions!.add('Restauró');
    shipping.userActions!.add(context.read<AuthenticationRepository>().user.id);
    shipping.dateActions!
        .add(DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()).toString());
    shipping.shippingState = shipping.getLastStatus();
    try {
      print('Deleting Shiping');
      await ShippingRepository().updateParameter(shipping: shipping);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
}

String checkedString({String? string}) {
  if (string == null || string == '' || string == 'null')
    return 'No se cargo todavía';
  return string;
}

class MyTextField extends StatelessWidget {
  const MyTextField({Key? key, required this.title, required this.body})
      : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title + ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(body),
        ],
      ),
    );
  }
}
