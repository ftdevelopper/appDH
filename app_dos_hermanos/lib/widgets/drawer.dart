import 'dart:io';

import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/drawer_bloc/drawer_bloc.dart';
import 'package:app_dos_hermanos/classes/drivers.dart';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/lote.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class LoadedDrawer extends StatelessWidget {
  const LoadedDrawer({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
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
                              DecorationImage(image: user.profilePhoto.image)),
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
                    subtitle: Text(user.name),
                    leading: Icon(Icons.verified),
                    onTap: () {
                      _changeName(context);
                    }),
                ListTile(
                  title: Text('Ubicacion: '),
                  subtitle: Text(user.location.name),
                  leading: Icon(Icons.location_on),
                  onTap: () {
                    _showlocationsDrawer(context);
                  },
                ),
                ListTile(
                  title: Text('Emai:'),
                  subtitle: Text(user.email),
                  leading: Icon(Icons.email),
                ),
                ListTile(
                  title: Text('Usuario ID:'),
                  subtitle: Text(user.id),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text('Lotes:'),
                  subtitle: Text('Toque para ver los lotes y tipos de arroz'),
                  leading: Icon(Icons.rice_bowl_rounded),
                  onTap: () {
                    _showRiceTypes(context);
                  },
                ),
                ListTile(
                  title: Text('DashBoard'),
                  subtitle: Text('Proximamente...'),
                  leading: Icon(Icons.space_dashboard),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Choferes'),
                  subtitle: Text('Toque para ver choferes cargados'),
                  leading: Icon(
                    Icons.text_snippet_outlined,
                  ),
                  onTap: () {
                    _showDrivers(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: ListTile(
              title: Text(
                'LogOut',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: Text('Press to Logout'),
              leading: Icon(
                Icons.login_outlined,
                color: Colors.red,
              ),
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

  Future<void> _showlocationsDrawer(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              'Ubicaciones',
              textAlign: TextAlign.center,
            ),
            actionsPadding: EdgeInsets.zero,
            actions: <Widget>[
              Center(
                child: IconButton(
                    onPressed: () {
                      BlocProvider.of<DrawerBloc>(context).add(LoadLocations());
                    },
                    icon: Icon(
                      Icons.replay_circle_filled,
                      size: 30,
                    )),
              )
            ],
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.4,
              child: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is LoadingLocations) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<Location> locations = state.localDataBase.locationDB;
                    return ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(locations[index].name),
                            onTap: () {
                              Navigator.of(context).pop();
                              BlocProvider.of<DrawerBloc>(context).add(
                                  ChangeLocation(
                                      locationName: locations[index].name));
                            });
                      },
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  Future<void> _showDrivers(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return BlocBuilder<DrawerBloc, DrawerState>(
            builder: (context, state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                title: Text(
                  'Choferes',
                  textAlign: TextAlign.center,
                ),
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  Center(
                    child: IconButton(
                        onPressed: () {
                          if (state is LoadingDrivers){

                          } else {
                            BlocProvider.of<DrawerBloc>(context)
                                .add(LoadDrivers());
                          }
                        },
                        icon: Icon(
                          Icons.replay_circle_filled,
                          size: 30,
                        )),
                  )
                ],
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: BlocBuilder<DrawerBloc, DrawerState>(
                    builder: (context, state) {
                      if (state is LoadingDrivers) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Descargando Choferes: ${(state.progress * 100).toStringAsFixed(2)}%',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: CircularProgressIndicator(
                              value: state.progress,
                              semanticsValue: state.progress.toString(),
                            )),
                          ],
                        );
                      } else {
                        List<Driver> drivers = state.localDataBase.driversDB;
                        return ListView.builder(
                          itemCount: drivers.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              leading: Icon(Icons.person_pin_rounded),
                              title: Text(drivers[index].name),
                              onTap: () {},
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        });
  }

  Future<void> _showRiceTypes(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              'Lotes',
              textAlign: TextAlign.center,
            ),
            actionsPadding: EdgeInsets.zero,
            actions: <Widget>[
              Center(
                child: IconButton(
                    onPressed: () {
                      BlocProvider.of<DrawerBloc>(context).add(LoadRices());
                    },
                    icon: Icon(
                      Icons.replay_circle_filled,
                      size: 30,
                    )),
              )
            ],
            content: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.4,
              child: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is LoadingRices) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<Lote> lote = state.localDataBase.loteDB;
                    return ListView.builder(
                      itemCount: lote.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          leading: Icon(Icons.rice_bowl_rounded),
                          title: Text(lote[index].lote),
                          subtitle: Text(lote[index].riceType),
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

  Future<void> _changeName(BuildContext context) async {
    String name = '';
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text(
              'Introduzca su nuevo nombre',
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: TextEditingController(),
                    decoration: InputDecoration(),
                    onChanged: (String txt) {
                      name = txt;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      BlocProvider.of<DrawerBloc>(context).add(
                        ChangeName(name: name),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
