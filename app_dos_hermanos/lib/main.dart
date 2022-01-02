import 'package:app_dos_hermanos/blocs/login_bloc/login_bloc.dart';
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
  }, blocObserver: SimpleBlocObserver());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.authenticationRepository}) : super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child:AppView(authenticationRepository: authenticationRepository),
    );
  }
}

class AppView extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;
  AppView({Key? key, required this.authenticationRepository}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  // ignore: unused_element
  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(authenticationRepository: widget.authenticationRepository)),
        BlocProvider(create: (context) => LoginBloc(authenticationRepository: widget.authenticationRepository))
      ],
      child: MaterialApp(
          theme: theme,
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            print('hola ');
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              bloc: AuthenticationBloc(authenticationRepository: widget.authenticationRepository),
              listenWhen: (previous, actual){
                if(previous is AuthenticationInitialState || actual is AuthenticationInitialState){
                  return true;
                } else {return true;}
              },
              listener: (context, state) {
                print('${state.status}');
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator!.pushAndRemoveUntil<void>(MyHomePage.route(), (route) => false);
                    //return Builder(builder: (BuildContext context) => MyHomePage());
                  break;
                  case AuthenticationStatus.unknown:
                  _navigator!.pushAndRemoveUntil<void>(MaterialPageRoute(builder: (_) => LoginPage(authenticationRepository: widget.authenticationRepository,)), (route) => false);
                    /*return Builder(
                      builder: (BuildContext context) => LoginPage(
                        authenticationRepository: widget.authenticationRepository,
                      ),
                    )*/
                  break;
                  case AuthenticationStatus.unaunthenticated:
                  _navigator!.pushAndRemoveUntil<void>(MaterialPageRoute(builder: (_) => LoginPage(authenticationRepository: widget.authenticationRepository)), (route) => false);
                    /*return Builder(
                      builder: (BuildContext context) => LoginPage(
                        authenticationRepository: widget.authenticationRepository,
                      ),
                    );*/
                    break;
                  default: break;
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => MyHomePage())
    ));
  }
}
