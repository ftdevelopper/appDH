import 'package:app_dos_hermanos/classes/driver.dart';
import 'package:app_dos_hermanos/repository/drivers_repository.dart';

class NewShippingValidator {

  static String? isHumidityValid(String value){
    int intValue = int.parse(value);

    if (intValue <= 9 || intValue >= 35) {
      return 'Rango de humedad invalido';
    } else {
      return null;
    }
  }

  static String? isRiceValid(String? value){
    if (value == 'Tipo de Arroz'){
      return 'Seleccione Tipo de Arroz';
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
      return 'No se encuetra Conductor';
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
      return 'No existe esta patente';
    }
  }

  static String? isChasisPatentValid({required String chasisPatent, required String truckPatent, required Driver driver}){
    List<int> indexs = [];
    int index = 0;
    bool existPatent = false;

    driver.truckPatents.forEach((element) {
      if (element == truckPatent){
        indexs.add(index);
      }
      index++;
    });

    indexs.forEach((element) {
      if (driver.chasisPatents[element] == chasisPatent){
        existPatent = true;
      }
    });

    if(chasisPatent == 'Sin Chasis'){
      existPatent = true;
    }

    if (!existPatent){
      return 'No se encuentra esta patente';
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

