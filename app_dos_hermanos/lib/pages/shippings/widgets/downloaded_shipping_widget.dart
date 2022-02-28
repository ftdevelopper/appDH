import 'package:flutter/material.dart';

class DownloadedShippingWidget extends StatelessWidget {
  const DownloadedShippingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      );
  }
}