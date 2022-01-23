import 'package:app_dos_hermanos/classes/rice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiceRepository {

  final CollectionReference riceTypesReference = FirebaseFirestore.instance.collection('ricetypes');

  Future<List<Rice>> getRiceTypes () async {
    final snapshot = await riceTypesReference.get();
    return snapshot.docs.map((doc) => _fromSnapshot(doc)).toList();
  }

  Rice _fromSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Rice.fromJson(data);
    
  }
}