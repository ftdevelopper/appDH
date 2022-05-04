import 'package:flutter/material.dart';

import 'package:app_dos_hermanos/features/registration_feature/pages/register_screen.dart';
import '../../../repositories/authentication_repository.dart';

class CreateAccountButton extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const CreateAccountButton({Key? key, required this.authenticationRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Crear Cuenta Nueva'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegisterScreen(
              authenticationRepository: authenticationRepository);
        }));
      },
    );
  }
}
