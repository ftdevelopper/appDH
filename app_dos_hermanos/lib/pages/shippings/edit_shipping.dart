import 'package:app_dos_hermanos/pages/shippings/update_shipping_button_widget.dart';
import 'package:app_dos_hermanos/pages/shippings/widgets/downloaded_shipping_widget.dart';
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
import 'package:app_dos_hermanos/validations/new_shipping_validators.dart';
import 'package:app_dos_hermanos/widgets/shipping_data.dart';

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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 Text('Envio Recibido'),
                                 Icon(Icons.warning)
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              primary: Colors.amber.shade700,
                            ),
                            onPressed: () {
                              _showRecivedConfirmationAlert();
                            },
                          ),
                    ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRecivedConfirmationAlert() async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Recepcion de Envio',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ShippingData(title: 'Fecha', data: DateFormat('dd-MM-yyyy').format(_date)),
                ShippingData(title: 'Hora', data: DateFormat.Hm().format(_date)),
                ShippingData(title: 'Usuario', data: widget.authenticationRepository.user.name),
                ShippingData(title: 'Ubicacion', data: widget.authenticationRepository.user.location.name),
                ShippingData(title: 'Arroz', data: riceValue),
                ShippingData(title: 'Chofer', data: _shipping.driverName),
                ShippingData(title: 'Camion', data: _shipping.truckPatent),
                ShippingData(title: 'Chasis', data: _shipping.chasisPatent),
                ShippingData(title: 'Peso Tara', data: _shipping.remiterTara.toString()),
                ShippingData(title: 'Peso Bruto', data: _shipping.remiterFullWeight.toString()),
                ShippingData(title: 'Peso Neto', data: _shipping.remiterWetWeight.toString()),
                ShippingData(title: 'Humedad', data: _shipping.humidity.toString()),
                ShippingData(title: 'Peso Seco', data: _shipping.remiterDryWeight.toString()),
                ElevatedButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    _shipping.addAction(
                      action: 'Confirmo Recepcion',
                      user: widget.authenticationRepository.user.id,
                      date: _formatedDate
                    );
                    _shipping.shippingState = ShippingStatus.completedShipping;
                    _shipping.reciverFullWeightTime = _date;
                    _shipping.reciverFullWeightUser =
                    widget.authenticationRepository.user.id;
                    _shipping.reciverTara = _shipping.remiterTara;
                    _shipping.reciverFullWeight = _shipping.remiterFullWeight;
                    _shipping.reciverDryWeight = _shipping.remiterDryWeight;
                    _shipping.reciverWetWeight = _shipping.remiterWetWeight;
                    context.read<ShippingsBloc>().add(UpdateShipping(shipping: _shipping));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[],
          actionsPadding: EdgeInsets.symmetric(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
