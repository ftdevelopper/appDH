import 'package:app_dos_hermanos/classes/dataBaseClass.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// ignore: must_be_immutable
class EntryShipPage extends StatefulWidget {

  EntryShipPage({Key? key, required this.database}) : super(key: key);

  RiceShipDB database;

  @override
  _EntryShipPageState createState() => _EntryShipPageState();
}

class _EntryShipPageState extends State<EntryShipPage> {

  late RiceShip _newRiceShip;
  late TextEditingController _contratoController;
  late TextEditingController _cosechaController;
  late TextEditingController _productoController;
  late TextEditingController _partidanumController;
  late FocusNode _contratoFocus;
  late FocusNode _cosechaFocus;
  late FocusNode _productoFocus;
  late FocusNode _partidanumFocus;
  List<String> _riceType = ['Doble Carolina', 'Integral', 'Largo Fino', 'No se pasa', 'Aromatico', 'Yamani', 'Select'];
  List<String> _procedencia = ['Campo 1', 'Campo 2', 'Campo 3', 'Campo 4', 'Campo 5', 'Campo 6'];
  String value = 'Select';
  String value1 = 'Campo 1';
  int _pesobruto = 0;
  int _pesotara = 0;

  @override
  void initState() {
    _newRiceShip = RiceShip.emptyEntry();
    _contratoController = TextEditingController();
    _cosechaController = TextEditingController();
    _productoController = TextEditingController();
    _partidanumController = TextEditingController();
    _contratoFocus = FocusNode();
    _cosechaFocus = FocusNode();
    _productoFocus = FocusNode();
    _partidanumFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _partidanumController.dispose();
    _productoController.dispose();
    _cosechaController.dispose();
    _contratoController.dispose();
    _partidanumFocus.dispose();
    _productoFocus.dispose();
    _cosechaFocus.dispose();
    _contratoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Nuevo Envio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset('assets/logo.png',alignment: Alignment.center),
                Row(
                  children: [
                    Icon(Icons.rice_bowl_rounded, color: Colors.grey[600],),
                    SizedBox(width: 10,),
                    Text('Tipo de Arroz: '),
                    SizedBox(width: 20,),
                    DropdownButton(
                      elevation: 0,
                      value: value,
                      items: _riceType.map((String item){
                          return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue){
                        setState(() {
                          value = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.grey[600],),
                    SizedBox(width: 10,),
                    Text('Procedencia: '),
                    SizedBox(width: 20,),
                    DropdownButton(
                      elevation: 0,
                      value: value1,
                      items: _procedencia.map((String item){
                          return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue){
                        setState(() {
                          value1 = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                Divider(),
                TextField(
                  controller: _contratoController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _contratoFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Contrato',
                    icon: Icon(Icons.file_copy),
                  ),
                  onSubmitted: (str){
                    FocusScope.of(context).requestFocus(_cosechaFocus);
                  },
                ),
                TextField(
                  controller: _cosechaController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _cosechaFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Cosecha',
                    icon: Icon(Icons.rice_bowl),
                  ),
                  onSubmitted: (str){
                    FocusScope.of(context).requestFocus(_productoFocus);
                  },
                ),
                TextField(
                  controller: _productoController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _productoFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    icon: Icon(Icons.production_quantity_limits),
                  ),
                  onSubmitted: (str){
                    FocusScope.of(context).requestFocus(_partidanumFocus);
                  },
                ),
                TextField(
                  controller: _partidanumController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _partidanumFocus,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Numero de Partida',
                    icon: Icon(Icons.format_list_numbered),
                  ),
                  maxLines: null,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  child: Text('Pesar'),
                  onPressed: (){
                    Random r = Random();
                    setState(() {
                      _pesobruto = r.nextInt(1000) + 10000;
                      _pesotara = r.nextInt(300) + 2000;
                    });
                  },
                ),
                Text(
                  'Peso Bruto: $_pesobruto kg\n'
                  'Peso Tara:    $_pesotara kg\n'
                  'Peso Neto:  ${_pesobruto - _pesotara} kg\n',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  height: 30,
                  child: ElevatedButton(
                    child: Text('Enviar'),
                    onPressed: (){
                      _newRiceShip.contrato = _contratoController.text;
                      _newRiceShip.cosecha = _cosechaController.text;
                      _newRiceShip.contrato = _contratoController.text;
                      _newRiceShip.product = _productoController.text;
                      _newRiceShip.procedencia = value1;
                      _newRiceShip.riceType = value;
                      _newRiceShip.pesoBruto = _pesobruto;
                      _newRiceShip.pesoTara = _pesotara;
                      Random r = Random();
                      _newRiceShip.llegada = DateTime.now().add(Duration(minutes: r.nextInt(600)));
                      setState(() {
                        widget.database.shipsDB.add(_newRiceShip);
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}