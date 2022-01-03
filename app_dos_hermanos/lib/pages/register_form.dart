import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/register_bloc/register_bloc.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/widgets/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RegisterBloc _registerBloc;

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSumbiting;
  }

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state){
        if (state is FailRegister){
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Register Failure'), Icon(Icons.error)],
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
              children: <Widget>[Text('Registering...'), CircularProgressIndicator()],
            ),
          ));
        }
        if (state is SuccesRegister){
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationUserChanged(User(email: _emailController.text,id: '',photo: '',name: '')));
          Navigator.of(context).pop();
        }
        if (state is LoadingRegister){
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
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state){
          return Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_){
                    return !state.isEmailValid? 'Invalid Email' : '';
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_){
                    return !state.isPasswordValid? 'Invalid Password' : '';
                  },
                ),
                RegisterButton(
                  onPressed: isRegisterButtonEnabled(state)
                  ? _onFormSubmitted
                  : null,
                ),
              ],
            )
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(){
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged(){
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted(){
    _registerBloc.add(
      Sumbitted(email: _emailController.text, password: _passwordController.text)
    );
  }
}