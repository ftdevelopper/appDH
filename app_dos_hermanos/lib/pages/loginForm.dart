import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/login_bloc/login_bloc.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/widgets/create_account_button.dart';
import 'package:app_dos_hermanos/widgets/google_login_button.dart';
import 'package:app_dos_hermanos/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationRepository authenticationRepository;

  const LoginForm({Key? key, required this.authenticationRepository}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  AuthenticationRepository get _authenticationRepository => widget.authenticationRepository;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state){
    return state.isFormValid && isPopulated && !state.isSumbiting;
  }

  @override
  void initState(){
    super.initState ();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build( _ ) {
    return BlocListener<LoginBloc,LoginState>(
      listener: (context, state){
        if (state is FailLogin){
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Login Failure'), Icon(Icons.error)],
            ),
            backgroundColor: Colors.red,
          ));
        }
        if (state is Sumbitted){
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Logging in...'), CircularProgressIndicator()],
            ),
          ));
        }
        if (state is SuccesLogin){
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationUserChanged(User(email: _emailController.text,id: '',photo: '',name: '')));
        }
        if (state is LoadingLogin){
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Logging in...'), CircularProgressIndicator()],
            ),
          ));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state){
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
                    )
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (_){
                      return !state.isEmailValid? 'Invalid Email' : '';
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (_){
                      return !state.isPasswordValid? 'Invalid Password' : '';
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
                          : null
                        ),
                        GoogleLoginButton(),
                        CreateAccountButton(authenticationRepository: _authenticationRepository),
                      ],
                    ),
                  ),
                ],
              ),
            )
          );
        },
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(){
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged(){
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted(){
    _loginBloc.add(
      LoginWithCredentialPressed(email: _emailController.text, password: _passwordController.text)
    );
  }
}