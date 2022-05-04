import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:app_dos_hermanos/features/connect_bluetooth_feature/cubit/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';

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
