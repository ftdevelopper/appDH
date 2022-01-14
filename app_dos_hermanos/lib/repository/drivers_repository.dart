import 'package:app_dos_hermanos/classes/driver.dart';

class DriverRepository {
  List<Driver> drivers;

  DriverRepository({required this.drivers});

  Driver driverFromName(String name){
    return drivers.firstWhere((element) => element.name == name);
  }

  List<Driver> sugestedDriver(String patent){
    return drivers.takeWhile((value) => value.truckPatents.contains(patent)).toList();
  }
}