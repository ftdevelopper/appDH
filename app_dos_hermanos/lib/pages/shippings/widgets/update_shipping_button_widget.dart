import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';

class UpdateShippingButtonWidget extends StatelessWidget {
  const UpdateShippingButtonWidget({Key? key}) : super(key: key);

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
            switch (shipping.shippingState) {
              case ShippingStatus.newShipping:
                shipping.remiterFullWeight = state.data;
                break;
              case ShippingStatus.inTravelShipping:
                shipping.humidity = _humidityController.text;
                shipping.remiterWetWeight =
                    ((double.tryParse(shipping.remiterFullWeight ?? '0') ??
                                0) -
                            (double.tryParse(shipping.remiterTara ?? '0') ??
                                0))
                        .toStringAsFixed(0);
                shipping.remiterDryWeight = shipping
                    .getDryWeight(
                        humidity:
                            double.tryParse(shipping.humidity ?? '12') ?? 12,
                        weight: double.tryParse(
                                shipping.remiterWetWeight ?? '0') ??
                            0)
                    .toStringAsFixed(0);
                shipping.reciverFullWeight = state.data;
                shipping.reciverWetWeight =
                    ((double.tryParse(shipping.reciverFullWeight ?? '0') ??
                                0) -
                            (double.tryParse(shipping.reciverTara ?? '0') ??
                                0))
                        .toStringAsFixed(0);
                shipping.reciverDryWeight = shipping
                    .getDryWeight(
                        humidity:
                            double.tryParse(shipping.humidity ?? '0') ?? 12,
                        weight: double.tryParse(
                                shipping.reciverWetWeight ?? '0') ??
                            0)
                    .toStringAsFixed(0);
                break;
              case ShippingStatus.downloadedShipping:
                shipping.reciverTara = state.data;
                break;
              default:
                break;
            }
            _showConfirmationAlert().then((_) => state.data = '');
          },
        ),
      ),
    );
  }

  Future<void> _showConfirmationAlert(Shipping shipping) async {
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
                ShippingData(title: 'Fecha',data: DateFormat('dd-MM-yyyy').format(_date)),
                ShippingData(title: 'Hora', data: DateFormat.Hm().format(_date)),
                ShippingData(title: 'Usuario', data: widget.authenticationRepository.user.name),
                ShippingData(title: 'Ubicacion', data: widget.authenticationRepository.user.location.name),
                ShippingData(title: 'Arroz', data: riceValue),
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Humedad', data: _humidityController.text),
                ShippingData(title: 'Chofer', data: shipping.driverName),
                ShippingData(title: 'Camion', data: shipping.truckPatent),
                ShippingData(title: 'Chasis', data: shipping.chasisPatent),
                if (shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Tara', data: shipping.remiterTara.toString()),
                if (shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Bruto', data: shipping.remiterFullWeight.toString()),
                if (shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Neto', data: shipping.remiterWetWeight.toString()),
                  if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Peso Neto', data: shipping.remiterWetWeight.toString()),
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Peso Seco', data: shipping.remiterDryWeight.toString()),
                if (shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Peso Bruto', data: shipping.reciverFullWeight.toString()),
                if (shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Bruto', data: shipping.reciverFullWeight.toString()),
                if (shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Tara', data: shipping.reciverTara.toString()),
                if (shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Neto', data: shipping.reciverWetWeight.toString()),
                if (shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Seco',data: shipping.reciverDryWeight.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    switch (shipping.shippingState) {
                      case ShippingStatus.newShipping:
                        shipping.addAction(
                            action: 'Peso Bruto Inicial',
                            user: widget.authenticationRepository.user.id,
                            date: _formatedDate);
                        break;
                      case ShippingStatus.inTravelShipping:
                        shipping.addAction(
                            action: 'Peso Bruto Recepcion',
                            user: widget.authenticationRepository.user.id,
                            date: _formatedDate);
                      break;
                      case ShippingStatus.downloadedShipping:
                        shipping.addAction(
                            action: 'Taro Recepcion',
                            user: widget.authenticationRepository.user.id,
                            date: _formatedDate);
                        break;
                      default:
                    }
                    uploadShipping();
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
