//import 'package:app_dos_hermanos/blocs/login_bloc/login_bloc.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleSignInButton(
      borderRadius: 25,
      centered: true,
      onPressed: (){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Ingresando...'),
                CircularProgressIndicator()
              ],
            ),
          ),
        );
        //BlocProvider.of<LoginBloc>(context).add(
          //LoginWithGooglePressed()
        //);
      },
    );
  }
}