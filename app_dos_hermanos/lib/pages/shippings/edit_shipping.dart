import 'dart:math';

import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:app_dos_hermanos/validations/new_shipping_validators.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EditShipping extends StatefulWidget {
  AuthenticationRepository authenticationRepository;
  Shipping shipping;
  LocalDataBase localDataBase;

  EditShipping(
      {Key? key,
      required this.authenticationRepository,
      required this.shipping,
      required this.localDataBase
      })
      : super(key: key);

  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {
  late Shipping _shipping;
  late DateTime _date;

  late TextEditingController _humidityController;
   late String riceValue = 'Tipo de Arroz';

  final Stream<String> _weightStream =
      Stream.periodic(Duration(seconds: 1), (_) {
    int _weight = 39000 + Random().nextInt(5000);
    return _weight.toString();
  });

  @override
  void initState() {
    _shipping = widget.shipping;
    _date = DateTime.now();
    _humidityController = TextEditingController();
    super.initState();
  }

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
                TextField(
                  controller: TextEditingController()
                    ..text = DateFormat('dd-MM-yyyy').format(_date),
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Fecha',
                      icon: Icon(Icons.calendar_today_outlined)),
                ),
                Divider(),
                TextField(
                  controller: TextEditingController()
                    ..text = _shipping.driverName,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Chofer', icon: Icon(Icons.contacts_outlined)),
                ),
                Divider(),
                TextField(
                  controller: TextEditingController()
                    ..text = _shipping.truckPatent,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Patente del Camion',
                      icon: Icon(Icons.local_shipping_rounded)),
                ),
                Divider(),
                TextField(
                  controller: TextEditingController()
                    ..text = _shipping.chasisPatent,
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: 'Patente del Chasis',
                      icon: Icon(Icons.local_shipping_rounded)),
                ),
                Divider(),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  Column(
                    children: [
                      Divider(),
                      DropdownButtonFormField<String>(
                        value: riceValue,
                        decoration: InputDecoration(
                            labelText: 'Tipo de arroz',
                            border: InputBorder.none,
                            icon: Icon(Icons.rice_bowl)),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (_) {
                          return NewShippingValidator.isRiceValid(riceValue);
                        },
                        onChanged: (dynamic newValue) {
                          setState(() {
                            riceValue = newValue;
                          });
                        },
                        items: widget.localDataBase.riceDB
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.type,
                            child: Text(
                              value.type,
                              overflow: TextOverflow.visible,
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (context) {
                          return widget.localDataBase.riceDB
                              .map((value) => Container(
                                    child: Text(value.type,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ))
                              .toList();
                        },
                      ),
                      Divider(),
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
                            labelText: 'Peso Neto - Procedencia',
                            icon: Icon(Icons.filter_1)),
                      ),
                      Divider(),
                      StreamBuilder(
                          initialData: 'Weight',
                          stream: _weightStream,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            _shipping.remiterFullWeight =
                                snapshot.data.toString();
                            return TextField(
                              controller: TextEditingController()
                                ..text = snapshot.data!,
                              enabled: false,
                              decoration: InputDecoration(
                                  labelText: 'Peso Bruto - Procedencia',
                                  icon: Icon(Icons.filter_2)),
                            );
                          }),
                    ],
                  ),
                if (_shipping.shippingState == ShippingStatus.inTravelShipping)
                  Column(
                    children: [
                      TextField(
                        controller: TextEditingController()
                          ..text = _shipping.remiterTara.toString(),
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: 'Peso Tara - Procedencia',
                            icon: Icon(Icons.filter_1)),
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
                      StreamBuilder(
                          initialData: 'Weight',
                          stream: _weightStream,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            _shipping.reciverFullWeight =
                                snapshot.data.toString();
                            return TextField(
                              controller: TextEditingController()
                                ..text = snapshot.data!,
                              enabled: false,
                              decoration: InputDecoration(
                                  labelText: 'Peso Bruto - Destino',
                                  icon: Icon(Icons.filter_3)),
                            );
                          }),
                    ],
                  ),
                if (_shipping.shippingState ==
                    ShippingStatus.downloadedShipping)
                  Column(
                    children: [
                      TextField(
                        controller: TextEditingController()
                          ..text = _shipping.remiterTara.toString(),
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: 'Peso Tara - Procedencia',
                            icon: Icon(Icons.filter_1)),
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
                      TextField(
                        controller: TextEditingController()
                          ..text = _shipping.reciverFullWeight.toString(),
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: 'Peso Bruto - Destino',
                            icon: Icon(Icons.filter_3)),
                      ),
                      Divider(),
                      StreamBuilder(
                          initialData: 'Weight',
                          stream: _weightStream,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            _shipping.reciverTara = snapshot.data.toString();
                            return TextField(
                              controller: TextEditingController()
                                ..text = snapshot.data!,
                              enabled: false,
                              decoration: InputDecoration(
                                  labelText: 'Peso Tara - Destino',
                                  icon: Icon(Icons.filter_4)),
                            );
                          }),
                    ],
                  ),
                ElevatedButton(
                  child: Text('Actualizar Envio'),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      primary: Colors.red.shade700),
                  onPressed: () {
                    _showConfirmationAlert();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationAlert() async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Shipping Confirmation',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(
                    title: 'Fecha',
                    data: DateFormat('dd-MM-yyyy').format(_date)),
                ShippingData(
                    title: 'Hora', data: DateFormat.Hm().format(_date)),
                ShippingData(
                    title: 'Usuario',
                    data: widget.authenticationRepository.user.name),
                ShippingData(
                    title: 'Ubicacion',
                    data: widget.authenticationRepository.user.location.name),
                ShippingData(title: 'Arroz', data: riceValue),
                ShippingData(title: 'Humedad', data: _humidityController.text),
                ShippingData(title: 'Chofer', data: _shipping.driverName),
                ShippingData(title: 'Camion', data: _shipping.truckPatent),
                ShippingData(title: 'Chasis', data: _shipping.chasisPatent),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(
                      title: 'Peso Bruto',
                      data: _shipping.remiterFullWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(
                      title: 'Peso Bruto',
                      data: _shipping.reciverFullWeight.toString()),
                if (_shipping.shippingState ==
                    ShippingStatus.downloadedShipping)
                  ShippingData(
                      title: 'Peso Bruto',
                      data: _shipping.reciverTara.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
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

  void uploadShipping() async {
    switch (_shipping.shippingState) {
      case ShippingStatus.newShipping:
        _shipping.remiterFullWeightTime = _date.toString();
        _shipping.remiterFullWeightUser =
            widget.authenticationRepository.user.id;
        _shipping.riceType = riceValue;
        _shipping.humidity = _humidityController.text;
        break;
      case ShippingStatus.inTravelShipping:
        _shipping.reciverFullWeightTime = _date.toString();
        _shipping.reciverFullWeightUser =
            widget.authenticationRepository.user.id;
        break;
      case ShippingStatus.downloadedShipping:
        _shipping.reciverTaraTime = _date.toString();
        _shipping.reciverTaraUser = widget.authenticationRepository.user.id;
        break;
      default:
    }
    _shipping.nextStatus();
    await ShippingRepository().updateParameter(shipping: _shipping);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
