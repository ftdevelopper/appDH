import 'package:app_dos_hermanos/classes/rice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiceRepository {
  RiceRepository({required this.ricetypes});

  List<Rice> ricetypes;

  final CollectionReference riceTypesReference = FirebaseFirestore.instance.collection('ricetypes');

  Future<List<dynamic>> getRiceTypes () async {
    final snapshot = await riceTypesReference.get();
    return snapshot.docs.map((doc) => _fromSnapshot(doc)).toList();
  }

  void loadRiceFromDB() {
    ricetypes = getRiceTypes() as List<Rice>;
  }

  Rice _fromSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic> data = snapshot.data() as Map<String, String>;
    return Rice.fromJson(data);
    
  }
}