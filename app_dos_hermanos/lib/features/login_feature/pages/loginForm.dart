import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_dos_hermanos/features/login_feature/cubit/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/features/login_feature/cubit/login_bloc/login_bloc.dart';
import 'package:app_dos_hermanos/features/login_feature/widgets/login_button.dart';
import '../../../repositories/authentication_repository.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;

  const LoginForm({Key? key, required this.authenticationRepository})
      : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  AuthenticationRepository get _authenticationRepository =>
      widget.authenticationRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSumbiting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(_) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state is FailLogin) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Error al ingresar'), Icon(Icons.error)],
            ),
            elevation: 6.0,
            backgroundColor: Colors.red,
          ));
      }
      if (state is Sumbitted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ingresando...'),
                  CircularProgressIndicator()
                ],
              ),
              backgroundColor: Colors.black));
      }
      if (state is SuccesLogin) {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationUserChanged());
      }
      if (state is LoadingLogin) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ingresando...'),
                  CircularProgressIndicator()
                ],
              ),
              backgroundColor: Colors.black));
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 200,
                      )),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      return !state.isEmailValid ? 'Email Invalido' : null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Contraseña',
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? 'Contraseña Invalida'
                          : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : () {}),
                        //GoogleLoginButton(),
                        //CreateAccountButton(authenticationRepository: _authenticationRepository),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _authenticationRepository.user.email = _emailController.text;
    _loginBloc
        .add(LoginWithCredentialPressed(password: _passwordController.text));
  }
}
