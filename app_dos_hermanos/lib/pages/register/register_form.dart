import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:app_dos_hermanos/blocs/authentication_bloc/authenticaiton_bloc.dart';
import 'package:app_dos_hermanos/blocs/register_bloc/register_bloc.dart';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/location_repository.dart';
import 'package:app_dos_hermanos/widgets/register_button.dart';
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
  late Location _location;

  Image profilePhoto = Image.asset('assets/default_profile_pic.jpg');
  File? profilePhotoFile;

  late RegisterBloc _registerBloc;

  final LocationRepository _locationRepository = LocationRepository();
  List<Location> _locations = [Location(name: 'SELECCIONAR')];

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
              children: <Widget>[Text('Error al registrar'), Icon(Icons.error)],
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
              children: <Widget>[Text('Registrando...'), CircularProgressIndicator()],
            ),
          ));
        }
        if (state is SuccesRegister){
          BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationUserChanged());
          Navigator.of(context).pop();
        }
        if (state is LoadingRegister){
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('Ingresando...'), CircularProgressIndicator()],
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
                        image: DecorationImage(image: profilePhoto.image,fit: BoxFit.scaleDown)
                      ),
                    ),
                    onTap: () async {
                      try {
                        XFile? newImage = (await ImagePicker().pickImage(source: ImageSource.camera));
                        if (newImage != null){
                          profilePhotoFile = File(newImage.path);
                          final bytes = await profilePhotoFile!.readAsBytes();
                          final image = (Image.memory(bytes));

                          setState(() {
                            profilePhoto = image;
                          });
                        }else{
                          print('newImage = null');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
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
                    return !state.isEmailValid? 'Email Invalido' : '';
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Contraseña',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_){
                    return !state.isPasswordValid? 'Contraseña Invalida' : '';
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Nombre',
                  ),
                ),
                SizedBox(height: 20,),
                FutureBuilder(
                  future: _loadLocations(),
                  builder:(context, AsyncSnapshot snapshot){ 
                    _location = Location(name: 'SELECCIONAR');
                    return DropdownButtonFormField<String>(
                    value: _location.name,
                    decoration: InputDecoration(labelText: 'Ubicacion', border: InputBorder.none, icon: Icon(Icons.location_on)),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_){
                    
                    },
                  onChanged: (dynamic newValue ){
                setState(() {
                  _location = Location.fromName(newValue);
                });
                  },
                  items: _locations.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name ,overflow: TextOverflow.visible,),
                );
                  }).toList(),
                  selectedItemBuilder: (context){
                return _locations
                .map((value) => Container(
                  child: Text(
                    value.name, 
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 1, 
                    softWrap: true
                  ),
                  width: MediaQuery.of(context).size.width*0.7,
                )
                ).toList();
                  },
                );
                  }),
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

  void _onFormSubmitted() async {
    widget.authenticationRepository.user
    ..email = _emailController.text
    ..name = _nameController.text
    ..photoURL = ''
    ..location = _location
    ..profilePhoto = profilePhoto;
    _registerBloc.add(Sumbitted(password: _passwordController.text, photoFile: profilePhotoFile)
    );
  }

  Future _loadLocations() async {
    _locations = await _locationRepository.getLocations();
  }
}