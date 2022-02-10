import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(InternetInitial());

  late StreamSubscription<InternetConnectionStatus> internetListener;

  void initInternetCheck(){
    internetListener = InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
      if (status == InternetConnectionStatus.connected){
        emit(InternetConnected());
        print('Conexion a internet disponible');
      } else {
        emit(InternetDisconnected());
        print('Sin Conexion a Internet');
      }
    });
  }

  @override
  Future<void> close() async {
    await internetListener.cancel();
    return super.close();
  }
}
