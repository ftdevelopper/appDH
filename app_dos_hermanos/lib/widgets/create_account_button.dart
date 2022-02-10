import 'package:app_dos_hermanos/pages/register/register_screen.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const CreateAccountButton({Key? key, required this.authenticationRepository}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Crear Cuenta Nueva'),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context){
            return RegisterScreen(authenticationRepository: authenticationRepository);
          })
        );
      },
    );
  }
}