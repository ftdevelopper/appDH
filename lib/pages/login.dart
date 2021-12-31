import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/login_bloc/login_bloc.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'loginForm.dart';

class LoginPage extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const LoginPage({Key? key, required this.authenticationRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authenticationRepository: authenticationRepository),
        child: LoginForm(authenticationRepository: authenticationRepository),
      )
    );
  }
}