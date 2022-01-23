import 'dart:io';

import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/rice.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:app_dos_hermanos/repository/rice_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
      emit(LoadingLocations());
      try {
        List<Location> locations = await LocationRepository().getLocations();
        localDataBase.locationDB = locations;
        print('Se intentara Escribir en la base de datos');
        DataBaseFileRoutines().writeDataBase(databaseToJson(localDataBase));
        print('Se escribio exitosamente en la base de datos');
        emit(LoadedLocations(localDataBase: localDataBase));
      } catch (e) {
        print(e);
      } 
    });

    on<LoadRices>((event,emit) async {
      emit(LoadingRices());
      try {
        List<Rice> riceTypes = await RiceRepository().getRiceTypes();
        print('rice Types Loaded from FireBase, now Trying to write DB');
        localDataBase.riceDB = riceTypes;
        DataBaseFileRoutines().writeDataBase(databaseToJson(localDataBase));
        emit(LoadedRices(localDataBase: localDataBase));
      } catch (e) {
        print(e);
      }
    });
  }
}
