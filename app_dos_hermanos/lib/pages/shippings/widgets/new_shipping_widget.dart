import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewShippingWidget extends StatelessWidget {
  const NewShippingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: this._loteController,
            decoration: InputDecoration(
              labelText: 'Lote',
              border: InputBorder.none,
              icon: Icon(Icons.document_scanner),
            ),
          ),
          suggestionsCallback: (pattern) {
            List<String?> lotes = [];
            lotesDB.forEach((lote) {
              if (lote.lote
                  .toLowerCase()
                  .contains(_loteController.text.toLowerCase()))
                lotes.add(lote.lote);
            });
            return lotes;
          },
          itemBuilder: (context, String? suggestion) {
            return ListTile(
              title: Text(suggestion!),
            );
          },
          noItemsFoundBuilder: (context) {
            return ListTile(
              leading: Icon(Icons.add),
              title: Text('No se encontro lote'),
              onTap: () {},
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (String? suggestion) {
            _loteController.text = suggestion!;
            setState(() {
              _riceController.text = lotesDB
                  .firstWhere((element) => element.lote == suggestion)
                  .riceType;
            });
            print('Tipo de arroz: ${_riceController.text}');
          },
        ),
        Divider(),
        TextFormField(
          enabled: false,
          controller: _riceController,
          decoration: InputDecoration(
              labelText: 'Tipo de arroz',
              border: InputBorder.none,
              icon: Icon(Icons.rice_bowl)),
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Divider(),
        TextField(
          controller: TextEditingController()
            ..text = _shipping.remiterTara.toString(),
          enabled: false,
          decoration: InputDecoration(
              labelText: 'Peso Tara - Procedencia', icon: Icon(Icons.filter_1)),
        ),
        Divider(),
        TextFormField(
          controller: TextEditingController(text: state.data),
          decoration: InputDecoration(
              labelText: 'Peso Bruto - Procedencia',
              icon: Icon(Icons.filter_2)),
          enabled: true,
          onChanged: (value) {
            state.data = value;
          },
        ),
      ],
    );
  }
}