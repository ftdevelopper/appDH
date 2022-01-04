import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShippingRepository {
  final databaseReference = FirebaseFirestore.instance;

  Stream<List<Shipping>> getSippings() {
    return databaseReference.collection("shippings").snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc) => Shipping.fromSnapShot(doc)).toList();
    });
  }
}