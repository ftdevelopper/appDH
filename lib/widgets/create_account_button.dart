import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const CreateAccountButton({Key? key, required this.authenticationRepository}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Create an Account'),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context){
            return Container();
          })
        );
      },
    );
  }
}