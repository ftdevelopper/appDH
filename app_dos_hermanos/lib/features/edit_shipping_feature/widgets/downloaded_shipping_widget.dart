import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';

class DownloadedShippingWidget extends StatelessWidget {
  DownloadedShippingWidget({Key? key}) : super(key: key);

  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _weightController.text =
            context.read<EditShippingCubit>().state.shipping.reciverTara ?? '';
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
              controller: _weightController,
              decoration: InputDecoration(
                  labelText: 'Peso Tara - Destino', icon: Icon(Icons.filter_3)),
              enabled: true,
              onChanged: (value) {
                int weight = (((int.tryParse(state.shipping.reciverFullWeight!)) ?? 0) - (int.tryParse(value) ?? 0));
                context.read<EditShippingCubit>().updateShippingParameter(
                      Shipping(
                        reciverTara: value,
                        reciverWetWeight: weight.toString(),
                      ),
                    );
                context.read<EditShippingCubit>().getDryWet(isRemiter: false);
              },
            ),
          ],
        );
      },
    );
  }
}
