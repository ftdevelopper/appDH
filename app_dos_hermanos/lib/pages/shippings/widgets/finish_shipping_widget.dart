import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinishShippingButtonWidget extends StatelessWidget {
  const FinishShippingButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Envio Recibido'), Icon(Icons.warning)],
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            primary: Colors.amber.shade700,
          ),
          onPressed: () {
            _showRecivedConfirmationAlert();
          },
        ),
      ),
    );
  }
  Future<void> _showRecivedConfirmationAlert(Shipping shipping) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Recepcion de Envio',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(title: 'Fecha', data: DateFormat('dd-MM-yyyy').format(_date)),
                ShippingData(title: 'Hora', data: DateFormat.Hm().format(_date)),
                ShippingData(title: 'Usuario', data: widget.authenticationRepository.user.name),
                ShippingData(title: 'Ubicacion', data: widget.authenticationRepository.user.location.name),
                ShippingData(title: 'Arroz', data: riceValue),
                ShippingData(title: 'Chofer', data: shipping.driverName),
                ShippingData(title: 'Camion', data: shipping.truckPatent),
                ShippingData(title: 'Chasis', data: shipping.chasisPatent),
                ShippingData(title: 'Peso Tara', data: shipping.remiterTara.toString()),
                ShippingData(title: 'Peso Bruto', data: shipping.remiterFullWeight.toString()),
                ShippingData(title: 'Peso Neto', data: shipping.remiterWetWeight.toString()),
                ShippingData(title: 'Humedad', data: shipping.humidity.toString()),
                ShippingData(title: 'Peso Seco', data: shipping.remiterDryWeight.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    shipping.addAction(
                      action: 'Confirmo Recepcion',
                      user: widget.authenticationRepository.user.id,
                      date: _formatedDate
                    );
                    shipping.shippingState = ShippingStatus.completedShipping;
                    shipping.reciverFullWeightTime = _date;
                    shipping.reciverFullWeightUser =
                    widget.authenticationRepository.user.id;
                    shipping.reciverTara = shipping.remiterTara;
                    shipping.reciverFullWeight = shipping.remiterFullWeight;
                    shipping.reciverDryWeight = shipping.remiterDryWeight;
                    shipping.reciverWetWeight = shipping.remiterWetWeight;
                    context.read<ShippingsBloc>().add(UpdateShipping(shipping: shipping));
                    Navigator.of(context).pop();
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
