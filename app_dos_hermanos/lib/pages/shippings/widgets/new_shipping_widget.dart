import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/pages/shippings/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class NewShippingWidget extends StatelessWidget {
  const NewShippingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditShippingCubit, EditShippingState>(
      builder: (context, state) {
        return Column(
          children: [
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: TextEditingController(text: state.shipping.lote),
                decoration: InputDecoration(
                  labelText: 'Lote',
                  border: InputBorder.none,
                  icon: Icon(Icons.document_scanner),
                ),
              ),
              suggestionsCallback: (pattern) {
                return context.read<LocalDataBase>().loteDB
                .map((element) {
                  if (element.lote.toLowerCase().contains(pattern.toLowerCase())){
                    return element.lote;
                  }
                });
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
                context.read<EditShippingCubit>().updateShippingParameter(
                  Shipping(
                    lote: suggestion,
                    riceType: context.read<LocalDataBase>().loteDB
                      .firstWhere((element) => element.lote == suggestion)
                      .riceType,
                  ),
                );
              },
            ),
            Divider(),
            TextFormField(
              enabled: false,
              controller: TextEditingController(text: state.shipping.riceType),
              decoration: InputDecoration(
                  labelText: 'Tipo de arroz',
                  border: InputBorder.none,
                  icon: Icon(Icons.rice_bowl)),
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Divider(),
            TextField(
              controller: TextEditingController()
                ..text = state.shipping.remiterTara.toString(),
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Peso Tara - Procedencia', icon: Icon(Icons.filter_1)),
            ),
            Divider(),
            TextFormField(
              controller: TextEditingController(text: state.shipping.remiterFullWeight),
              decoration: InputDecoration(
                  labelText: 'Peso Bruto - Procedencia',
                  icon: Icon(Icons.filter_2)),
              enabled: true,
              onChanged: (value) {
                context.read<EditShippingCubit>().updateShippingParameter(Shipping(
                  remiterFullWeight: value
                ));
              },
            ),
          ],
        );
      },
    );
  }
}