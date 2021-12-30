import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route(){
    return MaterialPageRoute(builder: (_) => LoginPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Column(
          children: <Widget>[
            Text('LoginPage en Construccion'),
            ElevatedButton(
              child: Text('Registrado'),
              onPressed: (){
                BlocProvider.of<AuthenticationBloc>(context, listen: false).add(AuthenticationUserChanged(User(email: 'tomastisocco@gmali.com',id: '123451',name: 'TomasCandente',photo: 'ulrPhoto')));
              },
            )
          ],
        ),
      ),
    );
  }
}