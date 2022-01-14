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
    await databaseReference.add(
      _mapShipping(shipping, this.databaseReference.id)
    ).then((value) {
      databaseReference.doc(value.id).update({'id':value.id});
    });
  }

  Future<void> updateParameter({required Shipping shipping}) async {
    databaseReference.doc(shipping.id).update(
      _mapShipping(shipping, shipping.id!)
    );
  }

  Map<String, String>_mapShipping(Shipping shipping, String id){
    Map<String, String> _shippingMap = {
      'shippingState': shipping.getStatus,
      'driverName': shipping.driverName,
      'truckPatent': shipping.truckPatent,
      'chasisPatent': shipping.chasisPatent,
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
      'riceType': shipping.riceType ?? '',
      'id': id,
      'crop': shipping.crop ?? '',
      'departure': shipping.departure ?? '',
      'humidity': shipping.humidity ?? '',
    };
    return _shippingMap;
  }
}