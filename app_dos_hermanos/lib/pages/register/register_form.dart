import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/register_bloc/register_bloc.dart';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:app_dos_hermanos/widgets/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {

  final AuthenticationRepository authenticationRepository;
  RegisterForm({Key? key, required this.authenticationRepository}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _location = 'campo default';

  late RegisterBloc _registerBloc;

  final LocationRepository _locationRepository = LocationRepository();
  List<Location> _locations = [Location(name: 'campo default')];

  bool get isPopulated => (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _nameController.text.isNotEmpty);

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSumbiting;
  }

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _nameController.addListener(_onPasswordChanged);
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return BlocListener<RegisterBloc,RegisterState>(
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
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationUserChanged(User(email: _emailController.text,id: '',photo: '',name: '',location: Location(name: ''))));
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(

                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('assets/default_profile_pic.jpg'))
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return !state.isEmailValid? 'Invalid Email' : '';
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return !state.isPasswordValid? 'Invalid Password' : '';
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.grey.shade600,),
                    SizedBox(width: 100,),
                    FutureBuilder(
                      future: _loadLocations(),
                      builder:(context, AsyncSnapshot snapshot){ 
                        return DropdownButton(
                          
                          items: _locations.map((Location location) {
                            return DropdownMenuItem<String>(
                              value: location.name,
                              child: Text(location.name)
                            );
                          }).toList(),
                          value: _location,
                          onChanged: (String? newlocation){
                            setState(() {
                              _location = newlocation ?? '';
                            });
                          },
                        );
                      }),
                  ],
                ),
                SizedBox(height: 20,),
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
    _nameController.dispose();
    super.dispose();
  }

  void _onEmailChanged(){
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged(){
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted(){
    widget.authenticationRepository.user
    ..email = _emailController.text
    ..name = _nameController.text
    ..photo = ''
    ..location = Location.fromName(_location);
    _registerBloc.add(Sumbitted(password: _passwordController.text)
    );
  }

  Future _loadLocations() async {
    _locations = await _locationRepository.getLocations();
  }
}