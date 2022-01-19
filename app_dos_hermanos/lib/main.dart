import 'package:app_dos_hermanos/blocs/login_bloc/login_bloc.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/pages/login/login.dart';
import 'package:app_dos_hermanos/pages/login/splash.dart';
import 'package:app_dos_hermanos/pages/shippings/shippings_page.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:app_dos_hermanos/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'blocs/drawer_bloc/drawer_bloc.dart';
import 'blocs/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  BlocOverrides.runZoned(() {
    runApp(MyApp(authenticationRepository: AuthenticationRepository(user: User.empty())));
  }, blocObserver: SimpleBlocObserver());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.authenticationRepository}) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final ShippingRepository shippingsRepository = ShippingRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child:AppView(authenticationRepository: authenticationRepository, shippingRepository: shippingsRepository),
    );
  }
}

class AppView extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;
  final ShippingRepository shippingRepository;
  AppView({Key? key, required this.authenticationRepository, required this.shippingRepository}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(authenticationRepository: widget.authenticationRepository)),
        BlocProvider(create: (context) => LoginBloc(authenticationRepository: widget.authenticationRepository)),
        //BlocProvider(create: (context) => RegisterBloc(authenticationRepository: widget.authenticationRepository)),
        BlocProvider(create: (context) => ShippingsBloc(shippingRepository: widget.shippingRepository)),
        BlocProvider(create: (context) => DrawerBloc(authenticationRepository: widget.authenticationRepository))
      ],
      child: MaterialApp(
          theme: theme,
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator!.pushAndRemoveUntil<void>(MaterialPageRoute(builder: (_) => ShippingsPage(authenticationRepository: widget.authenticationRepository,)), (route) => false);
                  break;
                  case AuthenticationStatus.unknown:
                    _navigator!.pushAndRemoveUntil<void>(MaterialPageRoute(builder: (_) => LoginPage(authenticationRepository: widget.authenticationRepository,)), (route) => false);
                  break;
                  case AuthenticationStatus.unaunthenticated:
                    _navigator!.pushAndRemoveUntil<void>(MaterialPageRoute(builder: (_) => LoginPage(authenticationRepository: widget.authenticationRepository)), (route) => false);
                    break;
                  default: break;
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => SplashPage(authenticationRepository: widget.authenticationRepository))
    ));
  }
}
