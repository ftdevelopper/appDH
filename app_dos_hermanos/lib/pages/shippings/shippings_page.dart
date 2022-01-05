import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/pages/shippings/new_shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingsPage extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;

  ShippingsPage({Key? key, required this.authenticationRepository}) : super(key: key);

  @override
  _ShippingsPageState createState() => _ShippingsPageState();
}

class _ShippingsPageState extends State<ShippingsPage> {

  List<Shipping> shippingList = [];
  
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShippingsBloc>(context).add(LoadShippings());
    return Scaffold(
      appBar: AppBar(title: Text('Shippings'),centerTitle: true,),
      body: BlocBuilder<ShippingsBloc, ShippingsState>(
        builder: (context, state){
          if (state is ShippingsLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if (state is ShippingsNotLoaded){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error),
                  Text('Cannot load shippings'),
                  ElevatedButton(
                    onPressed: (){
                      BlocProvider.of<ShippingsBloc>(context).add(LoadShippings());
                    },
                    child: Text('Reload'),
                  ),
                ],
              ),
            );
          }
          if (state is ShippingsLoaded){
            shippingList = state.shippings;
            return Container(
              child: shippingList.length == 0
              ? Center(
                child: Column(
                  children: [
                    Text('No Shipings Avaliable'),
                    ElevatedButton(
                    onPressed: (){
                      BlocProvider.of<ShippingsBloc>(context).add(LoadShippings());
                    },
                    child: Text('Reload'),
                  ),
                  ]
                )
              )
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_box_outlined),
        onPressed: (){
          Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => NewShipping(authenticationRepository: widget.authenticationRepository,)));
        },
      ),
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
            Text(shipping.patent)
          ],
        ),
      ),
    );
  }
}