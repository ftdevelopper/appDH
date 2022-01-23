import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/rice.dart';
import 'package:path_provider/path_provider.dart';

class LocalDataBase {
  // Listas de objetos a guardar en DB
  List<Rice> riceDB;
  List<Location> locationDB;

  LocalDataBase({required this.locationDB, required this.riceDB});

  // Transformar las listas de objetos a formato Json como distintos valores de un Mapa
  Map<String, dynamic> toJson() => {
    "riceTypes": List<dynamic>.from(riceDB.map((riceType) => riceType.toJson())),
    "locations": List<dynamic>.from(locationDB.map((locaiton) => locaiton.toJson()))
  };


  // Construye la base de datos desde el json guardado en el dispositivo.
  factory LocalDataBase.fromJson(Map<String, dynamic> jsonDB) {
    return LocalDataBase(
      riceDB: List<Rice>.from(jsonDB["riceTypes"].map((element) => Rice.fromJson(element))),
      locationDB: List<Location>.from(jsonDB["locations"].map((element) => Location.fromJson(element)))
    );
  }

  loadDB() async {
    try {
      await DataBaseFileRoutines().readDataBase().then((jsonDB) {
        locationDB = databaseFromJson(jsonDB).locationDB;
        riceDB = databaseFromJson(jsonDB).riceDB;
      });  
    } catch (e) {
      print(e);
    }
    
  }
}


class DataBaseFileRoutines {

  // Obtiene el path de la ubicacion donde esta la aplicacion almacenada
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Obtiene el archivo donde esta guardado el json con la data
  Future<File> get _localFile async {
    final path = await _localPath;
    //TODO: Delete Print
    print(path);
    return File('$path/LOCAlDataBase.json');
  }


  // Escribir en el archivo en la memoria local el json que se quiera
  Future<void> writeDataBase(String json) async {
    final file = await _localFile;

    try {
      file.writeAsString(json);
    } catch (e) {
      print(e);
    }
  }

  Future<String> readDataBase() async {
    try{
      final file = await _localFile;
      if(!file.existsSync()){
        print('File does not exist: ${file.absolute}');
        await writeDataBase('{"locations:[{"name":name}]","riceTypes":["type":type]}');
      }
      String content = await file.readAsString();
      return content;
    } catch (e) {
      print("error reading DataBase: $e");
      return "";
    }
  }
}

LocalDataBase databaseFromJson(String string) {
  final dataFromJson = json.decode(string);
  print('La Base de datos Local contenia lo siguiente: $string');
  return LocalDataBase.fromJson(dataFromJson);
}

String databaseToJson(LocalDataBase data){
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}