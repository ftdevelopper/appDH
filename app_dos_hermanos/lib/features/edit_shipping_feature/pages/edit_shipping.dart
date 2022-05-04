import 'package:flutter/material.dart';

import 'package:app_dos_hermanos/features/add_new_shipping_feature/widgets/pesar_button_widget.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/widgets/downloaded_shipping_widget.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/widgets/edit_shipping_widget.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/widgets/finish_shipping_widget.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/widgets/intravel_shipping_widget.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/widgets/new_shipping_widget.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/widgets/update_shipping_button_widget.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';

// ignore: must_be_immutable
class EditShipping extends StatelessWidget {
  EditShipping({
    Key? key,
    required this.shipping,
  }) : super(key: key);

  final Shipping shipping;  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Actualizar Envio'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                EditShippingWidget(),
                if (shipping.shippingState == ShippingStatus.newShipping)
                  NewShippingWidget(),
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  IntravelShippingWidget(),
                if (shipping.shippingState ==
                    ShippingStatus.downloadedShipping)
                  DownloadedShippingWidget(),
                PesarButtonWidget(),
                UpdateShippingButtonWidget(),
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  FinishShippingButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
