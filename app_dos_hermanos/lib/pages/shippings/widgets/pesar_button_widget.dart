import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/pages/shippings/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:intl/intl.dart';

class PesarButtonWidget extends StatelessWidget {
  const PesarButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
            child: Text('Pesar'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              primary: Colors.red.shade700,
            ),
            onPressed: () {
              context.read<BluetoothCubit>().requestWeight(
                comand: "T",
                patent: context.read<EditShippingState>().shipping.truckPatent ?? '',
                date: DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
              );
            }),
      ),
    );
  }
}
