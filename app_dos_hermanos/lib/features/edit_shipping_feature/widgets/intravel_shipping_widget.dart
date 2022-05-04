import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import '../../../utils/validations/new_shipping_validators.dart';

class IntravelShippingWidget extends StatelessWidget {
  IntravelShippingWidget({Key? key}) : super(key: key);

  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _weightController.text =
        context.read<EditShippingCubit>().state.shipping.reciverFullWeight ??
            '';
    return BlocBuilder<EditShippingCubit, EditShippingState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Humedad',
                  border: InputBorder.none,
                  icon: Icon(Icons.water_sharp)),
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                context
                    .read<EditShippingCubit>()
                    .updateShippingParameter(Shipping(
                      humidity: value,
                    ));
                context.read<EditShippingCubit>().getDryWet(isRemiter: true);
              },
              validator: (value) {
                return NewShippingValidator.isHumidityValid(value);
              },
            ),
            Divider(),
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
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                  labelText: 'Peso Bruto - Destino',
                  icon: Icon(Icons.filter_3)),
              enabled: true,
              onChanged: (value) {
                context
                    .read<EditShippingCubit>()
                    .updateShippingParameter(Shipping(
                      reciverFullWeight: value,
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
