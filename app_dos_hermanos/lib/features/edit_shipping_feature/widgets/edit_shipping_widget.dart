import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EditShippingWidget extends StatelessWidget {
  const EditShippingWidget(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditShippingCubit, EditShippingState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            TextField(
              controller: TextEditingController()..text = DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Fecha',
                  icon: Icon(Icons.calendar_today_outlined)),
            ),
            Divider(),
            TextField(
              controller: TextEditingController()
                ..text = state.shipping.driverName ?? '',
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Chofer', icon: Icon(Icons.contacts_outlined)),
            ),
            Divider(),
            TextField(
              controller: TextEditingController()..text = state.shipping.truckPatent ?? '',
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Patente del Camion',
                  icon: Icon(Icons.local_shipping_rounded)),
            ),
            Divider(),
            TextField(
              controller: TextEditingController()..text = state.shipping.chasisPatent ?? '',
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Patente del Chasis',
                  icon: Icon(Icons.local_shipping_rounded)),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
