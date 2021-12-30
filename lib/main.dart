import 'package:app_dos_hermanos/pages/homePage.dart';
import 'package:app_dos_hermanos/pages/login.dart';
import 'package:app_dos_hermanos/pages/splash.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/theme.dart';
//import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
//import 'blocs/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  BlocOverrides.runZoned(() {
    runApp(MyApp(authenticationRepository: AuthenticationRepository()));
  },
  blocObserver: SimpleBlocObserver()
  );
}

class MyApp extends StatelessWidget {

  MyApp({Key? key, required this.authenticationRepository}) : super(key: key);
  
  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authenticationRepository: authenticationRepository),
        child: AppView(),
      ),
    );
  }
}


class AppView extends StatefulWidget {
  AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationBloc(authenticationRepository: AuthenticationRepository()))
      ],
      child: MaterialApp(
        theme: theme,
        navigatorKey: _navigatorKey,
        builder: (context, child){
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (_, state){
            switch (state.status){
              case AuthenticationStatus.authenticated:
                return MyHomePage();
              
              case AuthenticationStatus.unknown:
                return LoginPage();
              
              case AuthenticationStatus.unaunthenticated:
                return LoginPage();
               
              default: 
                return MyHomePage();
              
            }
          },
          );
        },
        onGenerateRoute: (_) => SplashPage.route()
      ),
    );
  }
}