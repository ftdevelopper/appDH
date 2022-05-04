import 'dart:async';
import 'package:app_dos_hermanos/classes/drivers.dart';
import 'package:app_dos_hermanos/features/add_new_shipping_feature/cubit/new_shipping_cubit/new_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/connect_bluetooth_feature/cubit/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/features/add_new_shipping_feature/widgets/shipping_data.dart';
import 'package:app_dos_hermanos/repositories/location_repository.dart';
import 'package:app_dos_hermanos/repositories/local_data_base.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../utils/validations/new_shipping_validators.dart';

class NewShipping extends StatelessWidget {
  NewShipping({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  final LocationRepository locationRepository = LocationRepository();

  final String cosechaValue = 'CAMPAÑA 20-21';
  final String partidaValue = 'CAMPAÑA 20-21';

  final TextEditingController _driverConroller = TextEditingController();
  final TextEditingController _taraConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Envio'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: BlocBuilder<NewShippingCubit, NewShippingState>(
              builder: (context, state) {
                return ListView(
                  padding: EdgeInsets.all(25),
                  children: <Widget>[
                    TextFormField(
                      controller: TextEditingController(
                          text: context
                              .read<AuthenticationRepository>()
                              .user
                              .name),
                      decoration: InputDecoration(
                          labelText: 'Usuario',
                          border: InputBorder.none,
                          icon: Icon(Icons.person)),
                      enabled: false,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        return NewShippingValidator.isUserNameValid(
                            context.read<AuthenticationRepository>().user.name);
                      },
                    ),
                    Divider(),
                    TextFormField(
                      controller: TextEditingController(
                          text: context
                              .read<AuthenticationRepository>()
                              .user
                              .location
                              .name),
                      decoration: InputDecoration(
                          labelText: 'Ubicacion',
                          border: InputBorder.none,
                          icon: Icon(Icons.location_on)),
                      enabled: false,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (_) {
                        return NewShippingValidator.isLocationValid(context
                            .read<AuthenticationRepository>()
                            .user
                            .location
                            .name);
                      },
                    ),
                    Divider(),
                    TextFormField(
                      controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd kk:mm')
                              .format(DateTime.now())
                              .toString()),
                      decoration: InputDecoration(
                          labelText: 'Fecha',
                          border: InputBorder.none,
                          icon: Icon(Icons.calendar_today_outlined)),
                      enabled: false,
                    ),
                    Divider(),
                    DropdownButtonFormField(
                      value: partidaValue,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Cosecha/Partida',
                          border: InputBorder.none,
                          icon: Icon(Icons.description_sharp)),
                      onChanged: (dynamic newValue) {
                        context
                            .read<NewShippingCubit>()
                            .updateShippingParameter(
                              Shipping(
                                crop: partidaValue,
                                departure: partidaValue,
                              ),
                            );
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
                      value: state.shipping.reciverLocation ?? 'SELECCIONAR',
                      decoration: InputDecoration(
                          labelText: 'Destino',
                          border: InputBorder.none,
                          icon: Icon(Icons.location_on)),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        return NewShippingValidator.isLocationValid(
                            state.shipping.reciverLocation ?? '');
                      },
                      onChanged: (dynamic newValue) {
                        context
                            .read<NewShippingCubit>()
                            .updateShippingParameter(
                                Shipping(reciverLocation: newValue));
                      },
                      items: context
                          .read<LocalDataBase>()
                          .locationDB
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
                        return context
                            .read<LocalDataBase>()
                            .locationDB
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
                        controller: _driverConroller,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Conductor',
                          border: InputBorder.none,
                          icon: Icon(Icons.contacts_outlined),
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        List<Driver> names = [];
                        context.read<LocalDataBase>().driversDB.forEach(
                          (element) {
                            if (element.name.toLowerCase().contains(
                                  _driverConroller.text.toLowerCase(),
                                )) {
                              names.add(element);
                            }
                          },
                        );
                        return names;
                      },
                      itemBuilder: (context, Driver? suggestion) {
                        return ListTile(
                          title: Text(suggestion!.name),
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
                      onSuggestionSelected: (Driver? suggestion) {
                        _driverConroller.text = suggestion!.name;
                        context
                            .read<NewShippingCubit>()
                            .updateShippingParameter(Shipping(
                                driverName: suggestion.name,
                                truckPatent: suggestion.patent,
                                chasisPatent: suggestion.chasisPatent));
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        //TODO: IMPLEMENT VALIDATION
                      },
                    ),
                    Divider(),
                    TextFormField(
                      enabled: false,
                      controller: TextEditingController(
                          text: state.shipping.truckPatent),
                      decoration: InputDecoration(
                        labelText: 'Patente del Camion',
                        border: InputBorder.none,
                        icon: Icon(Icons.local_shipping_rounded),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      enabled: false,
                      controller: TextEditingController(
                          text: state.shipping.chasisPatent),
                      decoration: InputDecoration(
                        labelText: 'Patente del Chasis',
                        border: InputBorder.none,
                        icon: Icon(Icons.local_shipping_rounded),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _taraConroller,
                      decoration: InputDecoration(
                          labelText: 'Peso Tara',
                          border: InputBorder.none,
                          icon: Icon(Icons.calendar_today_outlined)),
                      enabled: true,
                      onChanged: (value) {
                        context
                            .read<NewShippingCubit>()
                            .updateShippingParameter(
                                Shipping(remiterTara: value));
                      },
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                      child: ElevatedButton(
                          child: Text('Pesar'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            primary: Colors.red.shade700,
                          ),
                          onPressed: () async {
                            context.read<BluetoothCubit>().requestWeight(
                                patent: context
                                        .read<NewShippingCubit>()
                                        .state
                                        .shipping
                                        .truckPatent ??
                                    '',
                                comand: "T",
                                date: DateFormat('yyyy-MM-dd kk:mm')
                                    .format(DateTime.now())
                                    .toString());
                          }),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
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
                            _showConfirmationAlert(context);
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        Shipping _shipping = context.read<NewShippingCubit>().state.shipping;
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
                    data: DateFormat('dd-MM-yyyy').format(DateTime.now())),
                ShippingData(
                    title: 'Hora',
                    data: DateFormat.Hm().format(DateTime.now())),
                ShippingData(
                    title: 'Ubicacion', data: _shipping.remiterLocation),
                ShippingData(title: 'Partida', data: _shipping.departure),
                ShippingData(title: 'Cosecha', data: _shipping.crop),
                ShippingData(title: 'Destino', data: _shipping.reciverLocation),
                ShippingData(title: 'Chofer', data: _shipping.driverName),
                ShippingData(title: 'Camion', data: _shipping.truckPatent),
                ShippingData(title: 'Chasis', data: _shipping.chasisPatent),
                ShippingData(
                    title: 'Peso Tara', data: _shipping.remiterTara.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    context.read<NewShippingCubit>().confirmButtonPressed();
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        );
      },
    );
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
}
