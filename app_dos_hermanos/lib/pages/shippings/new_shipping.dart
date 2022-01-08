import 'dart:async';
import 'dart:math';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  late TextEditingController _patentController;
  late TextEditingController _locationController;

  @override
  void initState() {
    _patentController = TextEditingController();
    _locationController = TextEditingController();
    _shipping = widget.shipping ?? Shipping(patent: '', shippingState: ShippingStatus.newShipping);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Shipping'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.authenticationRepository.user.name),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value){
                    return value!.isEmpty ? 'Location is required' : null;
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  controller: _patentController,
                  decoration: InputDecoration(labelText: 'Patent'),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value){
                    return value!.isEmpty ? 'Patent is required' : null;
                  },
                ),
                SizedBox(height: 15,),
                StreamBuilder(
                  initialData: 'Weight',
                  stream: _weightStream,
                  builder: (context, AsyncSnapshot<String> snapshot){
                    _shipping.remiterTara = snapshot.data.toString();
                    return Text(snapshot.data.toString());
                  },
                ),
                ElevatedButton(
                  child: Text('Add new shipping'),
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
                Text('Are you sure you want to send upload this Shipping?', textAlign: TextAlign.center,),
                Text('Location: ${_locationController.text}', textAlign: TextAlign.center,),
                Text('Patent: ${_patentController.text}', textAlign: TextAlign.center,),
                Text('Tara: ${_shipping.remiterTara}', textAlign: TextAlign.center,),
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
    setState(() {
      _shipping.patent = _patentController.text;
      _shipping.remiterLocation = _locationController.text;
    });
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
    _patentController.dispose();
    super.dispose();
  }
}