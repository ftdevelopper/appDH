import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/pages/shippings/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadedShippingWidget extends StatelessWidget {
  const DownloadedShippingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditShippingCubit, EditShippingState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            TextField(
              controller: TextEditingController()
                ..text = state.shipping.remiterTara.toString(),
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Peso Tara - Procedencia',
                  icon: Icon(Icons.filter_1)),
            ),
            Divider(),
            TextField(
              controller: TextEditingController()
                ..text = state.shipping.remiterFullWeight.toString(),
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Peso Bruto - Procedencia',
                  icon: Icon(Icons.filter_2)),
            ),
            Divider(),
            TextField(
              controller: TextEditingController()
                ..text = state.shipping.reciverFullWeight.toString(),
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Peso Bruto - Destino',
                  icon: Icon(Icons.filter_3)),
            ),
            Divider(),
            TextFormField(
              controller:
                  TextEditingController(text: state.shipping.reciverTara),
              decoration: InputDecoration(
                  labelText: 'Peso Tara - Destino', icon: Icon(Icons.filter_3)),
              enabled: true,
              onChanged: (value) {
                context.read<EditShippingCubit>().updateShippingParameter(
                      Shipping(
                        reciverTara: value,
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
