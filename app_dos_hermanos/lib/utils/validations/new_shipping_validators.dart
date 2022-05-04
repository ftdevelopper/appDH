import 'package:app_dos_hermanos/repositories/drivers_repository.dart';

class NewShippingValidator {

  static String? isHumidityValid(String? value){
    double? intValue = double.tryParse(value ?? '');

    if (intValue == null){
      return 'Valor invalido';
    }

    if (intValue <= 12 || intValue >= 36) {
      return 'Rango de humedad invalido';
    } else {
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
      return 'No se encuetra Conductor';
    }
  }

  static String? isTruckPatentValid({required String patent}){
    bool existPatent = false;
    /*driver.truckPatents.forEach((element) { 
      if (element == patent){
        existPatent = true;
      }
    });*/
    if (!existPatent){
      return 'No existe esta patente';
    }
  }

  static String? isChasisPatentValid({required String chasisPatent, required String truckPatent}){
    List<int> indexs = [];
    int index = 0;
    bool existPatent = false;

    /*driver.truckPatents.forEach((element) {
      if (element == truckPatent){
        indexs.add(index);
      }
      index++;
    });

    indexs.forEach((element) {
      if (driver.chasisPatents[element] == chasisPatent){
        existPatent = true;
      }
    });*/

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

  static String? isLocationValid(String location){
    if(location == 'SELECCIONAR'){
      return 'Seleccione una Ubicacion Valida';
    } else {
      return null;
    }
  }

  static String? isUserNameValid(String name){
    if(name == ''){
      return 'Ingrese Su Nombre';
    } else {
      return null;
    }
  }
}

