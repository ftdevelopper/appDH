import 'dart:io';

import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  AuthenticationRepository authenticationRepository;

  DrawerBloc({required this.authenticationRepository}) : super(DrawerInitial()) {

    on<ChangeProfilePhoto>((event, emit) async {
      emit(LoadingDrawer());
      try {
        authenticationRepository.user.photoURL = await authenticationRepository.userRepository.putProfileImage(image: event.newphotoFile, name: authenticationRepository.user.name);
        authenticationRepository.user.profilePhoto = event.newphoto;
        await authenticationRepository.userRepository.updateUserData(authenticationRepository.user);
        emit(LoadedDrawer());
      } catch (e) {
        print('Error in uploading photo: $e');
        emit(LoadedDrawer());
      }
    });

    on<ChangeLocation>((event, emit) async {
      emit(LoadingDrawer());
      try {
        authenticationRepository.user.location = Location.fromName(event.locationName);
        await authenticationRepository.userRepository.updateUserData(authenticationRepository.user);
        emit(LoadedDrawer());
      } catch (e) {
        print('Error in uploading location: $e');
        emit(LoadedDrawer());
      }
    });

    on<ChangeName>((event, emit) async {
      emit(LoadingDrawer());
      try {
        authenticationRepository.user.name = event.name;
        await authenticationRepository.userRepository.updateUserData(authenticationRepository.user);
        emit(LoadedDrawer());
      } catch (e) {
        print('Error in uploafing name: $e');
      }
    });

    on<LoadLocations>((event, emit) async {
      emit(LoadingLocations());
      try {
        List<Location> locations = await LocationRepository().getLocations();
        emit(LoadedLocations(locations: locations));
      } catch (e) {
      } 
    });
  }
}
