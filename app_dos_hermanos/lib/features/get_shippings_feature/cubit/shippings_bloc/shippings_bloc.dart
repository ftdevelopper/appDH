import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'package:app_dos_hermanos/features/get_shippings_feature/models/filter.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/repositories/local_data_base.dart';
import 'package:app_dos_hermanos/repositories/shipping_repository.dart';
import '../../../../utils/internet_cubit/internet_cubit.dart';

part 'shippings_event.dart';
part 'shippings_state.dart';

class ShippingsBloc extends Bloc<ShippingsEvent, ShippingsState> {
  final ShippingRepository shippingRepository;
  late StreamSubscription? _shippingsSubscription;
  late StreamSubscription? _internetSubscription;
  LocalDataBase localDataBase;
  final InternetCubit internetCubit;
  bool isInternetConnected = false;

  ShippingsBloc(
      {required this.shippingRepository,
      required this.localDataBase,
      required this.internetCubit})
      : super(ShippingsLoading(
            filter: Filter(duration: Duration(days: 3)),
            shippingList: localDataBase.shippingsDB)) {
    _internetSubscription = internetCubit.stream.listen((state) {
      List<Shipping> toRemove = [];
      if (state is InternetConnected) {
        isInternetConnected = true;
        localDataBase.shippingsDB.forEach((element) async {
          try {
            element.isOnLine = true;
            add(AddShipping(shipping: element));
            print('trying to upload ${element.truckPatent} to FireBase');
            toRemove.add(element);
          } catch (e) {
            element.isOnLine = false;
          }
        });
        localDataBase.shippingsDB
            .removeWhere((element) => toRemove.contains(element));
        DataBaseFileRoutines()
            .writeDataBase(json.encode(localDataBase.toJson()));
      } else {
        isInternetConnected = false;
      }
    });

    on<LoadShippings>((event, emit) async {
      try {
        _shippingsSubscription?.cancel();
      } catch (e) {
        print(e);
      }
      emit(ShippingsLoading(
          filter: event.filter, shippingList: state.shippingList));
      try {
        _shippingsSubscription = shippingRepository
            .getShippings(
          duration: state.filter?.duration ?? Duration(days: 3),
        )
            .listen((shippings) {
          print('New shipping Loaded: ${shippings.toString()}');
          return add(ShippingsUpdated(shippingList: shippings));
        });
        print('Loading new Shippings');
      } catch (e) {
        print('Error recived: $e');
        emit(ShippingsNotLoaded(shippingList: state.shippingList));
      }
    });

    on<AddShipping>((event, emit) async {
      if (isInternetConnected) {
        try {
          await shippingRepository.putShipping(event.shipping);
        } catch (e) {
          print(e);
          event.shipping.isOnLine = false;
          localDataBase.shippingsDB.add(event.shipping);
          DataBaseFileRoutines()
              .writeDataBase(json.encode(localDataBase.toJson()));
        }
      } else {
        event.shipping.isOnLine = false;
        localDataBase.shippingsDB.add(event.shipping);
        DataBaseFileRoutines()
            .writeDataBase(json.encode(localDataBase.toJson()));
        add(ShippingsUpdated(shippingList: localDataBase.shippingsDB));
      }
    });

    on<ShippingsUpdated>((event, emit) {
      emit(ShippingsLoading(
          filter: state.filter, shippingList: state.shippingList));
      List<Shipping> shippings = event.shippingList + state.shippingList;
      shippings = shippings.toSet().toList();
      shippings.sort((shipping1, shipping2) =>
          shipping2.remiterTaraTime!.compareTo(shipping1.remiterTaraTime!));
      emit(ShippingsLoaded(
          shippings:
              filterShippings(shippings: shippings, filter: state.filter)));
    });

    on<UpdateShipping>((event, emit) {
      if (isInternetConnected) {
        try {
          event.shipping.isOnLine = true;
          ShippingRepository().updateParameter(shipping: event.shipping);
        } catch (e) {
          print(e);
        }
      } else {
        event.shipping.isOnLine = false;
        localDataBase.shippingsDB.add(event.shipping);
        DataBaseFileRoutines()
            .writeDataBase(json.encode(localDataBase.toJson()));
      }
    });

    on<CreateExcel>((event, emit) async {
      final Workbook workbook = Workbook();
      Worksheet sheet = workbook.worksheets[0];

      putHeaders(sheet);
      print('Headers Seted');
      putData(sheet, state.shippingList);
      print('Data Seted');

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final String path = (await getApplicationDocumentsDirectory()).path;
      final String fileName = '$path/Envios.xlsx';
      print('Create new path: $fileName');
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      try {
        await OpenFile.open(fileName);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Future<void> close() {
    _shippingsSubscription?.cancel();
    return super.close();
  }

  void putHeaders(Worksheet sheet) {
    sheet.getRangeByIndex(1, 1).setText('Id');
    sheet.getRangeByIndex(1, 2).setText('Estado');
    sheet.getRangeByIndex(1, 3).setText('Origen');
    sheet.getRangeByIndex(1, 4).setText('Destino');
    sheet.getRangeByIndex(1, 5).setText('Cosecha');
    sheet.getRangeByIndex(1, 6).setText('Lote');
    sheet.getRangeByIndex(1, 7).setText('Tipo de arroz');
    sheet.getRangeByIndex(1, 8).setText('Chofer');
    sheet.getRangeByIndex(1, 9).setText('Patente del camion');
    sheet.getRangeByIndex(1, 10).setText('Patente del chasis');
    sheet.getRangeByIndex(1, 11).setText('Esdado de conexion');
    sheet.getRangeByIndex(1, 12).setText('Peso tara Origen');
    sheet.getRangeByIndex(1, 13).setText('Usuario tara origen');
    sheet.getRangeByIndex(1, 14).setText('Hora tara origen');
    sheet.getRangeByIndex(1, 15).setText('Peso bruto origen');
    sheet.getRangeByIndex(1, 16).setText('Usuario bruto origen');
    sheet.getRangeByIndex(1, 17).setText('Hora bruto origen');
    sheet.getRangeByIndex(1, 18).setText('Peso neto origen');
    sheet.getRangeByIndex(1, 19).setText('Humedad');
    sheet.getRangeByIndex(1, 20).setText('Peso seco origen');
    sheet.getRangeByIndex(1, 21).setText('Peso tara destino');
    sheet.getRangeByIndex(1, 22).setText('Usuario tara destino');
    sheet.getRangeByIndex(1, 23).setText('Hora tara destion');
    sheet.getRangeByIndex(1, 24).setText('Peso bruto destino');
    sheet.getRangeByIndex(1, 25).setText('Usuario tara destino');
    sheet.getRangeByIndex(1, 26).setText('Hora tara destino');
    sheet.getRangeByIndex(1, 27).setText('Peso neto destino');
    sheet.getRangeByIndex(1, 28).setText('Humedad');
    sheet.getRangeByIndex(1, 29).setText('Peso seco destino');
  }

  void putData(Worksheet sheet, List<Shipping> shippingList) {
    for (int i = 0; i < shippingList.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(shippingList[i].id);
      sheet.getRangeByIndex(i + 2, 2).setText(shippingList[i].getStatus);
      sheet.getRangeByIndex(i + 2, 3).setText(shippingList[i].remiterLocation);
      sheet.getRangeByIndex(i + 2, 4).setText(shippingList[i].reciverLocation);
      sheet.getRangeByIndex(i + 2, 5).setText(shippingList[i].crop);
      sheet.getRangeByIndex(i + 2, 6).setText(shippingList[i].lote);
      sheet.getRangeByIndex(i + 2, 7).setText(shippingList[i].riceType);
      sheet.getRangeByIndex(i + 2, 8).setText(shippingList[i].driverName);
      sheet.getRangeByIndex(i + 2, 9).setText(shippingList[i].truckPatent);
      sheet.getRangeByIndex(i + 2, 10).setText(shippingList[i].chasisPatent);
      sheet
          .getRangeByIndex(i + 2, 11)
          .setText(shippingList[i].isOnLine.toString());
      sheet.getRangeByIndex(i + 2, 12).setText(shippingList[i].remiterTara);
      sheet.getRangeByIndex(i + 2, 13).setText(shippingList[i].remiterTaraUser);
      sheet
          .getRangeByIndex(i + 2, 14)
          .setDateTime(shippingList[i].remiterTaraTime);
      sheet
          .getRangeByIndex(i + 2, 15)
          .setText(shippingList[i].remiterFullWeight);
      sheet
          .getRangeByIndex(i + 2, 16)
          .setText(shippingList[i].remiterFullWeightUser);
      sheet
          .getRangeByIndex(i + 2, 17)
          .setDateTime(shippingList[i].remiterFullWeightTime);
      sheet
          .getRangeByIndex(i + 2, 18)
          .setText(shippingList[i].remiterWetWeight);
      sheet.getRangeByIndex(i + 2, 19).setText(shippingList[i].humidity);
      sheet
          .getRangeByIndex(i + 2, 20)
          .setText(shippingList[i].remiterDryWeight);
      sheet.getRangeByIndex(i + 2, 21).setText(shippingList[i].reciverTara);
      sheet.getRangeByIndex(i + 2, 22).setText(shippingList[i].reciverTaraUser);
      sheet
          .getRangeByIndex(i + 2, 23)
          .setDateTime(shippingList[i].reciverTaraTime);
      sheet
          .getRangeByIndex(i + 2, 24)
          .setText(shippingList[i].reciverFullWeight);
      sheet
          .getRangeByIndex(i + 2, 25)
          .setText(shippingList[i].reciverFullWeightUser);
      sheet
          .getRangeByIndex(i + 2, 26)
          .setDateTime(shippingList[i].reciverFullWeightTime);
      sheet
          .getRangeByIndex(i + 2, 27)
          .setText(shippingList[i].reciverWetWeight);
      sheet.getRangeByIndex(i + 2, 28).setText(shippingList[i].humidity);
      sheet
          .getRangeByIndex(i + 2, 29)
          .setText(shippingList[i].reciverDryWeight);
    }
  }
}

List<Shipping> filterShippings(
    {required List<Shipping> shippings, required Filter? filter}) {
  String? destination = filter?.origin == 'SELECCIONAR' ? null : filter?.origin;
  String? origin =
      filter?.destination == 'SELECCIONAR' ? null : filter?.destination;

  if (destination == null && origin == null) {
    return shippings;
  }

  if (destination == null) {
    return shippings
        .where((element) => element.remiterLocation == origin)
        .toList();
  }

  if (origin == null) {
    return shippings
        .where((element) => element.reciverLocation == destination)
        .toList();
  }

  return shippings
      .where((element) =>
          element.reciverLocation == destination ||
          element.remiterLocation == origin)
      .toList();
}
