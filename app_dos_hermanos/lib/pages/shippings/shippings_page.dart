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

class _ShippingsPageState extends State<ShippingsPage> with SingleTickerProviderStateMixin {

  List<Shipping> shippingList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShippingsBloc>(context).add(LoadShippings());
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shippings'),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: 'All', icon: Icon(Icons.home)),
              Tab(text: 'New', icon: Icon(Icons.fiber_new_outlined)),
              Tab(text: 'Sending', icon: Icon(Icons.send)),
              Tab(text: 'Recived', icon: Icon(Icons.call_received)),
              Tab(text: 'Conpleted', icon: Icon(Icons.done))
            ],
          ),
        ),
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
              return TabBarView(
                controller: _tabController,
                children: [
                  Container(
                  child: shippingList.length == 0
                  ? Center(
                    child: Column(
                      children: [
                        Text('No Shipings Avaliable'),
                      ]
                    )
                  )
                  : ListView.builder(
                    itemCount: shippingList.length,
                    itemBuilder: (_, index){
                      return shippingsUI(shippingList[index]);
                    },
                  )
                ),
                Container(
                  child: filterShippings(ShippingStatus.newShipping).length == 0
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No New Shipings Avaliable'),
                      ]
                    )
                  )
                  : ListView.builder(
                    itemCount: filterShippings(ShippingStatus.newShipping).length,
                    itemBuilder: (_, index){
                      return shippingsUI(filterShippings(ShippingStatus.newShipping)[index]);
                    },
                  )
                ),
                Container(
                  child: filterShippings(ShippingStatus.inTravelShipping).length == 0
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Shipings in Travel'),
                      ]
                    )
                  )
                  : ListView.builder(
                    itemCount: filterShippings(ShippingStatus.inTravelShipping).length,
                    itemBuilder: (_, index){
                      return shippingsUI(filterShippings(ShippingStatus.inTravelShipping)[index]);
                    },
                  )
                ),
                Container(
                  child: filterShippings(ShippingStatus.downloadedShipping).length == 0
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Shipings Recived'),
                      ]
                    )
                  )
                  : ListView.builder(
                    itemCount: filterShippings(ShippingStatus.downloadedShipping).length,
                    itemBuilder: (_, index){
                      return shippingsUI(filterShippings(ShippingStatus.downloadedShipping)[index]);
                    },
                  )
                ),
                Container(
                  child: filterShippings(ShippingStatus.completedShipping).length == 0
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Complete Shippings'),
                      ]
                    )
                  )
                  : ListView.builder(
                    itemCount: filterShippings(ShippingStatus.completedShipping).length,
                    itemBuilder: (_, index){
                      return shippingsUI(filterShippings(ShippingStatus.completedShipping)[index]);
                    },
                  )
                ),
                ]
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
            _tabController.index == 0
            ? Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => NewShipping(authenticationRepository: widget.authenticationRepository,)))
            : null;
          },
          tooltip: 'Add a new Shipping',
        ),
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

  List<Shipping> filterShippings(ShippingStatus status){
    return shippingList.where((element) => element.shippingState == status).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}