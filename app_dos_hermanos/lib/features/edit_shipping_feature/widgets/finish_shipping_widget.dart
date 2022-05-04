import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:app_dos_hermanos/features/add_new_shipping_feature/widgets/shipping_data.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/repositories/authentication_repository.dart';

class FinishShippingButtonWidget extends StatelessWidget {
  FinishShippingButtonWidget({Key? key}) : super(key: key);
  final DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditShippingCubit, EditShippingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text('Envio Recibido'), Icon(Icons.warning)],
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                primary: Colors.amber.shade700,
              ),
              onPressed: () {
                _showRecivedConfirmationAlert(state.shipping, context);
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRecivedConfirmationAlert(
      Shipping shipping, BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Recepcion de Envio',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(
                    title: 'Fecha',
                    data: DateFormat('dd-MM-yyyy').format(date)),
                ShippingData(title: 'Hora', data: DateFormat.Hm().format(date)),
                ShippingData(
                    title: 'Usuario',
                    data: context.read<AuthenticationRepository>().user.name),
                ShippingData(
                    title: 'Ubicacion',
                    data: context
                        .read<AuthenticationRepository>()
                        .user
                        .location
                        .name),
                ShippingData(title: 'Arroz', data: shipping.riceType ?? ''),
                ShippingData(title: 'Chofer', data: shipping.driverName ?? ''),
                ShippingData(title: 'Camion', data: shipping.truckPatent ?? ''),
                ShippingData(
                    title: 'Chasis', data: shipping.chasisPatent ?? ''),
                ShippingData(
                    title: 'Peso Tara', data: shipping.remiterTara.toString()),
                ShippingData(
                    title: 'Peso Bruto',
                    data: shipping.remiterFullWeight.toString()),
                ShippingData(
                    title: 'Peso Neto',
                    data: shipping.remiterWetWeight.toString()),
                ShippingData(
                    title: 'Humedad', data: shipping.humidity.toString()),
                ShippingData(
                    title: 'Peso Seco',
                    data: shipping.remiterDryWeight.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    context.read<EditShippingCubit>().confirmRecive();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        );
      },
    );
  }
}
