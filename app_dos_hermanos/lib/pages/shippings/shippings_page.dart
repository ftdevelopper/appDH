import 'package:app_dos_hermanos/blocs/internet_cubit/internet_cubit.dart';
import 'package:app_dos_hermanos/pages/shippings/resume_page.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/blocs/drawer_bloc/drawer_bloc.dart';
import 'package:app_dos_hermanos/blocs/filter_bloc/filter_bloc.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/pages/bluetooth/discovery_page.dart';
import 'package:app_dos_hermanos/pages/shippings/new_shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/widgets/drawer.dart';
import 'edit_shipping.dart';

class ShippingsPage extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;
  final LocalDataBase localDataBase;

  ShippingsPage(
      {Key? key,
      required this.authenticationRepository,
      required this.localDataBase})
      : super(key: key);

  @override
  _ShippingsPageState createState() => _ShippingsPageState();
}

class _ShippingsPageState extends State<ShippingsPage>
    with SingleTickerProviderStateMixin {
  List<Shipping> shippingList = [];
  late TabController _tabController;

  late User _user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, initialIndex: 0, vsync: this);
    _user = widget.authenticationRepository.user;
    BlocProvider.of<BluetoothCubit>(context).initBlutetooth();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<InternetCubit>(context).initInternetCheck();
    return BlocBuilder<BluetoothCubit, MyBluetoothState>(
      builder: (context, state) {
        return BlocListener<BluetoothCubit, MyBluetoothState>(
          listener: (context, state) {
            if (state is ConnectedBluetooth) {}
          },
          child: DefaultTabController(
            length: 6,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Envios'),
                centerTitle: true,
                bottom: TabBar(
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(text: 'Todo', icon: Icon(Icons.home)),
                    Tab(text: 'Nuevo', icon: Icon(Icons.fiber_new_outlined)),
                    Tab(text: 'En Camino', icon: Icon(Icons.send)),
                    Tab(text: 'Recibido', icon: Icon(Icons.call_received)),
                    Tab(text: 'Conpletado', icon: Icon(Icons.done)),
                    Tab(text: 'Eliminado', icon: Icon(Icons.delete_rounded))
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/excel-3-24.png', scale: 1.1,),
                    onPressed: (){
                      context.read<ShippingsBloc>().add(CreateExcel(shippingList: shippingList));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_alt_rounded),
                    onPressed: () {
                      _showFilter(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bluetooth,
                      color: (state is ConnectedBluetooth)
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    onPressed: () async {
                      if (state is ConnectedBluetooth) {
                        BlocProvider.of<BluetoothCubit>(context)
                            .disconectBluetooth();
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DiscoveryPage()));
                      }
                    },
                  ),
                ],
              ),
              body: BlocBuilder<ShippingsBloc, ShippingsState>(
                  builder: (context, state) {
                if (state is ShippingsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ShippingsNotLoaded) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.error),
                        Text('No se pudieron cargar los envios'),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ShippingsBloc>(context)
                                .add(LoadShippings());
                          },
                          child: Text('Recargar'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is ShippingsLoaded) {
                  shippingList = state.shippings;
                  return TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Container(
                          child: filterShippings(status: ShippingStatus.newShipping, status2: ShippingStatus.inTravelShipping, status3: ShippingStatus.downloadedShipping, status4: ShippingStatus.completedShipping).length == 0
                              ? Center(
                                  child: Column(children: [
                                  Text('No hay envios disponibles'),
                                ]))
                              : ListView.builder(
                                  itemCount: filterShippings(status: ShippingStatus.newShipping, status2: ShippingStatus.inTravelShipping, status3: ShippingStatus.downloadedShipping, status4: ShippingStatus.completedShipping).length,
                                  itemBuilder: (_, index) {
                                    return shippingsUI(
                                        filterShippings(status: ShippingStatus.newShipping, status2: ShippingStatus.inTravelShipping, status3: ShippingStatus.downloadedShipping, status4: ShippingStatus.completedShipping)[index], context);
                                  },
                                )),
                      Container(
                          child: filterShippings(status: ShippingStatus.newShipping)
                                      .length ==
                                  0
                              ? Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                      Text('No hay nuevos envios'),
                                    ]))
                              : ListView.builder(
                                  itemCount: filterShippings(
                                          status: ShippingStatus.newShipping)
                                      .length,
                                  itemBuilder: (_, index) {
                                    return shippingsUI(
                                        filterShippings(
                                            status: ShippingStatus.newShipping)[index],
                                        context);
                                  },
                                )),
                      Container(
                          child:
                              filterShippings(status: ShippingStatus.inTravelShipping)
                                          .length ==
                                      0
                                  ? Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                          Text('No hay envios en camino'),
                                        ]))
                                  : ListView.builder(
                                      itemCount: filterShippings(
                                              status: ShippingStatus.inTravelShipping)
                                          .length,
                                      itemBuilder: (_, index) {
                                        return shippingsUI(
                                            filterShippings(status: ShippingStatus
                                                .inTravelShipping)[index],
                                            context);
                                      },
                                    )),
                      Container(
                          child:
                              filterShippings(status: ShippingStatus.downloadedShipping)
                                          .length ==
                                      0
                                  ? Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                          Text('No hay envios recibidos'),
                                        ]))
                                  : ListView.builder(
                                      itemCount: filterShippings(
                                              status: ShippingStatus.downloadedShipping)
                                          .length,
                                      itemBuilder: (_, index) {
                                        return shippingsUI(
                                            filterShippings(status: ShippingStatus
                                                .downloadedShipping)[index],
                                            context);
                                      },
                                    )),
                      Container(
                        child: filterShippings(status: ShippingStatus.completedShipping)
                                    .length ==
                                0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('No hay envios completados'),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: filterShippings(status: ShippingStatus.completedShipping)
                                    .length,
                                itemBuilder: (_, index) {
                                  return shippingsUI(
                                    filterShippings(status: ShippingStatus
                                        .completedShipping)[index],
                                    context,
                                  );
                                },
                              ),
                      ),
                      Container(
                        child: filterShippings(status: ShippingStatus.deletedShipping)
                                    .length ==
                                0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('No hay envios completados'),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: filterShippings(
                                        status: ShippingStatus.deletedShipping)
                                    .length,
                                itemBuilder: (_, index) {
                                  return shippingsUI(
                                    filterShippings(status: ShippingStatus
                                        .deletedShipping)[index],
                                    context,
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add_box_outlined),
                onPressed: () {
                  if (_tabController.index <= 1) {
                    Navigator.of(context).push<void>(MaterialPageRoute(
                        builder: (_) => NewShipping(
                              localDataBase: widget.localDataBase,
                              authenticationRepository:
                                  widget.authenticationRepository,
                            )));
                  }
                },
                tooltip: 'Nuevo Envio',
              ),
              drawer: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is LoadingDrawer) {
                    return Drawer(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return LoadedDrawer(user: _user);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget shippingsUI(Shipping shipping, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white70,
            textStyle: TextStyle(color: Colors.black),
            elevation: 2.0),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: shipping.statusIcon,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      children:<Widget>[
                        Text('Patente: ${shipping.truckPatent}',style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1,),
                        Text('Destino: ${shipping.reciverLocation}',style: TextStyle(color: Colors.black), maxLines: 1,),
                        Text('Origen: ${shipping.remiterLocation}',style: TextStyle(color: Colors.black), maxLines: 1,),
                        Text('Hora Tara: ${shipping.remiterTaraTime}',style: TextStyle(color: Colors.black), maxLines: 1,),
                      ]
                    ),
                  ),
                  if (!shipping.isOnLine) Icon(Icons.warning, color: Colors.red, size: 30,)
                ],
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => EditShipping(
                  localDataBase: widget.localDataBase,
                  authenticationRepository: widget.authenticationRepository,
                  shipping: shipping,
                ),
            ),
          );
        },
        onLongPress: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => ResumePage(
                authenticationRepository: widget.authenticationRepository,
                shipping: shipping,
              )
            )
          );
        },
      ),
    );
  }

  List<Shipping> filterShippings({required ShippingStatus status, ShippingStatus? status2, ShippingStatus? status3, ShippingStatus? status4}) {
    return shippingList
        .where((element) => (element.shippingState == status || element.shippingState == status2 || element.shippingState == status3 || element.shippingState == status4))
        .toList();
  }

  Future<void> _showFilter(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                          context
                              .read<FilterBloc>()
                              .add(ChangeDays(days: newValue));
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
                        items: widget.localDataBase.locationDB
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
                          return widget.localDataBase.locationDB
                              .map((value) => Container(
                                    child: Text(value.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
                        items: widget.localDataBase.locationDB
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
                          return widget.localDataBase.locationDB
                              .map((value) => Container(
                                    child: Text(value.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
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
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
