import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  String did;
  String name;
  String cuil;
  List<String> truckPatents;
  List<String> chasisPatents;
  List<String> driverShippings;

  Driver({
    required this.did, required this.name, required this.cuil, required this.truckPatents, required this.chasisPatents, required this.driverShippings
  });

  factory Driver.formSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Driver(
      did: data['did'],
      name: data['name'],
      cuil: data['cuil'],
      truckPatents: data['truckPatents'],
      chasisPatents: data['chasisPatents'],
      driverShippings: data['driverShippings']
    );
  }

  factory Driver.empty(){
    return Driver(
      did: '', 
      name: '', 
      cuil: '', 
      truckPatents: [''], 
      chasisPatents: [''], 
      driverShippings: ['']
    );
  }
}