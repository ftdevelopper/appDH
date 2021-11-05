class RiceShip{

  late String riceType;
  late String product;
  late String? cosecha;
  late String? contrato;
  late String? procedencia;
  late String? partidanum;
  late int pesoBruto;
  late int pesoTara;
  late DateTime llegada;

  RiceShip({required this.riceType, required this.product, this.cosecha, this.contrato, this.procedencia, this.partidanum, required this.pesoBruto, required this.pesoTara, required this.llegada});

  int get pesoNeto {
    return pesoBruto - pesoTara;
  }

  factory RiceShip.emptyEntry(){
    RiceShip _ship = RiceShip(
      llegada: DateTime.now(),
      pesoTara: 0,
      pesoBruto: 0,
      partidanum: '...',
      procedencia: '...',
      contrato: '...',
      cosecha: '...',
      product: '...',
      riceType: '...',
    );
    return _ship;
  }
}

class RiceShipDB{
  final List<RiceShip> shipsDB;

  RiceShipDB({required this.shipsDB});

  factory RiceShipDB.initialize(){
    List<String> _riceType = ['Doble Carolina', 'Integral', 'Largo Fino', 'No se pasa', 'Aromatico', 'Yamani'];
    List<RiceShip> _shipDB = [];
    for (var i = 0; i < 6; i++) {
      _shipDB.add(RiceShip(riceType: _riceType[i], pesoBruto: (i * 42 + 5000), pesoTara: (i * 10 + 912), product: i.toString(), cosecha: '...',
      contrato: '...', procedencia: 'Campo $i', partidanum: '...',
      llegada: DateTime.now().add(Duration(minutes: i*32 + 30))));
    }

    return RiceShipDB(shipsDB: _shipDB);
  }
}