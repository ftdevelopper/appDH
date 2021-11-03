import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShippingPage extends StatelessWidget {

  final int index;
  late List<String> _producto = ['23543','2341234','65433','3515123','43215','2413'];
  late List<String> _riceType = ['Doble Carolina', 'Integral', 'Largo Fino', 'No se pasa', 'Aromatico', 'Yamani'];
  late String _cosecha = '...';
  late String _contrato = '...';
  late String _partidaNumero = '...';
  late List<int> _pesoBruto = [2500,4000,1345,4562,2000,3000];
  late List<int> _pesoTara = [222,500,435,334,234,765];
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
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Codigo de Producto: ${_producto[index]}'),
              Text('Tipo de Arroz: ${_riceType[index]}'),
              Text('Peso Bruto: ${_pesoBruto[index]}'),
              Text('Peso Tara: ${_pesoTara[index]}'),
              Text('Peso Neto: ${(_pesoBruto[index] - _pesoTara[index])}'),
              Text('Procedencia: ${_procedencia[0]}'),
              Text('Cosecha: $_cosecha'),
              Text('Contrato: $_contrato'),
              Text('Nuemro de Partida: $_partidaNumero'),
              Text('Fecha de Envio: ${DateFormat.yMd().add_jm().format(DateTime.now().subtract(Duration(hours: index)))}'),
            ]
          ),
        )
      ),
    );
  }
}