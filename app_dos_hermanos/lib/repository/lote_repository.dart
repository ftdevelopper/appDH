import 'package:app_dos_hermanos/classes/lote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiceRepository {

  final CollectionReference riceTypesReference = FirebaseFirestore.instance.collection('lotes');

  Future<List<Lote>> getRiceTypes () async {
    final snapshot = await riceTypesReference.get();
    return snapshot.docs.map((doc) => _fromSnapshot(doc)).toList();
  }

  Lote _fromSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Lote.fromJson(data);
    
  }
}