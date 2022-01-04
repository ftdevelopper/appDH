import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingsPage extends StatefulWidget {
  ShippingsPage({Key? key}) : super(key: key);

  @override
  _ShippingsPageState createState() => _ShippingsPageState();
}

class _ShippingsPageState extends State<ShippingsPage> {
  List<Shipping> shippingList = [];
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShippingsBloc>(context).add(LoadShippings());
    return BlocBuilder<ShippingsBloc, ShippingsState>(
      builder: (context, state){
        if (state is ShippingsLoading){
          return Center(child: CircularProgressIndicator(),);
        }
        if (state is ShippingsNotLoaded){
          return Center(
            child: Column(
              children: <Widget>[
                Icon(Icons.error),
                Text('Cannot load shippings'),
              ],
            ),
          );
        }
        if (state is ShippingsLoaded){
          return Container(
            child: shippingList.length == 0
            ? Center(child: Text('No Shipings Avaliable'))
            : ListView.builder(
              itemCount: shippingList.length,
              itemBuilder: (_, index){
                return shippingsUI(shippingList[index]);
              },
            )
          );
        }
        else {
          return Container();
        }
      }
    );
  }

  Widget shippingsUI(Shipping shipping){
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(14.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(shipping.id)
          ],
        ),
      ),
    );
  }
}