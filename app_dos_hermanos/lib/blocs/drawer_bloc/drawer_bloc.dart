import 'dart:convert';
import 'dart:io';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/rice.dart';
import 'package:app_dos_hermanos/keys/apikeys.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/provider/drivers_provider.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/drivers_repository.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:app_dos_hermanos/repository/rice_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  AuthenticationRepository authenticationRepository;
  LocalDataBase localDataBase;

  DrawerBloc({required this.authenticationRepository, required this.localDataBase}) : super(DrawerInitial(localDataBase: localDataBase)) {
    
    on<ChangeProfilePhoto>((event, emit) async {
      emit(LoadingDrawer(localDataBase: localDataBase));
      try {
        authenticationRepository.user.photoURL = await authenticationRepository.userRepository.putProfileImage(image: event.newphotoFile, name: authenticationRepository.user.name);
        authenticationRepository.user.profilePhoto = event.newphoto;
        await authenticationRepository.userRepository.updateUserData(authenticationRepository.user);
        emit(DrawerLoaded(localDataBase: localDataBase));
      } catch (e) {
        print('Error in uploading photo: $e');
        emit(DrawerLoaded(localDataBase: localDataBase));
      }
    });

    on<ChangeLocation>((event, emit) async {
      emit(LoadingDrawer(localDataBase: localDataBase));
      try {
        authenticationRepository.user.location = Location.fromName(event.locationName);
        await authenticationRepository.userRepository.updateUserData(authenticationRepository.user);
        emit(DrawerLoaded(localDataBase: localDataBase));
      } catch (e) {
        print('Error in uploading location: $e');
        emit(DrawerLoaded(localDataBase: localDataBase));
      }
    });

    on<ChangeName>((event, emit) async {
      emit(LoadingDrawer(localDataBase: localDataBase));
      try {
        authenticationRepository.user.name = event.name;
        await authenticationRepository.userRepository.updateUserData(authenticationRepository.user);
        emit(DrawerLoaded(localDataBase: localDataBase));
      } catch (e) {
        print('Error in uploafing name: $e');
      }
    });

    on<LoadLocations>((event, emit) async {
      emit(LoadingLocations(localDataBase: localDataBase));
      try {
        List<Location> locations = await LocationRepository().getLocations();
        localDataBase.locationDB = locations;
        print('Se intentara Escribir en la base de datos');
        DataBaseFileRoutines().writeDataBase(databaseToJson(localDataBase));
        print('Se escribio exitosamente en la base de datos');
        emit(DrawerLoaded(localDataBase: localDataBase));
      } catch (e) {
        print(e);
      } 
    });

    on<LoadRices>((event,emit) async {
      emit(LoadingRices(localDataBase: localDataBase));
      try {
        List<Rice> riceTypes = await RiceRepository().getRiceTypes();
        print('rice Types Loaded from FireBase, now Trying to write DB');
        localDataBase.riceDB = riceTypes;
        DataBaseFileRoutines().writeDataBase(databaseToJson(localDataBase));
        emit(DrawerLoaded(localDataBase: localDataBase));
      } catch (e) {
        print(e);
      }
    });

    on<LoadDrivers>((event, emit) async {
      DriversProvider _driverProvider = DriversProvider();
      double progress = 0;
      emit(LoadingDrivers(localDataBase: localDataBase, progress: progress));

      try {
        Response? token = await _driverProvider.callApi(
          endpoint: 'oauth/token', 
          parameters: {
            "grant_type":"client_credentials", 
            "client_id":DHApiKeys().clientID, 
            "client_secret":DHApiKeys().clientStcret
          }
        );
        
        Response? driversJson = await  _driverProvider.callApi(endpoint: 'choferesapp/list', parameters: {"ACCESS_TOKEN": token!.body});

        DriverRepository driversrepo = DriverRepository.fromJson(json.decode(driversJson!.body));

        for (var i = 0; i < driversrepo.drivers.length; i++){
          if(driversrepo.drivers[i].active){
            Response? paramResponse = await _driverProvider.callApi(endpoint: 'choferesapp/' + driversrepo.drivers[i].code, parameters: {"ACCESS_TOKEN": token.body});
            if(paramResponse!.statusCode == 200){
              Map<String,dynamic> parameters = json.decode(paramResponse.body);
              driversrepo.drivers[i].patent = parameters["Patente"];
              driversrepo.drivers[i].chasisPatent = parameters["PatenteAcoplado"];
              driversrepo.drivers[i].company = parameters["Transportista"];
              print(i.toString());
            } else {
              print(paramResponse.statusCode);
              print(i.toString());
            }
            emit(LoadingDrivers(localDataBase: localDataBase, progress: i / driversrepo.drivers.length));
          }
        }

        localDataBase.driversDB = driversrepo.drivers;
        await DataBaseFileRoutines().writeDataBase(databaseToJson(localDataBase));

        emit(DrawerLoaded(localDataBase: localDataBase));
      } catch (e) {
        print(e);
      }
    });
  }
}
