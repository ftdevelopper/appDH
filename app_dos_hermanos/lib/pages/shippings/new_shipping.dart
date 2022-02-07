import 'dart:async';
import 'package:app_dos_hermanos/classes/drivers.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/validations/new_shipping_validators.dart';

class NewShipping extends StatefulWidget {
  final Shipping? shipping;
  final AuthenticationRepository authenticationRepository;
  final LocalDataBase localDataBase;
  NewShipping(
      {Key? key,
      this.shipping,
      required this.authenticationRepository,
      required this.localDataBase})
      : super(key: key);

  @override
  _NewShippingState createState() => _NewShippingState();
}

class _NewShippingState extends State<NewShipping> {
  late final Shipping _shipping;
  final formKey = GlobalKey<FormState>();

  LocationRepository locationRepository = LocationRepository();

  late TextEditingController _truckPatentController;
  late TextEditingController _chasisPatentController;
  late TextEditingController _locationController;
  late TextEditingController _driverNameController;
  late TextEditingController _userController;
  late TextEditingController _dateController;

  late DateTime _date;
  late String _formatedDate;

  String cosechaValue = 'CAMPAÑA 20-21';
  String partidaValue = 'CAMPAÑA 20-21';

  Location destination = Location(name: 'SELECCIONAR');
  late List<Driver> drivers;

  @override
  void initState() {
    drivers = widget.localDataBase.driversDB;
    _truckPatentController = TextEditingController();
    _chasisPatentController = TextEditingController();

    _driverNameController = TextEditingController();
    _locationController = TextEditingController(
        text: widget.authenticationRepository.user.location.name);
    _userController =
        TextEditingController(text: widget.authenticationRepository.user.name);

    _shipping = widget.shipping ??
        Shipping(
          isOnLine: true,
            driverName: '',
            truckPatent: '',
            chasisPatent: '',
            shippingState: ShippingStatus.newShipping);
    _date = DateTime.now();
    _formatedDate = DateFormat('yyyy-MM-dd kk:mm').format(_date);
    _dateController = TextEditingController(text: _formatedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothCubit, MyBluetoothState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Nuevo Envio'), centerTitle: true),
          body: SafeArea(
            child: Center(
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.all(25),
                  children: <Widget>[
                    TextFormField(
                      controller: this._userController,
                      decoration: InputDecoration(
                          labelText: 'Usuario',
                          border: InputBorder.none,
                          icon: Icon(Icons.person)),
                      enabled: false,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        return NewShippingValidator.isUserNameValid(
                            widget.authenticationRepository.user.name);
                      },
                    ),
                    Divider(),
                    TextFormField(
                      controller: this._locationController,
                      decoration: InputDecoration(
                          labelText: 'Ubicacion',
                          border: InputBorder.none,
                          icon: Icon(Icons.location_on)),
                      enabled: false,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        return NewShippingValidator.isLocationValid(
                            widget.authenticationRepository.user.location.name);
                      },
                    ),
                    Divider(),
                    TextFormField(
                      controller: this._dateController,
                      decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: InputBorder.none,
                          icon: Icon(Icons.calendar_today_outlined)),
                      enabled: false,
                    ),
                    Divider(),

                    /*DropdownButtonFormField(
                      value: cosechaValue,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(labelText: 'Cosecha', border: InputBorder.none, icon: Icon(Icons.done_outline_outlined)),
                      onChanged: (dynamic newValue ){
                        setState(() {
                          cosechaValue = newValue;
                        });
                      },
                      items: <String>[
                        'CAMPAÑA 20-21','CAMPAÑA 21-22',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Divider(),*/

                    DropdownButtonFormField(
                      value: partidaValue,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Cosecha/Partida',
                          border: InputBorder.none,
                          icon: Icon(Icons.description_sharp)),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          partidaValue = newValue;
                          cosechaValue = newValue;
                        });
                      },
                      items: <String>[
                        'CAMPAÑA 20-21',
                        'CAMPAÑA 21-22',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    DropdownButtonFormField<String>(
                      value: destination.name,
                      decoration: InputDecoration(
                          labelText: 'Destino',
                          border: InputBorder.none,
                          icon: Icon(Icons.location_on)),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        return NewShippingValidator.isLocationValid(
                            destination.name);
                      },
                      onChanged: (dynamic newValue) {
                        setState(() {
                          destination = Location.fromName(newValue);
                        });
                      },
                      items: widget.localDataBase.locationDB
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value.name,
                          child: Text(
                            value.name,
                            overflow: TextOverflow.visible,
                          ),
                        );
                      }).toList(),
                      selectedItemBuilder: (context) {
                        return widget.localDataBase.locationDB
                            .map((value) => Container(
                                  child: Text(value.name,
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
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: this._driverNameController,
                        decoration: InputDecoration(
                            labelText: 'Nombre del Conductor',
                            border: InputBorder.none,
                            icon: Icon(Icons.contacts_outlined)),
                      ),
                      suggestionsCallback: (pattern) {
                        List<String?> names = [];
                        drivers.forEach((element) {
                          if (element.name.toLowerCase().contains(
                              _driverNameController.text.toLowerCase()))
                            names.add(element.name);
                        });
                        return names;
                      },
                      itemBuilder: (context, String? suggestion) {
                        return ListTile(
                          title: Text(suggestion!),
                        );
                      },
                      noItemsFoundBuilder: (context) {
                        return ListTile(
                          leading: Icon(Icons.add),
                          title: Text('No se encontro al conductor'),
                          onTap: () {},
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (String? suggestion) {
                        _driverNameController.text = suggestion!;
                        _truckPatentController.text = drivers.firstWhere((element) => element.name == _driverNameController.text).patent;
                        _chasisPatentController.text = drivers.firstWhere((element) => element.name == _driverNameController.text).chasisPatent;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        //TODO: IMPLEMENT VALIDATION
                      },
                    ),
                    Divider(),
                    TextFormField(
                      enabled: false,
                      controller: this._truckPatentController,
                      decoration: InputDecoration(
                        labelText: 'Patente del Camion',
                        border: InputBorder.none,
                        icon: Icon(Icons.local_shipping_rounded),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      enabled: false,
                      controller: this._chasisPatentController,
                      decoration: InputDecoration(
                        labelText: 'Patente del Chasis',
                        border: InputBorder.none,
                        icon: Icon(Icons.local_shipping_rounded),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: TextEditingController(text: state.data),
                      decoration: InputDecoration(
                          labelText: 'Peso Tara',
                          border: InputBorder.none,
                          icon: Icon(Icons.calendar_today_outlined)),
                      enabled: true,
                      onChanged: (value){
                        state.data = value;
                      },
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: ElevatedButton(
                        child: Text('Pesar'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          primary: Colors.red.shade700,
                        ),
                        onPressed:() async {
                          BlocProvider.of<BluetoothCubit>(context)
                              .requestWeight(patent: _truckPatentController.text, comand: "T", date: _formatedDate);
                        }
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: ElevatedButton(
                        child: Text('Agregar Nuevo Envio'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          primary: Colors.red.shade700,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _shipping.remiterTara = state.data;
                            _showConfirmationAlert();
                          }
                        },
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
            'Confimacion Nuevo Envio',
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
                    title: 'Ubicacion', data: _locationController.text),
                ShippingData(title: 'Partida', data: partidaValue),
                ShippingData(title: 'Cosecha', data: cosechaValue),
                ShippingData(title: 'Destino', data: destination.name),
                ShippingData(title: 'Chofer', data: _driverNameController.text),
                ShippingData(
                    title: 'Camion', data: _truckPatentController.text),
                ShippingData(
                    title: 'Chasis', data: _chasisPatentController.text),
                ShippingData(
                    title: 'Peso Tara', data: _shipping.remiterTara.toString()),
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

  void uploadShipping() {
    _shipping.crop = cosechaValue;
    _shipping.departure = partidaValue;

    _shipping.reciverLocation = destination.name;

    _shipping.driverName = _driverNameController.text;
    _shipping.truckPatent = _truckPatentController.text;
    _shipping.chasisPatent = _chasisPatentController.text;
    _shipping.remiterTaraUser = widget.authenticationRepository.user.id;
    _shipping.remiterTaraTime = _date;
    _shipping.truckPatent = _truckPatentController.text;
    _shipping.remiterLocation = _locationController.text;
    _shipping.addAction(action: 'Taro', user: _userController.text, date: _formatedDate);

    BlocProvider.of<ShippingsBloc>(context)
        .add(AddShipping(shipping: _shipping));
    Navigator.pop(context);
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _truckPatentController.dispose();
    super.dispose();
  }
}
