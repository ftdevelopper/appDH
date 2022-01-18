import 'package:app_dos_hermanos/blocs/register_bloc/register_bloc.dart';
import 'package:app_dos_hermanos/pages/register/register_form.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  const RegisterScreen({Key? key, required this.authenticationRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar'), centerTitle: true,),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(authenticationRepository: authenticationRepository),
          child: RegisterForm(authenticationRepository: authenticationRepository),
        ),
      ),
    );
  }
}