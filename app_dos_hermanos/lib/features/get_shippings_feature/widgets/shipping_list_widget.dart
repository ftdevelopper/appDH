import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:flutter/material.dart';

import 'shipping_card.dart';

class ShippingsListWidget extends StatelessWidget {
  ShippingsListWidget({
    Key? key,
    required List<Shipping> shippingList,
    required List<ShippingStatus> status,
  })  : filteredShippingList = shippingList
            .where((element) => (status.contains(element.shippingState)))
            .toList(),
        super(key: key);

  final List<Shipping> filteredShippingList;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: (filteredShippingList.length == 0)
          ? Center(child: Column(children: [Text('No hay envios disponibles')]))
          : ListView.builder(
              itemCount: filteredShippingList.length,
              itemBuilder: (_, index) {
                return ShippingCard(
                  shipping: filteredShippingList[index],
                );
              },
            ),
    );
  }
}
