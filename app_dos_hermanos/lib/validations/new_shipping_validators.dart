import 'package:app_dos_hermanos/classes/driver.dart';
import 'package:app_dos_hermanos/repository/drivers_repository.dart';

class NewShippingValidator {

  static String? isHumidityValid(String value){
    int intValue = int.parse(value);

    if (intValue <= 0 || intValue >= 100) {
      return 'Rango de humedad invalido';
    } else {
      return null;
    }
  }

  static String? isRiceValid(String value){
    if (value == 'Tipo de Arroz'){
      return 'Seleccione Tipo de Arroz';
    }
    else {
      return null;
    }
  }

  static String? isNameValid({required String driver, required DriverRepository driverRepository}){
    bool containValue = false;
    driverRepository.drivers.forEach((element) {
      if (element.name == driver){
        containValue = true;
      }
    });

    if (!containValue){
      return 'No se encuetra Conductor, por favor cree uno';
    }
  }

  static String? isTruckPatentValid({required String patent, required Driver driver}){
    bool existPatent = false;
    driver.truckPatents.forEach((element) { 
      if (element == patent){
        existPatent = true;
      }
    });
    if (!existPatent){
      return 'No existe esa patente para este conductor';
    }
  }

  static String? isChasisPatentValid({required String chasisPatent, required String truckPatent, required Driver driver}){
    List<int> indexs = [];
    int index = 0;
    bool existPatent = false;

    driver.truckPatents.forEach((element) {
      index ++;
      if (element == truckPatent){
        indexs.add(index);
      }
    });

    indexs.forEach((element) {
      if (driver.chasisPatents[element] == chasisPatent){
        existPatent = true;
      }
    });

    if (!existPatent){
      return 'No se encuentra la patente de chasis para este Conductor';
    } else {
      return null;
    }
  }

  static String? isWeightValid(String weight){
    if (weight == 'Weight'){
      return 'No se encuentra Peso';
    } else {
      return null;
    }
  }
}

