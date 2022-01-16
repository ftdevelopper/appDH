import 'dart:math';

import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EditShipping extends StatefulWidget {

  AuthenticationRepository authenticationRepository;
  Shipping shipping;

  EditShipping({Key? key, required this.authenticationRepository, required this.shipping}) : super(key: key);

  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {

  late Shipping _shipping;
  late DateTime _date;

  final Stream<String> _weightStream = Stream.periodic(
    Duration(seconds: 1),
    (_){
      int _weight = 39000 + Random().nextInt(5000);
      return _weight.toString();
    }
  );
  
  @override
  void initState() {
    _shipping = widget.shipping;
    _date = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(_shipping.getStatus), centerTitle: true,),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(25),
            child: Column(
              children: <Widget>[


                TextField(
                  controller: TextEditingController()..text = DateFormat('dd-MM-yyyy').format(_date),
                  enabled: false,
                  decoration: InputDecoration(labelText: 'Fecha', icon: Icon(Icons.calendar_today_outlined)),
                ),
                Divider(),

                TextField(
                  controller: TextEditingController()..text = _shipping.driverName,
                  enabled: false,
                  decoration: InputDecoration(labelText: 'Chofer', icon: Icon(Icons.contacts_outlined)),
                ),
                Divider(),

                TextField(
                  controller: TextEditingController()..text = _shipping.truckPatent,
                  enabled: false,
                  decoration: InputDecoration(labelText: 'Patente del Camion', icon: Icon(Icons.local_shipping_rounded)),
                ),
                Divider(),
    
                TextField(
                  controller: TextEditingController()..text = _shipping.chasisPatent,
                  enabled: false,
                  decoration: InputDecoration(labelText: 'Patente del Chasis', icon: Icon(Icons.local_shipping_rounded)),
                ),
                Divider(),


                if(_shipping.shippingState == ShippingStatus.newShipping)
                Column(
                  children: [
                    TextField(
                      controller: TextEditingController()..text = _shipping.remiterTara.toString(),
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Peso Neto - Procedencia', icon: Icon(Icons.filter_1)),
                    ),
                    Divider(),  
                    StreamBuilder(
                      initialData: 'Weight',
                      stream: _weightStream,
                      builder: (context, AsyncSnapshot<String> snapshot){
                        _shipping.remiterFullWeight = snapshot.data.toString();
                        return TextField(
                          controller: TextEditingController()..text = snapshot.data!,
                          enabled: false,
                          decoration: InputDecoration(labelText: 'Peso Bruto - Procedencia', icon: Icon(Icons.filter_2)),
                        );
                      }
                    ),
                  ],
                ),


                if(_shipping.shippingState == ShippingStatus.inTravelShipping)
                Column(
                  children: [
                    TextField(
                      controller: TextEditingController()..text = _shipping.remiterTara.toString(),
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Peso Tara - Procedencia', icon: Icon(Icons.filter_1)),
                    ),
                    Divider(),
                    TextField(
                      controller: TextEditingController()..text = _shipping.remiterFullWeight.toString(),
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Peso Bruto - Procedencia', icon: Icon(Icons.filter_2)),
                    ),
                    Divider(),
                    StreamBuilder(
                      initialData: 'Weight',
                      stream: _weightStream,
                      builder: (context, AsyncSnapshot<String> snapshot){
                        _shipping.reciverFullWeight = snapshot.data.toString();
                        return TextField(
                          controller: TextEditingController()..text = snapshot.data!,
                          enabled: false,
                          decoration: InputDecoration(labelText: 'Peso Bruto - Destino', icon: Icon(Icons.filter_3)),
                        );
                      }
                    ),
                  ],
                ),
                

                if(_shipping.shippingState == ShippingStatus.downloadedShipping)
                Column(
                  children: [
                    TextField(
                      controller: TextEditingController()..text = _shipping.remiterTara.toString(),
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Peso Tara - Procedencia', icon: Icon(Icons.filter_1)),
                    ),
                    Divider(),
                    TextField(
                      controller: TextEditingController()..text = _shipping.remiterFullWeight.toString(),
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Peso Bruto - Procedencia', icon: Icon(Icons.filter_2)),
                    ),
                    Divider(),
                    TextField(
                      controller: TextEditingController()..text = _shipping.reciverFullWeight.toString(),
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Peso Bruto - Destino', icon: Icon(Icons.filter_3)),
                    ),
                    Divider(),
                    StreamBuilder(
                      initialData: 'Weight',
                      stream: _weightStream,
                      builder: (context, AsyncSnapshot<String> snapshot){
                        _shipping.reciverTara = snapshot.data.toString();
                        return TextField(
                          controller: TextEditingController()..text = snapshot.data!,
                          enabled: false,
                          decoration: InputDecoration(labelText: 'Peso Tara - Destino', icon: Icon(Icons.filter_4)),
                        );
                      }
                    ),
                  ],
                ),
    
                ElevatedButton(
                  child: Text('Update Shipping'),
                  onPressed: (){
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
          title: const Text('Shipping Confirmation', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(title: 'Fecha', data: DateFormat('dd-MM-yyyy').format(_date)),
                ShippingData(title: 'Hora', data: DateFormat.Hm().format(_date)),
                ShippingData(title: 'Usuario', data: widget.authenticationRepository.user.name),
                ShippingData(title: 'Ubicacion', data: widget.authenticationRepository.user.location.name),
                ShippingData(title: 'Chofer', data: _shipping.driverName),
                ShippingData(title: 'Camion', data: _shipping.truckPatent),
                ShippingData(title: 'Chasis', data: _shipping.chasisPatent),
                if (_shipping.shippingState == ShippingStatus.newShipping)
                  ShippingData(title: 'Peso Bruto', data: _shipping.remiterFullWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.inTravelShipping)
                  ShippingData(title: 'Peso Bruto', data: _shipping.reciverFullWeight.toString()),
                if (_shipping.shippingState == ShippingStatus.downloadedShipping)
                  ShippingData(title: 'Peso Bruto', data: _shipping.reciverTara.toString()),
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

  void uploadShipping() async {
    switch (_shipping.shippingState) {
      case ShippingStatus.newShipping:
        _shipping.remiterFullWeightTime = _date.toString();
        _shipping.remiterFullWeightUser = widget.authenticationRepository.user.id;
      break;
      case ShippingStatus.inTravelShipping:
        _shipping.reciverFullWeightTime = _date.toString();
        _shipping.reciverFullWeightUser = widget.authenticationRepository.user.id;
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