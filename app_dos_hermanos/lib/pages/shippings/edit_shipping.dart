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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}