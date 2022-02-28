import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              BlocProvider.of<BluetoothCubit>(context).requestWeight(
                  patent: _shipping.truckPatent,
                  comand: "T",
                  date: _formatedDate);
            }),
      ),
    );
  }
}
