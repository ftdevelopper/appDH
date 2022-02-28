import 'package:app_dos_hermanos/pages/shippings/update_shipping_button_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/downloaded_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/finish_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/intravel_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/new_shipping_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/pesar_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/blocs/shippings_bloc/shippings_bloc.dart';
import 'package:app_dos_hermanos/classes/lote.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/edit_shipping_widget.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';

// ignore: must_be_immutable
class EditShipping extends StatefulWidget {
  AuthenticationRepository authenticationRepository;
  Shipping shipping;
  LocalDataBase localDataBase;

  EditShipping(
      {Key? key,
      required this.authenticationRepository,
      required this.shipping,
      required this.localDataBase})
      : super(key: key);

  @override
  _EditShippingState createState() => _EditShippingState();
}

class _EditShippingState extends State<EditShipping> {
  late Shipping _shipping;
  late DateTime _date;
  late String _formatedDate;

  late TextEditingController _humidityController;
  late TextEditingController _riceController;
  late TextEditingController _loteController;
  late String riceValue = 'Tipo de Arroz';
  late List<Lote> lotesDB;

  @override
  void initState() {
    _shipping = widget.shipping;
    _date = DateTime.now();
    _formatedDate = DateFormat('yyyy-MM-dd kk:mm').format(_date);
    _humidityController = TextEditingController();
    lotesDB = widget.localDataBase.loteDB;
    _loteController = TextEditingController();
    _riceController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothCubit, MyBluetoothState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Actualizar Envio'),
              centerTitle: true,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[

                    EditShippingWidget(shipping: 
                      _shipping, 
                      formatedDate: _formatedDate,
                    ),
                    
                    if (_shipping.shippingState == ShippingStatus.newShipping)
                      NewShippingWidget(),

                    if (_shipping.shippingState ==
                        ShippingStatus.inTravelShipping)
                      IntravelShippingWidget(),

                    if (_shipping.shippingState ==
                        ShippingStatus.downloadedShipping)
                      DownloadedShippingWidget(),

                    PesarButtonWidget(),

                    UpdateShippingButtonWidget(),
                    
                    if (_shipping.shippingState == ShippingStatus.inTravelShipping)
                      FinishShippingButtonWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  

  void uploadShipping() async {
    switch (_shipping.shippingState) {
      case ShippingStatus.newShipping:
        _shipping.remiterFullWeightTime = _date;
        _shipping.remiterFullWeightUser =
            widget.authenticationRepository.user.id;
        _shipping.riceType = _riceController.text;
        _shipping.lote = _loteController.text;
        break;
      case ShippingStatus.inTravelShipping:
        _shipping.humidity = _humidityController.text;
        _shipping.reciverFullWeightTime = _date;
        _shipping.reciverFullWeightUser =
            widget.authenticationRepository.user.id;
        break;
      case ShippingStatus.downloadedShipping:
        _shipping.reciverTaraTime = _date;
        _shipping.reciverTaraUser = widget.authenticationRepository.user.id;
        break;
      default:
    }
    _shipping.nextStatus();
    context.read<ShippingsBloc>().add(UpdateShipping(shipping: _shipping));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
