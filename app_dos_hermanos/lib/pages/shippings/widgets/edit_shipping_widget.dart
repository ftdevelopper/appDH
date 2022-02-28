import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:flutter/material.dart';

class EditShippingWidget extends StatelessWidget {
  const EditShippingWidget({Key? key, required this.shipping, required this.formatedDate}) : super(key: key);

  final Shipping shipping;
  final String formatedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: TextEditingController()..text = formatedDate,
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Fecha', icon: Icon(Icons.calendar_today_outlined)),
        ),
        Divider(),
        TextField(
          controller: TextEditingController()..text = shipping.driverName,
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Chofer', icon: Icon(Icons.contacts_outlined)),
        ),
        Divider(),
        TextField(
          controller: TextEditingController()..text = shipping.truckPatent,
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Patente del Camion',
              icon: Icon(Icons.local_shipping_rounded)),
        ),
        Divider(),
        TextField(
          controller: TextEditingController()..text = shipping.chasisPatent,
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Patente del Chasis',
              icon: Icon(Icons.local_shipping_rounded)),
        ),
        Divider(),
      ],
    );
  }
}
