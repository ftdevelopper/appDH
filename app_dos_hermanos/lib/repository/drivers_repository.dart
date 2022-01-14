import 'package:app_dos_hermanos/classes/driver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverRepository {
  List<Driver> drivers;

  DriverRepository({required this.drivers});

  final CollectionReference driversReference = FirebaseFirestore.instance.collection('drivers');

  Future<List<Driver>> getLocations () async {
    final snapshot = await driversReference.get();
    return snapshot.docs.map((doc) => Driver.formSnapshot(doc)).toList();
  }

  Future<void> updateUserData(Driver driver) async {
    await driversReference.doc(driver.did).set(
      _mapDriver(driver, driver.did)
    );
  }

  Driver driverFromName(String name){
    return drivers.firstWhere((element) => element.name == name);
  }

  List<Driver> sugestedDriver(String patent){
    return drivers.takeWhile((value) => value.truckPatents.contains(patent)).toList();
  }

  Map<String, dynamic>_mapDriver(Driver driver, String did){
    Map<String, dynamic> _drivergMap = {
      'did': did,
      'name': driver.name,
      'cuil': driver.cuil,
      'truckPatents': driver.truckPatents,
      'chasisPatents': driver.chasisPatents,
      'driverShippings': driver.driverShippings
    };
    return _drivergMap;
  }
}