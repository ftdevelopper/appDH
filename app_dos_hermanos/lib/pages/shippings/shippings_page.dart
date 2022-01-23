import 'dart:io';
import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/drawer_bloc/drawer_bloc.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/rice.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/pages/shippings/new_shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_shipping.dart';

class ShippingsPage extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;
  final LocalDataBase localDataBase;

  ShippingsPage({Key? key, required this.authenticationRepository, required this.localDataBase})
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
    _tabController = TabController(length: 5, initialIndex: 0, vsync: this);
    _user = widget.authenticationRepository.user;
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ShippingsBloc>(context).add(LoadShippings());
    return DefaultTabController(
      length: 5,
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
                Tab(text: 'Recivido', icon: Icon(Icons.call_received)),
                Tab(text: 'Conpletado', icon: Icon(Icons.done))
              ],
            ),
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
              return TabBarView(controller: _tabController, 
                children: <Widget>[
                  Container(
                    child: shippingList.length == 0
                    ? Center(
                        child: Column(
                          children: [
                            Text('No hay envios disponibles'),
                          ]
                        )
                      )
                    : ListView.builder(
                      itemCount: shippingList.length,
                      itemBuilder: (_, index) {
                        return shippingsUI(shippingList[index], context);
                      },
                    )
                  ),
                  Container(
                    child: filterShippings(ShippingStatus.newShipping).length == 0
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('No hay nuevos envios'),
                        ]
                      )
                    )
                    : ListView.builder(
                      itemCount: filterShippings(ShippingStatus.newShipping).length,
                      itemBuilder: (_, index) {
                        return shippingsUI(filterShippings(ShippingStatus.newShipping)[index],context);
                      },
                    )
                  ),
                  Container(
                    child: filterShippings(ShippingStatus.inTravelShipping).length == 0
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            Text('No hay envios en camino'),
                          ]
                        )
                      )
                    : ListView.builder(
                      itemCount: filterShippings(ShippingStatus.inTravelShipping).length,
                      itemBuilder: (_, index) {
                        return shippingsUI(filterShippings(ShippingStatus.inTravelShipping)[index],context);
                      },
                    )
                  ),
                  Container(
                    child: filterShippings(ShippingStatus.downloadedShipping).length == 0
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          Text('No hay envios recibidos'),
                        ]
                      )
                    )
                    : ListView.builder(
                      itemCount: filterShippings(ShippingStatus.downloadedShipping).length,
                      itemBuilder: (_, index) {
                        return shippingsUI(filterShippings(ShippingStatus.downloadedShipping)[index],context);
                      },
                    )
                  ),
                  Container(
                    child: filterShippings(ShippingStatus.completedShipping).length == 0
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('No hay envios completados'),
                        ]
                      )
                    )
                    : ListView.builder(
                      itemCount: filterShippings(ShippingStatus.completedShipping).length,
                      itemBuilder: (_, index) {
                        return shippingsUI(filterShippings(ShippingStatus.completedShipping)[index],context);
                      },
                    )
                  ),
                ]
              );
            } else {
              return Container();
            }
          }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_box_outlined),
            onPressed: () {
              if (_tabController.index <= 1){
                Navigator.of(context).push<void>(MaterialPageRoute(
                  builder: (_) => NewShipping(
                    localDataBase: widget.localDataBase,
                    authenticationRepository: widget.authenticationRepository,
                    )
                  )
                );
              }
            },
            tooltip: 'Nuevo Envio',
          ),
          drawer:
              BlocBuilder<DrawerBloc, DrawerState>(builder: (context, state) {
            if (state is LoadingDrawer) {
              return Drawer(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return LoadedDrawer(context);
            }
          })),
    );
  }

  // ignore: non_constant_identifier_names
  Drawer LoadedDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Flexible(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image:
                              DecorationImage(image: _user.profilePhoto.image)),
                    ),
                    Positioned(
                      bottom: -10,
                      right: 50,
                      child: IconButton(
                        iconSize: 50,
                        color: Colors.grey,
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () async {
                          try {
                            XFile? newImage = (await ImagePicker()
                                .pickImage(source: ImageSource.camera));
                            if (newImage != null) {
                              File profilePhotoFile = File(newImage.path);
                              final bytes =
                                  await profilePhotoFile.readAsBytes();
                              final image = (Image.memory(bytes));
                              BlocProvider.of<DrawerBloc>(context).add(
                                  ChangeProfilePhoto(
                                      newphoto: image,
                                      newphotoFile: profilePhotoFile));
                            } else {
                              print('newImage = null');
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Text('Nombre:'),
                  subtitle: Text(_user.name),
                  leading: Icon(Icons.verified),
                  onTap: (){
                    _changeName();
                  }
                ),
                ListTile(
                  title: Text('Ubicacion: '),
                  subtitle: Text(_user.location.name),
                  leading: Icon(Icons.location_on),
                  onTap: (){
                    _showlocationsDrawer(context);
                  },
                ),
                ListTile(
                  title: Text('Emai:'),
                  subtitle: Text(_user.email),
                  leading: Icon(Icons.email),
                ),
                ListTile(
                  title: Text('Usuario ID:'),
                  subtitle: Text(_user.id),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text('Tipos de Arroz:'),
                  subtitle: Text('Mis tipos de Arroz'),
                  leading: Icon(Icons.rice_bowl_rounded),
                  onTap: (){
                    _showRiceTypes(context);
                  },
                ),
                ListTile(
                  title: Text('DashBoard'),
                  subtitle: Text('Proximamente...'),
                  leading: Icon(Icons.space_dashboard),
                  onTap: (){},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: ListTile(
              title: Text('LogOut'),
              subtitle: Text('Press to Logout'),
              leading: Icon(Icons.login_outlined),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationLogoutRequested());
              },
            ),
          )
        ],
      ),
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
          child: Row(
            children: <Widget>[
              shipping.statusIcon,
              SizedBox(
                width: 80,
              ),
              Text(
                'Patente: ${shipping.truckPatent}',
                style: TextStyle(color: Colors.black),
              ),

            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (_) => EditShipping(
                  localDataBase: widget.localDataBase,
                  authenticationRepository: widget.authenticationRepository,
                  shipping: shipping)));
        },
      ),
    );
  }

  List<Shipping> filterShippings(ShippingStatus status) {
    return shippingList
        .where((element) => element.shippingState == status)
        .toList();
  }

  Future<void> _showlocationsDrawer(BuildContext context){
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              'Ubicaciones',
              textAlign: TextAlign.center,
            ),
            actionsPadding: EdgeInsets.zero,
            actions: <Widget>[
              Center(
                child: IconButton(
                  onPressed: (){
                    BlocProvider.of<DrawerBloc>(context).add(LoadLocations());
                  },
                  icon: Icon(Icons.replay_circle_filled, size: 30,)
                ),
              )],
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.4,
              child: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is LoadingLocations){
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<Location> locations = state.localDataBase!.locationDB;
                    return ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(locations[index].name),
                      onTap: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<DrawerBloc>(context).add(ChangeLocation(locationName: locations[index].name));
                      }
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    });
  }

  Future<void> _showRiceTypes(BuildContext context){
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              'Tipos de Arroz',
              textAlign: TextAlign.center,
            ),
            actionsPadding: EdgeInsets.zero,
            actions: <Widget>[
              Center(
                child: IconButton(
                  onPressed: (){
                    BlocProvider.of<DrawerBloc>(context).add(LoadRices());
                  },
                  icon: Icon(Icons.replay_circle_filled, size: 30,)
                ),
              )],
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.4,
              child: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is LoadingRices){
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<Rice> rices = state.localDataBase!.riceDB;
                    return ListView.builder(
                    itemCount: rices.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                      leading: Icon(Icons.rice_bowl_rounded),
                      title: Text(rices[index].type),
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    });
  }

  Future<void> _changeName() async {
    String name = '';
    return showDialog<void>(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text('Introduzca su nuevo nombre', textAlign: TextAlign.center,),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(),
                  onChanged: (String txt){
                    name = txt;
                  },
                ),
                ElevatedButton(
                  child: Text('Guardar'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    BlocProvider.of<DrawerBloc>(context).add(ChangeName(name: name));
                  },
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
