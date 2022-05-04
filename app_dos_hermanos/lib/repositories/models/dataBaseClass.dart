import 'dart:math';

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
    Random r = Random();
    for (var i = 0; i < 6; i++) {
      _shipDB.add(RiceShip(riceType: _riceType[i], pesoBruto: (r.nextInt(3000) + 10000), pesoTara: (r.nextInt(400) + 2000), product: i.toString(), cosecha: '...',
      contrato: '...', procedencia: 'Campo $i', partidanum: '...',
      llegada: DateTime.now().add(Duration(minutes: r.nextInt(600)))));
    }
    _shipDB.sort((sort1, sort2) => sort1.llegada.compareTo(sort2.llegada));
    return RiceShipDB(shipsDB: _shipDB);
  }
}