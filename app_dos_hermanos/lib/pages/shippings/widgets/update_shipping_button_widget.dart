import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/pages/shippings/edit_shipping.dart';
import 'package:app_dos_hermanos/pages/shippings/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpdateShippingButtonWidget extends StatelessWidget {
  UpdateShippingButtonWidget({Key? key}) : super(key: key);

  final String date = DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
          child: Text('Actualizar Envio'),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              primary: Colors.red.shade700),
          onPressed: () {
            _showConfirmationAlert(context.read<EditShippingCubit>().state.shipping, context);
          },
        ),
      ),
    );
  }

  Future<void> _showConfirmationAlert(Shipping shipping, BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Envio',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(title: 'Fecha',data: date),
                ShippingData(title: 'Hora', data: date),
                ShippingData(title: 'Usuario', data: context.read<AuthenticationRepository>().user.name),
                ShippingData(title: 'Ubicacion', data: context.read<AuthenticationRepository>().user.location.name),
                ShippingData(title: 'Arroz', data: context.read<EditShipping>().shipping.riceType ?? ''),
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Humedad', data: context.read<EditShipping>().shipping.humidity ?? ''),
                ShippingData(title: 'Chofer', data: context.read<EditShipping>().shipping.driverName ?? ''),
                ShippingData(title: 'Camion', data: context.read<EditShipping>().shipping.truckPatent ?? ''),
                ShippingData(title: 'Chasis', data: context.read<EditShipping>().shipping.chasisPatent ?? ''),
                if (shipping.shippingState == ShippingStatus.newShipping)
                  ...[
                    ShippingData(title: 'Peso Tara', data: shipping.remiterTara.toString()),
                    ShippingData(title: 'Peso Bruto', data: shipping.remiterFullWeight.toString()),
                    ShippingData(title: 'Peso Neto', data: shipping.remiterWetWeight.toString()),
                  ],                  
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  ...[
                    ShippingData(title: 'Peso Neto', data: shipping.remiterWetWeight.toString()),
                    ShippingData(title: 'Peso Seco', data: shipping.remiterDryWeight.toString()),
                    ShippingData(title: 'Peso Bruto', data: shipping.reciverFullWeight.toString()),
                  ],                  
                if (shipping.shippingState == ShippingStatus.downloadedShipping)
                  ...[
                    ShippingData(title: 'Peso Bruto', data: shipping.reciverFullWeight.toString()),
                    ShippingData(title: 'Peso Tara', data: shipping.reciverTara.toString()),
                    ShippingData(title: 'Peso Neto', data: shipping.reciverWetWeight.toString()),
                    ShippingData(title: 'Peso Seco',data: shipping.reciverDryWeight.toString()),
                  ],
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    context.read<EditShippingCubit>().uploadSihpping();
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
          actions: <Widget>[],
          actionsPadding: EdgeInsets.symmetric(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        );
      },
    );
  }
}