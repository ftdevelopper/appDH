import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/locations.dart';

class LocationRepository {
  final CollectionReference locationsReference =
      FirebaseFirestore.instance.collection('locations');

  Future<List<Location>> getLocations() async {
    final snapshot = await locationsReference.get();
    return snapshot.docs.map((doc) => Location.fromSnapshot(doc)).toList();
  }
}
