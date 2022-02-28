import 'dart:convert';

import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShippingRepository {
  final databaseReference = FirebaseFirestore.instance.collection("shippingsTest");

  Stream<List<Shipping>> getShippings({required Duration duration}) {
    return databaseReference
    .where('remiterTaraTime', isGreaterThanOrEqualTo: DateTime.now().subtract(duration).toString())
    .orderBy('remiterTaraTime', descending: true)
    .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Shipping.fromSnapShot(doc)).toList();
    });
  }

  Future<void> putShipping(Shipping shipping) async {
    await databaseReference.doc(shipping.id).set(
      _mapShipping(shipping)
    );
  }

  Future<void> updateParameter({required Shipping shipping}) async {
    databaseReference.doc(shipping.id).update(
      _mapShipping(shipping)
    );
  }

  Map<String, String?>_mapShipping(Shipping shipping){
    Map<String, String?> _shippingMap = {
      'shippingState': shipping.getStatus,
      'driverName': shipping.driverName,
      'truckPatent': shipping.truckPatent,
      'chasisPatent': shipping.chasisPatent,
      'remiterFullWeight': shipping.remiterFullWeight,
      'remiterFullWeightTime': shipping.remiterFullWeightTime.toString(),
      'remiterFullWeightUser': shipping.remiterFullWeightUser,
      'remiterLocation': shipping.remiterLocation,
      'remiterTara': shipping.remiterTara,
      'remiterTaraTime': shipping.remiterTaraTime.toString(),
      'remiterTaraUser': shipping.remiterTaraUser,
      'reciverFullWeight': shipping.reciverFullWeight,
      'reciverFullWeightTime': shipping.reciverFullWeightTime.toString(),
      'reciverFullWeightUser': shipping.reciverFullWeightUser,
      'reciverLocation': shipping.reciverLocation,
      'reciverTara': shipping.reciverTara,
      'reciverTaraTime': shipping.reciverTaraTime.toString(),
      'reciverTaraUser': shipping.reciverTaraUser,
      'riceType': shipping.riceType,
      'id': shipping.id ?? DateTime.now().toString(),
      'crop': shipping.crop,
      'departure': shipping.departure,
      'humidity': shipping.humidity,
      'reciverDryWeight': shipping.reciverDryWeight,
      'reciverWetWeight': shipping.reciverWetWeight,
      'remiterDryWeight': shipping.remiterDryWeight,
      'remiterWetWeight': shipping.remiterWetWeight,
      'isOnLine': json.encode(shipping.isOnLine),
      'actions': json.encode(shipping.actions),
      'userActions': json.encode(shipping.userActions),
      'dateActions': json.encode(shipping.dateActions),
      'lote': shipping.lote,
    };
    return _shippingMap;
  }
}