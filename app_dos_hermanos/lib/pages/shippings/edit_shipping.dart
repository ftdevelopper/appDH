import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/lote.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/validations/new_shipping_validators.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
      required this.localDataBase})
      : super(key: key);

  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {
  late Shipping _shipping;
  late DateTime _date;
  late String _formatedDate;

  late TextEditingController _humidityController;
  late TextEditingController _riceController;
  late TextEditingController _loteController;
  late String riceValue = 'Tipo de Arroz';
  late List<Lote> lotesDB;

  @override
  void initState() {
    _shipping = widget.shipping;
    _date = DateTime.now();
    _formatedDate = DateFormat('yyyy-MM-dd kk:mm').format(_date);
    _humidityController = TextEditingController();
    lotesDB = widget.localDataBase.loteDB;
    _loteController = TextEditingController();
    _riceController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothCubit, MyBluetoothState>(
      builder: (context, state) {
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
                      controller: TextEditingController()..text = _formatedDate,
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
                          labelText: 'Chofer',
                          icon: Icon(Icons.contacts_outlined)),
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
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: this._loteController,
                              decoration: InputDecoration(
                                  labelText: 'Lote',
                                  border: InputBorder.none,
                                  icon: Icon(Icons.document_scanner),
                              ),
                            ),
                            suggestionsCallback: (pattern) {
                              List<String?> lotes = [];
                              lotesDB.forEach((lote) {
                                if (lote.lote.toLowerCase().contains(
                                    _loteController.text.toLowerCase()))
                                  lotes.add(lote.lote);
                              });
                              return lotes;
                            },
                            itemBuilder: (context, String? suggestion) {
                              return ListTile(
                                title: Text(suggestion!),
                              );
                            },
                            noItemsFoundBuilder: (context) {
                              return ListTile(
                                leading: Icon(Icons.add),
                                title: Text('No se encontro lote'),
                                onTap: () {},
                              );
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (String? suggestion) {
                              _loteController.text = suggestion!;
                              setState(() {  
                                _riceController.text = lotesDB
                                    .firstWhere((element) =>
                                        element.lote ==
                                        suggestion)
                                    .riceType;
                              });
                              print('Tipo de arroz: ${_riceController.text}');
                            },
                          ),
                          Divider(),
                          TextFormField(
                            enabled: false,
                            controller: _riceController,
                            decoration: InputDecoration(
                                labelText: 'Tipo de arroz',
                                border: InputBorder.none,
                                icon: Icon(Icons.rice_bowl)),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          Divider(),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Humedad',
                                border: InputBorder.none,
                                icon: Icon(Icons.water_sharp)),
                            controller: _humidityController,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (_) {
                              String humidity;
                              _humidityController.text.length == 0
                                  ? humidity = '1'
                                  : humidity = _humidityController.text;
                              return NewShippingValidator.isHumidityValid(
                                  humidity);
                            },
                          ),
                          Divider(),
                          TextField(
                            controller: TextEditingController()
                              ..text = _shipping.remiterTara.toString(),
                            enabled: false,
                            decoration: InputDecoration(
                                labelText: 'Peso Tara - Procedencia',
                                icon: Icon(Icons.filter_1)),
                          ),
                          Divider(),
                          TextFormField(
                            controller: TextEditingController(text: state.data),
                            decoration: InputDecoration(
                                labelText: 'Peso Bruto - Procedencia',
                                icon: Icon(Icons.filter_2)),
                            enabled: true,
                            onChanged: (value){
                              state.data = value;
                            },
                          ),
                        ],
                      ),
                    if (_shipping.shippingState ==
                        ShippingStatus.inTravelShipping)
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
                          TextFormField(
                            controller: TextEditingController(text: state.data),
                            decoration: InputDecoration(
                                labelText: 'Peso Bruto - Destino',
                                icon: Icon(Icons.filter_3)),
                            enabled: true,
                            onChanged: (value){
                              state.data = value;
                            },
                          ),
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
                          TextFormField(
                            controller: TextEditingController(text: state.data),
                            decoration: InputDecoration(
                                labelText: 'Peso Tara - Destino',
                                icon: Icon(Icons.filter_3)),
                            enabled: true,
                            onChanged: (value){
                              state.data = value;
                            },
                          ),
                        ],
                      ),
                    Padding(
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
                              BlocProvider.of<BluetoothCubit>(context)
                                  .requestWeight(
                                      patent: _shipping.truckPatent,
                                      comand: "T",
                                      date: _formatedDate);
                            }),
                      ),
                    ),
                    Padding(
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
                            switch (_shipping.shippingState) {
                              case ShippingStatus.newShipping:
                                _shipping.remiterFullWeight = state.data;
                                _shipping.humidity = _humidityController.text;
                                _shipping.remiterWetWeight = ((double.tryParse(
                                            _shipping.remiterFullWeight ?? '0') ?? 0) -
                                        (double.tryParse(_shipping.remiterTara ?? '0') ?? 0))
                                    .toStringAsFixed(0);
                                _shipping.remiterDryWeight = _shipping
                                    .getDryWeight(
                                        humidity:
                                            double.tryParse(_shipping.humidity ?? '12') ?? 12,
                                        weight: double.tryParse(
                                            _shipping.remiterWetWeight ?? '0') ?? 0)
                                    .toStringAsFixed(0);
                                break;
                              case ShippingStatus.inTravelShipping:
                                _shipping.reciverFullWeight = state.data;
                                break;
                              case ShippingStatus.downloadedShipping:
                                _shipping.reciverTara = state.data;
                                _shipping.reciverWetWeight = ((double.tryParse(
                                            _shipping.reciverFullWeight ?? '0') ?? 0) -
                                        (double.tryParse(_shipping.reciverTara ?? '0') ?? 0))
                                    .toStringAsFixed(0);
                                _shipping.reciverDryWeight = _shipping
                                    .getDryWeight(
                                        humidity:
                                            double.tryParse(_shipping.humidity ?? '0') ?? 12,
                                        weight: double.tryParse(
                                            _shipping.reciverWetWeight ?? '0') ?? 0)
                                    .toStringAsFixed(0);
                                break;
                              default:
                                break;
                            }
                            _showConfirmationAlert();
                          },
                        ),
                      ),
                    ),
                    if (_shipping.shippingState == ShippingStatus.inTravelShipping)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 Text('Envio Recibido'),
                                 Icon(Icons.warning)
                              ],
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
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showConfirmationAlert() async {
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
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Humedad', data: _humidityController.text),
                ShippingData(title: 'Chofer', data: _shipping.driverName),
                ShippingData(title: 'Camion', data: _shipping.truckPatent),
                ShippingData(title: 'Chasis', data: _shipping.chasisPatent),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Tara', data: _shipping.remiterTara.toString()),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Bruto', data: _shipping.remiterFullWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Neto', data: _shipping.remiterWetWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Seco', data: _shipping.remiterDryWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Peso Bruto', data: _shipping.reciverFullWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Bruto', data: _shipping.reciverFullWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Tara', data: _shipping.reciverTara.toString()),
                if (_shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Neto', data: _shipping.reciverWetWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Seco',data: _shipping.reciverDryWeight.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    switch (_shipping.shippingState) {
                      case ShippingStatus.newShipping:
                        _shipping.addAction(
                            action: 'Peso Bruto Inicial',
                            user: widget.authenticationRepository.user.id,
                            date: _formatedDate);
                        break;
                      case ShippingStatus.inTravelShipping:
                        _shipping.addAction(
                            action: 'Peso Bruto Recepcion',
                            user: widget.authenticationRepository.user.id,
                            date: _formatedDate);
                        break;
                      case ShippingStatus.downloadedShipping:
                        _shipping.addAction(
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

  Future<void> _showRecivedConfirmationAlert() async {
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
                ShippingData(title: 'Chofer', data: _shipping.driverName),
                ShippingData(title: 'Camion', data: _shipping.truckPatent),
                ShippingData(title: 'Chasis', data: _shipping.chasisPatent),
                ShippingData(title: 'Peso Tara', data: _shipping.remiterTara.toString()),
                ShippingData(title: 'Peso Bruto', data: _shipping.remiterFullWeight.toString()),
                ShippingData(title: 'Peso Neto', data: _shipping.remiterWetWeight.toString()),
                ShippingData(title: 'Humedad', data: _shipping.humidity.toString()),
                ShippingData(title: 'Peso Seco', data: _shipping.remiterDryWeight.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    _shipping.addAction(
                      action: 'Confirmo Recepcion',
                      user: widget.authenticationRepository.user.id,
                      date: _formatedDate
                    );
                    _shipping.shippingState = ShippingStatus.completedShipping;
                    _shipping.reciverFullWeightTime = _date;
                    _shipping.reciverFullWeightUser =
                    widget.authenticationRepository.user.id;
                    context.read<ShippingsBloc>().add(UpdateShipping(shipping: _shipping));
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

  void uploadShipping() async {
    switch (_shipping.shippingState) {
      case ShippingStatus.newShipping:
        _shipping.remiterFullWeightTime = _date;
        _shipping.remiterFullWeightUser =
            widget.authenticationRepository.user.id;
        _shipping.riceType = _riceController.text;
        _shipping.humidity = _humidityController.text;
        _shipping.lote = _loteController.text;
        break;
      case ShippingStatus.inTravelShipping:
        _shipping.reciverFullWeightTime = _date;
        _shipping.reciverFullWeightUser =
            widget.authenticationRepository.user.id;
        break;
      case ShippingStatus.downloadedShipping:
        _shipping.reciverTaraTime = _date;
        _shipping.reciverTaraUser = widget.authenticationRepository.user.id;
        break;
      default:
    }
    _shipping.nextStatus();
    context.read<ShippingsBloc>().add(UpdateShipping(shipping: _shipping));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
