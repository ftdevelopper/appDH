import 'package:app_dos_hermanos/blocs/filter_bloc/filter_bloc.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class FilterDialog extends StatelessWidget {
  FilterDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: Text(
        'Filtrar',
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.4,
        child: BlocBuilder<FilterBloc, FilterState>(
          builder: (context, state) {
            return ListView(
              children: <Widget>[
                NumberPicker(
                  maxValue: 900,
                  minValue: 0,
                  value: state.filter.duration!.inDays,
                  step: 1,
                  onChanged: (newValue) {
                    context.read<FilterBloc>().add(ChangeDays(days: newValue));
                  },
                ),
                DropdownButtonFormField<String>(
                  value: state.filter.origin,
                  decoration: InputDecoration(
                      labelText: 'Origen',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on)),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  onChanged: (dynamic newValue) {
                    BlocProvider.of<FilterBloc>(context)
                        .add(ChangeOrigin(origin: newValue));
                  },
                  items: context
                      .read<LocalDataBase>()
                      .locationDB
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(
                        value.name,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return context
                        .read<LocalDataBase>()
                        .locationDB
                        .map((value) => Container(
                              child: Text(value.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true),
                              width: MediaQuery.of(context).size.width * 0.5,
                            ))
                        .toList();
                  },
                ),
                DropdownButtonFormField<String>(
                  value: state.filter.destination,
                  decoration: InputDecoration(
                      labelText: 'Destino',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on)),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  onChanged: (dynamic newValue) {
                    BlocProvider.of<FilterBloc>(context)
                        .add(ChangeDestination(destination: newValue));
                  },
                  items: context
                      .read<LocalDataBase>()
                      .locationDB
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.name,
                      child: Text(
                        value.name,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return context
                        .read<LocalDataBase>()
                        .locationDB
                        .map((value) => Container(
                              child: Text(value.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true),
                              width: MediaQuery.of(context).size.width * 0.5,
                            ))
                        .toList();
                  },
                ),
                ElevatedButton(
                  child: Text('Guardar y Filtrar'),
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<ShippingsBloc>()
                        .add(LoadShippings(filter: state.filter));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
