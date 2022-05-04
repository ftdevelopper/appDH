import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_dos_hermanos/features/login_feature/cubit/authentication_bloc/authenticaiton_bloc.dart';
import '../../../repositories/authentication_repository.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key, required this.authenticationRepository})
      : super(key: key);

  final AuthenticationRepository authenticationRepository;

  static Route route(AuthenticationRepository authenticationRepository) {
    return MaterialPageRoute(
        builder: (_) => SplashPage(
              authenticationRepository: authenticationRepository,
            ));
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthenticationBloc>().add(AuthenticationUserChanged());

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset('assets/logo.png',
                  key: const Key('splash_bloc_image'), width: 150)),
        ],
      ),
    );
  }
}
