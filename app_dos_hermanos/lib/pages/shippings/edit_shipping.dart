import 'dart:math';

import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class EditShipping extends StatefulWidget {

  AuthenticationRepository authenticationRepository;
  Shipping shipping;

  EditShipping({Key? key, required this.authenticationRepository, required this.shipping}) : super(key: key);

  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {

  late Shipping _shipping;

  final Stream<String> _weightStream = Stream.periodic(
    Duration(seconds: 1),
    (_){
      int _weight = 39000 + Random().nextInt(5000);
      return _weight.toString();
    }
  );

  @override
  Widget build(BuildContext context) {
    _shipping = widget.shipping;

    return Scaffold(
      appBar: AppBar(title: Text(_shipping.getStatus), centerTitle: true,),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('patente: ${_shipping.patent}'),
                Text('Remiter Tara: ${_shipping.remiterTara}kg'),

                _shipping.shippingState == ShippingStatus.newShipping
                ? StreamBuilder(
                  initialData: 'Weight',
                  stream: _weightStream,
                  builder: (context, AsyncSnapshot<String> snapshot){
                    _shipping.remiterFullWeight = snapshot.data.toString();
                    return Text('Remiter Bruto: ${snapshot.data}kg'); 
                    
                  }
                )
                :Text('Remiter Bruto: ${_shipping.remiterFullWeight}kg'),

                _shipping.shippingState == ShippingStatus.inTravelShipping
                ? StreamBuilder(
                  initialData: 'Weight',
                  stream: _weightStream,
                  builder: (context, AsyncSnapshot<String> snapshot){
                      _shipping.reciverFullWeight = snapshot.data.toString();
                      return Text('Reciver Bruto: ${snapshot.data}kg');
                  }
                )
                : Text('Reciver Bruto :${_shipping.reciverFullWeight}kg'),

                _shipping.shippingState == ShippingStatus.downloadedShipping
                ? StreamBuilder(
                  initialData: 'Weight',
                  stream: _weightStream,
                  builder: (context, AsyncSnapshot<String> snapshot){
                    
                      _shipping.reciverTara = snapshot.data.toString();
                      return Text('Reciver Tara: ${snapshot.data}kg');
                    
                  }
                )
                : Text('Reciver Tara: ${_shipping.reciverTara}kg'),

                _shipping.shippingState == ShippingStatus.newShipping
                ? StreamBuilder(
                  initialData: 'Weight',
                  stream: _weightStream,
                  builder: (context, AsyncSnapshot<String> snapshot){
                    
                      _shipping.remiterTara = snapshot.data.toString();
                      return Text('Remiter Tara: ${snapshot.data}');
                        
                  }
                )
                : Text('Remiter Tara:${_shipping.remiterTara}')
              ],
            ),
          ),
        ),
      ),
    );
  }
}