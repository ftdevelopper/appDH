import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:app_dos_hermanos/blocs/internet_cubit/internet_cubit.dart';
import 'package:app_dos_hermanos/classes/filter.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/local_repository/local_data_base.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'shippings_event.dart';
part 'shippings_state.dart';

class ShippingsBloc extends Bloc<ShippingsEvent, ShippingsState> {

  final ShippingRepository shippingRepository;
  late StreamSubscription? _shippingsSubscription;
  late StreamSubscription? _internetSubscription;
  LocalDataBase localDataBase;
  final InternetCubit internetCubit;
  bool isInternetConnected = false;

  ShippingsBloc({required this.shippingRepository, required this.localDataBase, required this.internetCubit}) : super(ShippingsLoading(filter: Filter(duration: Duration(days: 3)), shippingList: localDataBase.shippingsDB)) {

    _internetSubscription = internetCubit.stream.listen((state) {
      List<Shipping> toRemove = [];
      if (state is InternetConnected){
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
        localDataBase.shippingsDB.removeWhere((element) => toRemove.contains(element));
        DataBaseFileRoutines().writeDataBase(json.encode(localDataBase.toJson()));
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
      emit(ShippingsLoading(filter: event.filter, shippingList: state.shippingList));
      try {
        _shippingsSubscription = shippingRepository.getShippings(
          duration: state.filter?.duration ?? Duration(days: 3),
        ).listen(
          (shippings){
            print('New shipping Loaded: ${shippings.toString()}');
            return add(ShippingsUpdated(shippingList: shippings));
          }
        );
        print('Loading new Shippings');
      } catch (e) {
        print('Error recived: $e');
        emit(ShippingsNotLoaded(shippingList: state.shippingList));
      }
    });

    on<AddShipping>((event, emit) async {
      if(isInternetConnected){
        try {
          await shippingRepository.putShipping(event.shipping);
        } catch (e) {
          print(e);
          event.shipping.isOnLine = false;
          localDataBase.shippingsDB.add(event.shipping);
          DataBaseFileRoutines().writeDataBase(json.encode(localDataBase.toJson()));
        }
      } else {
        event.shipping.isOnLine = false;
        localDataBase.shippingsDB.add(event.shipping);
        DataBaseFileRoutines().writeDataBase(json.encode(localDataBase.toJson()));
        add(ShippingsUpdated(shippingList: localDataBase.shippingsDB));
      }
    });

    on<ShippingsUpdated>((event, emit){
      emit(ShippingsLoading(filter: state.filter, shippingList: state.shippingList));
      List<Shipping> shippings = event.shippingList + state.shippingList;
      shippings = shippings.toSet().toList();
      shippings.sort((shipping1, shipping2) => shipping2.remiterTaraTime!.compareTo(shipping1.remiterTaraTime!));
      emit(ShippingsLoaded(shippings: filterShippings(shippings: shippings, filter: state.filter)));
    });


    on<UpdateShipping>((event,emit){
      if (isInternetConnected){
        try {
          event.shipping.isOnLine = true;
          ShippingRepository().updateParameter(shipping: event.shipping);
        } catch (e) {
          print(e);
        }
      } else {
        event.shipping.isOnLine = false;
        localDataBase.shippingsDB.add(event.shipping);
        DataBaseFileRoutines().writeDataBase(json.encode(localDataBase.toJson()));
      }
    });

    on<CreateExcel>((event,emit) async {
      final Workbook workbook = Workbook();
      Worksheet sheet = workbook.worksheets[0];
      
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final String path = (await getApplicationDocumentsDirectory()).path;
      final String fileName = '$path/Envios.xlsx';
      print('Create new path: $fileName');
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      try {
        await OpenFile.open(fileName);
      } catch(e){
        print(e);
      }
    });

  }

  @override
  Future<void> close() {
    _shippingsSubscription?.cancel();
    return super.close();
  }

  void putHeaders(Worksheet sheet){
    sheet.getRangeByIndex(0, 0).setText('Id');
    sheet.getRangeByIndex(0, 1).setText('Estado');
    sheet.getRangeByIndex(0, 2).setText('Estado');
    sheet.getRangeByIndex(0, 3).setText('Estado');
    sheet.getRangeByIndex(0, 4).setText('Estado');
    sheet.getRangeByIndex(0, 5).setText('Estado');
    sheet.getRangeByIndex(0, 6).setText('Estado');
    sheet.getRangeByIndex(0, 7).setText('Estado');
    sheet.getRangeByIndex(0, 8).setText('Estado');
    sheet.getRangeByIndex(0, 9).setText('Estado');
    sheet.getRangeByIndex(0, 10).setText('Estado');
    sheet.getRangeByIndex(0, 11).setText('Estado');
    sheet.getRangeByIndex(0, 12).setText('Estado');
  }
}

List<Shipping> filterShippings({required List<Shipping> shippings, required Filter? filter}){

  String? destination = filter?.origin == 'SELECCIONAR' ? null : filter?.origin;
  String? origin = filter?.destination == 'SELECCIONAR' ? null : filter?.destination;

  if (destination == null && origin == null){
    return shippings;
  }

  if (destination == null){
    return shippings.where((element) => element.remiterLocation == origin).toList();
  }

  if (origin == null){
    return shippings.where((element) => element.reciverLocation == destination).toList();
  }

  return shippings.where((element) => element.reciverLocation == destination || element.remiterLocation == origin).toList();
}
