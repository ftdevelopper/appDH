import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShippingRepository {
  final databaseReference = FirebaseFirestore.instance.collection("shippings");

  Stream<List<Shipping>> getSippings() {
    return databaseReference.snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc) => Shipping.fromSnapShot(doc)).toList();
    });
  }

  Future<void> putShipping(Shipping shipping) async {
    databaseReference.doc().set(
      _mapShipping(shipping)
    );
  }

  Future<void> updateParameter({required String id, required String parameter, required String value}) async {
    databaseReference.doc(id).update({
      parameter:value
    });
  }

  Map<String, String>_mapShipping(Shipping shipping){
    Map<String, String> _shippingMap = {
      'shippingState': shipping.getStatus,
      'patent': shipping.patent,
      'remiterFullWeight': shipping.remiterFullWeight ?? '',
      'remiterFullWeightTime': shipping.remiterFullWeightTime ?? '',
      'remiterFullWeightUser': shipping.remiterFullWeightUser ?? '',
      'remiterLocation': shipping.remiterLocation ?? '',
      'remiterTara': shipping.remiterTara ?? '',
      'remiterTaraTime': shipping.remiterTaraTime ?? '',
      'remiterTaraUser': shipping.remiterTaraUser ?? '',
      'reciverFullWeight': shipping.reciverFullWeight ?? '',
      'reciverFullWeightTime': shipping.reciverFullWeight ?? '',
      'reciverFullWeightUser': shipping.reciverFullWeightUser ?? '',
      'reciverLocation': shipping.reciverLocation ?? '',
      'reciverTara': shipping.reciverTara ?? '',
      'reciverTaraTime': shipping.reciverTaraTime ?? '',
      'reciverTaraUser': shipping.reciverTaraUser ?? '',
      'riceType': shipping.riceType ?? ''
    };
    return _shippingMap;
  }
}