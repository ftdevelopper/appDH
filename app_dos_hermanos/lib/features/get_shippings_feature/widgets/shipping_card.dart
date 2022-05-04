import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/pages/edit_shipping.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/pages/resume_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingCard extends StatelessWidget {
  ShippingCard({required this.shipping});
  final Shipping shipping;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white70,
            textStyle: TextStyle(color: Colors.black),
            elevation: 2.0),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: shipping.statusIcon,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(children: <Widget>[
                      Text(
                        'Patente: ${shipping.truckPatent}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        'Destino: ${shipping.reciverLocation}',
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                      ),
                      Text(
                        'Origen: ${shipping.remiterLocation}',
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                      ),
                      Text(
                        'Hora Tara: ${shipping.remiterTaraTime}',
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                      ),
                    ]),
                  ),
                  if (!(shipping.isOnLine ?? false))
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 30,
                    )
                ],
              ),
            ],
          ),
        ),
        onPressed: () {
          context.read<EditShippingCubit>().setShipping(shipping);
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => EditShipping(shipping: shipping),
            ),
          );
        },
        onLongPress: () {
          Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (_) => ResumePage(shipping: shipping)));
        },
      ),
    );
  }
}