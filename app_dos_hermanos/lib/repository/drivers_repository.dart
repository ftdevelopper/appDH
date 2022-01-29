import 'dart:convert';

import 'package:app_dos_hermanos/classes/drivers.dart';
import 'package:app_dos_hermanos/provider/drivers_provider.dart';

class DriverRepository {
  List<Driver> drivers;

  DriverRepository({required this.drivers});

  Future<List<Driver>> getLocations () async {
    return [];
  }

  List<Driver> sugestedDriver(String patent){
    return drivers.takeWhile((value) => value.patent.contains(patent)).toList();
  }

  factory DriverRepository.fromJson(dynamic jsonList){
    return DriverRepository(
      drivers: List<Driver>.from(jsonList.map((element) {
        return Driver.fromJson(element);
      }))
    );
  }
}