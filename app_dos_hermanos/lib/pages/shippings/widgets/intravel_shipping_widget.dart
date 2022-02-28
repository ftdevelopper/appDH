import 'package:flutter/material.dart';

class IntravelShippingWidget extends StatelessWidget {
  const IntravelShippingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Humedad',
              border: InputBorder.none,
              icon: Icon(Icons.water_sharp)),
          controller: _humidityController,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) {
            String humidity;
            _humidityController.text.length == 0
                ? humidity = '1'
                : humidity = _humidityController.text;
            return NewShippingValidator.isHumidityValid(humidity);
          },
        ),
        Divider(),
        TextField(
          controller: TextEditingController()
            ..text = _shipping.remiterTara.toString(),
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Peso Tara - Procedencia', icon: Icon(Icons.filter_1)),
        ),
        Divider(),
        TextField(
          controller: TextEditingController()
            ..text = _shipping.remiterFullWeight.toString(),
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Peso Bruto - Procedencia',
              icon: Icon(Icons.filter_2)),
        ),
        Divider(),
        TextFormField(
          controller: TextEditingController(text: state.data),
          decoration: InputDecoration(
              labelText: 'Peso Bruto - Destino', icon: Icon(Icons.filter_3)),
          enabled: true,
          onChanged: (value) {
            state.data = value;
          },
        ),
      ],
    );
  }
}
