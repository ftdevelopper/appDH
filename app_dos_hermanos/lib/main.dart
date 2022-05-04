import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_dos_hermanos/features/add_new_shipping_feature/cubit/new_shipping_cubit/new_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/edit_shipping_feature/cubit/edit_shipping_cubit/edit_shipping_cubit.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/pages/shippings_page.dart';
import 'package:app_dos_hermanos/features/login_feature/cubit/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/features/login_feature/cubit/login_bloc/login_bloc.dart';
import 'package:app_dos_hermanos/features/login_feature/models/user.dart';
import 'package:app_dos_hermanos/features/login_feature/pages/login.dart';
import 'package:app_dos_hermanos/features/login_feature/pages/splash.dart';
import 'package:app_dos_hermanos/repositories/authentication_repository.dart';
import 'package:app_dos_hermanos/repositories/local_data_base.dart';
import 'package:app_dos_hermanos/repositories/shipping_repository.dart';
import 'package:app_dos_hermanos/utils/blocs/simple_bloc_observer.dart';
import 'package:app_dos_hermanos/utils/internet_cubit/internet_cubit.dart';
import 'package:app_dos_hermanos/utils/theme.dart';
import 'features/connect_bluetooth_feature/cubit/bluetootu_cubit/bluetooth_cubit.dart';
import 'features/get_shippings_feature/cubit/drawer_bloc/drawer_bloc.dart';
import 'features/get_shippings_feature/cubit/filter_bloc/filter_bloc.dart';
import 'features/get_shippings_feature/cubit/shippings_bloc/shippings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  BlocOverrides.runZoned(() async {
    runApp(MyApp());
  }, blocObserver: SimpleBlocObserver());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView();
  }
}

class AppView extends StatefulWidget {
  AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthenticationRepository(user: User.empty()),
        ),
        RepositoryProvider(create: (_) => ShippingRepository()),
        RepositoryProvider(
          create: (_) => LocalDataBase.empty()..loadDB(),
          lazy: false,
        )
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthenticationBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => LoginBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => InternetCubit()..initInternetCheck(),
              lazy: false,
            ),
            BlocProvider(
              create: (context) => ShippingsBloc(
                shippingRepository: context.read<ShippingRepository>(),
                localDataBase: context.read<LocalDataBase>(),
                internetCubit: context.read<InternetCubit>(),
              ),
            ),
            BlocProvider(create: (_) => FilterBloc()),
            BlocProvider(
              create: (context) => DrawerBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
                localDataBase: context.read<LocalDataBase>(),
              ),
            ),
            BlocProvider(
              create: (_) => BluetoothCubit()..initBlutetooth(),
              lazy: false,
            ),
            BlocProvider(
              create: (context) => EditShippingCubit(
                bluetoothCubit: context.read<BluetoothCubit>(),
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              ),
            ),
            BlocProvider(
              create: (context) => NewShippingCubit(
                bluetoothCubit: context.read<BluetoothCubit>(),
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              ),
            )
          ],
          child: MaterialApp(
              theme: theme,
              navigatorKey: _navigatorKey,
              debugShowCheckedModeBanner: false,
              //showPerformanceOverlay: true,
              builder: (context, child) {
                return BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    switch (state.status) {
                      case AuthenticationStatus.authenticated:
                        context.read<ShippingsBloc>().add(LoadShippings());
                        _navigator!.pushAndRemoveUntil<void>(
                            MaterialPageRoute(
                                builder: (_) => ShippingsPage(
                                      authenticationRepository: context
                                          .read<AuthenticationRepository>(),
                                      localDataBase:
                                          context.read<LocalDataBase>(),
                                    )),
                            (route) => false);
                        break;
                      case AuthenticationStatus.unknown:
                        _navigator!.pushAndRemoveUntil<void>(
                            MaterialPageRoute(
                                builder: (_) => LoginPage(
                                      authenticationRepository: context
                                          .read<AuthenticationRepository>(),
                                    )),
                            (route) => false);
                        break;
                      case AuthenticationStatus.unaunthenticated:
                        _navigator!.pushAndRemoveUntil<void>(
                            MaterialPageRoute(
                                builder: (_) => LoginPage(
                                    authenticationRepository: context
                                        .read<AuthenticationRepository>())),
                            (route) => false);
                        break;
                      default:
                        break;
                    }
                  },
                  child: child,
                );
              },
              onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (context) => SplashPage(
                      authenticationRepository:
                          context.read<AuthenticationRepository>())))),
    );
  }
}
