import 'package:flutter/material.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/update_shipping_button_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/downloaded_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/finish_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/intravel_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/new_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/pesar_button_widget.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/edit_shipping_widget.dart';

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
                EditShippingWidget(
                  shipping: shipping,
                ),
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
