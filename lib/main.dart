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
    return AppView(authenticationRepository: authenticationRepository);
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
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (_, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    return MyHomePage();

                  case AuthenticationStatus.unknown:
                    return LoginPage(
                      authenticationRepository: widget.authenticationRepository,
                    );

                  case AuthenticationStatus.unaunthenticated:
                    return LoginPage(
                      authenticationRepository: widget.authenticationRepository,
                    );

                  default:
                    return MyHomePage();
                }
              },
            );
          },
          onGenerateRoute: (_) => SplashPage.route()),
    );
  }
}
