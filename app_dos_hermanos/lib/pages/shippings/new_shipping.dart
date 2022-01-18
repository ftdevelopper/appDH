import 'dart:async';
import 'dart:math';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/driver.dart';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/drivers_repository.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:app_dos_hermanos/validations/new_shipping_validators.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewShipping extends StatefulWidget {
  final Shipping? shipping;
  final AuthenticationRepository authenticationRepository;
  NewShipping({Key? key, this.shipping, required this.authenticationRepository}) : super(key: key);

  @override
  _NewShippingState createState() => _NewShippingState();
}

class _NewShippingState extends State<NewShipping> {
  late final Shipping _shipping;
  final formKey = GlobalKey<FormState>();

  LocationRepository locationRepository = LocationRepository();
  late List<Location> locations = [];

  late TextEditingController _truckPatentController;
  late TextEditingController _chasisPatentController;
  late TextEditingController _locationController;
  late TextEditingController _driverNameController;
  late TextEditingController _userController;
  late TextEditingController _dateController;
  late TextEditingController _humidityController;
  late DateTime _date;
  late String _formatedDate;

  String cosechaValue = 'CAMPAÑA 20-21';
  String partidaValue = 'CAMPAÑA 20-21';
  late String riceValue = 'Tipo de Arroz';
  Location destination = Location(name: 'SELECCIONAR');

  List<Driver> driver = [
    Driver(name: 'tomi', cuil: '1234', chasisPatents: ['asd123', 'asd234'], driverShippings: [''],truckPatents: ['dfg345', '234dfdg'],did: '12341234'),
    Driver(name: 'tadeo', cuil: '1234', chasisPatents: ['1234sd'], truckPatents: ['asdfwre'], did: 'qwer', driverShippings: ['']),
    Driver(name: 'fede', cuil: '', chasisPatents: ['12341'], truckPatents: ['sdf234'], driverShippings: [''], did: ''),
    Driver(name: 'fernando', cuil: '', chasisPatents: ['asdf2'], truckPatents: ['asdf'], driverShippings: [''], did: '')
  ];

  @override
  void initState(){
    _truckPatentController = TextEditingController();
    _chasisPatentController = TextEditingController();
    _humidityController = TextEditingController();
    _driverNameController = TextEditingController();
    _locationController = TextEditingController(text: widget.authenticationRepository.user.location.name);
    _userController = TextEditingController(text: widget.authenticationRepository.user.name);

    _shipping = widget.shipping ?? Shipping(driverName: '', truckPatent: '', chasisPatent: '', shippingState: ShippingStatus.newShipping);
    _date = DateTime.now();
    _formatedDate = DateFormat('dd-MM-yyyy').format(_date);
    _dateController = TextEditingController(text: _formatedDate);
    super.initState();
  }

  final Stream<String> _weightStream = Stream.periodic(
    Duration(seconds: 1),
    (_){
      
      int _weight = 39000 + Random().nextInt(5000);
      return _weight.toString();
    }
  );

  @override
  Widget build(BuildContext context){
    //TODO: Encontrar una mejor manera de hacer esto
    _loadLocation();
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
                  decoration: InputDecoration(labelText: 'Usuario', border: InputBorder.none, icon: Icon(Icons.person)),
                  enabled: false,
                ),
                Divider(),

                TextFormField(
                  controller: this._locationController,
                  decoration: InputDecoration(labelText: 'Ubicacion', border: InputBorder.none, icon: Icon(Icons.location_on)),
                  enabled: false,
                ),
                Divider(),

                TextFormField(
                  controller: this._dateController,
                  decoration: InputDecoration(labelText: 'Fecha', border: InputBorder.none, icon: Icon(Icons.calendar_today_outlined)),
                  enabled: false,
                ),
                Divider(),

                DropdownButtonFormField(
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
                Divider(),

                DropdownButtonFormField(
                  value: partidaValue,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  decoration:  InputDecoration(labelText: 'Partida', border: InputBorder.none, icon: Icon(Icons.description_sharp)),
                  onChanged: (dynamic newValue ){
                    setState(() {
                      partidaValue = newValue;
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

                //TODO: Check AutoValidationMode
                Divider(),
                DropdownButtonFormField<String>(
                  value: riceValue,
                  decoration: InputDecoration(labelText: 'Tipo de arroz', border: InputBorder.none, icon: Icon(Icons.rice_bowl)),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return NewShippingValidator.isRiceValid(riceValue);
                  },
                  onChanged: (dynamic newValue ){
                    setState(() {
                      riceValue = newValue;
                    });
                  },
                  items: _shipping.rices.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value ,overflow: TextOverflow.visible,),
                    );
                  }).toList(),
                  selectedItemBuilder: (context){
                    return _shipping.rices
                    .map((value) => Container(
                      child: Text(
                        value, 
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1, 
                        softWrap: true
                      ),
                      width: MediaQuery.of(context).size.width*0.7,
                    )
                    ).toList();
                  },
                ),
                Divider(),

                DropdownButtonFormField<String>(
                  value: destination.name,
                  decoration: InputDecoration(labelText: 'Destino', border: InputBorder.none, icon: Icon(Icons.location_on)),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    //TODO: Implement this validation
                  },
                  onChanged: (dynamic newValue ){
                    setState(() {
                      destination = Location.fromName(newValue);
                    });
                  },
                  items: locations.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(value.name ,overflow: TextOverflow.visible,),
                    );
                  }).toList(),
                  selectedItemBuilder: (context){
                    return locations
                    .map((value) => Container(
                      child: Text(
                        value.name, 
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1, 
                        softWrap: true
                      ),
                      width: MediaQuery.of(context).size.width*0.7,
                    )
                    ).toList();
                  },
                ),
                Divider(),


                TextFormField(
                  decoration: InputDecoration(labelText: 'Humedad', border: InputBorder.none, icon: Icon(Icons.water_sharp)),
                  controller: _humidityController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return NewShippingValidator.isHumidityValid(_humidityController.text);
                  },
                ),
                Divider(),

                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._driverNameController,
                    decoration: InputDecoration(labelText: 'Nombre del Conductor', border: InputBorder.none, icon: Icon(Icons.contacts_outlined)),
                  ),
                  suggestionsCallback: (pattern){
                    List<String?> names = [];
                    driver.forEach((element) {if(element.name.toLowerCase().contains(_driverNameController.text.toLowerCase())) names.add(element.name);});
                    return names;
                  },
                  itemBuilder: (context, String? suggestion){
                    return ListTile(
                      title: Text(suggestion!),
                    );
                  },
                  noItemsFoundBuilder: (context){
                    return ListTile(
                      leading: Icon(Icons.add),
                      title: Text('No se encontro al conductor'),
                      subtitle: Text('Presione para cargar nuevo conductor'),
                      onTap: (){
                        //TODO: Implementar Carga de nuevo conductor
                      },
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller){
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String? suggestion){
                    _driverNameController.text = suggestion!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return NewShippingValidator.isNameValid(driver: _driverNameController.text, driverRepository: DriverRepository(drivers: driver));
                  },
                ),
                Divider(),

                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._truckPatentController,
                    decoration: InputDecoration(labelText: 'Patente del Camion', border: InputBorder.none, icon: Icon(Icons.local_shipping_rounded)),
                  ),
                  suggestionsCallback: (pattern){
                    Driver actualDriver = driver.firstWhere((element) => element.name == _driverNameController.text);
                    List<String?> patents = [];
                    actualDriver.truckPatents.forEach((patent) {if(patent.toLowerCase().contains(_truckPatentController.text.toLowerCase())) patents.add(patent);});
                    return patents;
                  },
                  itemBuilder: (context, String? suggestion){
                    return ListTile(
                      title: Text(suggestion!),
                    );
                  },
                  noItemsFoundBuilder: (context){
                    return ListTile(
                      leading: Icon(Icons.add),
                      title: Text('No se encontro la patente'),
                      subtitle: Text('Presione para crear nueva patente para este conductor'),
                      onTap: (){
                        //TODO: Implementar Carga de nueva patente.
                      },
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller){
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String? suggestion){
                    _truckPatentController.text = suggestion!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return NewShippingValidator.isTruckPatentValid(patent: _truckPatentController.text, driver: driver.firstWhere((element) => element.name == _driverNameController.text));
                  },
                ),
                Divider(),

                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._chasisPatentController,
                    decoration: InputDecoration(labelText: 'Patente del Chasis', border: InputBorder.none, icon: Icon(Icons.local_shipping_rounded)),
                  ),
                  suggestionsCallback: (pattern){
                    Driver actualDriver = driver.firstWhere((element) => element.name == _driverNameController.text);
                    int index = actualDriver.truckPatents.indexWhere((element) => element == _truckPatentController.text);
                    List<String?> patents = [];
                    if(actualDriver.chasisPatents[index].contains(_chasisPatentController.text)) {
                      patents.add(actualDriver.chasisPatents[index]);
                    }
                    return patents;
                  },
                  itemBuilder: (context, String? suggestion){
                    return ListTile(
                      title: Text(suggestion!),
                    );
                  },
                  noItemsFoundBuilder: (context){
                    return ListTile(
                      leading: Icon(Icons.add),
                      title: Text('No se encontro la patente'),
                      subtitle: Text('Presione para crear nueva patente para este conductor'),
                      onTap: (){
                        //TODO: Implementar Carga de nueva patente.
                      },
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller){
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String? suggestion){
                    _chasisPatentController.text = suggestion!;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return NewShippingValidator.isChasisPatentValid(chasisPatent: _chasisPatentController.text, truckPatent: _truckPatentController.text, driver: driver.firstWhere((element) => element.name == _driverNameController.text));
                  },
                ),
                Divider(),

                Text('             Peso', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Row(
                  children: [
                    Icon(Icons.location_searching_outlined),
                    SizedBox(width: 20,),
                    StreamBuilder(
                      initialData: 'Weight',
                      stream: _weightStream,
                      builder: (context, AsyncSnapshot<String> snapshot){
                        _shipping.remiterTara = snapshot.data.toString();
                        return Text(snapshot.data.toString(),style: TextStyle(fontSize: 25,color: Colors.red),);
                      },
                    ),
                  ],
                ),
                Divider(),

                ElevatedButton(
                  child: Text('Add new shipping'),
                  onPressed: (){
                    if (formKey.currentState!.validate()){
                      _showConfirmationAlert();
                    }
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
          title: const Text('Confimacion Nuevo Envio', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(title: 'Fecha', data: DateFormat('dd-MM-yyyy').format(_date)),
                ShippingData(title: 'Hora', data: DateFormat.Hm().format(_date)),
                ShippingData(title: 'Ubicacion', data: _locationController.text),
                ShippingData(title: 'Partida', data: partidaValue),
                ShippingData(title: 'Cosecha', data: cosechaValue),
                ShippingData(title: 'Arroz', data: riceValue),
                ShippingData(title: 'Destino', data: destination.name),
                ShippingData(title: 'Humedad', data: _humidityController.text),
                ShippingData(title: 'Chofer', data: _driverNameController.text),
                ShippingData(title: 'Camion', data: _truckPatentController.text),
                ShippingData(title: 'Chasis', data: _chasisPatentController.text),
                ShippingData(title: 'Peso Tara', data: _shipping.remiterTara.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: (){
                    uploadShipping();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            
          ],
          actionsPadding: EdgeInsets.symmetric(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          
        );
      },
    );
  }

  void uploadShipping(){
    _shipping.crop = cosechaValue;
    _shipping.departure = partidaValue;
    _shipping.riceType = riceValue;
    _shipping.reciverLocation = destination.name;
    _shipping.humidity = _humidityController.text;
    _shipping.driverName = _driverNameController.text;
    _shipping.truckPatent = _truckPatentController.text;
    _shipping.chasisPatent = _chasisPatentController.text;
    _shipping.remiterTaraUser = widget.authenticationRepository.user.id;
    _shipping.remiterTaraTime = _date.toString();
    _shipping.truckPatent = _truckPatentController.text;
    _shipping.remiterLocation = _locationController.text;

    BlocProvider.of<ShippingsBloc>(context).add(AddShipping(shipping: _shipping));
    Navigator.pop(context);
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if (form!.validate()){
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

  void _loadLocation() async {
    locations = await locationRepository.getLocations();
  }
}