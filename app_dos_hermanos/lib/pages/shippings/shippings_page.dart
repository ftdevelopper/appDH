import 'dart:io';
import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/drawer_bloc/drawer_bloc.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/pages/shippings/new_shipping.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_shipping.dart';

class ShippingsPage extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;

  ShippingsPage({Key? key, required this.authenticationRepository})
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
                    Text('Cannot load shippings'),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<ShippingsBloc>(context)
                            .add(LoadShippings());
                      },
                      child: Text('Reload'),
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
                            Text('No Shipings Avaliable'),
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
                          Text('No New Shipings Avaliable'),
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
                            Text('No Shipings in Travel'),
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
                          Text('No Shipings Recived'),
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
                          Text('No Complete Shippings'),
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
              _tabController.index == 0
                  ? Navigator.of(context).push<void>(MaterialPageRoute(
                      builder: (_) => NewShipping(
                            authenticationRepository:
                                widget.authenticationRepository,
                          )))
                  : null;
            },
            tooltip: 'Add a new Shipping',
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
                              final image = (await Image.memory(bytes));
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
                  title: Text('Name:'),
                  subtitle: Text(_user.name),
                  leading: Icon(Icons.verified),
                ),
                ListTile(
                  title: Text('Location: '),
                  subtitle: Text(_user.location.name),
                  leading: Icon(Icons.map_rounded),
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
                  title: Text('User ID:'),
                  subtitle: Text(_user.id),
                  leading: Icon(Icons.person),
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
                'patent: ${shipping.patent}',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).push<void>(MaterialPageRoute(
              builder: (_) => EditShipping(
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

  Future<void> _showlocationsDrawer(BuildContext context) async {
    BlocProvider.of<DrawerBloc>(context).add(LoadLocations());
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Locations',
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: 70,
              height: 230,
              child: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is LoadingLocations){
                    return Center(child: CircularProgressIndicator(),);
                  } else if (state is LoadedLocations){
                  return ListView.builder(
                    itemCount: state.locations.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(state.locations[index].name),
                      onTap: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<DrawerBloc>(context).add(ChangeLocation(locationName: state.locations[index].name));
                      });
                    },
                  );} else{
                    return Container();
                  }
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
