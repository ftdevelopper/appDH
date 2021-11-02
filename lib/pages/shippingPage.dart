import 'package:flutter/material.dart';

class ShippingPage extends StatelessWidget {

  final int index;
  late List<String> _producto = [''];
  late List<String> _riceType = ['Blanco', 'Integral', 'Yamani', 'Bomba', 'Rojo', 'Salvaje'];
  late List<String> _cosecha = [];
  late List<String> _contrato = [];
  late List<String> _partidaNumero = [];
  late List<String> _pesoBruto = [];
  late List<String> _pesoTara = [];
  late List<String> _procedencia = ['Campo $index'];

  ShippingPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dos Hermanos'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Text(index.toString())
      ),
    );
  }
}